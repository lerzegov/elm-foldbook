module MarkupFoldbook exposing (main, Msg(..), Model, initialModel, initCmd, update, view, subscriptions
        , viewSheetByDatasetRef)


import FastDict as Dict exposing (Dict)
import List
import Http
import Json.Decode as Decode
import Task

import Element exposing (..)
import Element.Background as UiBackground
import Element.Border as UiBorder 
import Element.Font as UiFont
import Element.Input as UiInput
import Element.Events as UiEvents

import Html exposing (Html)
import Html.Attributes as HtmlAttr
import Html.Events as HtmlEvents

import Mark exposing (Styles
        , Enumerated(..), Item(..), Parsed, Document
        )
import Mark.Error as MkErr exposing (Error)
import Mark.Internal.Description as Desc exposing (
        Parsed(..), Description(..), InlineSelection(..), TextDescription(..), BlockKind(..)
        , ParsedDetails
        )
import Mark.Internal.Id as Id exposing (Id)
-- Record è Mark.record non vede Mark.Record

import Browser exposing (Document)
import Browser.Dom as Dom

import FastDict as Dict exposing (Dict)
import MyColors exposing (..)
import Ports exposing (..)
import TypesMarkup exposing (MarkupEnv, emptyMarkupEnv, EditState, Values, getValue, ShowValues(..))
import AppUtil exposing (..)
import Types exposing (Env, Error(..))
import DatasetPage exposing (Model)
-- TODO
-- add a plain view fucntion to DatasetPage
-- consider to add Env in place of EnvMarkup here
-- create a block type to shoe a dataset page given the dataset name as is
-- add fields to configure the dataset view





uiAttr = Element.htmlAttribute


-- Entry point

-- Model
type alias Model =
    { source : Maybe String
    , sourcePath : Maybe String
    , mkEnv : MarkupEnv
    , parsed : Maybe Mark.Parsed
    , errors : List MkErr.Error
    , svg : String -- svg buffer to be rendered
    -- editing moved to env because interacts with block parsers
    -- from former MarkupSource
    , editorMarkupContent : String
    }




main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = viewDocument
        , update = update
        , subscriptions = subscriptions -- always Sub.none
        }
initValues = Dict.fromList [("ricavi", 1000), ("costoVen", 550)]
initSourcePath = "articles/Equations.emu"

initialModel : Model
initialModel =
    { source = Nothing
    , sourcePath = Just initSourcePath
    , mkEnv = { emptyMarkupEnv | values = initValues }
    , parsed = Nothing
    , errors = []
    , svg = ""
    , editorMarkupContent = ""
    }
initCmd : Cmd Msg
initCmd = 
    Http.get
            { -- url = "articles/Article.emu"
            url = initSourcePath
            -- url = "articles/Counter.emu"
            -- url ="MyNotes.emu"
            , expect = Http.expectString GotSrcToParsed -- Msg containing http Result passed with Cmd to update
            }
init () =
    ( initialModel
    , initCmd
    )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch 
    [ receiveSvg (SetSvg)
    , markupContentChanged  MarkupContentChanged
    ]


-- Update


