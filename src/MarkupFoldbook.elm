module MarkupFoldbook exposing
    ( Model
    , Msg(..)
    , initCmd
    , initialModel
      --, main
    , subscriptions
    , update
    , view
    , viewSheetByDatasetRef
    )

-- Record è Mark.record non vede Mark.Record

import AppUtil exposing (..)
import Browser exposing (Document)
import Browser.Dom as Dom exposing (Viewport)
import Browser.Events exposing (onResize)
import DatasetPage exposing (Model)
import Element exposing (..)
import Element.Background as UiBackground
import Element.Border as UiBorder
import Element.Events as UiEvents
import Element.Font as UiFont
import Element.Input as UiInput
import FastDict as Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as HtmlAttr
import Html.Events as HtmlEvents
import Http
import Json.Decode as Decode exposing (Decoder, field, string)
import Json.Encode as Encode exposing (Value)
import List
import Mark
    exposing
        ( Document
        , Enumerated(..)
        , Item(..)
        , Parsed
        , Styles
        )
import Mark.Edit exposing (Offset)
import Mark.Error as MkErr exposing (Error)
import Mark.Internal.Description as Desc
    exposing
        ( BlockKind(..)
        , Description(..)
        , InlineSelection(..)
        , Parsed(..)
        , ParsedDetails
        , TextDescription(..)
        )
import Mark.Internal.Id as Id exposing (Id)
import MyColors exposing (..)
import Ports exposing (..)
import Routes exposing (Page(..))
import Task
import Types exposing (Env, Error(..))
import TypesJavascript exposing (BoundingClientRect)
import TypesMarkup
    exposing
        ( BlockType(..)
        , BlockTypesToRender(..)
        , EditState
        , MarkupEnv
        , ShowValues(..)
        , SidebarItem(..)
        , SidebarItemInfo
        , SidebarTree(..)
        , Values
        , emptyMarkupEnv
        , getValue
        )
import Url exposing (Url)
import Core.Basics exposing (le)



-- TODO
-- add a plain view fucntion to DatasetPage
-- consider to add Env in place of EnvMarkup here
-- create a block type to shoe a dataset page given the dataset name as is
-- add fields to configure the dataset view


uiAttr =
    Element.htmlAttribute



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
    , logOnlyActive : Bool
    , documentViewMode : DocumentViewMode
    -- dynamic viewport
    , viewport : Viewport
    }


type DocumentViewMode
    = RenderedMarkup
    | SourceMarkup



-- main : Program () Model Msg
-- main =
--     Browser.document
--         { init = init
--         , view = viewDocument
--         , update = update
--         , subscriptions = subscriptions -- always Sub.none
--         }


initValues =
    Dict.fromList [ ( "ricavi", 1000 ), ( "costoVen", 550 ) ]


initSourcePath =
    "articles/Mathlive.emu"


initialModel : Model
initialModel =
    let
        initialViewport : Viewport
        initialViewport =
            { scene = { width = 0, height = 0 }
            , viewport = { x = 0, y = 0, width = 0, height = 0 }
            }
    in
    { source = Nothing
    , sourcePath = Just initSourcePath
    , mkEnv = { emptyMarkupEnv | values = initValues }
    , parsed = Nothing
    , errors = []
    , svg = ""
    , editorMarkupContent = ""
    , logOnlyActive = False
    , documentViewMode = RenderedMarkup
    , viewport = initialViewport 
    }


initCmd : Cmd Msg
initCmd =
    Cmd.batch
        [ Http.get
            { -- url = "articles/Article.emu"
            url = initSourcePath

            -- url = "articles/Counter.emu"
            -- url ="MyNotes.emu"
            , expect = Http.expectString GotSrcToParsed -- Msg containing http Result passed with Cmd to update
            }
        , getViewportHeightCmd
        ]



init () =
    ( initialModel
    , initCmd
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ mathFieldInput MathFieldUpdated
        , markupContentChanged MarkupContentChanged
        , onResize (\_ _ -> GetViewport)
        ]



-- Update


