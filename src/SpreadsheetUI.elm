module SpreadsheetUI exposing
    ( Model
    , Msg(..)
    , initialModel
    , subscriptions
    , update
    , updateCellUI
    , updateSpreadsheetFromXModel
    , viewCell
    , viewSpreadsheetUI
    , updateTrayData
    , updateSheetUIDataFromView
    , processDimChange
    , viewPivotReshaper
    )


-- basic Editable type with two states: ReadOnly a for current value and Editable a a for value being edited
-- main funcs:
--  edit: if ReadOnly toggles to Editable origValue origValue, if Editable does nothing
--  save: if Editable toggles to ReadOnly modValue, if ReadOnly does nothing
--  cancel: if Editable toggles to ReadOnly with no update, if ReadOnly does nothing
--  map: applies a function to the value if Editable, does nothing if ReadOnly
--  get: returns the value
--  isReadOnly: returns True if ReadOnly, False if Editable
--  isEditable: returns True if Editable, False if ReadOnly
--  isValue: returns True if ReadOnly, False if Editable


import AppUtil exposing (cmdMsg, containsLetters, formatFloat, unique, myLog)
import Array exposing (Array, get)
import Array2D exposing (Array2D)
import Browser.Dom as Dom
import Browser.Events as BrowserEvents
import DnDTray exposing (..)
import Editable exposing (Editable(..))
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FastDict as Dict exposing (Dict)
import Html exposing (col, div, input)
import Html.Attributes as HtmlAttr exposing (style)
import Html.Events as HtmlEvents
import Json.Decode as Decode
import List.Extra as List
import MyColors exposing (..)
import Platform.Cmd as Cmd
import Set exposing (Set)
import Task
import Time exposing (Posix)
import TypesXModel exposing (..)
import UiWidgets exposing (lightTooltip, tooltip)
import XModel exposing (isDataArrayText)
import XParser exposing (XValue(..))

import Html exposing (header)

import XView exposing (SpreadsheetUIData)
import Html.Attributes exposing (start)
import List exposing (head)
import Color exposing (darkBlue)
import Color exposing (purple)
import Color exposing (brown)
import Color exposing (darkPurple)












-- import Ports exposing (focusAndSelect) -- TODO check if needed
-- Types


type alias CellUI =
    { value : Editable String
    , isSelected : Bool
    , isEditing : Bool
    }


type CellPosition
    = DataCell (Int, Int)
    | RowHeaderCell HeaderPath
    | ColHeaderCell HeaderPath
    | TopLeftHeaderCell DimVariantRef
    | TopRightHeaderCell DimVariantRef


type HeaderType
    = RowHeader
    | ColHeader
    | TopLeftHeader
    | TopRightHeader



type alias Model =
    { currentCellUI : Maybe (CellPosition, CellUI) -- current cell being edited and/or selected

    -- spreadsheetUIData
    , sheetUIData : XView.SpreadsheetUIData

    -- XModel
    , curDataset : Dataset
    , curDatasetView : XView.DatasetView
    , curDims : Dims

    -- format
    , defaultCellPadding : Int --
    , defaultFontSize : Int
    -- row/col resizing
    , defaultColWidth : Int -- in px
    , minColWidth : Int -- in px
    , minRowHeight : Int -- in px
    , defaultRowHeight : Int -- in px
    , colWidths : Array Int -- in px
    , rowHeights : Array Int -- in px
    , colHeaderHeights : Array Int -- in px
    , rowHeaderWidths : Array Int -- in px
    , topRightHeaderWidth : Int -- in px
    , resizingStartPosition : Maybe (Int, Int) -- Mouse position
    , ctrlClickedHeader : Maybe (HeaderType, Int) -- Tracks the type and index being resized
    , resizingDividerPosition : Maybe (Int, Int) -- Mouse position
    , hoveredDivider : Maybe (HeaderType, Int) -- Tracks the type and index being hovered     

    -- modal column size dialog
    , mouseClickPosition : Maybe ( Int, Int )
    , showModal : Bool
   
    , tempColumnWidth : Maybe Int

    , tempRowHeight : Maybe Int

    -- interaction status
    , escPressed : Bool
    , hoveredColumn : Maybe Int
    , hoveredRow : Maybe Int
    , ctrlPressed : Bool
    , altPressed : Bool
    , dndTrayModel : DnDTray.Model
    }


initialModel : XModel -> DatasetRef -> Model
initialModel xModel datasetRef =
    let
        -- initializes with initial data from pivot table without formulas
        -- cells calculated Either moved from Left (formula) to Right (value)
        --initialSpreadsheet = read CellParserExcel.parse initialSpreadsheetStr
        initialDataset =
            XModel.getDatasetByRef datasetRef xModel.datasets |> Maybe.withDefault XModel.emptyDataset

        initialDatasetView =
            XView.defaultDatasetView xModel datasetRef (datasetRef ++ "View")
        initialTrayData =
            XView.defaultTrayData xModel.dims
                initialDataset
                initialDatasetView

        initialDnDTrayModel =
            DnDTray.initialModel
        initialViewName = initialDatasetView.name
        rowHeaderDepth =
            List.length initialDatasetView.rowTray
        colHeaderDepth =
            List.length initialDatasetView.colTray

        -- NB view has no data, only structure
        initialSheetUIData =
            XView.generateSpreadsheetUIDataFromView xModel.dims initialDataset initialDatasetView


        defaultColumnWidth =
            120

        defaultRowHeight =
            24
        minColumnWidth =
            40

        defaultCellPadding =
            1
        
    in
    { currentCellUI = Nothing

    -- spreadsheet
    , sheetUIData = initialSheetUIData
    -- XModel
    , curDataset = initialDataset
    , curDatasetView = initialDatasetView
    , curDims = xModel.dims

    -- format
    , defaultCellPadding = defaultCellPadding
    , defaultFontSize = 14
    , defaultColWidth = defaultColumnWidth
    , defaultRowHeight = defaultRowHeight
    , minColWidth = minColumnWidth
    , minRowHeight = 20
    , rowHeights = Array.repeat initialSheetUIData.numDataRows defaultRowHeight
    , colWidths = Array.repeat initialSheetUIData.numDataCols defaultColumnWidth
    , colHeaderHeights = Array.repeat colHeaderDepth defaultRowHeight
    , rowHeaderWidths = Array.repeat rowHeaderDepth defaultColumnWidth
    , topRightHeaderWidth = autoResizedWidth minColumnWidth initialSheetUIData.colDimVariantRefs 14
    , resizingStartPosition = Nothing
    , ctrlClickedHeader = Nothing
    , resizingDividerPosition = Nothing
    , hoveredDivider = Nothing

    , escPressed = False
    , hoveredColumn = Nothing
    , hoveredRow = Nothing

    -- modal column size dialog
    , mouseClickPosition = Nothing
    , showModal = False
    , tempColumnWidth = Nothing
    , tempRowHeight = Nothing
    , ctrlPressed = False
    , altPressed = False
    , dndTrayModel = { initialDnDTrayModel 
        | trayData = initialTrayData 
        , viewName = initialViewName
        }
    }


type Msg
    = EditCellUI CellPosition String-- celle and header editing new common handling for all cell types
    | ChangeCellUI String
    | SaveCellUI 
    | CancelCellUI
    -- structure editing
    | NewDimRef HeaderType
    | RemoveDimRef DimRef HeaderType
    | DestroyDimRef DimRef 
    | NewCoord DimRef Coord HeaderPath HeaderType
    | NewDataArray DataArrayRef HeaderPath HeaderType
    | RemoveCoord DimRef Coord HeaderPath HeaderType
    | RemoveDataArray DataArrayRef HeaderPath HeaderType
    | SelectCell Int Int
    | SaveCell Int Int XValue
    | NoOp
    | RefreshFromXModel
    | FocusResult (Result Dom.Error ())
      -- headers
    | SelectRowHeader HeaderPath
    | SelectColHeader HeaderPath
    | SelectTopLeftHeader DimVariantRef
    | SelectTopRightHeader DimVariantRef
    | SaveHeader HeaderType HeaderPath XValue -- handles renaming of headers
    | SaveTopHeader HeaderType DimVariantRef XValue
    -- new resize
    | SetHeaderHeight HeaderType Int Int
    | SetHeaderWidth HeaderType Int Int
    | AutoColumnWidth Int
    -- general UI support
    | CtrlPressed Bool
    | AltPressed Bool
    | BackspacePressed
    | DebouncedFocus String
    | DnDTrayMsg DnDTray.Msg



subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch 
        [ BrowserEvents.onKeyDown keyDownDecoder
        , BrowserEvents.onKeyUp keyUpDecoder
        , Sub.map DnDTrayMsg (DnDTray.subscriptions model.dndTrayModel)
    ]

    
    -- if model.resizingTypeIndex /= Nothing then
    --     Sub.batch
    --         [ BrowserEvents.onMouseMove (Decode.map PerformResize mousePositionDecoder)
    --         , BrowserEvents.onMouseUp (Decode.succeed EndResize)
    --         ]
    -- else
   --  Sub.none

    -- if model.editingRowHeader /= [] || model.editingColHeader /= [] then
    --     Sub.none -- Disable global key handling during cell editing
    -- else
    --     BrowserEvents.onKeyDown keyDownDecoder




-- Sub.batch
--     [ BrowserEvents.onKeyDown keyDownDecoder
--     , BrowserEvents.onKeyUp keyUpDecoder
--     , BrowserEvents.onClick keyDownDecoder
--     ]
--  pivot and cell management


getRowHeight : Int -> Model -> Int
getRowHeight rowIndex model =
    Array.get rowIndex model.rowHeights |> Maybe.withDefault model.defaultRowHeight


getColumnWidth : Int -> Model -> Int
getColumnWidth coIndex model =
    Array.get coIndex model.colWidths |> Maybe.withDefault model.defaultColWidth




getCellValue : CellUI -> String
getCellValue cell =
    case cell.value of
        ReadOnly value ->
            value

        Editable old new ->
            new


-- what is used for?


getCellDictIndex : Int -> Int -> Array2D ( Int, Int ) -> ( Int, Int )
getCellDictIndex rowIndex colIndex spreadsheetIndex =
    Array2D.get rowIndex colIndex spreadsheetIndex |> Maybe.withDefault ( -1, -1 )



-- Update