type Msg
    = SetValue ( String, Float )
    | SetValueFromString String String 
    | GotSrcToParsed (Result Http.Error String) -- extended to doc with metadata
    | SetSvg (String, String)
    | RenderMathJax String
    | RequestRender String
    | ProcessEquations (List String)
    | ActivateEditMode Id
    | UpdateContent String
    | SaveEdit
    | CancelEdit
    | FocusResult (Result Dom.Error ())
    | ActivateValueEdit String
    | CancelValueEdit
    | SaveSource
    | SourceSaved
    | DatasetPageMsgInMarkup String DatasetPage.Msg
    | MarkupContentChanged String
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetValue ( key, val ) ->
            let
                curEnv = model.mkEnv
                updatedEnv =
                    {curEnv
                        | values =
                            Dict.insert key
                                val
                                model.mkEnv.values
                    }
            in
            ({ model
                | mkEnv =
                    updatedEnv
            }
            , Cmd.none
            )
        SetValueFromString key strVal  ->
            let
                curEnv = model.mkEnv
                cleanedStrVal = strVal -- cleaning non serve qui ma seve add ".0" in edit
                    -- if String.endsWith decimalSeparator strVal then
                    --     strVal ++ "0"
                    -- else
                    --     strVal
                val = String.toFloat cleanedStrVal 
            in
            case val of
                    Just v -> 
                        let
                            updatedEnv =
                                {curEnv
                                    | values =
                                        Dict.insert key
                                            v
                                            model.mkEnv.values
                                }
                        in 
                        ({ model | mkEnv = updatedEnv}, Cmd.none)
        
                    Nothing -> (model, cmdMsg CancelEdit)

        GotSrcToParsed result ->
            case result of
                Ok src ->
                    let modelWithSource = { model | source = Just src } in
                    case Mark.parse myDocumentWith src of
                        Mark.Success parsed ->
                            let
                                parsedDetailsFound = parsedToParsedDetailsFound (Just parsed)
                                equations = extractEquations parsedDetailsFound
                            in
                            ( { modelWithSource
                                | parsed = Just parsed
                                , editorMarkupContent = src
                              }
                            , cmdMsg (ProcessEquations equations)--Cmd.none 
                            )

                        Mark.Almost partial ->
                            let
                                parsedDetailsFound = parsedToParsedDetailsFound (Just partial.result)
                                equations = extractEquations parsedDetailsFound
                            in
                            ( { modelWithSource
                                | parsed = Just partial.result
                                , editorMarkupContent = "# HAS PARTIAL ERRORS\n" ++ src
                                , errors = partial.errors
                              }
                            , cmdMsg (ProcessEquations equations) -- Cmd.none 
                            )

                        Mark.Failure errors ->
                            ( { modelWithSource 
                                | parsed = Nothing
                                , editorMarkupContent = "# HAS ERRORS\n" ++ src
                                , errors = errors }
                            , Cmd.none
                            )

                Err err ->
                    let
                        _ =
                            Debug.log "err" err
                    in
                    ( model, Cmd.none )
        SetSvg (src, svgContent) ->
            let
                curEnv = model.mkEnv
                updatedEnv =
                    { curEnv
                        | equations =
                            Dict.insert src
                                svgContent
                                curEnv.equations
                    }
            in
            ( { model | mkEnv = updatedEnv }, Cmd.none )

        RenderMathJax src ->
            let
                curEnv = model.mkEnv
                updatedEnv = { curEnv | pendingEqn = Just src }
            in
            ( { model | mkEnv = updatedEnv }, renderMathJax src )

        RequestRender src ->
            if Dict.member src model.mkEnv.equations then
                ( model, Cmd.none )
            else
                ( model, renderMathJax src )
        ProcessEquations equations ->
            let
                myCmd eqSrc = cmdMsg (RenderMathJax eqSrc)
                renderCmds equationsArg = List.map myCmd equationsArg
            in
            ( model, Cmd.batch (renderCmds equations) )
        ActivateEditMode id ->
                    let
                        parsedFound = parsedToParsedDetailsFound model.parsed
                        -- `findMany` returns a list of descriptions without checks
                        -- there is a finer grained function `find` that returns a Maybe but is not exposed
                        descrForIf = Desc.findMany [id] parsedFound
                        idStr = Id.toString id
                    in
                    -- Debug.log ("descrForIf" ++ Debug.toString descrForIf) <|
                    case descrForIf of
                        [] ->
                            (model, Cmd.none)
                        curDescr::rest ->
                            let
                                content = extractContentFromMaybeDescr (Just curDescr)
                                curEnv = model.mkEnv
                                -- failure, needs metadata
                                updatedEnv = { curEnv | editState = Just { id = id, content = content } }

                            in
                            ( { model | mkEnv = updatedEnv }
                            , focusCommand (idStr ++ "-edit")
                            )


        UpdateContent newContent ->
            case model.mkEnv.editState of
                Just editState ->
                    let
                        curEnv = model.mkEnv
                        updatedEnv = { curEnv | editState = Just { editState | content = newContent  } }
                    in
                    ( { model | mkEnv = updatedEnv }
                    , Cmd.none
                    )
                Nothing ->
                    (model, Cmd.none)

        SaveEdit ->
            case model.mkEnv.editState of
                Just editState ->
                    let
                        parsedContent = parseSourceToBlocks myDocumentWithout editState.content
                        updatedParsedDoc = updateParsedDocument editState.id parsedContent model.parsed
                        curEnv = model.mkEnv
                        updatedEnv = { curEnv | parsedDetails = Nothing, editState = Nothing }
                        parsedDetailsFound = parsedToParsedDetailsFound parsedContent
                        equations = extractEquations parsedDetailsFound
                    in
                    ( { model 
                      | parsed = updatedParsedDoc
                      , source = parsedToSource updatedParsedDoc
                      , mkEnv = updatedEnv }
                    , 
                    Cmd.batch [
                        cmdMsg (ProcessEquations equations)
                        --, cmdMsg SaveSource -- moved to button to avoid multiple saves
                    ]

                    )
                Nothing ->
                    (model
                    , Cmd.none)

        CancelEdit -> 
            case model.mkEnv.editState of
                Just editState ->
                    let
                        curEnv = model.mkEnv
                        updatedEnv = { curEnv | parsedDetails = Nothing, editState = Nothing }
                    in
                    ( { model 
                      | mkEnv = updatedEnv }
                    , Cmd.none)

                Nothing ->
                    (model
                    , Cmd.none)
        FocusResult result ->
            case result of
                Ok () ->
                    (model, Cmd.none)
                Err error ->
                    Debug.log ("Error focusing input: " ++ Debug.toString(error))
                    (model, Cmd.none)
        ActivateValueEdit idStr -> -- idStr is the container id ++ the key of the value to edit
            let
                curEnv = model.mkEnv
                updatedEnv = { curEnv | showValues = Editable }
            in
            ( { model | mkEnv = updatedEnv }
            , focusCommand (idStr ++ "-edit") )
        CancelValueEdit ->
            let
                curEnv = model.mkEnv
                updatedEnv = { curEnv | showValues = NotEditable }
            in
            ( { model | mkEnv = updatedEnv }, Cmd.none )
        SaveSource ->
            case (model.source, model.sourcePath) of
                (Just src, Just path) ->
                    let
                        cleanedSrc = cleanSource src
                        updatedModel = { model 
                            | source = Just cleanedSrc 
                            , editorMarkupContent = cleanedSrc}
                    in
                    ( updatedModel, saveFile { content = cleanedSrc, path = path } )
                _ ->
                    ( model, Cmd.none )

        SourceSaved ->
            ( model, Cmd.none )
        -- complex message to handle DatasetPage.Msg here rendering sheets in markup
        DatasetPageMsgInMarkup datasetRef datasetPageMsg ->
            -- Forward the DatasetPageMsg to Main where is handled by MarkupFoldbookMsg
            -- with case on DatasetPageMsgInMarkup thatr re-routes to DatasetPageMsg
            (model,  cmdMsg (DatasetPageMsgInMarkup datasetRef datasetPageMsg))
        MarkupContentChanged content ->
            -- Debug.log ("EditorContentChanged" ++ content) <|
            ( { model | editorMarkupContent = content }, Cmd.none )
        NoOp ->
            (model, Cmd.none)


