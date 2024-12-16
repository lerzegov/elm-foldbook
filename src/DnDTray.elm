module DnDTray exposing (Model, Msg(..), initialModel, subscriptions, update, TrayToken, Item
                        , pageTrayView, rowTrayView, columnTrayView, ghostView, sectionStyles
                        , getPageNames, getRowNames, getColNames, getRowWidths, tokenView)
-- only drag and drop management of token trays
-- no logic for the content of the trays, set in PersonValue and PersonValuePivot
import DnDList.Groups

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border

import Html.Attributes as HtmlAttr exposing (style)
import MyColors exposing (..)
import Element.Font as UiFont
import FastDict as Dict exposing (Dict)
import Array exposing (Array)
import Dropdown
import TypesXModel exposing (Tray(..))



-- DATA




type alias TrayToken =
    { tray : Tray -- tray type token belongs to
    , name : String -- token name => dimRef
    , items : Array String -- item names => coords
    , color : Color
    , iterOrder : Int -- maybe used for mapping to matrix categories
    , width : Int -- maybe used to position sticky row headers
    }
-- tokens are created via XView.createToken in XView.createTrayData

getTokenNamesByTray : Tray -> List TrayToken -> List String
getTokenNamesByTray trayType trayData =
    trayData
        |> List.filter (\token -> token.tray == trayType && token.name /= "footer")
        |> List.map .name

getTokenWidthsByTray : Tray -> List TrayToken -> List Int
getTokenWidthsByTray trayType trayData =
    trayData
        |> List.filter (\token -> token.tray == trayType && token.name /= "footer")
        |> List.map .width

getPageNames : List TrayToken -> List String
getPageNames trayData =
    getTokenNamesByTray PageTray trayData

getRowNames : List TrayToken -> List String
getRowNames trayData =
    getTokenNamesByTray RowTray trayData

getRowWidths : List TrayToken -> List Int
getRowWidths trayData =
    getTokenWidthsByTray RowTray trayData

getColNames : List TrayToken -> List String
getColNames trayData =
    getTokenNamesByTray ColumnTray trayData

-- DnD SYSTEM

dndConfig : DnDList.Groups.Config TrayToken
dndConfig =
    { beforeUpdate = \_ _ list -> list
    , listen = DnDList.Groups.OnDrag
    , operation = DnDList.Groups.Rotate
    , groups =
        { listen = DnDList.Groups.OnDrag
        , operation = DnDList.Groups.InsertBefore
        , comparator = comparator
        , setter = setter
        }
    }


comparator : TrayToken -> TrayToken -> Bool
comparator item1 item2 =
    item1.tray == item2.tray


setter : TrayToken -> TrayToken -> TrayToken
setter item1 item2 =
    { item2 | tray = item1.tray }


system : DnDList.Groups.System TrayToken Msg
system =
    DnDList.Groups.create dndConfig DnDMsg



-- MODEL
type alias Item =
    String

type alias Model =
    -- DnD
    { dnd : DnDList.Groups.Model
    , viewName : String
    , trayData : List TrayToken -- set by XView.defaultTrayData then modified via Dnd
    -- Dropdown
    , dropdownStates : Dict String (Dropdown.State Item)
    , dropdownOptions : Dict String (List String)
    , dropdownSelectedOptions : Dict String (Maybe Item)
    }


initialModel : Model
initialModel =
    { dnd = system.model -- model of DnDList.Groups
    , viewName = ""
    , trayData = []
    , dropdownStates = Dict.empty
    , dropdownOptions = Dict.empty
    , dropdownSelectedOptions = Dict.empty
    }


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    system.subscriptions model.dnd



-- UPDATE


type Msg
    = DnDMsg DnDList.Groups.Msg
    | DnDTrayDropdownMsg String (Dropdown.Msg Item)
    | DnDTrayOptionPicked String (Maybe Item)

update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        DnDMsg msg -> -- passes the message to the DnDList.Groups.update function
            let
                ( dnd, trayData ) =
                    system.update msg model.dnd model.trayData
            in
            -- Debug.log("trayData: " ++ Debug.toString trayData)
            ( { model | dnd = dnd, trayData = trayData }
            , system.commands dnd
            )

        DnDTrayOptionPicked dropdownId option ->
            ( { model | dropdownSelectedOptions = Dict.insert dropdownId option model.dropdownSelectedOptions }, Cmd.none )

        DnDTrayDropdownMsg dropdownId subMsg ->
            let
                updatedModel = model -- { model | dropdownOptions = Dict.insert dropdownId items model.dropdownOptions }
                configForUpdate = dropdownConfig dropdownId updatedModel
                
                -- Retrieve the current state of the dropdown, initializing it if not present
                dropdownState = Dict.get dropdownId model.dropdownStates 
                        |> Maybe.withDefault (Dropdown.init dropdownId)
                
                -- Call Dropdown.update with the prepared configuration, the message, and the current state
                (updatedState, cmd) = Dropdown.update configForUpdate subMsg model dropdownState
                
            in
            -- Update the model with the new state of the dropdown and map the resulting command
            ( { model | dropdownStates = Dict.insert dropdownId updatedState model.dropdownStates }
            , cmd
            )