update : Msg -> Model -> XModel -> ( Model, XModel, Cmd Msg )
update msg model xModel =
    case msg of -- myLog "SpreadsheetUI update" msg of
        EditCellUI position newChar ->
            let
                (initialEditableValue , cellIdToFocus) =
                    case position of
                        DataCell (rowIndex, colIndex) ->
                            let
                                maybeSpreadsheetCell =
                                    Array2D.get rowIndex colIndex model.sheetUIData.spreadsheet

                                cellText =
                                    case maybeSpreadsheetCell of
                                        Just cell ->
                                            XParser.render cell

                                        Nothing ->
                                            ""

                                editableValue =
                                    if cellText /= "" && newChar == "" then
                                        Editable.edit (Editable cellText cellText)

                                    else if  newChar /= "" then
                                    -- char keypress to edit, only pressed char
                                        Editable.map (always newChar) (Editable.edit (Editable cellText cellText))

                                    else
                                        -- double click, edit cell content
                                        Editable.edit (Editable cellText cellText)
                                dataCellIdToFocus =
                                    getCellInputIdWithDataset rowIndex colIndex model
                            in
                            ( editableValue , dataCellIdToFocus )

                        RowHeaderCell path ->
                            let
                                coord = Tuple.second (List.head (List.reverse path) |> Maybe.withDefault ("", ""))
                                rowHeaderIdToFocus =
                                    getRowHeaderInputIdWithDataset model path
                            in
                            ( Editable.edit (Editable coord coord) , rowHeaderIdToFocus)

                        ColHeaderCell path ->
                            let
                                coord = Tuple.second (List.head (List.reverse path) |> Maybe.withDefault ("", ""))
                                colHeaderIdToFocus =
                                    getColHeaderInputIdWithDataset model path
                            in
                            ( Editable.edit (Editable coord coord) , colHeaderIdToFocus )

                        TopLeftHeaderCell dimVariantRef ->
                            ( Editable.edit (Editable dimVariantRef dimVariantRef) 
                            , getTopHeaderInputIdWithDataset model dimVariantRef TopLeftHeader
                            )

                        TopRightHeaderCell dimVariantRef ->
                            ( Editable.edit (Editable dimVariantRef dimVariantRef) 
                            , getTopHeaderInputIdWithDataset model dimVariantRef TopRightHeader
                            )

            in
            ({ model
                | currentCellUI =
                    Just
                        ( position
                        , { value = initialEditableValue, isEditing = True, isSelected = True }
                        )
            }
            , xModel
            , focusCommand cellIdToFocus -- did not work because inputId missing, not for debounce
            )

        ChangeCellUI newValue ->
            case model.currentCellUI of
                Just (position, cellUI) ->
                    let
                        -- Update the editable value with the new input directly
                        newEditableValueOld =
                            Editable.map (always newValue) cellUI.value
                        newEditableValue =
                            case cellUI.value of
                                ReadOnly value ->
                                    ReadOnly value

                                Editable old _ ->
                                    Editable old newValue
                    in
                    (
                        { model
                            | currentCellUI =
                                Just
                                    ( position
                                    , { cellUI 
                                        | value = newEditableValue 
                                        , isEditing = True
                                        --, isSelected = True
                                        }
                                    )
                        }
                    , xModel
                    , Cmd.none
                    )

                Nothing ->
                    (model, xModel, Cmd.none)




        SaveCellUI ->
             case model.currentCellUI of
                Just (position, cellUI) ->
                    let
                        saveCmd = 
                            case position of
                                DataCell (rowIndex , colIndex) ->
                                    cmdMsg (SaveCell rowIndex colIndex (XParser.parse (getCellValue cellUI) False))
                                RowHeaderCell path ->
                                    cmdMsg (SaveHeader RowHeader path (XParser.parse (getCellValue cellUI) True))
                                ColHeaderCell path ->
                                    cmdMsg (SaveHeader ColHeader path (XParser.parse (getCellValue cellUI) True))
                                TopLeftHeaderCell dimVariantRef ->
                                    cmdMsg (SaveTopHeader TopLeftHeader dimVariantRef (XParser.parse (getCellValue cellUI) True))
                                TopRightHeaderCell dimVariantRef ->
                                    cmdMsg (SaveTopHeader TopRightHeader dimVariantRef (XParser.parse (getCellValue cellUI) True))
                    in
                    ( model, xModel, saveCmd )  
                Nothing ->
                    ( model, xModel, Cmd.none )
        CancelCellUI  ->
            let
                focusCmd =
                    case model.currentCellUI of
                        Just (position, cellUI) ->
                            case position of
                                DataCell (rowIndex, colIndex) ->
                                    cmdMsg (SelectCell rowIndex colIndex)

                                RowHeaderCell path ->
                                    cmdMsg (SelectRowHeader path)

                                ColHeaderCell path ->
                                    cmdMsg (SelectColHeader path)

                                TopLeftHeaderCell dimVariantRef ->
                                    cmdMsg (SelectTopLeftHeader dimVariantRef)

                                TopRightHeaderCell dimVariantRef ->
                                    cmdMsg (SelectTopRightHeader dimVariantRef)

                        Nothing ->
                            Cmd.none
            in
            ( { model | currentCellUI = Nothing }, xModel, focusCmd )

        NewDimRef headerType->
            let
                updatedTray =
                    case headerType of
                        TopLeftHeader ->
                            RowTray

                        TopRightHeader ->
                            ColumnTray
                        _ ->
                            PageTray -- provisional, should not happen and does nothing
                
                newDimName =
                        XModel.newDimName xModel.dims
                updatedXModel =
                    XModel.newDimRef newDimName model.curDataset.ref updatedTray xModel
                -- in the UI changed dataset view is changed here, in other affected datasets it's done in Main UpdateEnv
                updatedView =
                    --myLog "updatedView in SpreadsheetUI" 
                        (XView.addDimRefInView newDimName updatedTray model.curDatasetView)
                updatedModel =
                    updateSheetUIModelFromStructureChange model updatedXModel updatedView
                focusCmd =
                    case (headerType , updatedXModel.updatedDimRef) of
                        (TopLeftHeader , Just updatedRef) ->
                            cmdMsg (SelectTopLeftHeader updatedRef)

                        (TopRightHeader , Just updatedRef)  ->
                            cmdMsg (SelectTopRightHeader updatedRef)
                        _ ->
                            Cmd.none
            in
            ( updatedModel, updatedXModel, focusCmd )

        RemoveDimRef dimName headerType ->
            let
                updatedXModel =
                    XModel.removeDimRef dimName model.curDataset.ref  xModel
                -- in the UI changed dataset view is changed here, in other affected datasets it's done in Main UpdateEnv
                updatedView =
                    --myLog "updatedView in SpreadsheetUI" 
                        (XView.removeDimRefInView dimName model.curDatasetView)
                updatedModel =
                    updateSheetUIModelFromStructureChange model updatedXModel updatedView
                curTrayDimRefs =
                    case headerType of
                        TopLeftHeader ->
                            model.sheetUIData.rowDimVariantRefs

                        TopRightHeader ->
                            model.sheetUIData.colDimVariantRefs
                        _ ->
                            []
                removedDimIndex =
                    elemIndexList dimName curTrayDimRefs |> Maybe.withDefault 0
                updatedDimIndex =
                    (if removedDimIndex + 1 == List.length curTrayDimRefs then
                        List.length curTrayDimRefs - 2
                    else
                        removedDimIndex + 1)

                updatedDimRef =
                    Just (getAtList updatedDimIndex curTrayDimRefs |> Maybe.withDefault "")
                focusCmd =
                    case (headerType , updatedDimRef) of
                        (TopLeftHeader , Just updatedRef) ->
                            cmdMsg (SelectTopLeftHeader updatedRef)

                        (TopRightHeader , Just updatedRef)  ->
                            cmdMsg (SelectTopRightHeader updatedRef)
                        _ ->
                            Cmd.none
                
            in
            ( updatedModel, updatedXModel, focusCmd )

        DestroyDimRef dimName  ->
            let
                updatedXModel =
                    XModel.destroyDimRef dimName model.curDataset.ref  xModel
                -- in the UI changed dataset view is changed here, in other affected datasets it's done in Main UpdateEnv
                updatedView =
                    --myLog "updatedView in SpreadsheetUI" 
                        (XView.removeDimRefInView dimName model.curDatasetView)
                updatedModel =
                    updateSheetUIModelFromStructureChange model updatedXModel updatedView
            in
            ( updatedModel, updatedXModel, Cmd.none )

        -- STRUCTURE
        NewCoord dimRef currentCoord headerPath headerType ->
            let
                updatedXModel =
                    XModel.newCoord dimRef currentCoord headerPath xModel 
                updatedModel =
                    updateSheetUIModelFromStructureChange model updatedXModel model.curDatasetView
                updatedHeaderPath =
                    myLog "NewCoord new path" <|
                    case updatedXModel.updatedHeaderPath of
                        Just path ->
                            path

                        Nothing ->
                            headerPath
                focusCmd =
                    case headerType of
                        RowHeader ->
                            cmdMsg (SelectRowHeader updatedHeaderPath)

                        ColHeader ->
                            cmdMsg (SelectColHeader updatedHeaderPath)
                        _ ->
                            Cmd.none

            in
            -- Debug.log ("NewHeaderTree: " ++ Debug.toString updatedModel.sheetUIData)
            ( updatedModel, updatedXModel, focusCmd )

        NewDataArray dataArrayRef headerPath headerType ->
            let
                updatedXModel =
                    XModel.newDataArray model.curDataset.ref dataArrayRef headerPath xModel
                updatedModel =
                    updateSheetUIModelFromStructureChange model updatedXModel model.curDatasetView
                updatedHeaderPath =
                    myLog "NewDataArray new path" <|
                    case updatedXModel.updatedHeaderPath of
                        Just path ->
                            path

                        Nothing ->
                            headerPath
                focusCmd =
                    case headerType of
                        RowHeader ->
                            cmdMsg (SelectRowHeader updatedHeaderPath)

                        ColHeader ->
                            cmdMsg (SelectColHeader updatedHeaderPath)
                        _ ->    
                            Cmd.none

            in
            -- Debug.log ("NewHeaderTree: " ++ Debug.toString updatedModel.sheetUIData)
            ( updatedModel, updatedXModel, focusCmd )

        RemoveCoord dimRef currentCoord headerPath headerType->
            let
                updatedXModel =
                    XModel.deleteCoord dimRef currentCoord headerPath xModel
                updatedModel =
                    updateSheetUIModelFromStructureChange model updatedXModel model.curDatasetView
                updatedHeaderPath =
                    myLog "NewCoord new path" <|
                    case updatedXModel.updatedHeaderPath of
                        Just path ->
                            path

                        Nothing ->
                            headerPath
                focusCmd =
                    case headerType of
                        RowHeader ->
                            cmdMsg (SelectRowHeader updatedHeaderPath)

                        ColHeader ->
                            cmdMsg (SelectColHeader updatedHeaderPath)
                        _ ->    
                            Cmd.none

            in
            -- Debug.log ("NewHeaderTree: " ++ Debug.toString updatedModel.sheetUIData)
            ( updatedModel, updatedXModel, focusCmd )

        RemoveDataArray dataArrayRef headerPath headerType ->
            let
                updatedXModel =
                    XModel.removeDataArray model.curDataset.ref dataArrayRef headerPath xModel
                updatedModel =
                    updateSheetUIModelFromStructureChange model updatedXModel model.curDatasetView
                updatedHeaderPath =
                    myLog "NewDataArray new path" <|
                    case updatedXModel.updatedHeaderPath of
                        Just path ->
                            path

                        Nothing ->
                            headerPath
                focusCmd =
                    case headerType of
                        RowHeader ->
                            cmdMsg (SelectRowHeader updatedHeaderPath)

                        ColHeader ->
                            cmdMsg (SelectColHeader updatedHeaderPath)
                        _ ->    
                            Cmd.none

            in
            -- Debug.log ("NewHeaderTree: " ++ Debug.toString updatedModel.sheetUIData)
            ( updatedModel, updatedXModel, focusCmd )

        -- NAVIGATION
        SelectCell rowIndex coIndex ->
            -- Update for selecting a cell
            updateForSelectCellUI model xModel (DataCell(rowIndex , coIndex))


        SaveCell rowIndex colIndex newCellValue ->
            if model.escPressed then
                -- Debug.log ("esc pressed, no save")
                ( { model | escPressed = False }, xModel, Cmd.none )

            else
                let
                    ( flatIndex, dVarIndex ) =
                        Array2D.get rowIndex colIndex model.sheetUIData.spreadsheetIndex|> Maybe.withDefault ( -1, -1 )

                    updatedDataset =
                        XModel.setXValueDatumToDataset model.curDataset flatIndex dVarIndex newCellValue

                    curDatasetName =
                        model.curDataset.ref

                    updatedXModel =
                        { xModel
                            | datasets = XModel.insertDataset curDatasetName updatedDataset xModel.datasets
                            , datasetsToRecalc = xModel.datasetsToRecalc ++ [ curDatasetName ]
                        }

                    updatedSheetUIData =
                        XView.generateSpreadsheetUIDataFromView xModel.dims updatedDataset model.curDatasetView 

                    updatedCellUI =
                        -- only with UI settings
                        case model.currentCellUI of
                            Just (position, cellUI ) ->
                                Just
                                    ( position
                                    , { cellUI | value = Editable.save cellUI.value, isEditing = False }
                                    )

                            _ ->
                                model.currentCellUI

                    -- Save changes and exit edit mode
                    newModel =
                        { model
                            | curDataset = updatedDataset
                            , curDims = updatedXModel.dims

                            --, table = updatedTable
                            , currentCellUI = updatedCellUI
                            , sheetUIData = updatedSheetUIData
                            , escPressed = False
                        }
                in
                -- Debug.log ("Updated dataset: " ++ Debug.toString(updatedDataset))
                ( newModel, updatedXModel, Cmd.none )


        NoOp ->
            ( model, xModel, Cmd.none )

        -- FocusResult is only a log message that is sent when the focus command is completed
        RefreshFromXModel ->
            let
                updatedXModel =
                    xModel

                updatedDataset =
                    XModel.getDatasetByRef model.curDataset.ref updatedXModel.datasets |> Maybe.withDefault XModel.emptyDataset

                updatedSheetUIData =
                    XView.generateSpreadsheetUIDataFromView xModel.dims updatedDataset model.curDatasetView 

                -- cellToFocus =
                --     let
                --         coordTuple =
                --             Maybe.withDefault ( 0, 0 ) model.selectedCellUI
                --     in
                --     getCellIdWithDataset (Tuple.first coordTuple) (Tuple.second coordTuple) model
            in
            ( { model
                | curDataset = updatedDataset
                , curDims = updatedXModel.dims
                , sheetUIData = updatedSheetUIData
                , escPressed = False
              }
            , updatedXModel
            , Cmd.none --focusCommand cellToFocus
              --, AppUtil.debounce 20 (DebouncedFocus cellToFocus)-- consigliato da chatGpt, non funziona
            )

        FocusResult result ->
            case result of
                Ok () ->
                    --Debug.log "FocusResult: focus completed" <|
                    --myLog "FocusResult: focus completed" ( model, xModel, Cmd.none )
                    ( model, xModel
                    , Cmd.none
                    --, AppUtil.logOnlyMessageNone True "FocusResult: focus completed" 
                    )

                Err error ->
                    ( model, xModel, AppUtil.logOnlyMessageNone True 
                        ("Error focusing input: " ++ Debug.toString error) 
                    )

        -- HEADERS
        SelectRowHeader headerPath ->
            updateForSelectCellUI model xModel (RowHeaderCell headerPath)
            

        SelectColHeader headerPath ->
            updateForSelectCellUI model xModel (ColHeaderCell headerPath)
        
        SelectTopLeftHeader dimVariantRef ->
            updateForSelectCellUI model xModel (TopLeftHeaderCell dimVariantRef)

        SelectTopRightHeader dimVariantRef ->
            updateForSelectCellUI model xModel (TopRightHeaderCell dimVariantRef)


        SaveHeader headerType headerPath newXValue ->
            case headerPathToCurCell headerPath of
                Just (dimVariantRef, coord) ->
                    let
                        -- Extract the last (dimVariantRef, coord) from the headerPath
                        -- Render the new value as a string
                        newXValueString =
                            XParser.render newXValue

                        -- Compose the updatedHeaderPath with the new value replacing the last coord
                        updatedHeaderPath : HeaderPath
                        updatedHeaderPath =
                            dropLast headerPath ++ [ (dimVariantRef, newXValueString) ]

                        -- Update the dimensions in the data model and the XModel and Model
                        updatedXModel1 =
                            if dimVariantRef == dVarIdentifier then
                                -- Debug.log ("renameDataArrayToXModel " ++ String.join ", " [ model.curDataset.ref, coord, newXValueString] )<|
                                XModel.renameDataArray xModel model.curDataset.ref coord newXValueString
                            else
                                xModel
                        updatedXModel2 =
                            XModel.renameCoord  
                                xModel.dims 
                                (CategDimRef dimVariantRef) 
                                coord 
                                newXValue
                                headerPath
                                updatedXModel1
                        updatedDataset =
                            XModel.getDatasetByRef model.curDataset.ref updatedXModel2.datasets |> Maybe.withDefault model.curDataset


                        -- Delete the old headerPath and insert the updatedHeaderPath in the appropriate Dict
                        updatedCellUI =
                            -- only with UI settings
                            case model.currentCellUI of
                                Just (position, cellUI ) ->
                                    Just
                                        ( position
                                        , { cellUI | value = Editable.save cellUI.value, isEditing = False }
                                        )

                                _ ->
                                    model.currentCellUI

                        -- Update the model with the new headerCellsUI
                        updatedModel1 =
                            { model
                                | currentCellUI = updatedCellUI
                            }
                        updatedModel2 =
                            updateSpreadsheetFromXModel updatedModel1 updatedXModel2 updatedDataset
                        focusCmd =
                            case headerType of
                                RowHeader ->
                                    focusCommand (getRowHeaderIdWithDataset model updatedHeaderPath)

                                ColHeader ->
                                    focusCommand (getColHeaderIdWithDataset model updatedHeaderPath)
                                _ ->
                                    Cmd.none
                    in
                    ( updatedModel2, updatedXModel2, focusCmd )
                Nothing ->
                    ( model, xModel, Cmd.none ) -- should not happen

        SaveTopHeader headerType dimVariantRef newXValue ->
            let

                -- Update the dimensions in the data model and the XModel and Model
                curDatasetRef =
                    model.curDataset.ref
                newDimVariantRef =
                    myLog "newDimVariantRef" (XParser.render newXValue)
                ( updatedXModel , updatedView) =
                    if dimVariantRef == dVarIdentifier -- dVarIdentifier cannot be modified, it's hard coded to "dato"
                        || newDimVariantRef == dVarIdentifier then -- nor a new dim can be named "dato"
                        ( xModel 
                        , model.curDatasetView
                        )
                    else if newDimVariantRef == dimChangeToString (DestroyDim dimVariantRef) then
                        ( XModel.destroyDimRef 
                            dimVariantRef
                            curDatasetRef
                            xModel
                        , (XView.removeDimRefInView 
                            dimVariantRef
                            model.curDatasetView)
                        )
                    else
                        ( XModel.renameDimRef  
                            xModel.dims 
                            curDatasetRef
                            dimVariantRef
                            newXValue
                            xModel
                        , myLog "new view" (XView.renameDimRefInView 
                            dimVariantRef
                            newDimVariantRef
                            model.curDatasetView)
                        )
                -- _ = myLog "SaveTopHeader scenario dims" (Dict.get "scenario" xModel.dims)
                updatedDataset =
                    XModel.getDatasetByRef curDatasetRef updatedXModel.datasets |> Maybe.withDefault model.curDataset


                -- Delete the old headerPath and insert the updatedHeaderPath in the appropriate Dict
                updatedCellUI =
                    -- only with UI settings
                    case model.currentCellUI of
                        Just (position, cellUI ) ->
                            Just
                                ( position
                                , { cellUI | value = Editable.save cellUI.value, isEditing = False }
                                )

                        _ ->
                            model.currentCellUI

                -- Update the model with the new headerCellsUI
                updatedModel1 =
                    { model
                        | currentCellUI = updatedCellUI
                        , curDatasetView = updatedView
                    }
                updatedModel2 =
                    updateSpreadsheetFromXModel updatedModel1 updatedXModel updatedDataset
                focusCmd =
                    case headerType of
                        TopLeftHeader ->
                            focusCommand (getTopHeaderIdWithDataset model newDimVariantRef headerType)
                        TopRightHeader ->
                            focusCommand (getTopHeaderIdWithDataset model newDimVariantRef headerType)
                        _ ->
                            Cmd.none
            in
            ( updatedModel2, updatedXModel, focusCmd )

        SetHeaderHeight headerType index newHeight ->
            case headerType of
                RowHeader ->
                    let
                        adjustedNewHeight =
                            if newHeight < model.minRowHeight then
                                model.minRowHeight
                            else
                                newHeight
                        updatedRowHeights =
                            Array.set index adjustedNewHeight model.rowHeights
                    in
                    ( { model | rowHeights = updatedRowHeights }, xModel, Cmd.none )
                ColHeader ->
                    let
                        adjustedNewHeight =
                            if newHeight < model.minRowHeight then
                                model.minRowHeight
                            else
                                newHeight
                        updatedRowHeights =
                            Array.set index adjustedNewHeight model.colHeaderHeights
                    in
                    ( { model | colHeaderHeights = updatedRowHeights }, xModel, Cmd.none )
                _ ->
                    ( model, xModel, Cmd.none )

        SetHeaderWidth headerType index newWidth ->
            case headerType of
                ColHeader ->
                    let
                        adjustedNewWidth =
                            if newWidth < model.minColWidth then
                                model.minColWidth
                            else
                                newWidth
                        updatedColWidths =
                            Array.set index adjustedNewWidth model.colWidths
                    in
                    ( { model | colWidths = updatedColWidths }, xModel, Cmd.none )
                RowHeader ->
                    let
                        adjustedNewWidth =
                            if newWidth < model.minColWidth then
                                model.minColWidth
                            else
                                newWidth
                        updatedColWidths =
                            Array.set index adjustedNewWidth model.rowHeaderWidths
                    in
                    ( { model | rowHeaderWidths = updatedColWidths }, xModel, Cmd.none )
                _ ->
                    ( model, xModel, Cmd.none )

        AutoColumnWidth colIndex -> -- activated via Alt + click on column header
            let
                columnData =
                    getRenderedDataCol model.sheetUIData colIndex

                newWidth =
                    autoResizedWidth model.minColWidth columnData 9

                updatedColWidths =
                    Array.set colIndex newWidth model.colWidths
            in
            --Debug.log ("AutoColumnWidth: " ++ String.fromInt colIndex ++ " " ++ String.fromInt newWidth) <|
            ( { model | colWidths = updatedColWidths }, xModel, Cmd.none )

        CtrlPressed isPressed ->
            ( { model | ctrlPressed = isPressed }, xModel, Cmd.none )

        AltPressed isPressed ->
            ( { model | altPressed = isPressed }, xModel, Cmd.none )

        BackspacePressed ->
            ( model, xModel, Cmd.none )

        DebouncedFocus elementId ->
            ( model, xModel, focusCommand elementId )
        DnDTrayMsg subMsg ->
            case myLog "DnDTrayMsg in sheetUI" subMsg of
                DnDTray.DnDTrayDropdownMsg dropdownId dropdownMsg ->
                    let
                        (updatedDndGroups, cmd) =
                            DnDTray.update (DnDTray.DnDTrayDropdownMsg dropdownId dropdownMsg) model.dndTrayModel
                    in
                    ({ model | dndTrayModel = updatedDndGroups }, xModel, Cmd.map DnDTrayMsg cmd)

                DnDTray.DnDTrayOptionPicked dropdownId option ->
                    let
                        (updatedDndGroups, cmd) =
                            DnDTray.update subMsg model.dndTrayModel

                        updatedDataview =
                            XView.updateDropdownOption dropdownId (Maybe.withDefault "" option) model.curDatasetView

                        updatedSpreadsheetUIModel =
                            updateSheetUIModelFromStructureChange model xModel updatedDataview
                    in
                    (updatedSpreadsheetUIModel, xModel, Cmd.map DnDTrayMsg cmd)

                DnDTray.DnDMsg _ ->
                    let
                        (updatedDndGroups, cmd) =
                            DnDTray.update subMsg model.dndTrayModel

                        updatedModel =
                            { model | dndTrayModel = updatedDndGroups }

                        updatedSpreadsheetUIModel =
                            updateSheetUIDataFromTrays updatedModel xModel
                    in
                    (updatedSpreadsheetUIModel, xModel, Cmd.map DnDTrayMsg cmd)
        -- DnDTrayMsg subMsg ->
        --     case myLog "DnDTrayMsg in sheetUI" subMsg of
        --         DnDTray.DnDTrayDropdownMsg dropdownId dropdownMsg ->
        --             let
        --                 -- Forward the dropdown message to DnDTray.update and handle the response
        --                 ( updatedDndGroups, cmd ) =
        --                     DnDTray.update (DnDTray.DnDTrayDropdownMsg dropdownId dropdownMsg) model.dndTrayModel
        --             in
        --             ( { model | dndTrayModel = updatedDndGroups }
        --             , xModel
        --             , Cmd.map DnDTrayMsg cmd
        --             )

        --         DnDTray.DnDTrayOptionPicked dropdownId option ->
        --             -- Handle option picked and update the dataset view
        --             -- pivot update copied from DnDTray.DnDMsg
        --             let
        --                 ( updatedDndGroups, cmd ) =
        --                     DnDTray.update subMsg model.dndTrayModel

        --                 -- updates for new dropdoen selection
        --                 updatedDataview =
        --                     XView.updateDropdownOption dropdownId (Maybe.withDefault "" option) model.curDatasetView

        --                 -- first round of update to set thetrays and  new datasetView
        --                 updatedSpreadsheetUIModel =
        --                     updateSheetUIModelFromStructureChange model xModel updatedDataview

                        
        --             in
        --             -- Debug.log ("(dropdownId, option)" ++ Debug.toString (dropdownId, option))
        --             -- Debug.log ("updatedDataview" ++ Debug.toString updatedDataview.pageTray)
        --             ( updatedSpreadsheetUIModel
        --               -- cmd restituito da DnDTray.update chiamato sopra
        --             , xModel
        --             , Cmd.map DnDTrayMsg cmd
        --             )

        --         DnDTray.DnDMsg _ ->
        --             -- Handle other DnDTray messages as before
        --             let
        --                 -- passa l'update event al model di DnDTray e riceve il cmd da eseguire
        --                 -- lo stesso cmd viene eseguito alla fine
        --                 -- qui subito aggiorna le info per camnbiare i Tray
        --                 ( updatedDndGroups, cmd ) =
        --                     DnDTray.update subMsg model.dndTrayModel

        --                 -- con i Tray cambiati parte il reshape della pivot table
        --                 updatedModel =
        --                     { model | dndTrayModel = updatedDndGroups }

        --                 -- se uso updatedSpreadsheetUIModel funziona
        --                 updatedSpreadsheetUIModel =
        --                     updateSheetUIDataFromTrays updatedModel xModel


        --             in
        --             -- Debug.log ("DnDMsg handled" ++ Debug.toString subMsg)
        --             ( updatedSpreadsheetUIModel
        --               -- cmd restituito da DnDTray.update chiamato sopra
        --             , xModel
        --             , Cmd.map DnDTrayMsg cmd
        --             )