-- helper function for editing and saving
cleanSource : String -> String
cleanSource source =
    let
        lines = String.split "\n" source
        cleanedLines = removeBlankLinesAfterEquals lines
    in
    String.join "\n" cleanedLines

removeBlankLinesAfterEquals : List String -> List String
removeBlankLinesAfterEquals lines =
    case lines of
        [] ->
            []

        line1 :: line2 :: rest ->
            if String.endsWith "=" line1 && String.trim line2 == "" then
                line1 :: removeBlankLinesAfterEquals rest
            else
                line1 :: removeBlankLinesAfterEquals (line2 :: rest)

        [line] ->
            [line]


-- Dummy function to extract content by Id
extractContentFromMaybeDescr : Maybe Desc.Description -> String
extractContentFromMaybeDescr maybeDesc =
    case maybeDesc of
        Just desc ->
            Desc.descriptionToString desc
        Nothing ->
            "Cannot get string from parsed" ++ Debug.toString maybeDesc



-- Function to update the parsed content in the model
updateParsedDocument : Id -> Maybe Parsed -> Maybe Parsed -> Maybe Parsed
updateParsedDocument curId parsedEditedContent parsedDocument =
    case (parsedEditedContent, parsedDocument) of
        (Just (Parsed parsedEdited), Just (Parsed parsedDoc)) ->
            let
                newDescription =
                    case parsedEdited.found of
                        Group { children } ->
                            List.head children
                        _ ->
                            Nothing

                updatedChildren =
                    List.map
                        (\desc ->
                            if Desc.getId desc == curId then
                                case newDescription of
                                    Just newDesc ->
                                        -- Replace the old description with the new one, keeping the original id
                                        case newDesc of
                                            DescribeBlock newBlock ->
                                                DescribeBlock { newBlock | id = curId }
                                            DescribeText newText ->
                                                DescribeText { newText | id = curId }
                                            _ ->
                                                desc
                                    Nothing ->
                                        desc
                            else
                                desc
                        )
                        (case parsedDoc.found of
                            StartsWith { second } ->
                                case second of
                                    Group { children } ->
                                        children
                                    _ ->
                                        []
                            _ ->
                                []
                        )
            in
            Just (Parsed
                { parsedDoc -- content of parsedDocument
                    | found = -- updaates found.second with updatedChildren
                        case parsedDoc.found of
                            StartsWith starts ->
                                StartsWith
                                    { starts
                                        | second =
                                            case starts.second of
                                                Group group -> -- if second is Group, updates children
                                                    Group { group | children = updatedChildren }
                                                _ ->
                                                    starts.second -- if not Group, returns the original second
                                    } -- return Parsed parsedDoc with updated found
                            _ ->
                                parsedDoc.found -- if not StartsWith, returns the original found
                })

        _ ->
            parsedDocument

-- View
viewDocument : Model -> Document Msg
viewDocument model =
    { title = ""
    , body =
            let
                src = Maybe.withDefault "" model.source
                psd = model.parsed
                bodyHtml =
                    case psd of
                        Just parsed ->
                            case compileDocumentWith psd of
                                Ok viewByData ->
                                    viewByData model.mkEnv
                                Err err ->
                                    text err
                        Nothing ->
                            paragraph []( viewErrors model.errors)
                parsedInspected = (inspectParsed model.parsed)
            in -- body must be a list of Html nodes
            [ Element.layout [] (
                textColumn [ padding 20
                       , spacing 10
                       , width fill
                       , height fill] 
                    [ viewSaveSourceButton
                    , bodyHtml
                    -- , parsedInspected
                    ]
                )
            ]

                
    }

view : Model -> Element Msg
view model =
            let
                src = Maybe.withDefault "" model.source
                psd = model.parsed
                bodyHtml =
                    case psd of
                        Just parsed ->
                            case compileDocumentWith psd of
                                Ok viewByData ->
                                    viewByData model.mkEnv
                                Err err ->
                                    text err
                        Nothing ->
                            paragraph []( viewErrors model.errors)
                parsedInspected = (inspectParsed model.parsed)
            in 
                textColumn [ padding 20
                       , spacing 10
                       , width fill
                       , height fill] 
                    [ viewSaveSourceButton
                    , bodyHtml
                    , viewEditedSource model
                    -- , parsedInspected
                    ]