type Msg
    = SetValue ( String, Float )
    | SetValueFromString String String
    | GotSrcToParsed (Result Http.Error String) -- extended to doc with metadata
    | FocusEquation String
    | BlurEquation String
    | MathFieldUpdated { id : String, value : String, mathJson : Encode.Value, result : String }
    | ActivateEditMode Id
    | UpdateContent String
    | SaveEdit
    | CancelEdit
    | FocusResult (Result Dom.Error ())
    | ActivateValueEdit String
    | CancelValueEdit
    | SaveSourceFromMarkup
    | SaveSourceFromCodemirror
    | SourceSaved
    | DatasetPageMsgInMarkup String DatasetPage.Msg
    | MarkupContentChanged String
    | InsertBlock Id Desc.New -- Action to insert a new block after a given Id
    | DeleteBlock Id -- Action to delete a block by Id
    | HoverEnter Id
    | HoverLeave
    | ToggleShowPopupSetting
    | ToggleShowSourceRendered
    | ToggleBlockTypesToRender
    | NavigateToAnchor String
    | ViewportHeightChanged Viewport
    | GetViewport
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetValue ( key, val ) ->
            let
                curEnv =
                    model.mkEnv

                updatedEnv =
                    { curEnv
                        | values =
                            Dict.insert key
                                val
                                model.mkEnv.values
                    }
            in
            ( { model
                | mkEnv =
                    updatedEnv
              }
            , Cmd.none
            )

        SetValueFromString key strVal ->
            let
                curEnv =
                    model.mkEnv

                cleanedStrVal =
                    strVal

                -- cleaning non serve qui ma seve add ".0" in edit
                -- if String.endsWith decimalSeparator strVal then
                --     strVal ++ "0"
                -- else
                --     strVal
                val =
                    String.toFloat cleanedStrVal
            in
            case val of
                Just v ->
                    let
                        updatedEnv =
                            { curEnv
                                | values =
                                    Dict.insert key
                                        v
                                        model.mkEnv.values
                            }
                    in
                    ( { model | mkEnv = updatedEnv }, Cmd.none )

                Nothing ->
                    ( model, cmdMsg CancelEdit )

        GotSrcToParsed result ->
            -- called at .emu document load or at codemirror edit in source edit mode
            case result of
                Ok src ->
                    let
                        modelWithSource =
                            { model | source = Just src }
                    in
                    case Mark.parse myDocumentWith src of
                        Mark.Success parsed ->
                            let
                                parsedDetailsFound =
                                    parsedToParsedDetailsFound (Just parsed)

                                equations =
                                    extractEquations parsedDetailsFound
                            in
                            ( { modelWithSource
                                | parsed = Just parsed
                                , editorMarkupContent = src
                              }
                            , Cmd.batch
                                [ if model.documentViewMode == RenderedMarkup then
                                    cmdMsg (MarkupContentChanged src)

                                  else
                                    Cmd.none
                                ]
                            )

                        Mark.Almost partial ->
                            let
                                parsedDetailsFound =
                                    parsedToParsedDetailsFound (Just partial.result)

                                equations =
                                    extractEquations parsedDetailsFound
                            in
                            ( { modelWithSource
                                | parsed = Just partial.result
                                , errors = partial.errors
                              }
                            , Cmd.batch
                                [ if model.documentViewMode == RenderedMarkup then
                                    cmdMsg (MarkupContentChanged ("# HAS PARTIAL ERRORS\n" ++ src))

                                  else
                                    Cmd.none
                                ]
                            )

                        Mark.Failure errors ->
                            ( { modelWithSource
                                | parsed = Nothing
                                , errors = errors
                              }
                            , Cmd.none
                            )

                Err err ->
                    let
                        _ =
                            Debug.log "err" err
                    in
                    ( model, Cmd.none )

        FocusEquation parentId ->
            case parentId of
                "m.none.0.0" ->
                    -- value of parentId when viewEqn gets an invalid id from elm-markup
                    ( model, logOnlyMessageNone model.logOnlyActive "Invalid parentId on focus" )

                _ ->
                    let
                        curEnv =
                            model.mkEnv

                        updatedEnv =
                            { curEnv
                                | focusedEquation = Just parentId
                            }

                        eqnId =
                            "eqn-" ++ parentId

                        logMessage =
                            "Focused equation with id: " ++ eqnId ++ "; focusedEquation: " ++ Debug.toString updatedEnv.focusedEquation
                    in
                    ( { model | mkEnv = updatedEnv }, logOnlyMessageFocusEquation model.logOnlyActive logMessage eqnId )

        BlurEquation parentId ->
            let
                curEnv =
                    model.mkEnv

                updatedEnv =
                    { curEnv | focusedEquation = Nothing }

                logMessage =
                    "Blurred equation with id: " ++ parentId ++ "; focusedEquation: " ++ Debug.toString updatedEnv.focusedEquation
            in
            ( { model | mkEnv = updatedEnv }, logOnlyMessageNone model.logOnlyActive logMessage )

        -- ProcessEquations no longer needed, equations are updated by ReceiveLatex
        MathFieldUpdated { id, value, mathJson, result } ->
            -- result not stored in equations dict
            let
                curEnv =
                    model.mkEnv

                maybeId =
                    Id.fromString id

                updatedInline =
                    "`" ++ value ++ "`{eqn}"

                mathJsonStr =
                    case decodeMathJson mathJson of
                        Ok str ->
                            str

                        Err _ ->
                            "Decoding failed"

                parsedContent =
                    parseSourceToBlocks myDocumentWith updatedInline

                updatedEquations =
                    Dict.insert value mathJson curEnv.equations

                -- Update the inline elements in the document
                updatedParsedDoc =
                    case maybeId of
                        Just idJust ->
                            updateParsedDocument idJust parsedContent model.parsed

                        Nothing ->
                            model.parsed

                updatedEnv =
                    { curEnv | equations = updatedEquations, pendingEqn = Nothing }

                logMessage =
                    "MathFieldUpdated for id: " ++ id ++ "; focusedEquation: " ++ Debug.toString updatedEnv.focusedEquation
            in
            ( { model
                | mkEnv = updatedEnv
                , parsed = updatedParsedDoc
                , source = parsedToSource updatedParsedDoc

                --}, logOnlyMessage("MathJson: " ++ mathJsonStr) )
              }
            , logOnlyMessageBlurEquation model.logOnlyActive logMessage id
            )

        -- generic edit mode for markup blocks, mathlive is handled separately
        ActivateEditMode id ->
            let
                parsedFound =
                    parsedToParsedDetailsFound model.parsed

                -- `findMany` returns a list of descriptions without checks
                -- there is a finer grained function `find` that returns a Maybe but is not exposed
                descrForIf =
                    Desc.findMany [ id ] parsedFound

                idStr =
                    Id.toString id
            in
            -- Debug.log ("descrForIf" ++ Debug.toString descrForIf) <|
            case descrForIf of
                [] ->
                    ( model
                    , Cmd.none
                    )

                curDescr :: rest ->
                    let
                        content =
                            extractContentFromMaybeDescr (Just curDescr)

                        curEnv =
                            model.mkEnv

                        -- failure, needs metadata
                        updatedEnv =
                            { curEnv
                                | editState = Just { id = id, content = content }
                                , activeBlockEditPopup = Nothing
                            }
                    in
                    ( { model | mkEnv = updatedEnv }
                      --, logOnlyMessage ("Activated edit mode for id: " ++ idStr) )
                    , focusCommand (idStr ++ "-edit")
                    )

        UpdateContent newContent ->
            case model.mkEnv.editState of
                Just editState ->
                    let
                        curEnv =
                            model.mkEnv

                        updatedEnv =
                            { curEnv | editState = Just { editState | content = newContent } }
                    in
                    ( { model | mkEnv = updatedEnv }
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )

        SaveEdit ->
            case model.mkEnv.editState of
                Just editState ->
                    let
                        parsedContent =
                            parseSourceToBlocks myDocumentWithout editState.content

                        updatedParsedDoc =
                            updateParsedDocument editState.id parsedContent model.parsed

                        curEnv =
                            model.mkEnv

                        updatedEnv =
                            { curEnv | parsedDetails = Nothing, editState = Nothing }

                        -- parsedDetailsFound = parsedToParsedDetailsFound parsedContent
                        -- equations = extractEquations parsedDetailsFound
                    in
                    ( { model
                        | parsed = updatedParsedDoc
                        , source = parsedToSource updatedParsedDoc
                        , mkEnv = updatedEnv
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( model
                    , Cmd.none
                    )

        CancelEdit ->
            case model.mkEnv.editState of
                Just editState ->
                    let
                        curEnv =
                            model.mkEnv

                        updatedEnv =
                            { curEnv | parsedDetails = Nothing, editState = Nothing }
                    in
                    ( { model
                        | mkEnv = updatedEnv
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( model
                    , Cmd.none
                    )

        FocusResult result ->
            case result of
                Ok () ->
                    ( model, Cmd.none )

                Err error ->
                    Debug.log ("Error focusing input: " ++ Debug.toString error)
                        ( model, Cmd.none )

        ActivateValueEdit idStr ->
            -- idStr is the container id ++ the key of the value to edit
            let
                curEnv =
                    model.mkEnv

                updatedEnv =
                    { curEnv | showValues = Editable }
            in
            ( { model | mkEnv = updatedEnv }
            , focusCommand (idStr ++ "-edit")
            )

        CancelValueEdit ->
            let
                curEnv =
                    model.mkEnv

                updatedEnv =
                    { curEnv | showValues = NotEditable }
            in
            ( { model | mkEnv = updatedEnv }, Cmd.none )

        SaveSourceFromMarkup ->
            case ( model.source, model.sourcePath ) of
                ( Just src, Just path ) ->
                    let
                        cleanedSrc =
                            cleanSource src

                        updatedModel =
                            { model
                                | source = Just cleanedSrc
                                , editorMarkupContent = cleanedSrc
                            }
                    in
                    ( updatedModel, saveFile { content = cleanedSrc, path = path } )

                _ ->
                    ( model, Cmd.none )

        SaveSourceFromCodemirror ->
            case model.sourcePath of
                Just path ->
                    let
                        updatedModel =
                            { model
                                | source = Just model.editorMarkupContent
                            }
                    in
                    ( updatedModel
                    , saveFile
                        { content = model.editorMarkupContent
                        , path = path
                        }
                    )

                _ ->
                    ( model, Cmd.none )

        SourceSaved ->
            ( model, Cmd.none )

        -- complex message to handle DatasetPage.Msg here rendering sheets in markup
        DatasetPageMsgInMarkup datasetRef datasetPageMsg ->
            -- Forward the DatasetPageMsg to Main where is handled by MarkupFoldbookMsg
            -- with case on DatasetPageMsgInMarkup thatr re-routes to DatasetPageMsg
            ( model, cmdMsg (DatasetPageMsgInMarkup datasetRef datasetPageMsg) )

        MarkupContentChanged content ->
            -- called by GotSrcToParsed after the source is parsed or at source change in codemirror
            ( { model | editorMarkupContent = content }
              -- if in codemirror, update the parsed markup
            , if model.documentViewMode == SourceMarkup then
                cmdMsg (GotSrcToParsed (Ok content))

              else
                Cmd.none
            )

        InsertBlock afterId newBlockType ->
            let
                ( updatedParsedDoc, maybeNewId ) =
                    insertBlockAfterId afterId newBlockType model.parsed
            in
            case maybeNewId of
                Just newId ->
                    ( { model
                        | parsed = updatedParsedDoc
                        , source = parsedToSource updatedParsedDoc
                      }
                    , cmdMsg (ActivateEditMode newId)
                    )

                Nothing ->
                    ( model, Cmd.none )

        DeleteBlock blockId ->
            let
                updatedParsedDoc =
                    deleteBlockById blockId model.parsed
            in
            ( { model
                | parsed = updatedParsedDoc
                , source = parsedToSource updatedParsedDoc
              }
            , Cmd.none
            )

        HoverEnter id ->
            let
                curEnv =
                    model.mkEnv

                updatedEnv =
                    { curEnv | hoveredBlock = Just id }
            in
            ( { model
                | mkEnv = updatedEnv
              }
            , logOnlyMessageNone False ("Hovering over block: " ++ Id.toString id)
            )

        HoverLeave ->
            let
                curEnv =
                    model.mkEnv

                updatedEnv =
                    { curEnv | hoveredBlock = Nothing }
            in
            -- Assuming we trigger getBoundingClientRect when showing the popup
            ( { model | mkEnv = updatedEnv }
            , Cmd.none
            )

        ToggleShowPopupSetting ->
            let
                curEnv =
                    model.mkEnv

                updatedEnv =
                    { curEnv | showPopupSetting = not curEnv.showPopupSetting }
            in
            ( { model | mkEnv = updatedEnv }, Cmd.none )

        ToggleShowSourceRendered ->
            let
                newDocumentMode =
                    case model.documentViewMode of
                        SourceMarkup ->
                            RenderedMarkup

                        RenderedMarkup ->
                            SourceMarkup
            in
            ( { model | documentViewMode = newDocumentMode }
            , Cmd.none
            )

        ToggleBlockTypesToRender ->
            let
                curMkEnv =
                    model.mkEnv

                newBlockTypesToRender =
                    case curMkEnv.blockTypesToRender of
                        AllBlocks ->
                            OnlySheets

                        OnlySheets ->
                            OnlyNonSheets

                        OnlyNonSheets ->
                            AllBlocks

                updatedMkEnv =
                    { curMkEnv | blockTypesToRender = newBlockTypesToRender }
            in
            ( { model | mkEnv = updatedMkEnv }
            , Cmd.none
            )

        NavigateToAnchor anchorId ->
            ( model, Cmd.none )

        ViewportHeightChanged viewport ->
            ( { model | viewport = viewport }
            , Cmd.none )

        GetViewport  ->
            ( model
            , getViewportHeightCmd )

        NoOp ->
            ( model, Cmd.none )



-- helper function for editing and saving

getViewportHeightCmd : Cmd Msg
getViewportHeightCmd =
    Task.perform ViewportHeightChanged Dom.getViewport

navigateToAnchor : String -> Msg
navigateToAnchor anchor =
    NavigateToAnchor anchor



logOnlyMessageFocusEquation : Bool -> String -> String -> Cmd Msg
logOnlyMessageFocusEquation doLog message id =
    -- This will log only the message
    if doLog then
        Debug.log message (focusCommand id)

    else
        focusCommand id


logOnlyMessageBlurEquation : Bool -> String -> String -> Cmd Msg
logOnlyMessageBlurEquation doLog message id =
    -- This will log only the message
    if doLog then
        Debug.log message (cmdMsg (BlurEquation id))

    else
        cmdMsg (BlurEquation id)


decodeMathJson : Encode.Value -> Result Decode.Error String
decodeMathJson value =
    Decode.decodeValue Decode.string value


cleanSource : String -> String
cleanSource source =
    let
        lines =
            String.split "\n" source

        cleanedLines =
            removeBlankLinesAfterEquals lines
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

        [ line ] ->
            [ line ]



-- block creation and insertion


placeHolderText : String -> Desc.NewInline
placeHolderText blockName =
    Desc.NewText (Desc.Text TypesMarkup.noStyling ("new" ++ blockName))


placeHolderTextBlock : String -> Desc.New
placeHolderTextBlock blockName =
    Desc.NewTextBlock [ placeHolderText blockName ]


insertBlockAfterId : Id -> Desc.New -> Maybe Parsed -> ( Maybe Parsed, Maybe Id.Id )
insertBlockAfterId afterId newBlockType maybeParsedDoc =
    case maybeParsedDoc of
        Just (Parsed parsedDoc) ->
            let
                -- Retrieve current children
                children =
                    getParsedDocumentChildren (Just (Parsed parsedDoc))

                -- Generate the new block using the elm-markup `create` function
                seed =
                    parsedDoc.currentSeed

                created =
                    Desc.create seed newBlockType

                newBlockId =
                    Desc.getId created.desc

                -- Insert the newly created block after the specified `afterId`
                updatedChildren =
                    List.concatMap
                        (\desc ->
                            if Desc.getId desc == afterId then
                                [ desc, created.desc ]
                                -- Insert the new block after the target block

                            else
                                [ desc ]
                        )
                        children

                -- Update the Parsed document with new children and updated seed
                updatedDoc =
                    updateParsedDocWithChildren (Just (Parsed parsedDoc)) updatedChildren
                        |> Maybe.map (\(Parsed doc) -> Parsed { doc | currentSeed = created.seed })
            in
            ( updatedDoc, Just newBlockId )

        Nothing ->
            ( Nothing, Id.fromString "err" )


deleteBlockById : Id -> Maybe Parsed -> Maybe Parsed
deleteBlockById blockId maybeParsedDoc =
    case maybeParsedDoc of
        Just (Parsed parsedDoc) ->
            let
                children =
                    getParsedDocumentChildren (Just (Parsed parsedDoc))

                updatedChildren =
                    List.filter (\desc -> Desc.getId desc /= blockId) children
            in
            updateParsedDocWithChildren (Just (Parsed parsedDoc)) updatedChildren

        Nothing ->
            Nothing


getParsedDocumentChildren : Maybe Parsed -> List Description
getParsedDocumentChildren maybeParsedDoc =
    case maybeParsedDoc of
        Just (Parsed parsedDoc) ->
            case parsedDoc.found of
                StartsWith { second } ->
                    case second of
                        Group { children } ->
                            children

                        _ ->
                            []

                _ ->
                    []

        Nothing ->
            []


updateParsedDocWithChildren : Maybe Parsed -> List Description -> Maybe Parsed
updateParsedDocWithChildren maybeParsedDoc newChildren =
    case maybeParsedDoc of
        Just (Parsed parsedDoc) ->
            let
                updatedFound =
                    case parsedDoc.found of
                        StartsWith starts ->
                            StartsWith
                                { starts
                                    | second =
                                        case starts.second of
                                            Group group ->
                                                Group { group | children = newChildren }

                                            _ ->
                                                starts.second
                                }

                        _ ->
                            parsedDoc.found
            in
            Just (Parsed { parsedDoc | found = updatedFound })

        Nothing ->
            Nothing



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
    case ( parsedEditedContent, parsedDocument ) of
        ( Just (Parsed parsedEdited), Just (Parsed parsedDoc) ) ->
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
            Just
                (Parsed
                    { parsedDoc
                      -- content of parsedDocument
                        | found =
                            -- updaates found.second with updatedChildren
                            case parsedDoc.found of
                                StartsWith starts ->
                                    StartsWith
                                        { starts
                                            | second =
                                                case starts.second of
                                                    Group group ->
                                                        -- if second is Group, updates children
                                                        Group { group | children = updatedChildren }

                                                    _ ->
                                                        starts.second

                                            -- if not Group, returns the original second
                                        }

                                -- return Parsed parsedDoc with updated found
                                _ ->
                                    parsedDoc.found

                        -- if not StartsWith, returns the original found
                    }
                )

        _ ->
            parsedDocument



-- View


view : Model -> Element Msg
view model =
    case model.documentViewMode of
        RenderedMarkup ->
            viewRenderedDocument model

        SourceMarkup ->
            viewSourceDocument model


viewRenderedDocument : Model -> Element Msg
viewRenderedDocument model =
    let
        src =
            Maybe.withDefault "" model.source

        psd =
            model.parsed

        bodyHtml =
            case psd of
                Just parsed ->
                    case compileDocumentWith psd of
                        Ok viewByData ->
                            viewByData model.mkEnv

                        Err err ->
                            text err

                Nothing ->
                    paragraph [] (viewErrors model.errors)

        parsedInspected =
            inspectParsed model.parsed
    in
    column [ width fill, height fill ]
        [ row [ paddingEach { top = 0, bottom = 0, left = 20, right = 0 }, spacing 30 ]
            [ viewToggleDocumentModeButton model
            , viewSaveSourceFromMarkupButton
            , viewTogglePopupButton model.mkEnv.showPopupSetting
            , viewToggleBlockTypesToRenderButton model
            ]
        , row [ width fill ]
            [ viewSidebar model
            , column
                --textColumn
                [ padding 5
                , width (fillPortion 7)
                , height (px (round model.viewport.viewport.height - 200) )--(minimum 0 (px 1600))
                , scrollbarY -- this is important to make the document scroll keeping the sidebar fixed
                , Element.htmlAttribute (HtmlAttr.id "documentElement")
                ]
                [ bodyHtml

                -- , viewInsertSubtitleButton model.parsed
                -- , parsedInspected
                ]
            ]
        ]


viewSourceDocument : Model -> Element Msg
viewSourceDocument model =
    column []
        [ row [ paddingEach { top = 0, bottom = 0, left = 20, right = 0 }, spacing 30 ]
            [ viewToggleDocumentModeButton model
            , viewSaveSourceFromCodemirrorButton
            ]
        , textColumn
            [ padding 20, width fill ]
            [ viewEditedSource model
            ]
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


buttonAttrs : List (Attribute Msg)
buttonAttrs =
    [ padding 5
    , alignRight
    , UiBorder.width 1
    , UiBorder.rounded 5
    , UiBorder.color <| rgb255 200 200 200
    , UiBackground.color MyColors.lightBlue
    , UiFont.size 16
    ]


viewToggleDocumentModeButton : Model -> Element Msg
viewToggleDocumentModeButton model =
    let
        buttonText =
            case model.documentViewMode of
                RenderedMarkup ->
                    "View Source"

                SourceMarkup ->
                    "View Rendered"
    in
    UiInput.button
        buttonAttrs
        { onPress = Just ToggleShowSourceRendered
        , label = text buttonText
        }


viewToggleBlockTypesToRenderButton : Model -> Element Msg
viewToggleBlockTypesToRenderButton model =
    let
        buttonText =
            case model.mkEnv.blockTypesToRender of
                AllBlocks ->
                    "All block types -> only sheets"

                OnlySheets ->
                    "Only sheets -> only non-sheets"

                OnlyNonSheets ->
                    "Only non-sheets -> all block types"
    in
    UiInput.button
        buttonAttrs
        { onPress = Just ToggleBlockTypesToRender
        , label = text buttonText
        }


viewSaveSourceFromMarkupButton : Element Msg
viewSaveSourceFromMarkupButton =
    UiInput.button
        buttonAttrs
        { onPress = Just SaveSourceFromMarkup
        , label = text "Save source from markup"
        }


viewSaveSourceFromCodemirrorButton : Element Msg
viewSaveSourceFromCodemirrorButton =
    UiInput.button
        buttonAttrs
        { onPress = Just SaveSourceFromCodemirror
        , label = text "Save source from Codemirror"
        }


viewTogglePopupButton : Bool -> Element Msg
viewTogglePopupButton showPopupSetting =
    let
        buttonText =
            if showPopupSetting then
                "Hide Popups"

            else
                "Show Popups"
    in
    UiInput.button
        buttonAttrs
        { onPress = Just ToggleShowPopupSetting
        , label = text buttonText
        }


viewInsertSubtitleButton : Maybe Parsed -> Element Msg
viewInsertSubtitleButton maybeParsedDoc =
    UiInput.button
        [ padding 5
        , alignRight
        , UiBorder.width 1
        , UiBorder.rounded 3
        , UiBorder.color <| rgb255 200 200 200
        ]
        { onPress =
            case findFirstTitleId maybeParsedDoc of
                Just titleId ->
                    Just
                        (InsertBlock titleId
                            (let
                                newPlaceHolderText =
                                    placeHolderText "Subtitle"
                             in
                             Desc.NewBlock "Subtitle" (Desc.NewTextBlock [ newPlaceHolderText ])
                            )
                        )

                Nothing ->
                    Nothing

        -- No Title block found, so do nothing
        , label = text "Insert Subtitle"
        }



-- Helper function to find the first Title block's Id, for initial test only


findFirstTitleId : Maybe Parsed -> Maybe Id
findFirstTitleId maybeParsedDoc =
    case maybeParsedDoc of
        Just (Parsed parsedDoc) ->
            let
                children =
                    getParsedDocumentChildren (Just (Parsed parsedDoc))

                firstTitleBlock =
                    List.head <|
                        List.filter
                            (\desc ->
                                case desc of
                                    DescribeBlock block ->
                                        block.name == "Title"

                                    _ ->
                                        False
                            )
                            children
            in
            case firstTitleBlock of
                Just desc ->
                    case desc of
                        DescribeBlock block ->
                            Just block.id

                        _ ->
                            Nothing

                Nothing ->
                    Nothing

        Nothing ->
            Nothing


viewEditedSource : Model -> Element Msg
viewEditedSource model =
    let
        codeMirrorElement =
            Element.html <|
                Html.node "code-mirror-markup-editor"
                    [ HtmlAttr.attribute "data-initial-value" model.editorMarkupContent
                    , HtmlAttr.attribute "id" "markup-editor"
                    , HtmlEvents.on "markupContentChanged" (Decode.map MarkupContentChanged (Decode.at [ "detail" ] Decode.string))
                    ]
                    []
    in
    column [ padding 20, spacing 10 ]
        [ row [ UiFont.size 24, UiFont.bold ] [ text "Markup Editor" ]
        , el [ UiFont.size 16, width fill ] codeMirrorElement
        ]



-- to keep an autonomous main function that can be used in the browser


viewEditedSourceToHtml : Model -> Html.Html Msg
viewEditedSourceToHtml model =
    layout [] (viewEditedSource model)



-- define the doc structure, in this case it's just a list of blocks
-- by means of counterBlock produces messages (String, Float)
-- that in view are passed wrapped in SetValue to the update function


myDocumentWith :
    Mark.Document
        { id : String
        , author : String
        , description : List (MarkupEnv -> Element.Element Msg)
        , title : List (MarkupEnv -> Element.Element Msg)
        }
        (MarkupEnv -> Element.Element Msg)
myDocumentWith =
    Mark.documentWith
        { id = \_ -> "doc" --\metadata -> metadata.id
        , metadata =
            --articleMetadata
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
            List.map addIdToBlock
                [ ( TitleBlock, titleBlock )
                , ( SubtitleBlock, subtitleBlock )
                , ( SheetBlock, sheetBlock )
                , ( TextBlock, Mark.map flattenAndSetFontSize mkText ) -- sgamuffo per non rendere List (Values -> Element Msg) ma spezza esto con diversi formati
                , ( CounterBlock, counterBlock )
                , ( SumBlock, sumBlock )
                , ( ImageBlock, imageBlock )
                , ( CodeBlock, codeBlock )
                , ( EqnBlock, eqnBlock )
                , ( ListBlock, listBlock )
                ]
        }



-- myDocument without metadata used to parse single blocks
-- DEPRECATED missing doc id in metadata causes error in block id generation
-- () is for the missing metadata


myDocumentWithout : Mark.Document () (MarkupEnv -> Element Msg)
myDocumentWithout =
    Mark.document
        (List.map addIdToBlock
            [ ( TitleBlock, titleBlock )
            , ( SubtitleBlock, subtitleBlock )
            , ( SheetBlock, sheetBlock )
            , ( TextBlock, Mark.map flattenAndSetFontSize mkText ) -- sgamuffo per non rendere List (Values -> Element Msg) ma spezza esto con diversi formati
            , ( CounterBlock, counterBlock )
            , ( SumBlock, sumBlock )
            , ( ImageBlock, imageBlock )
            , ( CodeBlock, codeBlock )
            , ( EqnBlock, eqnBlock )
            , ( ListBlock, listBlock )
            ]
        )


parseSourceToBlocks : Mark.Document meta data -> String -> Maybe Mark.Parsed
parseSourceToBlocks doc content =
    let
        outcome =
            Mark.parse doc content

        retBlocks =
            case outcome of
                Mark.Success parsed ->
                    Just parsed

                _ ->
                    Nothing
    in
    retBlocks



-- SIDEBAR CREATION
-- Extracts the sidebar items from the parsed document


generateSidebarFromParsed : BlockTypesToRender -> Maybe Parsed -> List SidebarItem
generateSidebarFromParsed blockTypesToRender maybeParsed =
    case maybeParsed of
        Just (Parsed parsedDetails) ->
            case parsedDetails.found of
                Desc.StartsWith { second } ->
                    case second of
                        Group { children } ->
                            children
                                |> List.concatMap extractSidebarTree
                                |> groupIntoTree
                                |> List.filterMap (filterSidebarTree blockTypesToRender)
                                |> flattenSidebarTreeToItems

                        _ ->
                            []

                _ ->
                    []

        Nothing ->
            []


groupIntoTree : List SidebarTree -> List SidebarTree
groupIntoTree items =
    let
        -- Helper function to recursively nest items by level
        nestItems : List SidebarTree -> Int -> ( List SidebarTree, List SidebarTree )
        nestItems itemsArg parentLevel =
            case itemsArg of
                [] ->
                    ( [], [] )

                (Node (FolderItem itemInfo) children) :: rest ->
                    if itemInfo.level > parentLevel then
                        let
                            ( nestedChildren, remaining ) =
                                nestItems rest itemInfo.level

                            newNode =
                                Node (FolderItem itemInfo) nestedChildren

                            ( siblings, remainder ) =
                                nestItems remaining parentLevel
                        in
                        ( newNode :: siblings, remainder )

                    else
                        ( [], itemsArg )

                (Node (SheetItem itemInfo) []) :: rest ->
                    let
                        sheetNode =
                            Node (SheetItem itemInfo) []

                        ( siblings, remainder ) =
                            nestItems rest parentLevel
                    in
                    ( sheetNode :: siblings, remainder )

                _ ->
                    ( [], [] )

        ( groupedItems, _ ) =
            nestItems items 0
    in
    groupedItems


extractSidebarTree : Description -> List SidebarTree
extractSidebarTree description =
    case description of
        DescribeBlock { name, id, found } ->
            case name of
                "Title" ->
                    [ Node
                        (FolderItem
                            { anchor = Id.toString id
                            , name = getSidebarTextContent found
                            , level = 1
                            }
                        )
                        []
                    ]

                "Subtitle" ->
                    [ Node
                        (FolderItem
                            { anchor = Id.toString id
                            , name = getSidebarTextContent found
                            , level = 2
                            }
                        )
                        []
                    ]

                _ ->
                    []

        Record { name, id, found } ->
            if name == "Sheet" then
                [ Node
                    (SheetItem
                        { anchor = Id.toString id
                        , name = getSheetTitle found
                        , level = 3
                        }
                    )
                    []
                ]

            else
                []

        _ ->
            []


filterSidebarTree : BlockTypesToRender -> SidebarTree -> Maybe SidebarTree
filterSidebarTree blockTypesToRender (Node item children) =
    let
        -- Recursively filter the children of the current node
        filteredChildren =
            children
                |> List.filterMap (filterSidebarTree blockTypesToRender)

        -- Determine if the current node should be included based on the filter
        shouldInclude =
            case ( blockTypesToRender, item ) of
                ( AllBlocks, _ ) ->
                    True

                ( OnlySheets, SheetItem _ ) ->
                    True

                ( OnlySheets, FolderItem _ ) ->
                    List.length filteredChildren > 0

                ( OnlyNonSheets, SheetItem _ ) ->
                    False

                ( OnlyNonSheets, FolderItem _ ) ->
                    True

        -- List.length filteredChildren > 0
    in
    if shouldInclude then
        Just (Node item filteredChildren)

    else
        Nothing



-- Helper function to flatten the tree structure into a list of items


flattenSidebarTreeToItems : List SidebarTree -> List SidebarItem
flattenSidebarTreeToItems trees =
    List.concatMap flattenNode trees


flattenNode : SidebarTree -> List SidebarItem
flattenNode (Node item children) =
    item :: List.concatMap flattenNode children


getSidebarTextContent : Description -> String
getSidebarTextContent content =
    case content of
        DescribeText { text } ->
            text
                |> List.map (\styled -> getTextFromStyled styled)
                |> String.join ""

        _ ->
            ""


getTextFromStyled : TextDescription -> String
getTextFromStyled textDesc =
    case textDesc of
        Styled (Desc.Text _ content) ->
            content

        -- Extracts plain text content, ignoring styles
        _ ->
            ""


getSheetTitle : List ( String, Description ) -> String
getSheetTitle fields =
    fields
        |> List.filter (\( key, _ ) -> key == "title")
        |> List.head
        |> Maybe.map (\( _, titleWrapped ) -> unwrapDescribeString titleWrapped)
        |> Maybe.withDefault ""


unwrapDescribeString : Description -> String
unwrapDescribeString description =
    case description of
        Desc.DescribeString _ content ->
            content

        _ ->
            ""



-- sidebar view functions


viewSidebar : Model -> Element Msg
viewSidebar model =
    let
        items =
            generateSidebarFromParsed model.mkEnv.blockTypesToRender model.parsed
    in
    --Debug.log ("items" ++ Debug.toString items) <|
    Element.column
        [ width (fillPortion 1) --(px 200)
        , spacing 10
        , padding 20
        , Element.alignTop
        , Element.htmlAttribute (HtmlAttr.id "sidebarElement")
        ]
        (List.map viewSidebarItem items)


viewSidebarItem : SidebarItem -> Element Msg
viewSidebarItem item =
    let
        attrs itemInfo =
            case itemInfo.level of
                1 ->
                    [ UiFont.bold, UiFont.size 16 ]

                2 ->
                    [ paddingEach { top = 0, left = 10, bottom = 0, right = 0 }, UiFont.size 16 ]

                3 ->
                    [ paddingEach { top = 0, left = 20, bottom = 0, right = 0 }, UiFont.size 14 ]

                _ ->
                    []
    in
    case item of
        FolderItem itemInfo ->
            UiInput.button
                (attrs itemInfo)
                { label = paragraph [] [ text itemInfo.name ]
                , onPress = Just (NavigateToAnchor itemInfo.anchor)
                }

        SheetItem itemInfo ->
            UiInput.button
                (attrs itemInfo)
                { label = paragraph [] [ text itemInfo.name ]
                , onPress = Just (NavigateToAnchor itemInfo.anchor)
                }



-- Ignore non-styled elements
-- rendered doc is not usable because it's a list of (Env -> Element Msg)
-- must inspect on parsed to get internal structure


inspectParsed : Maybe Mark.Parsed -> Element Msg
inspectParsed parsed =
    -- case parsed of
    --     Nothing ->
    --         text "No document parsed"
    --     Just (Parsed parsedDetails) ->
    let
        parsedDetailsFound =
            parsedToParsedDetailsFound parsed

        subtitles =
            extractSubtitles parsedDetailsFound

        equations =
            extractEquations parsedDetailsFound
    in
    paragraph []
        [ logToParagraph (String.join "\n " (List.map extractSubtitleText subtitles)) "Subtitles: "

        --, logToParagraph (String.join "\n " equations) "Equations: "
        --, logToParagraph (parsedToSource parsed |> Maybe.withDefault "Error recreating source from parsed") "Parsed source"
        , logToParagraph (parsedDetailsFound |> Debug.toString) "Parsed details"

        --, logToParagraph (parsed |> Debug.toString)  "Parsed data complete"
        ]


parsedToParsedDetailsFound : Maybe Parsed -> Desc.Description
parsedToParsedDetailsFound maybeParsed =
    case maybeParsed of
        Just (Parsed p) ->
            p.found

        Nothing ->
            DescribeString (Id.Id "err" [ 0 ]) "Cannot get description from parsed"


parsedToSource : Maybe Parsed -> Maybe String
parsedToSource maybeParsed =
    case maybeParsed of
        Just p ->
            Just (Mark.toString p)

        Nothing ->
            Nothing



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
                [ description ] ++ extractSubtitles found

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

        Desc.Record { name, found } ->
            -- Record is matched for Sheet and Metadata
            if name == "eqn" then
                List.concatMap (extractEquations << Tuple.second) found

            else
                []

        Desc.DescribeText { text } ->
            -- Only extract equations if the record name is "eqn"
            List.concatMap (extractEqnFromText "eqn") text

        Desc.DescribeBlock { found } ->
            extractEquations found

        _ ->
            []



-- Extract equations from text descriptions


extractEqnFromText : String -> TextDescription -> List String
extractEqnFromText inlineName textDesc =
    case textDesc of
        Styled _ ->
            -- No equations to extract from styled text
            []

        -- without filter on "eqn" triggered ProcessEquations after rendering source editor
        InlineBlock { kind, record } ->
            --Debug.log ("InlineBlock, kind: " ++ Debug.toString kind ++ " record: " ++ Debug.toString record) <|
            case kind of
                SelectString eqnSource ->
                    case record of
                        Desc.Record { name, found } ->
                            if name == inlineName then
                                [ eqnSource ]

                            else
                                []

                        _ ->
                            []

                _ ->
                    -- Ignore other kinds
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
            case Mark.render myDocumentWith source of
                -- render handles parsed, compile handles source
                Mark.Success ( metadata, blocks ) ->
                    Ok
                        -- result is a function that takes the valid blocks and returns their views
                        -- model.values (here `data`) is passed to such function returned as viewByData  ...
                        (\env ->
                            -- Debug.log ("data" ++ Debug.toString data) <|
                            column [ spacing 10 ]
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
                            let
                                ( metadata, blocks ) =
                                    result
                            in
                            column []
                                [ row [] (viewErrors errors) -- first displays errors
                                , row []
                                    (List.map
                                        (\block -> block env)
                                        blocks
                                     -- then displays the valid result
                                    )
                                ]
                        )

                Mark.Failure errors ->
                    Err ("FAILURE\n" ++ String.join "\n" (List.map MkErr.toString errors))


viewErrors : List MkErr.Error -> List (Element msg)
viewErrors errors =
    List.map
        (Element.html << MkErr.toHtml MkErr.Light)
        errors



-- Markup blocks


curEditId : MarkupEnv -> Id
curEditId env =
    let
        curEditState : Maybe EditState
        curEditState =
            env.editState
    in
    case curEditState of
        Just editState ->
            editState.id

        Nothing ->
            Id.Id "none" [ 0 ]



-- Apply Mark.withId to named block


addIdToBlock : ( BlockType, Mark.Block (MarkupEnv -> Element Msg) ) -> Mark.Block (MarkupEnv -> Element Msg)
addIdToBlock ( blockType, block ) =
    Mark.withId
        (\id render ->
            \env ->
                let
                    shouldRender =
                        case env.blockTypesToRender of
                            AllBlocks ->
                                True

                            OnlySheets ->
                                isSheetBlock blockType

                            OnlyNonSheets ->
                                not (isSheetBlock blockType)
                in
                if shouldRender then
                    if id == curEditId env then
                        addIdAttributeAndEventsEdit env id

                    else
                        let
                            activeBlockEditPopupId =
                                env.activeBlockEditPopup

                            element =
                                render env

                            elementWithEvents =
                                if activeBlockEditPopupId == Just id then
                                    el
                                        [ getIdAttribute id, width fill ]
                                        element

                                else
                                    addIdAttributeAndEvents env id activeBlockEditPopupId element
                        in
                        elementWithEvents

                else
                    -- Return an empty element or placeholder if the block should not be rendered
                    Element.none
        )
        block


isSheetBlock : BlockType -> Bool
isSheetBlock blockType =
    blockType == SheetBlock



-- wraps in a div with only id attribute


addIdAttributeAndEvents : MarkupEnv -> Id -> Maybe Id -> Element Msg -> Element Msg
addIdAttributeAndEvents env id maybeActivePopupId element =
    let
        onMouseEnterAttr =
            case maybeActivePopupId of
                Just activePopupId ->
                    if activePopupId == id then
                        -- not being edited
                        UiEvents.onMouseEnter NoOp

                    else
                        UiEvents.onMouseEnter (HoverEnter id)

                Nothing ->
                    UiEvents.onMouseEnter (HoverEnter id)

        blockAttrs =
            [ getIdAttribute id
            , onMouseEnterAttr
            , UiEvents.onMouseLeave HoverLeave
            , width fill
            ]

        paddingNormal =
            paddingEach { top = 2, right = 5, bottom = 5, left = 5 }

        paddingWithButtons =
            paddingEach { top = 2, right = 5, bottom = 5, left = 5 }

        elmentWithMaybeButtonBar =
            if env.showPopupSetting && env.hoveredBlock == Just id && env.focusedEquation == Nothing then
                column (paddingWithButtons :: blockAttrs)
                    [ viewBlockEditPopup id
                    , element
                    ]

            else
                el (paddingNormal :: blockAttrs) element

        debugString =
            "id: "
                ++ Id.toString id
    in
    -- Debug.log debugString <|
    elmentWithMaybeButtonBar


addIdAttributeAndEventsEdit : MarkupEnv -> Id -> Element Msg
addIdAttributeAndEventsEdit env id =
    let
        content =
            case env.editState of
                Just state ->
                    state.content

                Nothing ->
                    "env.editState is Nothing"
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
    let
        idStr =
            Id.toString id
    in
    Element.htmlAttribute (HtmlAttr.id idStr)


{-| Title block, renders to h1 [][ text _ ]
with 2nd arg in lambda: (\\str \_ ->) returns a (Values -> Element msg) function!!
-}
titleBlock : Mark.Block (MarkupEnv -> Element Msg)
titleBlock =
    Mark.block "Title"
        (\children ->
            \env -> row titleAttrs (List.map (\child -> child env) children)
        )
        mkText


titleAttrs : List (Attribute msg)
titleAttrs =
    [ UiFont.bold, UiFont.size 24, paddingEach { top = 15, right = 0, bottom = 8, left = 0 } ]


subtitleBlock : Mark.Block (MarkupEnv -> Element Msg)
subtitleBlock =
    Mark.block "Subtitle"
        (\children ->
            \env ->
                row
                    subTitleAttrs
                    (List.map (\child -> child env) children)
        )
        mkText


subTitleAttrs : List (Attribute msg)
subTitleAttrs =
    [ UiFont.bold, UiFont.size 20, paddingEach { top = 12, right = 0, bottom = 5, left = 0 } ]


{-| Counter block, renders to `var = [+] value [-]`
returns msg with the name of the counter and the new value
-}
counterBlock : Mark.Block (MarkupEnv -> Element Msg)
counterBlock =
    Mark.record "Counter"
        -- instruction to parse "Counter" blocks as records
        (\name env ->
            -- name is of type `var1` and values is the dictionary
            let
                values =
                    env.values

                value =
                    -- get the value for name of type `var1` from the dictionary
                    getValue name values
            in
            row
                [ spacing 5 ]
                [ text (name ++ "  =  ")
                , UiInput.button
                    [ UiBorder.rounded 1, UiBackground.color MyColors.lightGray ]
                    { label = text " - ", onPress = Just (SetValue ( name, value - 1 )) }
                , text (String.fromFloat value) -- render the value in div
                , UiInput.button
                    [ UiBorder.rounded 1, UiBackground.color MyColors.lightGray ]
                    { label = text " + ", onPress = Just (SetValue ( name, value + 1 )) }
                ]
        )
        |> Mark.field "name" Mark.string
        -- field parser for the name of the counter variable
        |> Mark.toBlock



-- marks end of record block


{-| Renders the sum of two values controlled through counters, renders to `var1 + var2 == value`
-}
sumBlock : Mark.Block (MarkupEnv -> Element Msg)
sumBlock =
    Mark.record "Sum"
        (\arg1 arg2 env ->
            let
                values =
                    env.values

                res =
                    getValue arg1 values + getValue arg2 values
            in
            row
                []
                [ text (arg1 ++ " + " ++ arg2 ++ " == ")
                , text (String.fromFloat res)
                ]
        )
        |> Mark.field "arg1" Mark.string
        -- fields holding the names of the counter variables
        |> Mark.field "arg2" Mark.string
        -- that are to be summed
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
        , poemBlock |> Mark.map (\str -> [ str ])
        ]



-- TEXT HANDLING IN elm-ui


viewText : Styles -> String -> (MarkupEnv -> Element Msg)
viewText styles string =
    let
        styleFlags =
            (if styles.bold then
                [ UiFont.bold ]

             else
                []
            )
                ++ (if styles.italic then
                        [ UiFont.italic ]

                    else
                        []
                   )
                ++ (if styles.strike then
                        [ UiFont.strike ]

                    else
                        []
                   )

        -- ++ [padding 20]
        -- created to solve nowrap issue, but it's not needeed, used textColumn
        -- created to solve nowrap issue, but it's not needeed, used textColumn
        -- to avoid text wrap in Sheets use sheetBlock, not viewSheet inline
        -- displayInline = [uiAttr (HtmlAttr.style "display" "inline")]
    in
    if List.isEmpty styleFlags then
        \_ -> text string

    else
        \_ ->
            el
                styleFlags
                (text string)



-- Mark.textWith returns: -> Block (List rendered)


mkText : Mark.Block (List (MarkupEnv -> Element Msg))
mkText =
    Mark.textWith
        { view =
            \styles string ->
                viewText styles string
        , replacements = Mark.commonReplacements
        , inlines =
            [ viewSheet
            , viewLink
            , viewEqn
            , viewValue
            , viewValueDiff
            ]

        -- no inline elements, conflicts with elm-ui
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



-- mathlive
-- Custom event handler to prevent default and stop propagation
-- Custom event handler to prevent default on double-click


onDoubleClickWithPreventDefault : Msg -> Html.Attribute Msg
onDoubleClickWithPreventDefault msg =
    HtmlEvents.preventDefaultOn "dblclick" (Decode.succeed ( msg, True ))


viewBlockEditPopup : Id -> Element Msg
viewBlockEditPopup id =
    -- Debug.log ("id: " ++ Debug.toString id ++ ", mousePosition: " ++ Debug.toString ( x, y )) <|
    row
        [ padding 2
        , spacing 5
        , UiBorder.color darkCharcoal
        , UiBorder.width 1
        , UiBorder.rounded 5
        , UiFont.size 14
        , width shrink

        -- , htmlAttribute (HtmlAttr.style "opacity" "1") -- Ensure full opacity
        -- , htmlAttribute (HtmlAttr.style "filter" "none") -- Remove any filters
        -- not needed to leave popup buttons clickable, but left for better security
        , htmlAttribute (HtmlAttr.style "pointer-events" "auto") -- Ensure pointer events are enabled
        ]
        [ button "Edit block" (ActivateEditMode id)
        , el [ padding 2, UiFont.bold ] (text "Insert after")
        , button "Title" (InsertBlock id (Desc.NewBlock "Title" (placeHolderTextBlock "Title")))
        , button "Subtitle" (InsertBlock id (Desc.NewBlock "Subtitle" (placeHolderTextBlock "Subtitle")))
        , button "Paragraph" (InsertBlock id (placeHolderTextBlock "Paragraph"))
        , button "Sheet" (InsertBlock id (Desc.NewRecord "Sheet" [ ( "datasetRef", Desc.NewString "Ce" ), ( "sheet", Desc.NewString "Az" ) ]))
        , el [ padding 2, UiFont.bold ] (text "   ")
        , button "Delete block" (DeleteBlock id)
        ]


button : String -> Msg -> Element Msg
button label msg =
    UiInput.button
        [ padding 2
        , UiBackground.color lightGray
        , UiBorder.width 1
        , UiBorder.rounded 3
        , UiBorder.color darkGray
        ]
        { onPress = Just msg
        , label = text label
        }


renderDisplayEquation : String -> String -> MarkupEnv -> Element Msg
renderDisplayEquation parentId src _ =
    let
        -- editEvent = case (Id.fromString parentId) of
        --     Just id -> ActivateEditMode id
        --     Nothing -> NoOp
        customElement =
            Html.node "math-live-edit"
                -- "math-field" -- made the same as math-live-edit to avail of compute
                [ HtmlAttr.attribute "id" ("eqn-" ++ parentId)
                , HtmlAttr.attribute "value" src
                , HtmlAttr.attribute "read-only" "true"
                , HtmlAttr.attribute "style" "border: none;"
                , HtmlAttr.attribute "parent-id" parentId
                , HtmlEvents.onClick (FocusEquation parentId)

                -- not needed, generic elm-markup double click works outside of equation content
                --, onDoubleClickWithPreventDefault editEvent -- not working, use esc to edit latex source
                ]
                []

        resultElement =
            -- provisional used to test evaluation in mathlivex
            Html.div
                [ HtmlAttr.attribute "id" ("result-" ++ parentId)
                , HtmlAttr.attribute "class" "result"
                , HtmlAttr.attribute "style" "margin-top: 5px; font-weight: bold; color: #333;"
                ]
                [ Html.text "empty result" ]

        -- Initially empty, will be populated with the result
    in
    Element.row []
        [ Element.html customElement
        , Element.html resultElement
        ]


renderEditEquation : String -> String -> MarkupEnv -> Element Msg
renderEditEquation parentId src _ =
    let
        -- Directly render the LaTeX source in a Mathlive element
        -- editEvent = case (Id.fromString parentId) of
        --     Just id -> ActivateEditMode id
        --     Nothing -> NoOp
        customElement =
            Html.node "math-live-edit"
                [ HtmlAttr.attribute "id" ("eqn-" ++ parentId)
                , HtmlAttr.attribute "value" src

                --, HtmlAttr.attribute "read-only" "false"
                , HtmlAttr.attribute "style" "border: none;"
                , HtmlAttr.attribute "parent-id" parentId
                , HtmlEvents.onBlur (BlurEquation parentId)

                -- not needed, generic elm-markup double click works outside of equation content
                --, onDoubleClickWithPreventDefault editEvent
                ]
                []

        resultElement =
            -- provisional used to test evaluation in mathlive
            Html.div
                [ HtmlAttr.attribute "id" ("result-" ++ parentId)
                , HtmlAttr.attribute "class" "result"
                , HtmlAttr.attribute "style" "margin-top: 5px; font-weight: bold; color: #333;"
                ]
                [ Html.text "empty result" ]

        -- Initially empty, will be populated with the result
    in
    Element.row []
        [ Element.html customElement
        , Element.html resultElement
        ]


renderEquation : String -> String -> MarkupEnv -> Element Msg
renderEquation parentId src mkEnv =
    case mkEnv.focusedEquation of
        Just eqnId ->
            if eqnId == parentId then
                -- Temporarily disable the popup by setting activeBlockEditPopup to Nothing
                let
                    mkEnvNoPopup =
                        { mkEnv | activeBlockEditPopup = Nothing }
                in
                renderEditEquation parentId src mkEnvNoPopup

            else
                renderDisplayEquation parentId src mkEnv

        Nothing ->
            renderDisplayEquation parentId src mkEnv


viewEqn : Mark.Record (MarkupEnv -> Element Msg)
viewEqn =
    Mark.verbatim "eqn"
        (\id src env ->
            -- Debug.log ("Render equation with id : " ++ Debug.toString id) <|
            let
                parentId =
                    Id.toString id
            in
            renderEquation parentId src env
        )



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
        (\id name env ->
            -- id rimane quello di container block
            let
                inputId =
                    Id.toString id ++ "-" ++ name
            in
            case env.showValues of
                -- TODO if edited value is not a number (e.g. delete last figure)
                -- text change is not reflected in the input
                Editable ->
                    UiInput.multiline
                        -- UiInput.text does not shrink
                        [ width shrink
                        , height shrink
                        , paddingEach { top = 0, right = 2, bottom = 0, left = 2 }
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
                                rawStr =
                                    getValue name env.values |> String.fromFloat

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
                        [ UiBackground.color lightGray
                        , UiBorder.rounded 2
                        , UiBorder.width 1
                        , UiBorder.color darkCharcoal
                        , paddingEach { top = 0, right = 2, bottom = 0, left = 2 }
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
                    values =
                        env.values

                    res =
                        getValue arg1 values - getValue arg2 values
                in
                el
                    [ UiBackground.color yellow
                    , UiBorder.rounded 2
                    , UiBorder.width 1
                    , UiBorder.color darkCharcoal
                    , paddingEach { top = 0, right = 2, bottom = 0, left = 2 }
                    ]
                    (text (texts ++ ": " ++ formatFloat res))
        )
        |> Mark.field "arg1" Mark.string
        -- fields holding the names of the counter variables
        |> Mark.field "arg2" Mark.string



-- that are to be summed


viewLink : Mark.Record (MarkupEnv -> Element Msg)
viewLink =
    Mark.annotation "link"
        (\id texts url ->
            \env ->
                link []
                    { url = url
                    , label =
                        paragraph
                            [ UiFont.bold, UiFont.underline, UiFont.color blue ]
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
                , viewSheetByDatasetRefInternal env datasetRef
                ]
        )
        |> Mark.field "datasetRef" Mark.string
        |> Mark.field "title" Mark.string
        |> Mark.toBlock


imageBlock : Mark.Block (MarkupEnv -> Element Msg)
imageBlock =
    Mark.record "Image"
        (\src description _ ->
            --usual dummy arg for Values
            image
                [ uiAttr (HtmlAttr.style "float" "left")
                , uiAttr (HtmlAttr.style "margin-right" "48px")
                ]
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



-- to make a named block with id used by renderinf func make a trick
-- first create a named block returning content as string
-- then pass it to Mark.withId where the rendering function is redefined
-- other blocks have id assigned in documentWith togethr with edit toggling events


eqnBlock : Mark.Block (MarkupEnv -> Element Msg)
eqnBlock =
    let
        wrapBlock =
            Mark.block "Equation"
                (\latex ->
                    latex
                )
                Mark.string
    in
    Mark.withId
        (\id latex env ->
            let
                parentId =
                    Id.toString id
            in
            renderEquation parentId latex env
        )
        wrapBlock



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
    group [ HtmlAttr.style "paddingTop" "0px" ]
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


onKeyDownEditDecoder : MarkupEnv -> Decode.Decoder Msg
onKeyDownEditDecoder env =
    let
        keyDecoder =
            Decode.field "keyCode" Decode.int
    in
    Decode.map (keyCodeToMsg env) keyDecoder



-- current implementation


keyCodeToMsg : MarkupEnv -> Int -> Msg
keyCodeToMsg env keyCode =
    case env.editState of
        Nothing ->
            NoOp

        _ ->
            if keyCode == 13 then
                -- Enter key
                SaveEdit

            else if keyCode == 27 then
                -- Escape key
                CancelEdit

            else
                NoOp


focusCommand : String -> Cmd Msg
focusCommand elementId =
    Dom.focus elementId
        |> Task.attempt FocusResult