updateSpreadsheetFromXModel : Model -> XModel -> Dataset -> Model
updateSpreadsheetFromXModel model xModel updatedDataset =
    let
        updatedSheetUIData =
            XView.generateSpreadsheetUIDataFromView xModel.dims updatedDataset model.curDatasetView 

        -- updatedCellsUI = -- only with UI settings
        --     initialCellsUI updatedSpreadsheet
        -- Save changes and exit edit mode
        newModel =
            { model
                | curDataset = updatedDataset
                , curDims = xModel.dims

                --, table = updatedTable
                , sheetUIData = updatedSheetUIData
                , escPressed = False
                -- provisional to ensure widths and heights matching spreadsheetUI size
                , colWidths = Array.repeat updatedSheetUIData.numDataCols model.defaultColWidth
                , rowHeights = Array.repeat updatedSheetUIData.numDataRows model.defaultRowHeight
                , colHeaderHeights = Array.repeat updatedSheetUIData.colHeaderDepth model.defaultRowHeight
                , rowHeaderWidths = Array.repeat updatedSheetUIData.rowHeaderDepth model.defaultColWidth
            }
    in
    newModel


getColHeaderId : HeaderPath -> String
getColHeaderId headerPath =
    "col-header-" ++ (headerPathToString headerPath) ++ "-id"


getRowHeaderId : HeaderPath -> String
getRowHeaderId headerPath =
    "row-header-" ++ (headerPathToString headerPath) ++ "-id"

getColHeaderInputId : HeaderPath -> String
getColHeaderInputId headerPath =
    getColHeaderId headerPath ++ "-input-id"

getRowHeaderInputId : HeaderPath -> String
getRowHeaderInputId headerPath =
    getRowHeaderId headerPath ++ "-input-id"

getColHeaderIdWithDataset : Model -> HeaderPath -> String
getColHeaderIdWithDataset model headerPath =
    model.curDataset.ref ++ "-" ++ getColHeaderId headerPath

getRowHeaderIdWithDataset : Model -> HeaderPath -> String
getRowHeaderIdWithDataset model headerPath =
    model.curDataset.ref ++ "-" ++ getRowHeaderId headerPath

getColHeaderInputIdWithDataset : Model -> HeaderPath -> String
getColHeaderInputIdWithDataset model headerPath =
    model.curDataset.ref ++ "-" ++ getColHeaderInputId headerPath 

getRowHeaderInputIdWithDataset : Model -> HeaderPath -> String
getRowHeaderInputIdWithDataset model headerPath =
    model.curDataset.ref ++ "-" ++ getRowHeaderInputId headerPath 


headerTypeToString : HeaderType -> String
headerTypeToString headerType =
    case headerType of
        RowHeader ->
            "-row-header-"
        ColHeader ->
            "-col-header-"
        TopLeftHeader ->
            "-top-left-header-"
        TopRightHeader ->
            "-top-right-header-"
getTopHeaderIdWithDataset : Model -> DimVariantRef -> HeaderType -> String
getTopHeaderIdWithDataset model dimVariantRef headerType =
    model.curDataset.ref ++ headerTypeToString headerType ++ dimVariantRef ++ "-id"

getTopHeaderInputIdWithDataset : Model -> DimVariantRef -> HeaderType -> String
getTopHeaderInputIdWithDataset model dimVariantRef headerType =
    model.curDataset.ref ++ headerTypeToString headerType ++ dimVariantRef ++ "-input-id"




isCellText : Int -> Int -> Model -> Bool
isCellText rowIndex colIndex model =
    let
        ( _, dVarIndex ) =
            Array2D.get rowIndex colIndex model.sheetUIData.spreadsheetIndex|> Maybe.withDefault ( -1, -1 )

        dataArray =
            XModel.getDataArrayByDVarIndex model.curDataset dVarIndex
    in
    isDataArrayText dataArray

-- taken from DatasetPage helper func for DnD dropdown msg
updateSheetUIModelFromStructureChange : Model -> XModel -> XView.DatasetView -> Model
updateSheetUIModelFromStructureChange model xModel passedDataview =
    let
        updatedDataset =
            XModel.getDatasetByRef model.curDataset.ref xModel.datasets |> Maybe.withDefault model.curDataset
        updatedSheetUIData =
            XView.generateSpreadsheetUIDataFromView xModel.dims updatedDataset passedDataview
    in
    -- returns updated spreadsheetUI model with shape settings for MyPivotTable and datasetView with shape and data
    { model
        | curDataset = updatedDataset
        , curDims = xModel.dims
        , curDatasetView = passedDataview
        , sheetUIData = updatedSheetUIData
        -- provisional to ensure widths and heights matching spreadsheetUI size
        , colWidths = Array.repeat updatedSheetUIData.numDataCols model.defaultColWidth
        , rowHeights = Array.repeat updatedSheetUIData.numDataRows model.defaultRowHeight
        , colHeaderHeights = Array.repeat updatedSheetUIData.colHeaderDepth model.defaultRowHeight
        , rowHeaderWidths = Array.repeat updatedSheetUIData.rowHeaderDepth model.defaultColWidth
    }


updateSheetUIDataFromView : Model -> XModel -> XView.DatasetView -> Model
updateSheetUIDataFromView model curXModel updatedDataview =
    let

        -- set shapes and data as required by XArray and update model.datasetView

        -- gets current spreadsheetUI model
        curSpreadsheetModel =
            model
        updatedSheetUIData =
            XView.generateSpreadsheetUIDataFromView curXModel.dims curSpreadsheetModel.curDataset updatedDataview
    in
    -- returns updated spreadsheetUI model with shape settings for MyPivotTable and datasetView with shape and data
    { curSpreadsheetModel
        | curDatasetView = updatedDataview
        , sheetUIData = updatedSheetUIData
        -- provisional
        , colWidths = Array.repeat updatedSheetUIData.numDataCols curSpreadsheetModel.defaultColWidth
        , rowHeights = Array.repeat updatedSheetUIData.numDataRows curSpreadsheetModel.defaultRowHeight
        , colHeaderHeights = Array.repeat updatedSheetUIData.colHeaderDepth curSpreadsheetModel.defaultRowHeight
        , rowHeaderWidths = Array.repeat updatedSheetUIData.rowHeaderDepth curSpreadsheetModel.defaultColWidth
    }