viewSheetByDatasetRefInternal : MarkupEnv -> String -> Element Msg
viewSheetByDatasetRefInternal mkEnv datasetRef =
    case Dict.get datasetRef mkEnv.datasetModels of
        Just datasetModel ->
            DatasetPage.viewSheet mkEnv.mainEnv datasetModel |> Element.map (DatasetPageMsgInMarkup datasetRef)
        Nothing ->
            Element.text ("Dataset page " ++ datasetRef ++ " not found")

viewSheetByDatasetRef : Result Types.Error Types.Env -> Dict String DatasetPage.Model -> String -> Element Msg
viewSheetByDatasetRef mainEnv datasetModels datasetRef =
    case Dict.get datasetRef datasetModels of
        Just datasetModel ->
            DatasetPage.viewSheet mainEnv datasetModel |> Element.map (DatasetPageMsgInMarkup datasetRef)
        Nothing ->
            Element.text ("Dataset page " ++ datasetRef ++ " not found")

viewSaveSourceButton : Element Msg
viewSaveSourceButton =
    UiInput.button
        [ padding 5
        , alignRight
        , UiBorder.width 1
        , UiBorder.rounded 3
        , UiBorder.color <| rgb255 200 200 200 ]
        { onPress = Just SaveSource
        , label = text "Save source"
        }

viewEditedSource : Model -> Element Msg
viewEditedSource model =
    let
        codeMirrorElement =
            Element.html <| Html.node "code-mirror-markup-editor"
                            [ HtmlAttr.attribute "data-initial-value" model.editorMarkupContent
                            , HtmlAttr.attribute "id" "markup-editor"
                            , HtmlEvents.on "formulaContentChanged" (Decode.map MarkupContentChanged (Decode.at [ "detail" ] Decode.string)) 
                            ] []
    in
    column [padding 20, spacing 10, width fill]
        [ row [UiFont.size 24, UiFont.bold] [ text "Markup Editor" ]
        , el [UiFont.size 16] codeMirrorElement
        ]

-- to keep an autonomous main function that can be used in the browser
viewEditedSourceToHtml : Model -> Html.Html Msg
viewEditedSourceToHtml model =
    layout [] (viewEditedSource model)

-- define the doc structure, in this case it's just a list of blocks
-- by means of counterBlock produces messages (String, Float) 
-- that in view are passed wrapped in SetValue to the update function

myDocumentWith : Mark.Document
              { id : String
              , author : String
              , description : List (MarkupEnv -> Element.Element Msg)
              , title : List (MarkupEnv -> Element.Element Msg)
              }
                (MarkupEnv -> Element.Element Msg)
        
myDocumentWith = 
    Mark.documentWith 
        { id = \_ -> "doc" --\metadata -> metadata.id
        , metadata = --articleMetadata
            Mark.record "Metadata"
                (\author description title ->
                    { id = "doc"
                    , author = author
                    , description = description
                    , title = title
                    }
                )
                |> Mark.field "author" Mark.string
                |> Mark.field "description" mkText
                |> Mark.field "title" mkText
                -- toBlock is called in documentWith
        , blocks =
            List.map addIdToblock     
                [ titleBlock
                , subtitleBlock
                , sheetBlock
                , Mark.map flattenAndSetFontSize mkText -- sgamuffo per non rendere List (Values -> Element Msg) ma spezza esto con diversi formati
                , counterBlock
                , sumBlock
                , imageBlock
                , codeBlock
                , listBlock
                ]
        }

-- myDocument without metadata used to parse single blocks

-- () is for the missing metadata
myDocumentWithout : Mark.Document () (MarkupEnv -> Element Msg)
myDocumentWithout = 
    Mark.document 
        (List.map addIdToblock     
            [ titleBlock
            , subtitleBlock
            , Mark.map flattenAndSetFontSize mkText -- sgamuffo per non rendere List (Values -> Element Msg) ma spezza esto con diversi formati
            , counterBlock
            , sumBlock
            , imageBlock
            , codeBlock
            , listBlock
             ])



parseSourceToBlocks : Mark.Document meta data -> String -> Maybe Mark.Parsed
parseSourceToBlocks doc content = 
    let
        outcome = Mark.parse doc content
        retBlocks = case outcome of
            Mark.Success parsed ->
                Just parsed
            _ -> 
                Nothing
    in
    retBlocks 
-- rendered doc is not usable because it's a list of (Env -> Element Msg)
-- must inspect on parsed to get internal structure
inspectParsed : Maybe Mark.Parsed -> Element Msg
inspectParsed parsed = 
    -- case parsed of
    --     Nothing ->
    --         text "No document parsed"
    --     Just (Parsed parsedDetails) ->
    let
        parsedDetailsFound = parsedToParsedDetailsFound parsed
        subtitles = extractSubtitles parsedDetailsFound
        equations = extractEquations parsedDetailsFound
    in
    paragraph []
        [ logToParagraph (String.join "\n " (List.map extractSubtitleText subtitles)) "Subtitles: "
        --, logToParagraph (String.join "\n " equations) "Equations: "
        --, logToParagraph (parsedToSource parsed |> Maybe.withDefault "Error recreating source from parsed") "Parsed source"
        , logToParagraph (parsedDetailsFound |> Debug.toString)  "Parsed details"
        --, logToParagraph (parsed |> Debug.toString)  "Parsed data complete"
                ]