dropdownConfig : String  -> Model -> Dropdown.Config Item Msg Model
dropdownConfig dropdownId model =
    let
        optsFromTrayData : List String
        optsFromTrayData =
            model.trayData
                |> List.filter (\token -> token.name == dropdownId)
                |> List.head  -- Assuming you expect to find at most one token with matching dropdownId
                |> Maybe.map .items
                |> Maybe.map Array.toList
                |> Maybe.withDefault []

        --options = Dict.get dropdownId model.dropdownOptions |> Maybe.withDefault [] -- Fetch options from the model
        options = optsFromTrayData
        defaultOption = List.head options -- Set the default option
        containerAttrs = [ width shrink , Background.color MyColors.white] -- Container custom attributes
        selectAttrs = [ Border.width 1, Border.rounded 5, paddingXY 4 4, spacing 5, width fill ] -- Select custom attributes
        searchAttrs = [ Border.width 0, padding 0 ] -- Search field custom attributes
        listAttrs = [ Border.width 1
                    , Border.roundEach { topLeft = 0, topRight = 0, bottomLeft = 5, bottomRight = 5 }
                    , Background.color white
                    , width shrink
                    , spacing 5 ] -- Dropdown list custom attributes
    in
    Dropdown.filterable
        { itemsFromModel = always options
        -- Use your model to track selected options
        , selectionFromModel = \_ -> 
                Dict.get dropdownId model.dropdownSelectedOptions 
                    |> Maybe.withDefault defaultOption
        , dropdownMsg = DnDTrayDropdownMsg dropdownId -- Wrap Dropdown.Msg with your Msg constructor
        , onSelectMsg = DnDTrayOptionPicked dropdownId -- Wrap the selection message
        , itemToPrompt = text -- Function to display each option in the dropdown
        , itemToElement = \_ _ option -> el [ padding 8, spacing 10, width fill ] (text option) -- Function to render the dropdown items
        , itemToText = identity -- Function to convert items to text for filtering
        }
        |> Dropdown.withContainerAttributes containerAttrs
        |> Dropdown.withPromptElement (el [] (text "Select option")) -- Customize the prompt
        |> Dropdown.withFilterPlaceholder "Type for option" -- Placeholder text for the filter
        |> Dropdown.withSelectAttributes selectAttrs -- Apply custom attributes to the select element
        |> Dropdown.withListAttributes listAttrs -- Apply custom attributes to the dropdown list
        |> Dropdown.withSearchAttributes searchAttrs -- Apply custom attributes to the search field


viewDropdown : String -> Model -> Element Msg
viewDropdown dropdownId model =
    let
        -- Assuming you have a way to get the current state of the dropdown by its ID
        -- For example, model.dropdownStates might be a Dict String (Dropdown.State Item)
        maybeDropdownState = Dict.get dropdownId model.dropdownStates

        dropdownState = 
            case maybeDropdownState of
                Just state -> state
                Nothing -> -- Handle the case where there's no state for this dropdown ID
                           -- This might involve initializing a new state or handling an error
                           Dropdown.init "state-not-found"

        -- Construct the Dropdown.Config for this specific dropdown
        configForView = dropdownConfig dropdownId model

        -- Render the dropdown view, mapping its messages to your application's message type
        dropdownElement = 
            Dropdown.view configForView model dropdownState
    in
    dropdownElement




-- VIEW

pageTrayView : Model -> Element Msg
pageTrayView model =
    trayView model PageTray lightGray

rowTrayView : Model -> Element Msg
rowTrayView model =
    trayView model RowTray lightBlue

columnTrayView : Model -> Element Msg
columnTrayView model =
    trayView model ColumnTray pink

-- handles the ghost view of the dragged item
ghostView : DnDList.Groups.Model -> List TrayToken -> Element Msg
ghostView dnd items =
    case maybeDragItem dnd items of
        Just { name, color } ->
            el
                (itemStyles color ++ List.map htmlAttribute (system.ghostStyles dnd))
                ( text name)

        Nothing ->
            none
-- helper view function to set formats for the different trays
trayView : Model -> Tray -> Color -> Element Msg
trayView model tray color  =
    let
        orientation =
            case tray of
            RowTray ->
                wrappedRow (groupStyles tray color)
            ColumnTray ->
                wrappedRow (groupStyles tray color) -- changed to row
            PageTray ->
                wrappedRow (groupStyles tray color)              
    in

    model.trayData
        |> List.filter (\item -> item.tray == tray)
        |> List.indexedMap (tokenView model (calculateOffset 0 tray model.trayData))
        |> (orientation)