-- procesesed buffered dim changes in a single DatasetPage model
processDimChange : DimChange -> XModel -> Model -> Model
processDimChange dimChange xModel sheetUImodel =
    let
        modelRaw = -- changes dims in trays
            case dimChange of
                RenameDim oldDimRef newDimRef ->
                    renameDimRefInView oldDimRef newDimRef sheetUImodel


                InsertDim dimName tray ->
                    insertDimInView dimName tray sheetUImodel


                RemoveDim dimName ->
                    removeDimInView dimName sheetUImodel

                DestroyDim dimName ->
                    removeDimInView dimName sheetUImodel
                _ ->
                    sheetUImodel
        sUiModelWithUpdatedView = -- updates view
            updateSheetUIDataFromView modelRaw xModel modelRaw.curDatasetView
        sUiModelWithTrayData = -- syncs trayData
            sUiModelWithUpdatedView |> updateTrayData

        _ = myLog ("trayData in processDimChange for dataset " ++ Debug.toString sheetUImodel.curDataset.ref
                 ++ " and change " ++ Debug.toString dimChange)
            (sUiModelWithTrayData.dndTrayModel.trayData |> List.map .name)
    in
    sUiModelWithTrayData


-- XModel is changed elsewhere
renameDimRefInView : String -> String -> Model -> Model
renameDimRefInView oldDimRef newDimRef sheetUImodel =
    let
        curSpreadsheetUIModel =
            sheetUImodel
        curView =
            curSpreadsheetUIModel.curDatasetView
        updatedView =
            XView.renameDimRefInView oldDimRef newDimRef curView
        updatedSpreadsheetUIModel =
            { curSpreadsheetUIModel | curDatasetView = updatedView }

    in
    updatedSpreadsheetUIModel


insertDimInView : String -> Tray -> Model -> Model
insertDimInView dimName tray sheetUImodel =
    let
        curSpreadsheetUIModel =
            sheetUImodel
        curView =
            curSpreadsheetUIModel.curDatasetView
        updatedView =
            myLog "updatedView in Main" (XView.addDimRefInView dimName tray curView)
        updatedSpreadsheetUIModel =
            { curSpreadsheetUIModel | curDatasetView = updatedView }

    in
    updatedSpreadsheetUIModel


removeDimInView : String -> Model -> Model
removeDimInView dimName sheetUImodel =
    let
        curSpreadsheetUIModel =
            sheetUImodel
        curView =
            curSpreadsheetUIModel.curDatasetView
        updatedView =
            XView.removeDimRefInView dimName curView
        updatedSpreadsheetUIModel =
            { curSpreadsheetUIModel | curDatasetView = updatedView }

    in
    updatedSpreadsheetUIModel
-- helper function to recalc changed datasets


-- trayData are duplicated in SheetUIData to be passed to DnDModel also in DatasetPage
updateTrayData : Model -> Model
updateTrayData model =
    let
        curDnDModel =
            model.dndTrayModel
        -- assuming trayData is updated in DnDTray.update
        updatedTrayData =
            model.sheetUIData.trayData
        updatedDnDModel =
            { curDnDModel | trayData = updatedTrayData }

    in
    { model | dndTrayModel = updatedDnDModel }
updateSheetUIDataFromTrays : Model -> XModel -> Model
updateSheetUIDataFromTrays model curXModel =
    let
        -- common step get from trays the names of the pages, rows and columns
        -- to trigger when tokens are moved across trays
        pageNames =
            DnDTray.getPageNames model.dndTrayModel.trayData

        rowNames =
            DnDTray.getRowNames model.dndTrayModel.trayData

        colNames =
            DnDTray.getColNames model.dndTrayModel.trayData

        -- set shapes and data as required by XArray and update model.datasetView


        updatedDataview =
            XView.updateDatasetViewTrays
                curXModel.dims
                model.curDataset
                model.curDatasetView
                pageNames
                rowNames
                colNames

        -- gets current spreadsheetUI model
        curSpreadsheetModel =
            model
        updatedSheetUIData =
            XView.generateSpreadsheetUIDataFromView curXModel.dims curSpreadsheetModel.curDataset updatedDataview
    in
    -- returns updated spreadsheetUI model with shape settings for MyPivotTable and datasetView with shape and data
    { curSpreadsheetModel
        | curDatasetView = updatedDataview
        , sheetUIData = updatedSheetUIData
        -- provisional to ensure widths and heights matching spreadsheetUI size
        , colWidths = Array.repeat updatedSheetUIData.numDataCols curSpreadsheetModel.defaultColWidth
        , rowHeights = Array.repeat updatedSheetUIData.numDataRows curSpreadsheetModel.defaultRowHeight
        , colHeaderHeights = Array.repeat updatedSheetUIData.colHeaderDepth curSpreadsheetModel.defaultRowHeight
        , rowHeaderWidths = Array.repeat updatedSheetUIData.rowHeaderDepth curSpreadsheetModel.defaultColWidth
    }
updateForSelectCellUI : Model -> XModel -> CellPosition -> ( Model, XModel, Cmd Msg )
updateForSelectCellUI model xModel position =
    case position of
        DataCell ( rowIndex, coIndex ) ->
            let

                currentValue = Array2D.get rowIndex coIndex model.sheetUIData.spreadsheet |> Maybe.withDefault (XEmpty)
            in
            ( { model 
                | currentCellUI = Just 
                    ( DataCell ( rowIndex, coIndex )
                    , { value = ReadOnly (XParser.render currentValue), isEditing = False, isSelected = True } 
                    )
                }
            , xModel
            , focusCommand (getCellIdWithDataset rowIndex coIndex model)
            )

        RowHeaderCell path ->
            let
                (dimVariantRef, coord ) = List.head (List.reverse path) |> Maybe.withDefault ("", "")
                    |> myLog "RowHeaderCell"
                focusCmdRow =
                    focusCommand (getRowHeaderIdWithDataset model path) -- "current-slider" --  non funziona
            in
            ( { model
                | currentCellUI = Just
                    ( RowHeaderCell path
                    , { value = ReadOnly coord, isEditing = False, isSelected = True }
                    )
                }
            , xModel
            , focusCmdRow
            )

        ColHeaderCell path ->
            let
                coord = Tuple.second (List.head (List.reverse path) |> Maybe.withDefault ("", ""))
                focusCmdCol =
                    focusCommand (getColHeaderIdWithDataset model path)
            in
            ( { model
                | currentCellUI = Just
                    ( ColHeaderCell path
                    , { value = ReadOnly coord, isEditing = False, isSelected = True }
                    )
                }
            , xModel
            , focusCmdCol
            )
        TopLeftHeaderCell dimVariantRef ->
            let
                focusCmdTopLeft =
                    focusCommand (getTopHeaderIdWithDataset model dimVariantRef TopLeftHeader)
            in
            ( { model
                | currentCellUI = Just
                    ( TopLeftHeaderCell dimVariantRef
                    , { value = ReadOnly dimVariantRef, isEditing = False, isSelected = True }
                    )
                }
            , xModel
            , focusCmdTopLeft -- Cmd.none --focusCmdTopLeft
            )
        TopRightHeaderCell dimVariantRef ->
            let
                focusCmdTopRight =
                    focusCommand (getTopHeaderIdWithDataset model dimVariantRef TopRightHeader)
            in
            ( { model
                | currentCellUI = Just
                    ( TopRightHeaderCell dimVariantRef
                    , { value = ReadOnly dimVariantRef, isEditing = False, isSelected = True }
                    )
                }
            , xModel
            , focusCmdTopRight
            )



updateCellUI : Int -> Int -> (CellUI -> CellUI) -> Array2D CellUI -> Array2D CellUI
updateCellUI rowIndex colIndex updateFunction cells =
    Array2D.update rowIndex colIndex updateFunction cells






-- from chatGpt


-- ci sono settaggi per fissare in modo semi hard coded sticked row e col headers
-- si basano su larghezze e altezze di righe e colonne in px settati qui
-- li ho disattivati perché non funzionano bene cambiando l'ordine di reshape
viewResizeHeightSlider : Model -> Int -> Element Msg
viewResizeHeightSlider model rowIndex =
        let
            curHeight =
                model.rowHeights |> Array.get rowIndex |> Maybe.withDefault model.defaultRowHeight 
                    
        in
        Input.slider 
            [ moveLeft 2
            , width (px 5), height (px curHeight), alignRight
            , behindContent <| 
                el 
                    [width (px 5), height fill, Background.color red]
                    none
            ]
            { onChange = negate >> round >> (SetHeaderHeight RowHeader rowIndex)
            , step = Nothing
            , label = Input.labelHidden ("curHeight: " ++ String.fromInt curHeight)
            , thumb = miniThumb -- Input.defaultThumb
            , value = negate curHeight |> toFloat
            , min = toFloat (-curHeight - model.minRowHeight)
            , max = toFloat -model.minRowHeight}

viewResizeColHeaderHeightSlider : Model -> Int -> Int -> Element Msg
viewResizeColHeaderHeightSlider model headerDepth colIndex =
        let
            curHeight =
                model.colHeaderHeights |> Array.get headerDepth |> Maybe.withDefault model.defaultRowHeight 
                    
        in
        Input.slider 
            [ moveLeft 2
            , width (px 5), height (px curHeight), alignRight
            , behindContent <| 
                (el 
                    [ width (px 5)
                    , height fill
                    , Background.color red
                    ] 
                    none)
            ]
            { onChange = negate >> round >> (SetHeaderHeight ColHeader headerDepth)
            , step = Nothing
            , label = Input.labelHidden ("curHeight: " ++ String.fromInt curHeight)
            , thumb = miniThumb -- Input.defaultThumb
            , value = negate curHeight |> toFloat
            , min = toFloat (-curHeight - model.minRowHeight)
            , max = toFloat -model.minRowHeight}

viewResizeWidthSlider : Model -> Int -> Element Msg
viewResizeWidthSlider model  colIndex =
        let
            curWidth =
                model.colWidths |> Array.get colIndex |> Maybe.withDefault model.defaultColWidth
        in
        Input.slider 
            [ moveUp 5
            , width (px curWidth), height (px 5), alignRight, alignTop, spacing 0, padding 0
            , behindContent <| el [width fill, height fill,  Background.color red, spacing 0, padding 0] none
            , Element.htmlAttribute <| (HtmlAttr.id "current-slider")
            ]
            { onChange = round >> (SetHeaderWidth ColHeader colIndex)
            , step = Nothing
            , label = Input.labelHidden ("curHeight: " ++ String.fromInt curWidth)
            , thumb = miniThumb -- Input.defaultThumb
            , value = curWidth |> toFloat
            , min = toFloat model.minColWidth
            , max = toFloat (curWidth + model.minColWidth)}

viewResizeRowHeaderWidthSlider : Model -> Int -> Element Msg
viewResizeRowHeaderWidthSlider model  rowDepth =
        let
            curWidth =
                model.rowHeaderWidths |> Array.get rowDepth |> Maybe.withDefault model.defaultColWidth
        in
        Input.slider 
            [ moveUp 5
            , width (px curWidth), height (px 5), alignRight, alignTop, spacing 0, padding 0
            , behindContent <| el [width fill, height fill,  Background.color red, spacing 0, padding 0] none
            , Element.htmlAttribute <| (HtmlAttr.id "current-slider")
            ]
            { onChange = round >> (SetHeaderWidth RowHeader rowDepth)
            , step = Nothing
            , label = Input.labelHidden ("curHeight: " ++ String.fromInt curWidth)
            , thumb = miniThumb -- Input.defaultThumb
            , value = curWidth |> toFloat
            , min = toFloat model.minColWidth
            , max = toFloat (curWidth + model.minColWidth)}
miniThumb : Input.Thumb
miniThumb =
    Input.thumb
        [ width (px 5)
        , height (px 5)
        , Border.rounded 0
        , Background.color red
        , Border.color red
        , Border.width 1
        , rotate 45
        , Element.htmlAttribute <| (HtmlAttr.id "mini-thumb")
        ]


viewTopHeader : Model -> DimVariantRef -> HeaderType -> Int -> List (Attribute Msg) -> Element Msg
viewTopHeader model dimVariantRef headerType index gridAttrs =
    let
        tokeViewEl =
            DnDTray.tokenView 
        cellId =
            getTopHeaderIdWithDataset model dimVariantRef headerType
        cellInputId =
            getTopHeaderInputIdWithDataset model dimVariantRef headerType
        pivtoAttrs = gridAttrs ++ 
            List.map htmlAttribute [ HtmlAttr.id cellId
            , style "user-select" "none"
            , style "cursor" "default"
            ]
        tabIndex = 
            case headerType of
                TopLeftHeader ->
                    getTabIndex 0 index (model.sheetUIData.numDataCols + model.sheetUIData.rowHeaderDepth + 1)
                TopRightHeader ->
                    let totCols = (model.sheetUIData.numDataCols + model.sheetUIData.rowHeaderDepth + 1) in
                    getTabIndex index (totCols - 1) totCols
                _ ->
                    0

        defaultCellUI =
            { value = ReadOnly dimVariantRef, isSelected = False, isEditing = False }
        ( cellUI , isEditing , isSelected) =
            case (model.currentCellUI , headerType) of
                ( Just (TopLeftHeaderCell curHeaderDimRef, value ) , TopLeftHeader )->
                    if (curHeaderDimRef==dimVariantRef) then
                        (value
                        , value.isEditing
                        , value.isSelected)
                    else
                        ( defaultCellUI
                        , False
                        , False)
                ( Just (TopRightHeaderCell curHeaderDimRef, value ) , TopRightHeader )->
                    if (curHeaderDimRef==dimVariantRef) then
                        (value
                        , value.isEditing
                        , value.isSelected)
                    else
                        ( defaultCellUI
                        , False
                        , False)

                _ ->
                    (defaultCellUI, False, False)
        editableValue =
            getCellValue cellUI
        editCellAttributes =
            [ HtmlAttr.value editableValue --editableValue
            --, HtmlEvents.onInput ChangeCellUI 
            , onInputPreventDefaultThenChangeCellUI
            --, HtmlEvents.onBlur SaveCellUI -- disabled to avoid double save after enter
            , onKeyDown onKeyDownDecoderCellUI 
            , style "width" "100%" -- (String.fromInt (model.defaultColumnWidth - 10) ++ "px") --
            , style "height" "100%"
            , style "box-sizing" "border-box" -- Include padding and border in the element's width
            , HtmlAttr.class "edit-cell"
            , HtmlAttr.id cellInputId
            ]
        headerCellConstructor =
            case headerType of
                TopLeftHeader ->
                    TopLeftHeaderCell dimVariantRef
                TopRightHeader ->
                    TopRightHeaderCell dimVariantRef
                _ -> -- should not happen
                    DataCell (0, 0)
        headerHandler = -- no resizing for top right header
            if isSelected && not model.ctrlPressed && not isEditing  then
                [ Element.htmlAttribute 
                    <| onKeyDownWithPreventDefault 
                        (noEditKeyDecoderWithPreventDefault model headerCellConstructor)

                , Font.italic

                ]
            else
                []
        dblclickAction = 
                -- if model.ctrlPressed then
                --     --Debug.log "ctrlPressed" <|
                --     (Decode.succeed (AutoColumnWidth colIndex, True))
                -- else
                    case headerType of
                        TopLeftHeader ->
                            Decode.succeed (EditCellUI (TopLeftHeaderCell dimVariantRef) "", True)
                        TopRightHeader ->
                            Decode.succeed (EditCellUI (TopRightHeaderCell dimVariantRef) "", True)
                        _ ->
                            Decode.succeed (NoOp, True)
        clickAction =
        -- if model.altPressed then
        --     AutoColumnWidth colIndex
        -- else
            case headerType of
                TopLeftHeader ->
                    SelectTopLeftHeader dimVariantRef
                TopRightHeader ->
                    SelectTopRightHeader dimVariantRef
                _ ->
                    NoOp

        noEditCellAttributes =
            ([ HtmlAttr.tabindex tabIndex
            , HtmlEvents.preventDefaultOn "contextmenu" (Decode.succeed (clickAction, True))
            , HtmlEvents.onClick clickAction
            , HtmlEvents.stopPropagationOn 
                "dblclick" 
                dblclickAction
            ]
            |> List.map Element.htmlAttribute)
                ++ headerHandler
                ++ [ inFront <| el [centerX, centerY] (text dimVariantRef)
                   , mouseOver 
                        [Background.color darkOrange
                        , Border.color blue
                        , Font.color white
                        , Border.shadow { offset = ( 4, 4 ), size = 3, blur = 10, color = blue }]
                --    , if dimVariantRef == dVarIdentifier then
                --         Border.rounded 6
                --     else
                --         Border.rounded 0
                --    , if dimVariantRef == dVarIdentifier then
                --         Border.dashed
                --     else
                --         Border.solid
                   ] -- to center text

        cellStyle =
            [ Element.htmlAttribute (HtmlAttr.id cellId)  
            , padding model.defaultCellPadding -- width set in grid-template-columns
            , Border.width 1
            , Font.bold
            , Font.center
            , Font.size model.defaultFontSize
            , Background.color <|
                if isEditing then
                    lightGray
                else if isSelected then
                    pink
                -- else if model.ctrlPressed then -- only for testing\
                --     lightBlue
                else if dimVariantRef == dVarIdentifier then
                    blue
                else
                    darkGray
            , Font.color <|
                if dimVariantRef == dVarIdentifier then
                    white
                else
                    darkCharcoal
            --, positionRelative
            ]
    in
    if isEditing then
        -- Render input field for editing
        el (pivtoAttrs ++ cellStyle ) <|
            html <| Html.node "input" (editCellAttributes) []
    else
        -- Render non-editable cell
        el
            (pivtoAttrs ++ cellStyle ++ noEditCellAttributes)
            none
            -- Ensures text is centered horizontally and vertically
                    --(text dimVariantRef)  -- Header content