parsedToParsedDetailsFound : Maybe Parsed -> Desc.Description
parsedToParsedDetailsFound maybeParsed = case maybeParsed of
    Just (Parsed p) -> p.found
    Nothing -> DescribeString (Id.Id "err" [0]) "Cannot get description from parsed"

parsedToSource : Maybe Parsed -> Maybe String
parsedToSource  maybeParsed = case maybeParsed of
    Just p -> Just (Mark.toString p) 
    Nothing -> Nothing

-- First text: Extract subtitles from the parsed details
extractSubtitles : Desc.Description -> List Desc.Description
extractSubtitles description =
    case description of
        Desc.StartsWith { first, second } ->
            extractSubtitles first ++ extractSubtitles second

        Desc.Group { children } ->
            List.concatMap extractIfSubtitle children

        Desc.Record { found } ->
            List.concatMap (extractSubtitles << Tuple.second) found

        _ ->
            []
-- Check if the description is a subtitle and extract it
extractIfSubtitle : Desc.Description -> List Desc.Description
extractIfSubtitle description =
    case description of
        Desc.DescribeBlock { name, found } ->
            if name == "Subtitle" then
                [description] ++ extractSubtitles found
            else
                extractSubtitles found

        Desc.Group { children } ->
            List.concatMap extractIfSubtitle children

        _ ->
            []
-- Helper function to extract text from DescribeBlock with DescribeString
extractSubtitleText : Desc.Description -> String
extractSubtitleText description =
    case description of
        Desc.DescribeBlock { found } ->
            case found of
                Desc.DescribeString _ textContent ->
                    textContent

                _ ->
                    ""
        _ ->
            ""

-- Extracting Equations
-- Extract equations from the parsed details
extractEquations : Desc.Description -> List String
extractEquations description =
    case description of
        Desc.StartsWith { first, second } ->
            extractEquations first ++ extractEquations second

        Desc.Group { children } ->
            List.concatMap extractEquations children

        Desc.Record { found } ->
            List.concatMap (extractEquations << Tuple.second) found

        Desc.DescribeText { text } ->
            List.concatMap extractFromText text

        Desc.DescribeBlock { found } ->
            extractEquations found

        _ ->
            []

-- Extract equations from text descriptions
extractFromText : Desc.TextDescription -> List String
extractFromText textDescription =
    case textDescription of
        Desc.InlineBlock { kind, record } ->
            case kind of
                SelectString str ->
                    [str]
                _ ->
                    []

        Desc.Styled _ ->
            []

-- my integration of Szerzo example into editor example with metadata and text
-- use of this function is to compile the document and return a function that takes the runtime data 
-- in model.values; in editor the compiled is called directly by view
compileDocumentWith : Maybe Mark.Parsed -> Result String (MarkupEnv -> Element Msg)
compileDocumentWith parsed =
    case parsed of
        Nothing ->
            Err "No document parsed"

        Just source ->
            case Mark.render myDocumentWith source of -- render handles parsed, compile handles source
                Mark.Success (metadata, blocks)  ->
                    Ok -- result is a function that takes the valid blocks and returns their views
                    -- model.values (here `data`) is passed to such function returned as viewByData  ...
                        (\env -> -- Debug.log ("data" ++ Debug.toString data) <|
                            column [spacing 10]
                                (List.map
                                    -- ... to Inject runtime data into each block handler
                                    -- triggering the rendering function
                                    -- that makes them into regular `elm-ui` nodes
                                    (\block -> block env)
                                    blocks
                                )
                        )
                Mark.Almost { result, errors } ->
                    Ok
                        (\env ->
                            let (metadata, blocks) = result in
                            column []
                                [ row [] (viewErrors errors) -- first displays errors
                                , row []
                                    (List.map
                                        (\block -> block env)
                                        blocks -- then displays the valid result
                                    )
                                ]
                        )
                Mark.Failure errors ->
                    Err ("FAILURE\n" ++ String.join "\n" (List.map MkErr.toString errors))


viewErrors : List MkErr.Error -> List (Element msg)
viewErrors errors =
    List.map
        (Element.html << (MkErr.toHtml MkErr.Light))
        errors



-- Markup blocks


curEditId : MarkupEnv -> Id
curEditId env =
    let
        curEditState : Maybe EditState
        curEditState = env.editState
    in
    case curEditState of
        Just editState -> editState.id
        Nothing -> Id.Id "none" [0]


-- Apply Mark.withId to named block
addIdToblock : Mark.Block (MarkupEnv -> Element Msg) -> Mark.Block (MarkupEnv -> Element Msg)
addIdToblock block =
    Mark.withId
        (\id render ->
            \env ->

                if id == curEditId env then
                    addIdAttributeAndEventsEdit env id 
                else
                    let
                        element = render env
                    in
                    addIdAttributeAndEvents id element
        )
        block