-- called by trayView to create the token views
tokenView : Model -> Int -> Int -> TrayToken -> Element Msg
tokenView model offset localIndex { tray, name, color } =
    let
        globalIndex : Int
        globalIndex =
            offset + localIndex

        tokenId : String
        tokenId =
            "view-" ++ model.viewName ++ "-" ++ String.fromInt globalIndex ++ "-id"
    in
    case ( system.info model.dnd, maybeDragItem model.dnd model.trayData ) of
        ( Just { dragIndex }, Just dragItem ) ->
            -- If the item is a transparent footer and it's being dragged to a different tray, show an empty div for dropping
            if color == myTransparent && name == "footer" && dragItem.tray /= tray then
                el
                    (htmlAttribute (HtmlAttr.id tokenId)
                        :: auxiliaryStyles
                        ++ List.map htmlAttribute (system.dropEvents globalIndex tokenId)
                    )
                    none

            -- If the item is a transparent footer and it's being dragged within the same tray, show an empty div
            else if color == myTransparent && name == "footer" && dragItem.tray == tray then
                el
                    (htmlAttribute (HtmlAttr.id tokenId)
                        :: auxiliaryStyles
                    )
                    none

            -- If the item is not the currently dragged item, show the item with drop events
            else if dragIndex /= globalIndex then
                el
                    (htmlAttribute (HtmlAttr.id tokenId)
                        :: itemStyles color
                        ++  List.map htmlAttribute (system.dropEvents globalIndex tokenId)
                    )
                    <| text name

            -- If the item is the currently dragged item, show the item with gray styling in the destination position
            else
                el
                    (htmlAttribute (HtmlAttr.id tokenId)
                        :: itemStyles white
                        ++ [UiFont.color white]
                    )
                    <| text name --- sgamuffo per non far vedere il nome dell'item che si sta trascinando

        _ ->
            -- If the item is a transparent footer, show an empty div
            if color == myTransparent && name == "footer" then
                el
                    (htmlAttribute (HtmlAttr.id tokenId)
                        :: auxiliaryStyles
                    )
                    none

            -- Otherwise, show the item with drag events
            else
                el
                    [ htmlAttribute (HtmlAttr.id tokenId)
                    , width shrink
                    ]
                    (row
                        []
                        [ el
                            (itemStyles color ++ List.map htmlAttribute (system.dragEvents globalIndex tokenId))
                            (text name)
                        , if tray == PageTray then 
                            viewDropdown name model -- changed dropdownId no tokenId yes name=dim
                        else 
                            none
                        ]
                    )



-- HELPERS



calculateOffset : Int -> Tray -> List TrayToken -> Int
calculateOffset index group list =
    case list of
        [] ->
            0

        x :: xs ->
            if x.tray == group then
                index

            else
                calculateOffset (index + 1) group xs


maybeDragItem : DnDList.Groups.Model -> List TrayToken -> Maybe TrayToken
maybeDragItem dnd items =
    system.info dnd
        |> Maybe.andThen (\{ dragIndex } -> items |> List.drop dragIndex |> List.head)

-- STYLES
groupStyles : Tray -> Color -> List (Element.Attribute Msg)
groupStyles tray color =
    let
            curWidth = case tray of
                RowTray ->
                    width fill
                ColumnTray ->
                    width fill-- <| minimum 110 fill
                PageTray ->
                    width fill

            curHeight = case tray of
                RowTray ->
                    height fill -- <| px 30
                ColumnTray ->
                    height fill
                PageTray ->
                    height <| px 30
            
    in
    [ curHeight
    , Background.color color
    , paddingXY 10 10
    , curWidth
    , spacing 5
    , Border.rounded 6
    ]
sectionStyles : List (Element.Attribute msg)
sectionStyles =
    [ height fill
    , width fill
    , alignBottom
    -- , alignTop
    , alignRight
    -- , paddingXY 10 0
    , UiFont.size 14
    ]

itemStyles : Color ->  List (Attribute Msg)
itemStyles color =
    [ width shrink -- <| px 100
    , height <| px 25
    --, UiFont.alignLeft
    , UiFont.bold
    , paddingEach {top=4, bottom=4, left=4, right=4}
    , centerY
    , Background.color color
    , Border.rounded 6
    , Border.solid
    , Border.width 1
    , Border.color lightGray
    , htmlAttribute <| style "cursor" "pointer"
    ]

auxiliaryStyles : List (Attribute Msg)
auxiliaryStyles =
    [ width fill
    -- , width <| px 100
    , height <| minimum 20 fill
    ]