viewRowHeader : Model -> Int -> Int -> Int -> Int -> Int -> Int -> HeaderPath -> Coord -> Element Msg
viewRowHeader model depth span offset rowDepth colDepth rowIndex headerPath coord =
    -- depth is depth of current header in the tree, rowDepth is the total depth of the row headers, colDepth is the total depth of the col headers
    let
        cellId =
            getRowHeaderIdWithDataset model headerPath 
        cellInputId =
            getRowHeaderInputIdWithDataset model headerPath
        -- Existing pivotAttrs and additionalAttrs...
        cursorString =
            -- if model.ctrlPressed && isSelected && not isEditing then
            --     "sw-resize"
            -- else
                "default"
        gridRow0 = colDepth + offset + 1
        gridCol0 = depth + 1
        tabIndex = getTabIndex (gridRow0 - 1) (gridCol0 - 1) ( model.sheetUIData.numDataCols + rowDepth +1)
        pivotHtmlAttrs =
                [ style "grid-row-start" <| String.fromInt <| colDepth + offset + 1
                , style "grid-row-end" <| String.fromInt <| gridRow0 + span
                , style "grid-column-start" <| String.fromInt <|gridCol0
                , style "grid-column-end" <| String.fromInt <| gridCol0 + 1
                , HtmlAttr.id cellId
                , style "user-select" "none"
                , style "cursor" cursorString
                -- , style "position" "sticky"
                -- , style "left" <| (String.fromInt (getRowHeaderPosition model depth) ++ "px")
                -- , style "z-index" "1"
                ]
        pivotAttrs =
            List.map Element.htmlAttribute pivotHtmlAttrs

        isEdgeHeader : Bool
        isEdgeHeader =
            (rowDepth - depth) == 1

        isHovered : Bool
        isHovered =
            model.hoveredRow == Just rowIndex

        hoverText =
            "Click to format"
        defaultCellUI =
            { value = ReadOnly coord, isSelected = False, isEditing = False }
        ( cellUI , isEditing , isSelected) =
            case model.currentCellUI of
                Just (RowHeaderCell curHeaderPath, value ) ->
                    if (curHeaderPath==headerPath) then
                        (value
                        , value.isEditing
                        , value.isSelected)
                    else
                        ( defaultCellUI
                        , False
                        , False)

                _ ->
                    (defaultCellUI, False, False)

        editableValue =
            getCellValue cellUI
        editCellAttributes =
            [ HtmlAttr.value editableValue
            --, HtmlEvents.onInput ChangeCellUI 
            , onInputPreventDefaultThenChangeCellUI
            --, HtmlEvents.onBlur SaveCellUI 
            , onKeyDown onKeyDownDecoderCellUI
            , style "width" "100%" -- (String.fromInt (model.defaultColumnWidth - 10) ++ "px") --
            , style "height" "100%"
            , style "box-sizing" "border-box" -- Include padding and border in the element's width
            , HtmlAttr.class "edit-cell"
            , HtmlAttr.id cellInputId
            ]
        headerHandler =
            if isSelected && model.ctrlPressed && not isEditing && isEdgeHeader then
                --myLog "condition1"
                [onRight <| viewResizeHeightSlider model rowIndex
                , below <| viewResizeRowHeaderWidthSlider model depth
                ]
            else if isSelected && model.ctrlPressed && not isEditing  then
                --myLog "condition2"
                [ below <| viewResizeRowHeaderWidthSlider model depth
                ]
            else if isSelected && not model.ctrlPressed && not isEditing  then
                --myLog "condition3"
                [ Element.htmlAttribute 
                    --<| onKeyDown (onKeyDownDecoderCoord headerPath RowHeader)
                    <| onKeyDownWithPreventDefault (noEditKeyDecoderWithPreventDefault model (RowHeaderCell headerPath))
                , Font.italic
                ]
            else
                []
        noEditCellAttributes =
            ([HtmlAttr.tabindex tabIndex 
            , HtmlEvents.preventDefaultOn "contextmenu" (Decode.succeed (SelectRowHeader headerPath, True))
            , HtmlEvents.onClick (SelectRowHeader headerPath)
            , HtmlEvents.stopPropagationOn 
                "dblclick" 
                (Decode.succeed (EditCellUI (RowHeaderCell headerPath) "", True))
            ]
            |> List.map Element.htmlAttribute)
            -- add handlers for resizing and coord editing
                ++ headerHandler

        cellStyle =
            [ padding model.defaultCellPadding -- no height, set in grid-template-rows
            , Font.bold
            , Border.width 1
            , Font.size model.defaultFontSize
            , Background.color <|
                if isEditing then
                    lightGray
                else if isSelected then
                    pink
                else
                    lightGray
            --, positionRelative
            ]
        isDragging =
            model.ctrlClickedHeader == Just (RowHeader, rowIndex)


        positionRelative =
            Element.htmlAttribute <| HtmlAttr.style "position" "relative"
    in
    if isEditing then
        -- Render input field for editing
        el (cellStyle ++ pivotAttrs) <|
            html <| Html.node "input" (editCellAttributes) []
    else
        el
            ( pivotAttrs ++ cellStyle ++ noEditCellAttributes)
            (text coord)  -- Header content
            --(text (coord ++ Debug.toString headerHandler))


    
viewColHeader : Model -> Int -> Int -> Int -> Int -> Int -> Int -> HeaderPath -> Coord -> Element Msg
viewColHeader model depth span offset rowDepth colDepth colIndex headerPath coord =
    -- depth is depth of current header in the tree, rowDepth is the total depth of the row headers, 
    -- colDepth is the total depth of the col headers
    let
        cellId =
            getColHeaderIdWithDataset model headerPath 
        cellInputId =
            getColHeaderInputIdWithDataset model headerPath
        cursorString =
            if model.altPressed  && isSelected && not isEditing then
                "ew-resize"
            -- else if model.ctrlPressed then
            --     "sw-resize"
            else
                "default"
        gridRow0 = depth + 1
        gridCol0 = rowDepth + offset + 1
        tabIndex = getTabIndex (gridRow0 - 1) (gridCol0 - 1) ( model.sheetUIData.numDataCols + rowDepth +1)

        -- Existing pivotAttrs and additionalAttrs...
        pivotHtmlAttrs =
            [ style "grid-row-start" <| String.fromInt <| gridRow0
            , style "grid-row-end" <| String.fromInt <| gridRow0 + 1
            , style "grid-column-start" <| String.fromInt <| gridCol0
            , style "grid-column-end" <| String.fromInt <| gridCol0 + span
            , style "user-select" "none"
            , style "cursor" cursorString
            , HtmlAttr.id cellId 

            -- , style "position" "sticky"
            -- , style "top" (String.fromInt (headerHeightPerDim*(depth+1)+titleAndTraysHeight) ++ "px")
            -- , style "z-index" "2"
            ]
        pivotAttrs =
            List.map Element.htmlAttribute pivotHtmlAttrs

        isEdgeHeader : Bool
        isEdgeHeader =
            (colDepth - depth) == 1

        isHovered : Bool
        isHovered =
            model.hoveredRow == Just colIndex

        hoverText =
            "Click to format"
        defaultCellUI =
            { value = ReadOnly coord, isSelected = False, isEditing = False }
        ( cellUI , isEditing , isSelected) =
            case model.currentCellUI of
                Just (ColHeaderCell curHeaderPath, value ) ->
                    if (curHeaderPath==headerPath) then
                        (value
                        , value.isEditing
                        , value.isSelected)
                    else
                        ( defaultCellUI
                        , False
                        , False)

                _ ->
                    (defaultCellUI, False, False)

        editableValue =
            getCellValue cellUI
        editCellAttributes =
            [ HtmlAttr.value editableValue
            --, HtmlEvents.onInput ChangeCellUI 
            , onInputPreventDefaultThenChangeCellUI
            --, HtmlEvents.onBlur SaveCellUI 
            , onKeyDown onKeyDownDecoderCellUI 
            , style "width" "100%" -- (String.fromInt (model.defaultColumnWidth - 10) ++ "px") --
            , style "height" "100%"
            , style "box-sizing" "border-box" -- Include padding and border in the element's width
            , HtmlAttr.class "edit-cell"
            , HtmlAttr.id cellInputId
            ]
        headerHandler =
            if isSelected && model.ctrlPressed &&  not isEditing && isEdgeHeader then
                [ below <| viewResizeWidthSlider model colIndex
                , onRight <| viewResizeColHeaderHeightSlider model depth colIndex
                ]
            else if isSelected && model.ctrlPressed &&  not isEditing then
                [ onRight <| viewResizeColHeaderHeightSlider model depth colIndex
                ]
            else if isSelected && not model.ctrlPressed && not isEditing  then
                [Element.htmlAttribute 
                    <| onKeyDownWithPreventDefault (noEditKeyDecoderWithPreventDefault model (ColHeaderCell headerPath))
                --  <| onKeyDown (onKeyDownDecoderCoord headerPath ColHeader)
                , Font.italic
                --, Element.htmlAttribute (HtmlAttr.tabindex 0) -- to make it focusable
                ]
            else
                []
        dblclickAction = 
                -- if model.ctrlPressed then
                --     --Debug.log "ctrlPressed" <|
                --     (Decode.succeed (AutoColumnWidth colIndex, True))
                -- else
                    (Decode.succeed (EditCellUI (ColHeaderCell headerPath) "", True))
        clickAction =
            if model.altPressed then
                AutoColumnWidth colIndex
            else
                SelectColHeader headerPath

        noEditCellAttributes =
            ([HtmlAttr.tabindex tabIndex
            , HtmlEvents.preventDefaultOn "contextmenu" (Decode.succeed (SelectColHeader headerPath, True))
            , HtmlEvents.onClick clickAction
            , HtmlEvents.stopPropagationOn 
                "dblclick" 
                dblclickAction
            ]
            |> List.map Element.htmlAttribute)
                ++ headerHandler


        cellStyle =
            [ padding model.defaultCellPadding -- width set in grid-template-columns
            , Border.width 1
            , Font.bold
            , Font.center
            , Font.size model.defaultFontSize
            , Background.color <|
                if isEditing then
                    lightGray
                else if isSelected then
                    pink
                -- else if model.ctrlPressed then -- only for testing\
                --     lightBlue
                else
                    lightGray
            --, positionRelative
            ]


    in
    if isEditing then
        -- Render input field for editing
        el (cellStyle ++ pivotAttrs) <|
            html <| Html.node "input" (editCellAttributes) []
    else
        -- Render non-editable cell
        el
            (pivotAttrs ++ cellStyle ++ noEditCellAttributes)
            -- Ensures text is centered horizontally and vertically
                    (text coord)  -- Header content




getCurrentColumnWidth : Model -> Int -> Length
getCurrentColumnWidth model colIndex =
    let
        curSetWidth =
            Array.get colIndex model.colWidths
    in
    case curSetWidth of
        Just width ->
            if width > 0 then
                px width

            else
                fill

        Nothing ->
            fill



-- content taken from cell, not from arg