-- wraps in a div with only id attribute
addIdAttributeAndEvents : Id -> Element Msg -> Element Msg
addIdAttributeAndEvents id element =
    el [ getIdAttribute id
       , UiEvents.onDoubleClick (ActivateEditMode id)
       , width fill
       ] element

addIdAttributeAndEventsEdit : MarkupEnv -> Id  -> Element Msg
addIdAttributeAndEventsEdit env id  =
    let
        content = case env.editState of
            Just state -> state.content
            Nothing -> "env.editState is Nothing"
    in
    UiInput.multiline
        [ width shrink
        , height fill
        , UiBorder.rounded 6
        , UiBorder.width 2
        , UiBorder.color darkCharcoal
        , UiBackground.color paleGreen
        --, UiEvents.onDoubleClick (SaveEdit)
        , uiAttr (onKeyDown (onKeyDownEditDecoder env))
        , uiAttr (HtmlAttr.id (Id.toString id ++ "-edit"))
        ]
        { onChange = UpdateContent
        , text = content
        , placeholder = Nothing
        , spellcheck = False
        , label = UiInput.labelHidden ""
        }

-- Function to set the block name ABORTED a lot of more fields must be set
setBlockName : String -> Mark.Block (MarkupEnv -> Element Msg) -> Mark.Block (MarkupEnv -> Element Msg)
setBlockName name (Desc.Block details) =
    Desc.Block { details | kind = Named name }


getIdAttribute : Id -> Attribute msg
getIdAttribute id =
    let idStr = Id.toString id in
    Element.htmlAttribute (HtmlAttr.id idStr)

{-| Title block, renders to h1 [][ text _ ]
with 2nd arg in lambda: (\str _ ->)  returns a (Values -> Element msg) function!! 
-}

titleBlock : Mark.Block (MarkupEnv -> Element Msg)
titleBlock =
    Mark.block "Title"
        (\children ->
            \env -> row titleAttrs (List.map (\child -> child env) children)
        )
        mkText
titleAttrs : List (Attribute msg)
titleAttrs = [UiFont.bold, UiFont.size 24, paddingEach {top=15, right=0, bottom= 8, left= 0}]

subtitleBlock : Mark.Block (MarkupEnv -> Element Msg)
subtitleBlock =
    Mark.block "Subtitle"
        (\children ->
            \env -> row 
                subTitleAttrs 
                (List.map (\child -> child env) children)
        )
        mkText
subTitleAttrs : List (Attribute msg)
subTitleAttrs = [UiFont.bold, UiFont.size 20, paddingEach {top=12, right=0, bottom= 5, left= 0}]


{-| Counter block, renders to `var = [+] value [-]`
returns msg with the name of the counter and the new value
-}
counterBlock : Mark.Block (MarkupEnv -> Element Msg)
counterBlock =
    Mark.record "Counter"  -- instruction to parse "Counter" blocks as records
        (\name env ->   -- name is of type `var1` and values is the dictionary
            let
                values = env.values
                value = -- get the value for name of type `var1` from the dictionary
                    getValue name values
            in
            row
                [spacing 5]
                [ text (name ++ "  =  ")
                , UiInput.button 
                    [UiBorder.rounded 1, UiBackground.color MyColors.lightGray] 
                    { label = text " - ", onPress = Just (SetValue ( name, value - 1 )) }
                , text (String.fromFloat value) -- render the value in div
                , UiInput.button 
                    [UiBorder.rounded 1, UiBackground.color MyColors.lightGray] 
                    { label = text " + ", onPress = Just (SetValue ( name, value + 1 )) }
                ]
        )
        |> Mark.field "name" Mark.string -- field parser for the name of the counter variable
        |> Mark.toBlock -- marks end of record block


{-| Renders the sum of two values controlled through counters, renders to `var1 + var2 == value`
-}
sumBlock : Mark.Block (MarkupEnv -> Element Msg)
sumBlock =
    Mark.record "Sum"
        (\arg1 arg2 env ->
            let
                values = env.values
                res =
                    getValue arg1 values + getValue arg2 values
            in
            row
                []
                [ text (arg1 ++ " + " ++ arg2 ++ " == ")
                , text (String.fromFloat res)
                ]
        )
        |> Mark.field "arg1" Mark.string -- fields holding the names of the counter variables
        |> Mark.field "arg2" Mark.string -- that are to be summed
        |> Mark.toBlock

-- toy block for testing data parsing
poemBlock : Mark.Block String
poemBlock = 
    Mark.block "Poem"
        (\str -> str)
        Mark.string

csvBlock : Mark.Block (List String)
csvBlock = 
    Mark.block "Csv"
        (\str -> String.split "," str)
        Mark.string
myStringProcessorDoc : Mark.Document () (List String)
myStringProcessorDoc = 
    Mark.document 
        [ csvBlock
        , poemBlock |> Mark.map (\str -> [str])
        ]

