module TypesMarkup exposing (..)

import DatasetPage exposing (Model)
import FastDict as Dict exposing (Dict, values)
import Json.Encode exposing (Value)
import Mark.Internal.Description as Desc exposing (Description(..))
import Mark.Internal.Id as Id exposing (Id)
import Types exposing (Env, Error(..))
import TypesJavascript exposing (BoundingClientRect)


type alias MarkupEnv =
    { values : Values
    , equations : Dict String Value
    , focusedEquation : Maybe String
    , pendingEqn : Maybe String

    -- editing
    , editState : Maybe EditState
    , parsedDetails : Maybe Desc.Description
    , showValues : ShowValues
    , datasetModels : Dict String DatasetPage.Model
    , mainEnv : Result Types.Error Types.Env
    , hoveredBlock : Maybe Id
    , activeBlockEditPopup : Maybe Id
    , mousePosition : Maybe ( Int, Int )
    , boundingClientRect : Maybe BoundingClientRect
    , blockTypesToRender : BlockTypesToRender
    , showPopupSetting : Bool -- Add this line
    }


type ShowValues
    = Editable
    | NotEditable


type BlockTypesToRender
    = AllBlocks
    | OnlySheets
    | OnlyNonSheets


emptyMarkupEnv : MarkupEnv
emptyMarkupEnv =
    { values = Dict.empty
    , equations = Dict.empty
    , focusedEquation = Nothing
    , pendingEqn = Nothing
    , editState = Nothing
    , parsedDetails = Nothing
    , showValues = NotEditable
    , datasetModels = Dict.empty
    , mainEnv = Ok Types.emptyEnv
    , hoveredBlock = Nothing
    , activeBlockEditPopup = Nothing
    , mousePosition = Nothing
    , boundingClientRect = Nothing
    , blockTypesToRender = AllBlocks
    , showPopupSetting = False
    }


type BlockType
    = TitleBlock
    | SubtitleBlock
    | SheetBlock
    | TextBlock
    | CounterBlock
    | SumBlock
    | ImageBlock
    | CodeBlock
    | EqnBlock
    | ListBlock


type SidebarItem
    = FolderItem SidebarItemInfo -- anchor id, title text
    | SheetItem SidebarItemInfo -- anchor id, subtitle text


type alias SidebarItemInfo =
    { anchor : String
    , name : String
    , level : Int -- 1 for Title, 2 for Subtitle, 3 for Sheet
    }


type SidebarTree
    = Node SidebarItem (List SidebarTree)


type alias EditState =
    { id : Id
    , content : String
    }



-- Values
-- generic dictionary to store runtime values
-- similar to elm-interpreter Env


type alias Values =
    Dict.Dict String Float



-- for XY positions


type alias BoundingClientRect =
    { left : Float
    , top : Float
    , right : Float
    , bottom : Float
    , width : Float
    , height : Float
    }


getValue : String -> Values -> Float
getValue name values =
    values
        |> Dict.get name
        -- Values that are not kept track of yet are assumed to be the default
        |> Maybe.withDefault 0


noStyling : Desc.Styling
noStyling =
    { bold = False, italic = False, strike = False }