viewCell : Model -> Int -> Int -> Int -> Int -> Element Msg
viewCell model rowIndex colIndex rowDepth colDepth =
    let
        -- Unique ID for the cell
        cellId =
            getCellIdWithDataset rowIndex colIndex model
        cellInputId =
            getCellInputIdWithDataset rowIndex colIndex model
        -- Compute pivot attributes for grid positioning
        gridRow0 =
            colDepth + rowIndex + 1
        gridCol0 =
            rowDepth + colIndex + 1
        tabIndex =
            getTabIndex (gridRow0 - 1) (gridCol0 - 1) ( model.sheetUIData.numDataCols + rowDepth +1)
        pivotHtmlAttrs =
            [ style "grid-row-start" <| String.fromInt <| gridRow0
            , style "grid-row-end" <| String.fromInt <| gridRow0 + 1
            , style "grid-column-start" <| String.fromInt <| gridCol0
            , style "grid-column-end" <| String.fromInt <| gridCol0 + 1
            , style "user-select" "none"
            , style "overflow" "auto"
            , HtmlAttr.id cellId
            ]
        pivotAttrs =
            List.map Element.htmlAttribute pivotHtmlAttrs


        -- Determine if the cell is being edited
        isEditing =
            case model.currentCellUI of
                Just (DataCell (r, c), value ) ->
                    (r == rowIndex && c == colIndex) && value.isEditing

                _ ->
                    False
        isSelected =
            case model.currentCellUI of
                Just (DataCell (r, c), value ) ->
                    (r == rowIndex && c == colIndex) && value.isSelected

                _ ->
                    False

        renderedValue = 
            renderFormatXValue (Array2D.get rowIndex colIndex model.sheetUIData.spreadsheet |> Maybe.withDefault XEmpty)

        -- Editable value when editing
        editableValue =
            case model.currentCellUI of
                Just (_, cellUI) ->
                    getCellValue cellUI

                _ ->
                    ""

        -- Determine if the cell contains text
        isText =
            isCellText rowIndex colIndex model

        -- Current column width
        curWidth =
            getCurrentColumnWidth model colIndex
        -- Attributes for editable cells
        editCellAttributes =
            --[ HtmlEvents.onInput ChangeCellUI  -- makes cursor jump to the end of the input field
            [ onInputPreventDefaultThenChangeCellUI
            --, HtmlEvents.onBlur SaveCellUI
            , HtmlAttr.value editableValue
            , onKeyDown onKeyDownDecoderCellUI 
            , style "width" "100%"
            , style "height" "100%"
            , style "box-sizing" "border-box"
            , HtmlAttr.class "edit-cell"
            , HtmlAttr.id cellInputId
            ]

        -- Attributes for non-editable cells
        noEditCellAttributes =
            [ HtmlAttr.tabindex tabIndex
            , HtmlEvents.onClick (SelectCell rowIndex colIndex)
            , HtmlEvents.stopPropagationOn 
                "dblclick" 
                (Decode.succeed (EditCellUI (DataCell (rowIndex, colIndex)) "", True))
            --, HtmlEvents.onDoubleClick (EditCell rowIndex colIndex "")
            --, onKeyDownWithPreventDefault (noEditKeyDecoderWithPreventDefaultCell model rowIndex colIndex model.sheetUIData.numDataRows model.sheetUIData.numDataCols)
            , onKeyDownWithPreventDefault (noEditKeyDecoderWithPreventDefault model (DataCell (rowIndex, colIndex)))
            ]
                |> List.map Element.htmlAttribute

        -- Common cell styling
        cellStyle =
            [ Background.color <|
                if isEditing then
                    lightGray
                else if isSelected then
                    darkGray
                else
                    white
            , Border.width 1
            , padding model.defaultCellPadding
            , width curWidth
            , height fill
            , Font.center
            , Font.size model.defaultFontSize
            ]



    in
    if isEditing then
        -- Render input field for editing
        el (cellStyle ++ pivotAttrs) <|
            html <| Html.node "input" (editCellAttributes) []
        -- html <| div 
        --     (pivotHtmlAttrs)
        --     [ input (editCellAttributes) [] ]
    else
        -- Render non-editable cell
        el (noEditCellAttributes ++ cellStyle ++ pivotAttrs) <| text renderedValue






-- presa da Korban p. 121


htmlAttrs : List (Html.Attribute Msg) -> List (Attribute Msg)
htmlAttrs =
    List.map htmlAttribute



-- HELPER FUNCTIONS
-- to avoid cursor jumping to the end of the input field
onInputPreventDefaultThenChangeCellUI : Html.Attribute Msg
onInputPreventDefaultThenChangeCellUI  =
    let
        targetValueDecoder =
            Decode.at ["target", "value"] Decode.string
    in  
    HtmlEvents.preventDefaultOn "input" (Decode.map (\newValue -> (ChangeCellUI newValue, True)) targetValueDecoder)

-- same as XParser.render plus float formatting
renderFormatXValue : XValue -> String
renderFormatXValue xValue =
    case xValue of
        XEmpty ->
            ""

        XString text ->
            text

        XFloat number ->
            formatFloat number


        XError error ->
            error

getRenderedDataRow : SpreadsheetUIData -> Int -> List String
getRenderedDataRow spreadsheet rowIndex =
    List.range 0 (spreadsheet.numDataCols - 1)
        |> List.map (\colIndex ->
            Array2D.get rowIndex colIndex spreadsheet.spreadsheet
                |> Maybe.withDefault XEmpty
                |> renderFormatXValue
        )

getRenderedDataCol : SpreadsheetUIData -> Int -> List String
getRenderedDataCol spreadsheet colIndex =
    List.range 0 (spreadsheet.numDataRows - 1)
        |> List.map (\rowIndex ->
            Array2D.get rowIndex colIndex spreadsheet.spreadsheet
                |> Maybe.withDefault XEmpty
                |> renderFormatXValue
        )

autoResizedWidth : Int -> List String -> Int -> Int
autoResizedWidth minWidth values pxPerChar =
    List.foldl
        (\value acc ->
            let
                valueWidth =
                    String.length value * pxPerChar
            in
            if valueWidth > acc then
                valueWidth

            else
                acc
        )
        minWidth
        values

getCellId : Int -> Int -> String
getCellId rowIndex coIndex =
    "cell-" ++ String.fromInt rowIndex ++ "-" ++ String.fromInt coIndex 


getCellIdWithDataset : Int -> Int -> Model -> String
getCellIdWithDataset rowIndex coIndex model =
    model.curDataset.ref ++ "-" ++ getCellId rowIndex coIndex

getCellInputIdWithDataset : Int -> Int -> Model -> String
getCellInputIdWithDataset rowIndex coIndex model =
    model.curDataset.ref ++ "-" ++ getCellId rowIndex coIndex ++ "-input"


getTabIndex : Int -> Int -> Int -> Int
getTabIndex rowIndex coIndex nrCols =
    rowIndex * nrCols + coIndex + 1




-- Decode keyboard event to Msg







-- le chiamate ad update vanno nei decoder


mousePositionDecoder : Decode.Decoder ( Int, Int )
mousePositionDecoder =
    Decode.map2 Tuple.pair
        (Decode.field "clientX" Decode.int)
        (Decode.field "clientY" Decode.int)





onKeyDownDecoderCellUI : Decode.Decoder Msg
onKeyDownDecoderCellUI =
    Decode.field "keyCode" Decode.int
        |> Decode.map (\keyCode ->
            case keyCode of
                13 -> SaveCellUI -- Enter key
                27 -> CancelCellUI-- Escape key
                _ -> NoOp -- myLog "onKeyDownDecoderCellUI" NoOp
        )

onKeyDownDecoderDimRef : DimRef  -> HeaderType -> Decode.Decoder Msg
onKeyDownDecoderDimRef dimRef headerType =
    Decode.field "keyCode" Decode.int
        |> Decode.map (\keyCode ->
            case keyCode of
                13 -> 
                    
                    if dimRef /= dVarIdentifier then
                        myLog "newDimRef" (NewDimRef  headerType)-- Enter key
                    else
                        NoOp
                -- backspace
                8 -> 
                    
                    if dimRef /= dVarIdentifier then
                        RemoveDimRef dimRef headerType-- Backspace key
                    else
                        NoOp
                _ -> 
                    NoOp
        )


        




-- Generic onKeyDown handler, takes decoder as parameter


onKeyDown : Decode.Decoder msg -> Html.Attribute msg
onKeyDown decoder =
    HtmlEvents.on "keydown" decoder

    



------------------------------------------------
-- GIG tentativi abortiti di gestire ctrl+backspace,
-- penso perché c'è preventDefault
-- per cancellare contenuto cella con solo backspace mo modificato
-- noEditKeyPressDecoder
-- keyDownDecoder : Decode.Decoder Msg
-- keyDownDecoder =
--     let _ = Debug.log ("keyDownDecoder") in
--     Decode.map CtrlPressed (Decode.field "ctrlKey" Decode.bool)


keyDownDecoder : Decode.Decoder Msg
keyDownDecoder =
    Decode.field "key" Decode.string
        |> Decode.andThen keyDownToMsg


keyDownToMsg : String -> Decode.Decoder Msg
keyDownToMsg keyString =
    case keyString of
        "Control" ->
            Decode.succeed (CtrlPressed True)
        "Alt" ->
            Decode.succeed (AltPressed True)

        "Backspace" ->
            -- Only produce Backspace-related Msg if you need it here,
            -- and you can check your application's state to see if Ctrl is pressed.
            Decode.succeed BackspacePressed

        _ ->
            Decode.fail "Not a key we're interested in"



keyUpDecoder : Decode.Decoder Msg
keyUpDecoder =
    Decode.field "key" Decode.string
        |> Decode.andThen keyUpToMsg


keyUpToMsg : String -> Decode.Decoder Msg
keyUpToMsg keyString =
    case keyString of
        "Control" ->
            Decode.succeed (CtrlPressed False)
        "Alt" ->
            Decode.succeed (AltPressed False)

        "Backspace" ->
            -- Only produce Backspace-related Msg if you need it here,
            -- and you can check your application's state to see if Ctrl is pressed.
            Decode.succeed BackspacePressed

        _ ->
            Decode.fail "Not a key we're interested in"



-- fine tentativi abortiti
------------------------------------------------


isAlphanumeric : Char -> Bool
isAlphanumeric key =
    Char.isDigit key || Char.isLower key || Char.isUpper key


onKeyDownWithPreventDefault : Decode.Decoder ( Msg, Bool ) -> Html.Attribute Msg
onKeyDownWithPreventDefault decoder =
    HtmlEvents.preventDefaultOn "keydown" decoder


noEditKeyDecoderWithPreventDefault : Model -> CellPosition -> Decode.Decoder ( Msg, Bool )
noEditKeyDecoderWithPreventDefault model position =
    case position of
        DataCell (rowIndex, colIndex) ->          
            Decode.map2 Tuple.pair
                (noEditKeyPressDecoderCell model rowIndex colIndex )
                (Decode.succeed True) -- Always succeed with True to prevent the default
        RowHeaderCell headerPath ->
            Decode.map2 Tuple.pair
                (noEditKeyPressDecoderRowColTopHeader model headerPath RowHeader)
                (Decode.succeed True)
        ColHeaderCell headerPath ->
            Decode.map2 Tuple.pair
                (noEditKeyPressDecoderRowColTopHeader model headerPath ColHeader)
                (Decode.succeed True)
        TopLeftHeaderCell dimVariantRef ->
            Decode.map2 Tuple.pair -- uses dummy headerPath with dimVariantRef only
                (noEditKeyPressDecoderRowColTopHeader model [(dimVariantRef,"")] TopLeftHeader)
                (Decode.succeed True)
        TopRightHeaderCell dimVariantRef ->
            Decode.map2 Tuple.pair
                (noEditKeyPressDecoderRowColTopHeader model [(dimVariantRef,"")] TopRightHeader)
                (Decode.succeed True)


-- TODO generalization to all cell types including header cells

noEditKeyPressDecoderRowColTopHeader : Model -> HeaderPath -> HeaderType -> Decode.Decoder Msg
noEditKeyPressDecoderRowColTopHeader model headerPath headerType=
    case headerPathToCurDimCoord headerPath of 
        Nothing ->
            Decode.succeed NoOp
        Just (dimVariantRef , currentCoord) ->
            let
                keyDecoder =
                    Decode.field "key" Decode.string

                shiftKeyDecoder =
                    Decode.field "shiftKey" Decode.bool

                rowDepth = model.sheetUIData.rowHeaderDepth
                colDepth = model.sheetUIData.colHeaderDepth
            in
            Decode.map2
                (\key shiftKey ->
                    case key of
                        "Enter" -> 
                            if headerType == RowHeader || headerType == ColHeader then
                                    if dimVariantRef /= dVarIdentifier then
                                        NewCoord dimVariantRef currentCoord headerPath headerType -- Enter key
                                    else
                                        NewDataArray currentCoord headerPath headerType
                            else if headerType == TopLeftHeader || headerType == TopRightHeader then
                                        NewDimRef  headerType-- Enter key

                            else
                                NoOp

                        -- backspace
                        "Backspace" -> 
                            if headerType == RowHeader || headerType == ColHeader then
                                    if dimVariantRef /= dVarIdentifier then
                                        RemoveCoord dimVariantRef currentCoord headerPath headerType -- Enter key
                                    else
                                        RemoveDataArray currentCoord headerPath headerType
                            else if headerType == TopLeftHeader || headerType == TopRightHeader then
                                    if dimVariantRef /= dVarIdentifier then
                                        RemoveDimRef dimVariantRef headerType-- Enter key
                                    else
                                        NoOp
                            else
                                NoOp
                        "Tab" -> --only in cells
                            if shiftKey then
                                -- Handle Shift+Tab
                                NoOp

                            else
                                -- Handle Tab
                                NoOp

                        "ArrowUp" ->            
                            case headerType of
                                RowHeader ->
                                    if isTopLeftBoundary headerPath model.curDims model.curDataset.dataArrayRefs then
                                        SelectTopLeftHeader dimVariantRef
                                    else
                                        let 
                                            siblingPath = myLog "prevSiblingByHeaderPath headerPath"
                                                (prevSiblingByHeaderPath headerPath model.curDims model.curDataset.dataArrayRefs)

                                        in
                                        case siblingPath of
                                            Just siblingPathJust ->
                                                SelectRowHeader siblingPathJust
                                            Nothing ->
                                                NoOp
                                ColHeader ->
                                    if List.length headerPath > 1 then
                                        let parentPath = parentHeaderPath headerPath in 
                                            SelectColHeader parentPath
                                    else
                                        NoOp
                                TopLeftHeader ->    
                                    NoOp
                                TopRightHeader ->
                                    let
                                        curHeaderIndex =
                                            elemIndexList dimVariantRef model.sheetUIData.colDimVariantRefs
                                                |> Maybe.withDefault -1
                                        siblingDimVariantRef = List.getAt (curHeaderIndex - 1) 
                                            model.sheetUIData.colDimVariantRefs
                                    in    
                                    case siblingDimVariantRef of
                                        Just siblingDimVariantRefJust ->
                                            SelectTopRightHeader siblingDimVariantRefJust
                                        Nothing ->
                                            NoOp


                        
                        "ArrowDown" ->
                            case headerType of
                                RowHeader ->
                                    let 
                                        siblingPath = myLog "nextSiblingByHeaderPath headerPath"
                                            (nextSiblingByHeaderPath headerPath model.curDims model.curDataset.dataArrayRefs)

                                    in
                                    case siblingPath of
                                        Just siblingPathJust ->
                                            SelectRowHeader siblingPathJust
                                        Nothing ->
                                            NoOp
                                ColHeader -> -- cross over to data cell
                                    if List.length headerPath == colDepth then
                                        let 
                                            colIndex  = 
                                                myLog "elemIndexOfHeaderLeafPath"
                                                (elemIndexOfHeaderLeafPath headerPath model.sheetUIData.headerTrees.col)
                                        in 
                                        case colIndex of
                                            Just colIndexJust ->
                                                SelectCell 0 colIndexJust
                                            Nothing ->
                                                NoOp

                                    else -- go to first children
                                        let
                                            currentTree = myLog "headerTreeByHeaderPathRoot headerPath"
                                                (headerTreeByHeaderPathRoot headerPath model.sheetUIData.headerTrees.col)
                                            childPath = myLog "firstChildByHeaderPath headerPath"
                                                (case currentTree of
                                                    Just tree -> (firstChildByHeaderPath headerPath tree)
                                                    Nothing -> Nothing)
                                        in
                                        case childPath of
                                            Just childPathJust ->
                                                SelectColHeader childPathJust
                                            Nothing ->
                                                NoOp
                                TopLeftHeader ->    
                                    let
                                        maybePath = pathToStartDimCoordByDimVariantRef 
                                            dimVariantRef 
                                            model.curDims 
                                            model.sheetUIData.rowDimVariantRefs
                                            model.curDataset.dataArrayRefs
                                    in
                                    case maybePath of
                                        Just path ->
                                            SelectRowHeader path
                                        Nothing ->
                                            NoOp
                                TopRightHeader ->
                                    let
                                        curHeaderIndex =
                                            elemIndexList dimVariantRef model.sheetUIData.colDimVariantRefs
                                                |> Maybe.withDefault -1
                                        siblingDimVariantRef = List.getAt (curHeaderIndex + 1) 
                                            model.sheetUIData.colDimVariantRefs
                                    in    
                                    case siblingDimVariantRef of
                                        Just siblingDimVariantRefJust ->
                                            SelectTopRightHeader siblingDimVariantRefJust
                                        Nothing ->
                                            NoOp


                        "ArrowLeft" ->
                                case headerType of
                                    RowHeader ->
                                        let parentPath = parentHeaderPath headerPath in 
                                        SelectRowHeader parentPath
                                    ColHeader ->
                                        if isTopLeftBoundary headerPath model.curDims model.curDataset.dataArrayRefs then
                                            case List.reverse model.sheetUIData.rowDimVariantRefs of
                                                [] ->
                                                    NoOp
                                                lastRowDimVarianRef :: _ ->
                                                     SelectTopLeftHeader lastRowDimVarianRef
                                        else
                                            let 
                                                siblingPath = myLog "prevSiblingByHeaderPath headerPath"
                                                    (prevSiblingByHeaderPath headerPath model.curDims model.curDataset.dataArrayRefs)

                                            in
                                            case siblingPath of
                                                Just siblingPathJust ->
                                                    SelectColHeader siblingPathJust
                                                Nothing ->
                                                    NoOp
                                    TopLeftHeader ->    
                                        let
                                            curHeaderIndex =
                                                elemIndexList dimVariantRef model.sheetUIData.rowDimVariantRefs
                                                    |> Maybe.withDefault -1
                                            siblingDimVariantRef = List.getAt (curHeaderIndex - 1) 
                                                model.sheetUIData.rowDimVariantRefs
                                        in    
                                        case siblingDimVariantRef of
                                            Just siblingDimVariantRefJust ->
                                                SelectTopLeftHeader siblingDimVariantRefJust
                                            Nothing ->
                                                NoOp
                                    TopRightHeader ->
                                        let
                                            maybePath = pathToEndDimCoordByDimVariantRef 
                                                dimVariantRef 
                                                model.curDims 
                                                model.sheetUIData.colDimVariantRefs
                                                model.curDataset.dataArrayRefs
                                            _ = myLog "pathToEndDimCoordByDimVariantRef" maybePath
                                        in
                                        case maybePath of
                                            Just path ->
                                                SelectColHeader path
                                            Nothing ->
                                                NoOp
                           

                        "ArrowRight" ->
                            case headerType of
                                RowHeader ->
                                    if List.length headerPath == rowDepth then
                                        let 
                                            rowIndex  = 
                                                --myLog "elemIndexOfHeaderLeafPath"
                                                (elemIndexOfHeaderLeafPath headerPath model.sheetUIData.headerTrees.row)
                                        in 
                                        case rowIndex of
                                            Just rowIndexJust ->
                                                SelectCell rowIndexJust 0
                                            Nothing ->
                                                NoOp

                                    else -- go to first children
                                        let 
                                            currentTree = --myLog "headerTreeByHeaderPathRoot headerPath"
                                                (headerTreeByHeaderPathRoot headerPath model.sheetUIData.headerTrees.row)
                                            childPath = --myLog "firstChildByHeaderPath headerPath"
                                                (case currentTree of
                                                    Just tree -> (firstChildByHeaderPath headerPath tree)
                                                    Nothing -> Nothing)
                                        in
                                        case childPath of
                                            Just childPathJust ->
                                                SelectRowHeader childPathJust
                                            Nothing ->
                                                NoOp


                                ColHeader ->  
                                    if isTopRightBoundary headerPath model.curDims model.curDataset.dataArrayRefs then
                                        SelectTopRightHeader dimVariantRef
                                    else
                                        let 
                                            siblingPath = myLog "nextSiblingByHeaderPath headerPath"
                                                (nextSiblingByHeaderPath headerPath model.curDims model.curDataset.dataArrayRefs)

                                        in
                                        case siblingPath of
                                            Just siblingPathJust ->
                                                SelectColHeader siblingPathJust
                                            Nothing ->
                                                NoOp

                                TopLeftHeader ->
                                    if Just dimVariantRef == lastList model.sheetUIData.rowDimVariantRefs then
                                        let
                                            startDimCoord =
                                                startDimCoordByDimVariantRef 
                                                    Nothing 
                                                    model.curDims 
                                                    model.sheetUIData.colDimVariantRefs
                                                    model.curDataset.dataArrayRefs

                                        in
                                        case startDimCoord of
                                            Just (startDimVariantRefJust, startCoordJust) ->
                                                SelectColHeader [(startDimVariantRefJust , startCoordJust)]
                                            _ ->
                                                NoOp
                                    else
                                        let
                                            curHeaderIndex =
                                                elemIndexList dimVariantRef model.sheetUIData.rowDimVariantRefs
                                                    |> Maybe.withDefault -1
                                            siblingDimVariantRef = List.getAt (curHeaderIndex + 1) 
                                                model.sheetUIData.rowDimVariantRefs
                                        in    
                                        case siblingDimVariantRef of
                                            Just siblingDimVariantRefJust ->
                                                SelectTopLeftHeader siblingDimVariantRefJust
                                            Nothing ->
                                                NoOp
                                TopRightHeader ->
                                    NoOp


                        _ ->
                            if String.length key == 1 && (isAlphanumeric (stringHead key |> Maybe.withDefault ' ') || key == "\"") then
                                case headerType of
                                    RowHeader ->
                                        EditCellUI (RowHeaderCell headerPath) key
                                    ColHeader ->
                                        EditCellUI (ColHeaderCell headerPath) key
                                    TopLeftHeader ->
                                        EditCellUI (TopLeftHeaderCell dimVariantRef) key
                                    TopRightHeader ->
                                        EditCellUI (TopRightHeaderCell dimVariantRef) key

                            else
                                NoOp
                )
                keyDecoder
                shiftKeyDecoder




noEditKeyPressDecoderCell : Model -> Int -> Int -> Decode.Decoder Msg
noEditKeyPressDecoderCell model rowIndex colIndex  =
    let
        keyDecoder =
            Decode.field "key" Decode.string

        shiftKeyDecoder =
            Decode.field "shiftKey" Decode.bool
        nrRows = model.sheetUIData.numDataRows
        nrCols = model.sheetUIData.numDataCols
    in
    Decode.map2
        (\key shiftKey ->
            case key of
                "Tab" -> --only in cells
                    if shiftKey then
                        -- Handle Shift+Tab
                        moveToPreviousCell rowIndex colIndex nrRows nrCols

                    else
                        -- Handle Tab
                        moveToNextCell rowIndex colIndex nrRows nrCols

                "ArrowUp" ->
                    if rowIndex == 0 then
                            case (getEdgeColHeaderPathAt colIndex model) of
                                Just headerPath ->
                                    let _ = myLog "getEdgeRowHeaderPathAt" headerPath in
                                    SelectColHeader headerPath

                                Nothing ->
                                    SelectCell rowIndex (max 0 (colIndex - 1))

                    else
                    SelectCell (max 0 (rowIndex - 1)) colIndex

                "ArrowDown" ->
                    SelectCell (min (nrRows - 1) (rowIndex + 1)) colIndex

                "ArrowLeft" ->
                    if colIndex == 0 then
                            case (getEdgeRowHeaderPathAt rowIndex model) of
                                Just headerPath ->
                                    let _ = myLog "getEdgeRowHeaderPathAt" headerPath in
                                    SelectRowHeader headerPath

                                Nothing ->
                                    SelectCell rowIndex (max 0 (colIndex - 1))

                    else
                        SelectCell rowIndex (max 0 (colIndex - 1))
                    

                "ArrowRight" ->
                    SelectCell rowIndex (min (nrCols - 1) (colIndex + 1))

                "Backspace" -> -- delete cell content
                    SaveCell rowIndex colIndex XEmpty

                _ ->
                    if String.length key == 1 && (isAlphanumeric (stringHead key |> Maybe.withDefault ' ') || key == "\"") then
                        EditCellUI (DataCell (rowIndex, colIndex)) key

                    else
                        NoOp
        )
        keyDecoder
        shiftKeyDecoder

getEdgeRowHeaderPathAt : Int ->  Model -> Maybe HeaderPath
getEdgeRowHeaderPathAt rowIndex  model =
    let
        rowHeaderTree =
            model.sheetUIData.headerTrees.row
        edgePaths = 
            List.concatMap getHeaderLeafPathsFromTree rowHeaderTree
        nrRows = model.sheetUIData.numDataRows
    in
    if rowIndex < nrRows then
        List.getAt rowIndex edgePaths 
    else
        Nothing

getEdgeColHeaderPathAt : Int ->  Model -> Maybe HeaderPath
getEdgeColHeaderPathAt colIndex  model =
    let
        colHeaderTree =
            model.sheetUIData.headerTrees.col
        edgePaths = 
            List.concatMap getHeaderLeafPathsFromTree colHeaderTree
        nrCols = model.sheetUIData.numDataCols
    in
    if colIndex < nrCols then
        List.getAt colIndex edgePaths 
    else
        Nothing
stringHead : String -> Maybe Char
stringHead key =
    String.toList key |> List.head



-- if String.length key == 1 && isAlphanumeric (stringHead key |> Maybe.withDefault ' ') then
-- for tab navigation


moveToNextCell : Int -> Int -> Int -> Int -> Msg
moveToNextCell rowIndex colIndex nrRows nrCols =
    if colIndex < (nrCols - 1) then
        SelectCell rowIndex (colIndex + 1)

    else if rowIndex < (nrRows - 1) then
        SelectCell (rowIndex + 1) 0

    else
        NoOp



-- At the end of the spreadsheet, do nothing or wrap around based on your preference


moveToPreviousCell : Int -> Int -> Int -> Int -> Msg
moveToPreviousCell rowIndex colIndex nrRows nrCols =
    if colIndex > 0 then
        SelectCell rowIndex (colIndex - 1)

    else if rowIndex > 0 then
        SelectCell (rowIndex - 1) (nrCols - 1)

    else
        NoOp



-- At the beginning of the spreadsheet, do nothing or wrap around based on your preference


focusCommand : String -> Cmd Msg
focusCommand elementId =
    Dom.focus elementId
        |> Task.attempt FocusResult


init : DatasetRef -> ( Model, XModel, Cmd Msg )
init datasetRef =
    let
        xModel =
            XModel.myXModel

        model =
            initialModel xModel datasetRef

        initialFocusCmd =
            focusCommand (getCellIdWithDataset 0 0 model)

        -- Focus on cell [0,0]
    in
    ( model, xModel, initialFocusCmd )



-- Pivot table


formatAttrs : List (Element.Attribute msg)
formatAttrs =
    [ Element.width Element.shrink
    , Border.width 1 -- prende un div che con shrink è tutta la tabella
    , Border.color <| Element.rgb255 0 0 0
    , padding 3
    ]


viewPivotReshaper : Model -> Int -> Bool -> Element Msg
viewPivotReshaper model reshaperWidth showReshaper =
    let buttonSize = 24 in
    row [ Font.size model.defaultFontSize, width (px reshaperWidth ) 
        , padding 5, spacing 5]
        -- cannot set dynamically to max width of container elements

            --[ buttonTogglePivotReshaper model buttonSize
            [ if showReshaper then
                column [width (px  (reshaperWidth - buttonSize - 10)) ]
                [ Element.map DnDTrayMsg <| DnDTray.pageTrayView model.dndTrayModel
                , row 
                    [ width fill, height shrink, padding 2, spacing 2 ]
                    -- no shrink loses row headers
                    -- in DnDTray all trays are set to width fill
                    [ Element.map DnDTrayMsg <| DnDTray.rowTrayView model.dndTrayModel
                    , Element.map DnDTrayMsg <| DnDTray.columnTrayView model.dndTrayModel
                    , Element.map DnDTrayMsg <| DnDTray.ghostView model.dndTrayModel.dnd model.dndTrayModel.trayData
                    ]
                ]
              else if model.curDatasetView.pageTray /= [] then
                Element.map DnDTrayMsg <| DnDTray.pageTrayView model.dndTrayModel
              else
                none
        ]


viewPageTray : Model -> Element Msg
viewPageTray model =
    Element.map DnDTrayMsg <| DnDTray.pageTrayView model.dndTrayModel


-- main view function used by main
-- chatGpt refactoring, bagno di sangue
-- rispetto a MyPivotTable, nelle local functions ho dovuto cambiare i msg in Msg e i comparable in String
-- prende Tree di header text in ordine di livelli gerachici e restituisce "colonne" di Element Msg


topLeftContainer : Model -> String -> Int -> Int -> Element Msg
topLeftContainer model gridAreaTopLeft rowDepth colDepth =
    Element.paragraph
        [ htmlAttribute <| style "display" "inline-grid"
        , htmlAttribute <| style "grid-template-columns" "subgrid"
            --( String.join " " <| List.repeat  rowDepth "auto" ) --
        , htmlAttribute <| style "grid-template-rows" "subgrid"
            --( String.join " " <| List.repeat  colDepth "auto" ) --"subgrid"
        , htmlAttribute <| style "grid-area" gridAreaTopLeft
        , htmlAttribute <| style "position" "sticky"
        --, htmlAttribute <| style "left" "0px"
        , htmlAttribute <| style "z-index" "3"
        , htmlAttribute <| HtmlAttr.id "top-left-container"
        , Background.color darkGray
        , centerY
        , Border.width 1
        ]
        (topLeftHelper model rowDepth colDepth)

topLeftHelper : Model -> Int -> Int -> List (Element Msg)
topLeftHelper model rowDepth colDepth =
    let
        xyLeftTopRightBottom index = -- 1-based, Right and Bottom are last + 1, or -1 if full grid
            " 1 / "  ++ String.fromInt (index + 1) ++ " / " ++ String.fromInt (colDepth + 1) ++  " / " ++ String.fromInt (index + 2)

        gridAttrs index =
            [ htmlAttribute <| style "grid-area" (xyLeftTopRightBottom index)
            ]
    in
    
    List.indexedMap
        (\index dimName ->
            viewTopHeader model dimName TopLeftHeader index (gridAttrs index)
        )
        model.sheetUIData.rowDimVariantRefs

topRightContainer : Model -> String -> Int -> Int -> Element Msg
topRightContainer model gridAreaTopLeft rowDepth colDepth =
    Element.paragraph
        [ htmlAttribute <| style "display" "inline-grid"
        , htmlAttribute <| style "grid-template-columns" "subgrid"
            --( String.join " " <| List.repeat  rowDepth "auto" ) --
        , htmlAttribute <| style "grid-template-rows" "subgrid"
            --( String.join " " <| List.repeat  colDepth "auto" ) --"subgrid"
        , htmlAttribute <| style "grid-area" gridAreaTopLeft
        , htmlAttribute <| style "position" "sticky"
        --, htmlAttribute <| style "left" "0px"
        , htmlAttribute <| style "z-index" "3"
        , htmlAttribute <| HtmlAttr.id "top-right-container"
        , Background.color darkGray
        , centerY
        , Border.width 1
        ]
        (topRightHelper model rowDepth colDepth)


topRightHelper : Model -> Int -> Int -> List (Element Msg)
topRightHelper model rowDepth colDepth =
    let
        xyLeftTopRightBottom index = -- 1-based, Right and Bottom are last + 1, or -1 if full grid
            String.fromInt (index + 1)  ++ " / -1 /"  ++ String.fromInt (index + 1)  ++  " / -1" 

        gridAttrs index =
            [ htmlAttribute <| style "grid-area" (xyLeftTopRightBottom index)
            ]
    in
    
    List.indexedMap
        (\index dimName ->
            viewTopHeader model dimName TopRightHeader index (gridAttrs index)
        )
        model.sheetUIData.colDimVariantRefs

rowHeadersContainer : List (Element msg) -> String -> Element msg
rowHeadersContainer rowHeadersArg gridAreaRow =
    Element.paragraph
        [ htmlAttribute <| style "display" "inline-grid"
        , htmlAttribute <| style "grid-template-columns" "subgrid"
        , htmlAttribute <| style "grid-template-rows" "subgrid"

        -- per sticky partire da 1/1/-1/-1 e cambiare pos fino a cui si blocca + 1, qui y4
        , htmlAttribute <| style "grid-area" gridAreaRow -- xStart/yStart/xEnd+1/yEnd+1 1-based
        , htmlAttribute <| style "position" "sticky"
        , htmlAttribute <| style "left" "0px"
        , htmlAttribute <| style "z-index" "2"
        , htmlAttribute <| HtmlAttr.id "row-header-container"

        -- , width (px 300) -- non fa un tubo
        ]
        -- Replace with actual row header content
        rowHeadersArg


columnHeadersContainer : List (Element msg) -> String -> Element msg
columnHeadersContainer columnHeaderArg gridAreaCol =
    Element.paragraph
        [ htmlAttribute <| style "display" "inline-grid"
        , htmlAttribute <| style "grid-template-columns" "subgrid"
        , htmlAttribute <| style "grid-template-rows" "subgrid"

        -- cambiare pos fino a cui si blocca + 1, qui x1 (1 riga) come gSheet
        , htmlAttribute <| style "grid-area" gridAreaCol
        , htmlAttribute <| style "position" "sticky"
        , htmlAttribute <| style "z-index" "2"
        , htmlAttribute <| HtmlAttr.id "col-header-container"
        , Border.color MyColors.darkGray
        , Border.width 1

        -- , width (px 300) -- non fa un tubo
        ]
        -- Replace with actual column header content
        columnHeaderArg


dataCellsContainer : List (Element msg) -> Element msg
dataCellsContainer dataCellsArg =
    Element.paragraph
        [ htmlAttribute <| style "display" "inline-grid"
        , htmlAttribute <| style "grid-template-columns" "subgrid"
        , htmlAttribute <| style "grid-template-rows" "subgrid"

        -- qui non si blocca nulla quindi tutta la grid
        , htmlAttribute <| style "grid-area" "1/1/-1/-1"
        , Border.color veryLightGray

        --, width (px 300) -- non fa un tubo
        ]
        -- Replace with actual data cells content
        dataCellsArg


-- Helper function to generate the row headers with HeaderPath
rowViewHeadersHelper : Model -> Int -> Int -> List HeaderTree -> List (Element Msg)
rowViewHeadersHelper model rowDepth colDepth trees =
    let
        -- Recursive function to traverse the tree and compute headers
        traverse : HeaderPath -> Int -> Int -> HeaderTree -> (List (Element Msg), Int)
        traverse currentPath depth currentRow headerTree =
            case headerTree of
                HeaderNode header children ->
                    let
                        -- Update the path with the current header
                        newPath : HeaderPath
                        newPath =
                            currentPath ++ [header]

                        -- Compute the span (total rows spanned by all children)
                        span : Int
                        span =
                            List.sum (List.map getHeaderTreeWidth children)

                        -- Generate the header element for this node
                        headerElement : Element Msg
                        headerElement =
                            viewRowHeader
                                model
                                depth
                                span
                                currentRow
                                rowDepth
                                colDepth
                                currentRow
                                newPath
                                (Tuple.second header)

                        -- Recursively process children
                        (childrenElements, nextRow) =
                            List.foldl
                                (\child (accElements, childRow) ->
                                    let
                                        (childElements, updatedRow) =
                                            traverse newPath (depth + 1) childRow child
                                    in
                                    (accElements ++ childElements, updatedRow)
                                )
                                ([], currentRow)
                                children
                    in
                    (headerElement :: childrenElements, nextRow)

                HeaderLeaf header ->
                    let
                        -- Update the path for the leaf node
                        newPath : HeaderPath
                        newPath =
                            currentPath ++ [header]

                        -- Generate the header element for this leaf
                        headerElement : Element Msg
                        headerElement =
                            viewRowHeader
                                model
                                depth
                                1
                                currentRow
                                rowDepth
                                colDepth
                                currentRow
                                newPath
                                (Tuple.second header)
                    in
                    ([headerElement], currentRow + 1)

        -- Process all root trees
        (headerElements, _) =
            List.foldl
                (\rootTree (accElements, currentRow) ->
                    let
                        (rootElements, updatedRow) =
                            traverse [] 0 currentRow rootTree
                    in
                    (accElements ++ rootElements, updatedRow)
                )
                ([], 0)
                trees
    in
    headerElements

-- Helper function to generate the column headers with HeaderPath
colViewHeadersHelper : Model -> Int -> Int -> List HeaderTree -> List (Element Msg)
colViewHeadersHelper model rowDepth colDepth trees =
    let
        -- Recursive function to traverse the tree and compute headers
        traverse : HeaderPath -> Int -> Int -> HeaderTree -> (List (Element Msg), Int)
        traverse currentPath depth currentCol headerTree =
            case headerTree of
                HeaderNode header children ->
                    let
                        -- Update the path with the current header
                        newPath : HeaderPath
                        newPath =
                            currentPath ++ [header]

                        -- Compute the span (total columns spanned by all children)
                        span : Int
                        span =
                            List.sum (List.map getHeaderTreeWidth children)

                        -- Generate the header element for this node
                        headerElement : Element Msg
                        headerElement =
                            viewColHeader
                                model
                                depth
                                span
                                currentCol
                                rowDepth
                                colDepth
                                currentCol
                                newPath
                                (Tuple.second header)

                        -- Recursively process children
                        (childrenElements, nextCol) =
                            List.foldl
                                (\child (accElements, childCol) ->
                                    let
                                        (childElements, updatedCol) =
                                            traverse newPath (depth + 1) childCol child
                                    in
                                    (accElements ++ childElements, updatedCol)
                                )
                                ([], currentCol)
                                children
                    in
                    (headerElement :: childrenElements, nextCol)

                HeaderLeaf header ->
                    let
                        -- Update the path for the leaf node
                        newPath : HeaderPath
                        newPath =
                            currentPath ++ [header]

                        -- Generate the header element for the leaf
                        headerElement : Element Msg
                        headerElement =
                            viewColHeader
                                model
                                depth
                                1
                                currentCol
                                rowDepth
                                colDepth
                                currentCol
                                newPath
                                (Tuple.second header)
                    in
                    ([headerElement], currentCol + 1)

        -- Process all root trees
        (headerElements, _) =
            List.foldl
                (\rootTree (accElements, currentCol) ->
                    let
                        (rootElements, updatedCol) =
                            traverse [] 0 currentCol rootTree
                    in
                    (accElements ++ rootElements, updatedCol)
                )
                ([], 0)
                trees
    in
    headerElements

-- creates headers using trayStrings, gets Array2D of sheetData.data, iterates on i rows and j cols
-- and calls viewCellInPivot for each cell (that gets values from cellsUI)
-- gets getSpreadsheetDataForView from current model.dataView
-- no data shaping here, only computes the headers' shapes


viewSpreadsheetUI : Model -> Element Msg
viewSpreadsheetUI model  =
    let

        -- nr of flatIndices without dVar reference
        numRowsData =
            model.sheetUIData.numDataRows 
            --|> myLog "numRowsData"

        -- nr of dVars
        numColsData =
            model.sheetUIData.numDataCols 

        -- type XTree a b => leaf è List a=values, node è List ( b=label, XTree a b )
        --    = Node (List ( b, XTree a b ))
        --    | Leaf (List a)
        -- Group the rows based on the rowGroupFields and convert them to a tree structure
        rowGroup : List HeaderTree
        rowGroup = 
            model.sheetUIData.headerTrees.row--XView.trayGroup rowTrayCoords
            --|> AppUtil.myLog "rowHeaders from viewSpreadsheetUI"


        -- Group the rows based on the colGroupFields and convert them to a tree structure
        colGroup : List HeaderTree
        colGroup =
            model.sheetUIData.headerTrees.col --XView.trayGroup colTrayCoords

        -- Calculate the depth of the rowGroupFields and colGroupFields
        rowDepth : Int
        rowDepth =
            model.sheetUIData.rowHeaderDepth --List.length rowTrayCoords

        colDepth : Int
        colDepth =
            model.sheetUIData.colHeaderDepth -- List.length colTrayCoords

        -- Calculate the row indices sets for each level of the rowGroupFields
        -- Generate the row headers for the pivot table
        rowHeaders : List (Element Msg)
        rowHeaders =
            rowViewHeadersHelper model rowDepth colDepth rowGroup

        -- Helper function to generate the row headers for each level of the rowGroupFields
        

        -- flattens list of lists
        -- Generate the column headers for the pivot table
        colHeaders : List (Element Msg)
        colHeaders =
            colViewHeadersHelper model rowDepth colDepth colGroup

        -- Helper function to generate the column headers for each level of the colGroupFields
        

        -- Generate the data cells for the pivot table
        dataCells : List (Element Msg)
        dataCells =
            List.concatMap
                (\i ->
                    List.map
                        (\j ->
                            viewCell model i j rowDepth colDepth
                        )
                        (List.range 0 (numColsData - 1))
                )
                (List.range 0 (numRowsData - 1))
        topRightColWidth = 
            --autoResizedWidth model.minColWidth model.sheetUIData.colDimVariantRefs 14
            model.topRightHeaderWidth
    in
    Element.el
        [ Element.scrollbarY, width fill, height fill ]
        -- row height and col width arre best set here at css grid level
        (Element.paragraph
            [ htmlAttribute <| style "display" "inline-grid"

            -- , htmlAttribute <| style "grid-template-areas" "'col-headers col-headers' 'row-headers data-cells'"
            -- , htmlAttribute <| style "grid-template-rows" <| String.join " " <| List.repeat (colDepth + getFirstHeaderTreeWidth rowGroup) "auto"
            --, htmlAttribute <| style "grid-template-rows" <| getRowHeights colDepth rowGroup model.rowHeights
            --, htmlAttribute <| style "grid-template-rows" <| getRowHeightsSlim colDepth model.rowHeights
            --, htmlAttribute <| style "grid-template-columns" (getColumnWidthsAuto (rowDepth + XModel.getWidth colGroup))
            , htmlAttribute <| style "grid-template-rows"  (getRowHeights model.colHeaderHeights model.rowHeights)
            , htmlAttribute <| style "grid-template-columns" 
                ((getColWidths model.rowHeaderWidths model.colWidths) 
                    ++ " " ++ (String.fromInt topRightColWidth) ++ "px") -- auto for col dimVariantRef headers
            

            -- <| String.join " "
            -- <| List.repeat (rowDepth + XModel.getWidth colGroup) getColumWidthForGridPx --"auto"
            --, width fill
            , height fill

            --, Background.color MyColors.lightRed
            ]
            [ if xor (colDepth == 0) (rowDepth == 0) then
                Element.none
              else
                --topLeftCorner ("1/1/" ++ String.fromInt (colDepth + 1) ++ "/" ++ String.fromInt (rowDepth + 1))
                topLeftContainer model ("1/1/" ++ String.fromInt (colDepth + 1) ++ "/" ++ String.fromInt (rowDepth + 1)) rowDepth colDepth
            , if colDepth > 0 then
                columnHeadersContainer colHeaders ("1/1/" ++ String.fromInt (colDepth + 1) ++ "/-1")

              else
                Element.none
            , if colDepth > 0 then
                topRightContainer model ("1/-1/" ++ String.fromInt (colDepth + 1) ++ "/ -2")  rowDepth colDepth
                -- -2 set by trial and error, -1 is the last column
              else
                Element.none
            , if rowDepth > 0 then
                rowHeadersContainer rowHeaders ("1/1/-1/" ++ String.fromInt (rowDepth + 1))
              else
                Element.none
            , dataCellsContainer dataCells
            ]
        )


getColWidths : Array Int -> Array Int -> String
getColWidths headerRowWidths dataColWidths =
    let
        -- Create an array of "auto" for the header columns
        headerColumns =
            --Array.repeat nrHeaderColumns  "auto" -- "max-content"
            Array.map (\width -> String.fromInt width ++ "px") headerRowWidths

        -- Convert data column widths to strings with "px"
        dataColumns =
            Array.map (\width -> String.fromInt width ++ "px") dataColWidths

        -- Combine the two arrays
        combinedColumns =
            Array.append headerColumns dataColumns
    in
    -- Convert the array to a string
    Array.toList combinedColumns
        |> String.join " "


getRowHeights : Array Int -> Array Int -> String
getRowHeights headerColHeights rowHeights =
    let
        headerRows = 
            --Array.repeat nrHeaderRows "auto"
            Array.map (\h -> String.fromInt h ++ "px") headerColHeights
        dataRows = Array.map (\h -> String.fromInt h ++ "px") rowHeights
        combined = Array.append headerRows dataRows
    in
    Array.toList combined |> String.join " "


dropLast : List a -> List a
dropLast list =
    case list of
        [] ->
            []

        [_] ->
            []

        x :: xs ->
            x :: dropLast xs