-- TEXT HANDLING IN elm-ui
viewText : Styles -> String -> ( MarkupEnv -> Element Msg)
viewText styles string  =
        let
            styleFlags = (if styles.bold then [UiFont.bold] else []) 
                ++ (if styles.italic then [UiFont.italic] else [])  
                ++ (if styles.strike then [UiFont.strike] else [])
            -- created to solve nowrap issue, but it's not needeed, used textColumn
            -- to avoid text wrap in Sheets use sheetBlock, not viewSheet inline
            -- displayInline = [uiAttr (HtmlAttr.style "display" "inline")]
        in
        if List.isEmpty styleFlags then (\_ -> text string)
        else 
            (\_ -> el
                    (styleFlags)
                    (text string)
                )
-- Mark.textWith returns: -> Block (List rendered)
mkText : Mark.Block ( List (MarkupEnv -> Element Msg) )
mkText =
    Mark.textWith
        { view =
            \styles string  ->
                viewText styles string 
        , replacements = Mark.commonReplacements
        , inlines = 
        [ viewSheet
        , viewLink
        , viewEqn
        , viewValue
        , viewValueDiff
        ] -- no inline elements, conflicts with elm-ui
        }
-- from editor example
mkTextHtml : Mark.Block (List (Html msg))
mkTextHtml =
    Mark.textWith
        { view =
            \styles string ->
                viewTextHtml styles string
        , replacements = Mark.commonReplacements
        , inlines =
            [ viewLinkHtml
            , droppedCapitalHtml
            ]
        }

viewTextHtml styles string =
    if styles.bold || styles.italic || styles.strike then
        Html.span
            [ HtmlAttr.classList
                [ ( "bold", styles.bold )
                , ( "italic", styles.italic )
                , ( "strike", styles.strike )
                ]
            ]
            [ Html.text string ]

    else
        Html.text string




renderEquation : String -> MarkupEnv -> Element Msg
renderEquation src env =
    if Dict.member src env.equations then
        let
            svg = Dict.get src env.equations |> Maybe.withDefault ""
        in
        image []
            { src = "data:image/svg+xml;base64," ++ svg
            , description = "rendered equation for src: " ++ src
            }
    else
        el [ UiEvents.onClick (RequestRender src) ] (text "Rendering...")


viewEqn : Mark.Record (MarkupEnv -> Element Msg)
viewEqn =
    Mark.verbatim "eqn"
        (\id src env ->
            renderEquation src env
        )
        --renderEquation
        --|> Mark.field "src" Mark.string
-- NB wraps text in divs, no title, use for partial views or cells, add view field
-- use sheetBlock for whole sheets with pivotreshaper and editor
viewSheet : Mark.Record (MarkupEnv -> Element Msg)
viewSheet =
    Mark.verbatim "sheet"
        (\id datasetRef env ->
            viewSheetByDatasetRefInternal env datasetRef
        )

viewValue : Mark.Record (MarkupEnv -> Element Msg)
viewValue =
    Mark.verbatim "value"
        (\id name env -> -- id rimane quello di container block
            let inputId = Id.toString id ++ "-" ++ name in
            case env.showValues of
                -- TODO if edited value is not a number (e.g. delete last figure) 
                -- text change is not reflected in the input
                Editable ->
                    UiInput.multiline -- UiInput.text does not shrink
                        [ width shrink
                        , height shrink
                        , paddingEach {top=0, right=2, bottom=0, left=2}
                        , UiBorder.rounded 2
                        , UiBorder.width 1
                        , UiBorder.color darkCharcoal
                        , UiBackground.color lightBlue
                        , UiEvents.onLoseFocus CancelValueEdit
                        -- , uiAttr (onKeyDown (onKeyDownEditDecoder env))
                        , uiAttr (HtmlAttr.id (inputId ++ "-edit"))
                        ]
                        { onChange = SetValueFromString name
                        , text = 
                            let 
                                rawStr = getValue name env.values |> String.fromFloat
                                curatedStr = 
                                    if String.contains "." rawStr then
                                        rawStr
                                    else
                                        rawStr ++ ".0"
                            in
                            curatedStr
                        , placeholder = Nothing
                        , label = UiInput.labelHidden ""
                        , spellcheck = False
                        }
                NotEditable ->
                    el 
                    [UiBackground.color lightGray, UiBorder.rounded 2, UiBorder.width 1, UiBorder.color darkCharcoal
                    , paddingEach {top=0, right=2, bottom=0, left=2}
                    , UiEvents.onClick (ActivateValueEdit inputId)
                    , uiAttr (HtmlAttr.id (inputId ++ "-noedit"))
                    ]
                    --(text (String.fromFloat(getValue name env.values)))
                    (text (formatFloat (getValue name env.values)))
        )
viewValueDiff : Mark.Record (MarkupEnv -> Element Msg)
viewValueDiff =
    Mark.verbatim "valueDiff"
        (\id texts arg1 arg2 ->
            \env ->
                let
                    values = env.values
                    res =
                        getValue arg1 values - getValue arg2 values
                in
                el 
                    [UiBackground.color yellow, UiBorder.rounded 2, UiBorder.width 1, UiBorder.color darkCharcoal
                    , paddingEach {top=0, right=2, bottom=0, left=2}
                    ]
                    (text (texts ++ ": " ++ formatFloat res))
        )
        |> Mark.field "arg1" Mark.string -- fields holding the names of the counter variables
        |> Mark.field "arg2" Mark.string -- that are to be summed


viewLink : Mark.Record (MarkupEnv -> Element Msg)
viewLink =
    Mark.annotation "link"
        (\id texts url ->
            \env ->
                link []
                    { url = url
                    , label = paragraph 
                        [UiFont.bold, UiFont.underline, UiFont.color blue] 
                        (List.map (\text -> text env) (List.map (applyTuple viewText) texts))
                    }
        )
        |> Mark.field "url" Mark.string

viewLinkHtml =
    Mark.annotation "link"
        (\id texts url ->
            Html.a [ HtmlAttr.href url ]
                (List.map (applyTuple viewTextHtml) texts)
        )
        |> Mark.field "url" Mark.string


applyTuple fn ( one, two ) =
    fn one two

-- TO REFACTOR
droppedCapitalHtml =
    Mark.verbatim "drop"
        (\id str ->
            let
                drop =
                    String.left 1 str

                lede =
                    String.dropLeft 1 str
            in
            Html.span []
                [ Html.span [ HtmlAttr.class "drop-capital" ]
                    [ Html.text drop ]
                , Html.span [ HtmlAttr.class "lede" ]
                    [ Html.text lede ]
                ]
        )


-- Helper function to flatten List (Values -> Element Msg) to Values -> Element Msg
-- TODO normal text size set here
flattenAndSetFontSize : List (MarkupEnv -> Element Msg) -> MarkupEnv -> Element Msg
flattenAndSetFontSize blocks env =
    paragraph 
        [ UiFont.size 18
        ] 
        (List.map (\block -> block env) blocks)
flattenHtml : Mark.Block (List (Html msg)) -> Mark.Block (Html msg)
flattenHtml blockOfList =
    Mark.map
        (\htmlMsgList ->
            Html.div [] htmlMsgList
        )
        blockOfList
sheetBlock : Mark.Block (MarkupEnv -> Element Msg)
sheetBlock =
    Mark.record "Sheet"
        (\datasetRef title env ->
            column []
                [ el subTitleAttrs (text title)
                , (viewSheetByDatasetRefInternal env datasetRef)
                ]
        )
        |> Mark.field "datasetRef" Mark.string
        |> Mark.field "title" Mark.string
        |> Mark.toBlock

imageBlock : Mark.Block (MarkupEnv -> Element Msg)
imageBlock =
    Mark.record "Image"
        (\src description _ -> --usual dummy arg for Values
            image [uiAttr (HtmlAttr.style "float" "left")
                , uiAttr (HtmlAttr.style "margin-right" "48px")]
                { src = src
                , description = description
                }

        )
        |> Mark.field "src" Mark.string
        |> Mark.field "description" Mark.string
        |> Mark.toBlock

codeBlock : Mark.Block (MarkupEnv -> Element Msg)
codeBlock =
    Mark.block "Code"
        (\str _ ->
            Html.pre
                [ HtmlAttr.style "padding" "12px"
                , HtmlAttr.style "background-color" "#eee"
                ]
                [ Html.text str ]
                    |> Element.html
        )
        Mark.string

{- Handling bulleted and numbered lists -}


--list : Mark.Block 
treeBlock : Mark.Block (MarkupEnv -> Element Msg)
treeBlock =
    Mark.tree 
        (wrapElement renderList)
        (mkTextHtml |> flattenHtml)

listBlock : Mark.Block (MarkupEnv -> Element Msg)
listBlock =
    Mark.block "List"
        identity
        treeBlock
 
renderList : Enumerated (Html msg) -> Html msg
renderList (Mark.Enumerated list) =
    let
        group =
            case list.icon of
                Mark.Bullet ->
                    Html.ul

                Mark.Number ->
                    Html.ol
    in
    group [HtmlAttr.style "paddingTop" "0px"]
        (List.map renderItem list.items)

renderItem : Item (Html msg) -> Html msg
renderItem (Mark.Item item) =
    Html.li []
        [ Html.div [] item.content
        , renderList item.children
        ]

wrapElement : (a -> Html msg) -> a -> MarkupEnv -> Element msg
wrapElement renderFn data _ =
    Element.html (renderFn data)    

-- keyboard events
onKeyDown : Decode.Decoder msg -> Html.Attribute msg
onKeyDown decoder =
    HtmlEvents.on "keydown" decoder

onKeyDownEditDecoder : MarkupEnv  -> Decode.Decoder Msg
onKeyDownEditDecoder env  =
    let
        keyDecoder = Decode.field "keyCode" Decode.int
    in
    Decode.map (keyCodeToMsg env ) keyDecoder

-- current implementation
keyCodeToMsg : MarkupEnv  -> Int -> Msg
keyCodeToMsg env keyCode =
    case env.editState of
        Nothing -> 
            NoOp

        _ -> 
            if keyCode == 13  then  -- Enter key
                SaveEdit
            else if keyCode == 27 then  -- Escape key
                CancelEdit
            else
                NoOp
        
focusCommand : String -> Cmd Msg
focusCommand elementId =
    Dom.focus elementId
        |> Task.attempt FocusResult