module SpreadsheetUI exposing (Model, initialModel, update
        , spreadsheetModalView, focusA1, updateCellUI, updateCellsUI
        , viewCellInPivot
        , getCurrentSpreadsheetAndIndexFromView, viewPivotTableFromSpreadsheetView
        , updateSpreadsheetFromXModel
        , Msg(..), subscriptions)

-- versione con DnDList soltanto importate
import Platform.Cmd as Cmd
-- embedded here

-- NO LONGER USED MyPivotTable
-- import MyPivotTable exposing (..)
import Dict exposing (Dict)
import Set exposing (Set)
-- UI
import Browser.Dom as Dom
-- not exposed to avoid conflicts with Html.Events
import Browser.Events as BrowserEvents 
import Task
import Html exposing (div, input)
import Html.Attributes as HtmlAttr exposing (style)
import Html.Events as HtmlEvents

import Element exposing (..)
import Element.Background as Background
import Element.Font as UiFont
import Element.Border as Border
import Element.Input as Input

import MyColors exposing (..)
import UiWidgets exposing (tooltip, lightTooltip)
import AppUtil exposing (unique, formatFloat, containsLetters)
import XParser exposing (XValue(..))

-- Data and calculations
import Json.Decode as Decode

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
import Editable exposing (Editable(..))

import Array exposing (Array)
import Array2D exposing (Array2D)
import Array.Extra


-- XModel
import TypesXModel exposing (..)

import XView

import String.Conversions exposing (fromBool)
import Element.Font as Font
import Html exposing (col)
import XModel exposing (isDataArrayText)


-- Types
type alias CellUI =
    { value : Editable String
    , isSelected : Bool
    , isEditing : Bool
    }


type alias RowUI = Array CellUI

type alias CellsUI = Array RowUI


type alias Model =
    { nrRows : Int
    , nrCols : Int
    , cellsUI : Array2D CellUI
    , selectedCellUI : Maybe (Int, Int)
    -- spreadsheet
    , spreadsheet : Array2D XValue
    , spreadsheetIndex : Array2D (Int, Int) -- index of cells in spreadsheet
    -- XModel
    , curDataset : Dataset
    , curDatasetView : XView.DatasetView
    -- format
    , defaultColumnWidth : Int -- in px
    , defaultRowHeight : Int -- in px
    , defaultCellPadding : Int --
    , columnWidths : Array Int -- in px
    , rowHeights : Array Int -- in px
    , defaultFontSize : Int
    -- modal column size dialog
    , mouseClickPosition: Maybe (Int, Int)
    , showModal : Bool
    , adjustingColIndex : Maybe Int
    , tempColumnWidth : Maybe Int
    , adjustingRowIndex : Maybe Int
    , tempRowHeight : Maybe Int
    -- interaction status
    , escPressed : Bool
    , hoveredColumn : Maybe Int
    , hoveredRow : Maybe Int
    , ctrlPressed : Bool
 }

initialModel : XModel -> DatasetRef -> Model
initialModel xModel datasetRef =
    let
        -- initializes with initial data from pivot table without formulas
        -- cells calculated Either moved from Left (formula) to Right (value)
        --initialSpreadsheet = read CellParserExcel.parse initialSpreadsheetStr 
        initialDataset = XModel.getDatasetByRef datasetRef xModel.datasets |> Maybe.withDefault XModel.emptyDataset
        initialDatasetView = XView.defaultDatasetView xModel datasetRef (datasetRef ++ "View") -- NB view has no data, only structure
        (initialSpreadsheet, initialSpreadsheetIndex)  =  
            XView.generateSpreadsheetAndIndexFromView xModel.dims initialDataset initialDatasetView

        nrRows = Array2D.rows initialSpreadsheet
        nrCols = Array2D.columns initialSpreadsheet
        defaultColumnWidth = 120
        defaultRowHeight = 24
        defaultCellPadding = 2
    in
    { nrRows = nrRows
    , nrCols = nrCols
    , cellsUI = initialCellsUI initialSpreadsheet
    , selectedCellUI = Just (0, 0)
    -- spreadsheet
    , spreadsheet = initialSpreadsheet
    , spreadsheetIndex = initialSpreadsheetIndex
    -- XModel
    , curDataset = initialDataset
    , curDatasetView = initialDatasetView
    -- format
    , defaultColumnWidth = defaultColumnWidth
    , defaultRowHeight = defaultRowHeight
    , defaultCellPadding = defaultCellPadding
    , rowHeights = Array.repeat nrRows defaultRowHeight
    , columnWidths = Array.repeat nrCols defaultColumnWidth
    , defaultFontSize = 14
    , escPressed = False
    , hoveredColumn = Nothing
    , hoveredRow = Nothing
    -- modal column size dialog
    , mouseClickPosition = Nothing
    , showModal = False
    , adjustingColIndex = Nothing
    , tempColumnWidth = Nothing
    , adjustingRowIndex = Nothing
    , tempRowHeight = Nothing
    , ctrlPressed = False
    }

type Msg
    = SelectCell Int Int
    | EditCell Int Int String
    | Cancel Int Int
    | CellValueChange Int Int String
    | SaveCell Int Int XValue
    | NoOp
    | RefreshFromXModel
    | FocusResult (Result Dom.Error ())
    -- column width dialog
    | MouseEnterColumn Int
    | MouseLeaveColumn
    | OpenColWidthDialog Int (Int, Int)
    | AdjustColumnWidth Int 
    | ConfirmColumnWidthChange
    | CancelColumnWidthChange
    -- Row height dialog
    | MouseEnterRow Int
    | MouseLeaveRow
    | OpenRowHeightDialog Int (Int, Int)
    | AdjustRowHeight Int
    | ConfirmRowHeightChange
    | CancelRowHeightChange
    | CtrlPressed Bool
    | BackspacePressed


subscriptions : Model -> Sub Msg
subscriptions model =
    BrowserEvents.onKeyDown keyDownDecoder
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
    Array.get coIndex model.columnWidths |> Maybe.withDefault model.defaultColumnWidth  



initialCellsUI : Array2D XValue -> Array2D CellUI
initialCellsUI spreadsheet =
    let
        nrRows = Array2D.rows spreadsheet
        nrCols = Array2D.columns spreadsheet

        createCellUI rowIndex colIndex =
            let
                maybeCell = Array2D.get rowIndex colIndex spreadsheet
                cellValue = 
                    case maybeCell of
                        Just cell -> XParser.render cell
                        Nothing -> ""  -- Or a default value if the cell is not found
            in
            if rowIndex == 0 && colIndex == 0 then
                initFirstCell cellValue
            else
                initOtherCell cellValue

        initFirstCell value =
            { value = ReadOnly value, isSelected = True, isEditing = False }

        initOtherCell value =
            { value = ReadOnly value, isSelected = False, isEditing = False }
        
    in
    Array2D.initialize nrRows nrCols createCellUI


updateCellsUI : Array2D CellUI -> Array2D XValue -> Array2D CellUI
updateCellsUI prevCellsUI spreadsheet =
    let
        -- DISABLED no longer formulas always recalc
        -- spreadsheet = formulaSpreadsheet |> eval
        nrRows = Array2D.rows spreadsheet
        nrCols = Array2D.columns spreadsheet

        createCellUI rowIndex colIndex =
            let
                maybeCell = Array2D.get rowIndex colIndex spreadsheet
                prevCellUI = getCellUI rowIndex colIndex prevCellsUI
                cellValue = 
                    case maybeCell of
                        Just cell -> XParser.render cell
                        Nothing -> ""  -- Or a default value if the cell is not found
            in
            { prevCellUI | value = ReadOnly cellValue }
        
    in
    Array2D.initialize nrRows nrCols createCellUI


getCellUI : Int -> Int -> Array2D CellUI -> CellUI
getCellUI rowIndex coIndex cells =
    let
        cell = Array2D.get rowIndex coIndex cells 
                |> Maybe.withDefault 
                    { value = ReadOnly ""
                    , isSelected = False
                    , isEditing = False }
    in
    cell

getCellValue : CellUI -> String
getCellValue cell =
    case cell.value of
        ReadOnly value ->
            value
        Editable old new ->
            new

-- what is used for?
getCellDictIndex : Int -> Int -> Array2D (Int, Int)-> (Int, Int)
getCellDictIndex rowIndex colIndex spreadsheetIndex =
    Array2D.get rowIndex colIndex spreadsheetIndex |> Maybe.withDefault (-1, -1)


-- Update
update : Msg -> Model -> XModel -> (Model, XModel, Cmd Msg)
update msg model xModel=
    case msg of
        SelectCell rowIndex coIndex ->
            -- Update for selecting a cell
            updateForSelectCellUI model xModel rowIndex coIndex

        EditCell rowIndex colIndex newChar ->
            let
                cellUI = getCellUI rowIndex colIndex model.cellsUI
                maybeSpreadsheetCell = Array2D.get rowIndex colIndex model.spreadsheet
                cellText =
                    case maybeSpreadsheetCell of
                        Just cell ->
                            XParser.render cell
                        Nothing ->
                            ""
                editableValue =
                            if cellText /= "" then
                                Editable.edit (Editable cellText cellText)
                            else -- char keypress to edit, only pressed char
                            if newChar /= "" then
                                Editable.map (always newChar) (Editable.edit cellUI.value)
                            else -- double click, edit cell content
                                Editable.edit cellUI.value
                updatedCells =
                    updateCellUI rowIndex colIndex (\cellUIarg -> 
                        { cellUIarg | value = editableValue, isEditing = True }) model.cellsUI
            in
            -- ( { model | cells = updatedCells, editingValue = Just initialEditingValue }
            ( { model | cellsUI = updatedCells, escPressed = False }
            , xModel
            , focusCommand (getCellId rowIndex colIndex) )


        SaveCell rowIndex colIndex newCellValue ->
            if model.escPressed then
                -- Debug.log ("esc pressed, no save")
                ({model | escPressed = False}, xModel, Cmd.none )
            else
                let
                    (flatIndex, dVarIndex) = Array2D.get rowIndex colIndex model.spreadsheetIndex |> Maybe.withDefault (-1, -1)
                    updatedDataset = XModel.setXValueDatumToDataset model.curDataset flatIndex dVarIndex newCellValue
                    curDatasetName = model.curDataset.ref
                    updatedXModel = { xModel 
                                    | datasets = XModel.insertDataset curDatasetName updatedDataset xModel.datasets
                                    , datasetToRecalc = Just curDatasetName
                                    }
                    updatedSpreadsheet =
                        XView.generateSpreadsheetAndIndexFromView xModel.dims updatedDataset model.curDatasetView |> Tuple.first

                    updatedCellsUI = -- only with UI settings
                        updateCellUI rowIndex colIndex (\cellUI -> { cellUI | isEditing = False }) model.cellsUI

                -- Save changes and exit edit mode

                    newModel = { model 
                        | curDataset = updatedDataset
                        --, table = updatedTable
                        , cellsUI = (updateCellsUI updatedCellsUI updatedSpreadsheet)
                        , spreadsheet = updatedSpreadsheet
                        , escPressed = False
                        }
                in
                -- Debug.log ("Updated dataset: " ++ Debug.toString(updatedDataset))
                ( newModel, updatedXModel, focusCommand (getCellId rowIndex colIndex) )

        CellValueChange rowIndex colIndex newValue ->
            let
                updatedCells = updateCellUI rowIndex colIndex (\cellUI ->
                    { cellUI | value = Editable.map (always newValue) cellUI.value }
                    ) model.cellsUI
            in
            ({ model | cellsUI = updatedCells }, xModel, Cmd.none)

        Cancel rowIndex colIndex ->
            -- Revert any unsaved changes and exit edit mode
            ({ model 
            | cellsUI = updateForCancelEdit model
            , escPressed = True
            -- , editingValue = Nothing
            }
            , xModel
            , focusCommand (getCellId rowIndex colIndex) )
        NoOp ->
            (model, xModel, Cmd.none)
        -- FocusResult is only a log message that is sent when the focus command is completed
        RefreshFromXModel  ->
            let
                updatedXModel = xModel
                updatedDataset = XModel.getDatasetByRef model.curDataset.ref updatedXModel.datasets |> Maybe.withDefault XModel.emptyDataset
                updatedSpreadsheet =
                    XView.generateSpreadsheetAndIndexFromView xModel.dims updatedDataset model.curDatasetView |> Tuple.first
                updatedCellsUI = -- only with UI settings
                    updateCellsUI model.cellsUI updatedSpreadsheet
            in
            ( { model 
                | curDataset = updatedDataset
                --, table = updatedTable
                , cellsUI = updatedCellsUI
                , spreadsheet = updatedSpreadsheet
                }
            , updatedXModel
            --, Cmd.none)
            -- PROVVI focusCommand (getCellId 0 0) must pass current row and col index
            ,   focusCommand (getCellId 1 1) -- non funziona
            )
        FocusResult result ->
            case result of
                Ok () ->
                    (model, xModel, Cmd.none)
                Err error ->
                    Debug.log ("Error focusing input: " ++ Debug.toString(error))
                    (model, xModel, Cmd.none)

        MouseEnterColumn colIndex ->
            -- Debug.log ("MouseEnterColumn " ++ String.fromInt colIndex)
            ({ model | hoveredColumn = Just colIndex }, xModel, Cmd.none)

        MouseLeaveColumn ->
            ({ model | hoveredColumn = Nothing }, xModel, Cmd.none)

        MouseEnterRow rowIndex ->
            ({ model | hoveredRow = Just rowIndex }, xModel, Cmd.none)

        MouseLeaveRow ->
            ({ model | hoveredRow = Nothing }, xModel, Cmd.none)

        OpenColWidthDialog colIndex (clientX, clientY) ->
            ({ model | showModal = True
                     , adjustingColIndex = Just colIndex
                     , tempColumnWidth = Just (getColumnWidth colIndex model)
                     , mouseClickPosition = Just (clientX, clientY)
                     }
            , xModel
            , Cmd.none)
        
        AdjustColumnWidth newWidth ->
            -- ({ model | tempColumnWidth = Just newWidth }, Cmd.none)
            case model.adjustingColIndex of
                Just colIndex ->
                    -- logic to update the actual column width array
                    -- no hide modal
                    let
                        updatedColumnWidths = Array.set colIndex newWidth model.columnWidths
                    in
                    ({ model | columnWidths = updatedColumnWidths, tempColumnWidth = Just newWidth }
                    , xModel
                    , Cmd.none)
                Nothing ->
                    -- logic to hide modal
                    ({ model | showModal = False, adjustingColIndex = Nothing }
                    , xModel
                    , Cmd.none)

        ConfirmColumnWidthChange ->
            case model.adjustingColIndex of
                Just colIndex ->
                    -- logic to update the actual column width array
                    -- hide modal
                    let
                        updatedColumnWidths = Array.set colIndex (Maybe.withDefault model.defaultColumnWidth model.tempColumnWidth) model.columnWidths
                        updatedModel = { model | 
                            showModal = False
                            , adjustingColIndex = Nothing 
                            , columnWidths = updatedColumnWidths
                            }
                    in
                    -- Debug.log ("Updated Model showModal: " ++ (fromBool updatedModel.showModal))
                    ( updatedModel, xModel, Cmd.none)
                Nothing ->
                    -- logic to hide modal
                    ({ model | showModal = False, adjustingColIndex = Nothing }, xModel, Cmd.none)

        CancelColumnWidthChange ->
            case model.adjustingColIndex of
            -- logic to cancel changes and hide modal
            -- for simplicity, no restoring of previous column width, only set to default
                Just colIndex ->
                    -- logic to update the actual column width array
                    -- hide modal
                    let
                        updatedColumnWidths = Array.set colIndex (Maybe.withDefault model.defaultColumnWidth Nothing) model.columnWidths
                    in
                    ({ model | showModal = False, adjustingColIndex = Nothing
                     , columnWidths = updatedColumnWidths }
                     , xModel
                     , Cmd.none)
                Nothing ->
                    -- logic to hide modal
                    ({ model | showModal = False, adjustingColIndex = Nothing }, xModel, Cmd.none)

        OpenRowHeightDialog rowIndex (clientX, clientY) ->
            ({ model | showModal = True
                     , adjustingRowIndex = Just rowIndex
                     , tempRowHeight = Just (getRowHeight rowIndex model)
                     , mouseClickPosition = Just (clientX, clientY)
                     }
            , xModel
            , Cmd.none)
        
        AdjustRowHeight newHeight ->
            case model.adjustingRowIndex of
                Just rowIndex ->
                    -- logic to update the actual column width array
                    -- no hide modal
                    let
                        updatedRowHeights = Array.set rowIndex newHeight model.rowHeights
                    in
                    ({ model | rowHeights = updatedRowHeights, tempRowHeight = Just newHeight }
                    , xModel
                    , Cmd.none)
                Nothing ->
                    -- logic to hide modal
                    ({ model | showModal = False, adjustingRowIndex = Nothing }
                    , xModel
                    , Cmd.none)

        ConfirmRowHeightChange ->
            case model.adjustingRowIndex of
                Just rowIndex ->
                    -- logic to update the actual column width array
                    -- hide modal
                    let
                        updatedRowHeights = Array.set rowIndex (Maybe.withDefault model.defaultRowHeight model.tempRowHeight) model.rowHeights
                    in
                    ({ model | showModal = False, adjustingRowIndex = Nothing
                     , rowHeights = updatedRowHeights }, xModel, Cmd.none)
                Nothing ->
                    -- logic to hide modal
                    ({ model | showModal = False, adjustingRowIndex = Nothing }, xModel, Cmd.none)

        CancelRowHeightChange ->
            case model.adjustingRowIndex of
                Just rowIndex ->
                    let
                        updatedRowHeights = Array.set rowIndex (Maybe.withDefault model.defaultRowHeight Nothing) model.rowHeights
                    in
                    ({ model | showModal = False, adjustingRowIndex = Nothing
                     , rowHeights = updatedRowHeights }, xModel, Cmd.none)
                Nothing ->
                    -- logic to hide modal
                    ({ model | showModal = False, adjustingRowIndex = Nothing }, xModel, Cmd.none)
        CtrlPressed isPressed ->
            ({ model | ctrlPressed = isPressed }, xModel, Cmd.none)
        BackspacePressed ->
            (model, xModel, Cmd.none)


updateSpreadsheetFromXModel : Model -> XModel -> Dataset-> Model
updateSpreadsheetFromXModel model xModel updatedDataset =
    let
                    updatedSpreadsheet =
                        XView.generateSpreadsheetAndIndexFromView xModel.dims updatedDataset model.curDatasetView |> Tuple.first


                    -- updatedCellsUI = -- only with UI settings
                    --     initialCellsUI updatedSpreadsheet

                -- Save changes and exit edit mode

                    newModel = { model 
                        | curDataset = updatedDataset
                        --, table = updatedTable
                        , cellsUI = (updateCellsUI model.cellsUI updatedSpreadsheet)
                        , spreadsheet = updatedSpreadsheet
                        , escPressed = False
                        }
        in
        newModel
isCellText : Int -> Int -> Model -> Bool
isCellText rowIndex colIndex model =
    let
        (_, dVarIndex) = Array2D.get rowIndex colIndex model.spreadsheetIndex |> Maybe.withDefault (-1, -1)
        dataArray  = XModel.getDataArrayByDVarIndex model.curDataset dVarIndex
    in
    isDataArrayText dataArray

updateForSelectCellUI : Model -> XModel -> Int -> Int -> (Model, XModel, Cmd Msg)
updateForSelectCellUI model xModel rowIndex coIndex =
    let
        deselectCurrentCell =
            case model.selectedCellUI of
                Just (prevRowIndex, prevColumnIndex) ->
                    updateCellUI prevRowIndex prevColumnIndex (\cell -> { cell | isSelected = False }) model.cellsUI
                Nothing ->
                    model.cellsUI

        selectNewCell =
            updateCellUI rowIndex coIndex (\cell -> { cell | isSelected = True }) deselectCurrentCell
    in
    ({ model | cellsUI = selectNewCell, selectedCellUI = Just (rowIndex, coIndex) }
    , xModel
    , focusCommand (getCellId rowIndex coIndex))

updateForCancelEdit : Model -> Array2D CellUI
updateForCancelEdit model =
    case model.selectedCellUI of
        Just (rowIndex, coIndex) ->
            let
                updatedCellsUI = updateCellUI rowIndex coIndex 
                    (\cell -> { cell | value = Editable.cancel cell.value, isEditing = False }) model.cellsUI
            in
                updateCellsUI updatedCellsUI model.spreadsheet

        Nothing ->
            model.cellsUI


updateCellUI : Int -> Int -> (CellUI -> CellUI) -> Array2D CellUI -> Array2D CellUI
updateCellUI rowIndex colIndex updateFunction cells =
    Array2D.update rowIndex colIndex updateFunction cells


-- View
spreadsheetModalView : Model -> Element Msg
spreadsheetModalView model =
    let
        modalFunc = if model.adjustingColIndex /= Nothing then viewModalColumnWidth else viewModalRowHeight
    in
       if model.showModal then
            modalFunc model
       else
            Element.none


-- ci sono settaggi per fissare in modo semi hard coded sticked row e col headers
-- si basano su larghezze e altezze di righe e colonne in px settati qui
-- e in PersonValue.elm
-- li ho disattivati perché non funzionano bene cambiando l'ordine di reshape
viewRowHeaderInPivot : Model -> Int -> Int -> Int -> Int -> Int -> Int -> String -> Element Msg
viewRowHeaderInPivot model depth span offset rowDepth colDepth rowIndex headerText =
    let
        isHedgeHeader : Bool
        isHedgeHeader = ((rowDepth - depth) == 1 )
        isHovered : Bool
        isHovered = (model.hoveredRow == Just rowIndex)
        hoverText = "Click to format"
        -- hoverText = if isHedgeHeader && isHovered then "Click to format" else ""
        pivotAttrs = (List.map Element.htmlAttribute
            [ style "grid-row-start" <| String.fromInt <| colDepth + offset + 1
            , style "grid-row-end" <| String.fromInt <| colDepth + offset + 1 + span
            , style "grid-column-start" <| String.fromInt <| depth + 1
            , style "grid-column-end" <| String.fromInt <| depth + 2
            -- , style "position" "sticky"
            -- , style "left" <| (String.fromInt (getRowHeaderPosition model depth) ++ "px")
            -- , style "z-index" "1"
            ])

        additionalAttrs =
            if isHedgeHeader then -- depth is 0-based
                [ tooltip above (lightTooltip hoverText)
                --, Events.onMouseEnter (MouseEnterRow rowIndex)
                --, Events.onMouseLeave MouseLeaveRow
                , htmlAttribute (onClickRowHeaderWithPosition rowIndex)
                , height (fill |> minimum (getRowHeight rowIndex model))
                , padding model.defaultCellPadding
                , UiFont.bold
                , Border.width 1
                , UiFont.size model.defaultFontSize
                , Background.color lightGray
                -- , Background.color pink
                --, UiFont.size <| if isHovered then 8 else model.defaultFontSize
                --, Background.color <| if isHovered then green else lightGray
                ]
            else
                [ height (fill |> minimum (getRowHeight rowIndex model))
                , padding model.defaultCellPadding
                , Border.width 1
                , UiFont.bold
                , UiFont.size model.defaultFontSize
                , Background.color lightGray
                -- , UiFont.size <| if isHedgeHeader && isHovered then 10 else model.defaultFontSize
                -- , Background.color <| if isHedgeHeader && isHovered then green else lightGray
                ]

    in
    -- el (pivotAttrs ++ additionalAttrs) (headerContent [Font.alignLeft] hoverText headerText)
    el (pivotAttrs ++ additionalAttrs) (headerContent [Font.alignLeft] "" headerText)
getCurrentColumnWidth : Model -> Int -> Length
getCurrentColumnWidth model colIndex =
    let
        curSetWidth = Array.get colIndex model.columnWidths
    in
    case curSetWidth of
        Just width -> if width > 0 then px width else fill
        Nothing -> fill

viewColHeaderInPivot : Model -> Int -> Int -> Int -> Int -> Int -> Int -> String -> Element Msg
viewColHeaderInPivot model depth span offset rowDepth colDepth colIndex headerText =
    let
        headerHeightPerDim = 18
        titleAndTraysHeight = 110
        isHedgeHeader : Bool
        isHedgeHeader = ((colDepth - depth) == 1)
        curWidth = getCurrentColumnWidth model colIndex
        isHovered : Bool
        isHovered = (model.hoveredColumn == Just colIndex)
        hoverText = "Click to format"
        -- hoverText = if isHedgeHeader && isHovered then "Click to format" else "" 
        pivotAttrs = (List.map Element.htmlAttribute
                [ style "grid-row-start"    <| String.fromInt <| depth + 1
                , style "grid-row-end"      <| String.fromInt <| depth + 2
                , style "grid-column-start" <| String.fromInt <| rowDepth + offset + 1
                , style "grid-column-end"   <| String.fromInt <| rowDepth + offset + 1 + span
                -- , style "position" "sticky"
                -- , style "top" (String.fromInt (headerHeightPerDim*(depth+1)+titleAndTraysHeight) ++ "px")
                -- , style "z-index" "2"
                ])

        additionalAttrs =
            if isHedgeHeader then -- depth is 0-based
                let
                    adjIndex = Maybe.withDefault -1 model.adjustingColIndex
                in
                [ tooltip below (lightTooltip hoverText)
                --, Events.onMouseEnter (MouseEnterColumn colIndex)
                --, Events.onMouseLeave MouseLeaveColumn
                , htmlAttribute (onClickColHeaderWithPosition colIndex)
                , width curWidth --(px model.defaultColumnWidth) --(fill |> minimum (getColumnWidth colIndex model))
                , padding model.defaultCellPadding
                , UiFont.center
                , UiFont.bold
                , Border.width 1
                --, Border.dashed
                , UiFont.size model.defaultFontSize
                , Background.color lightGray
                -- provato a spostare qui ma non funzionano bottoni, resize funziona
                -- , inFront (if model.showModal && colIndex == adjIndex then 
                --             spreadsheetModalView model 
                --         else Element.none)
                --, UiFont.size <| if isHovered then 8 else model.defaultFontSize
                --, Background.color <| if isHovered then green else lightGray
                ]
            else
                [ width fill --(px model.defaultColumnWidth) --(fill |> minimum (getColumnWidth colIndex model)) -- provvisorio
                , padding model.defaultCellPadding
                , UiFont.center
                , UiFont.bold
                , Border.width 1
                , UiFont.size model.defaultFontSize
                , Background.color lightGray
                -- , UiFont.size <| if isHedgeHeader && isHovered then 10 else model.defaultFontSize
                -- , Background.color <| if isHedgeHeader && isHovered then green else lightGray
                ]

    in
    -- el (pivotAttrs ++ additionalAttrs) (headerContent [Font.center] hoverText headerText)
    el (pivotAttrs ++ additionalAttrs) (headerContent [Font.center] "" headerText)

-- content taken from cell, not from arg
viewCellInPivot : Model -> Int -> Int -> Int -> Int   -> Element Msg
viewCellInPivot model rowIndex colIndex rowDepth colDepth  =
    let 
        pivotAttrs = [ style "grid-row-start" <| String.fromInt <| colDepth + rowIndex + 1
                        , style "grid-row-end"      <| String.fromInt <| colDepth + rowIndex + 2
                        , style "grid-column-start" <| String.fromInt <| rowDepth + colIndex + 1
                        , style "grid-column-end"   <| String.fromInt <| rowDepth + colIndex + 2
                        , style "overflow" "auto" 
                        ]
        -- here cell.value get from celllsUI
        cell = getCellUI rowIndex colIndex model.cellsUI
        cellId = getCellId rowIndex colIndex
        isText = isCellText rowIndex colIndex model
        cellValue = getCellValue cell
        curWidth = getCurrentColumnWidth model colIndex
        noEditCellAttributes =
            [ HtmlAttr.id cellId -- HtmlAttr is alias of Html.Attribute
            , HtmlAttr.tabindex (getTabIndex rowIndex colIndex model.nrCols)
            , HtmlEvents.onClick (SelectCell rowIndex colIndex)
            , HtmlEvents.onDoubleClick (EditCell rowIndex colIndex "")
            , onKeyDownWithPreventDefault (noEditKeyDecoderWithPreventDefault rowIndex colIndex model.nrRows model.nrCols)
            ]
            |> List.map Element.htmlAttribute

        cellStyle = 
            [ Background.color <| if cell.isSelected then rgb255 135 135 135 else rgb255 255 255 255
            , Border.width 1 -- <| if cell.isEditing then 2 else 1
            , padding model.defaultCellPadding
            , width curWidth -- (px model.defaultColumnWidth)-- (px (getColumnWidth colIndex model)) -- funziona ma per le prove meglio fill
            , height fill -- (px (getRowHeight rowIndex model)) -- funziona ma per le prove meglio fill
            , UiFont.center
            , UiFont.size model.defaultFontSize
            ]

        -- usati da element input
        editCellAttributes =
            [ HtmlAttr.id cellId
            , HtmlEvents.onInput (CellValueChange rowIndex colIndex)
            , HtmlEvents.onBlur (SaveCell rowIndex colIndex (XParser.parse cellValue isText))
            , HtmlAttr.value cellValue
            , onKeyDown (onKeyDownEditDecoder rowIndex colIndex model cellValue)
            -- if width is set to 100% removing it is not relevant
            , style "width" "100%" -- (String.fromInt (model.defaultColumnWidth - 10) ++ "px") -- 
            , style "height" "100%" 
            , style "box-sizing" "border-box" -- Include padding and border in the element's width
            , HtmlAttr.class "edit-cell"
            ]

    in
    case cell.value of
        ReadOnly value ->
            let
                renderedValue = if isText then value else formatFloat (String.toFloat value |> Maybe.withDefault (0/0))
            in
            el (noEditCellAttributes ++ cellStyle ++ htmlAttrs pivotAttrs) <| text renderedValue

        -- qui lascio html.Attribute perché hanno tanti attr non gestiti da elm-ui
        Editable _ newValue ->
            let
                -- div contenitore per input
                widthStyle = style "width" "100%" --(String.fromInt (getColumnWidth colIndex model) ++ "px")
                heightStyle = style "height" (String.fromInt (getRowHeight rowIndex model) ++ "px")
                editCellFormat = 
                        --[widthStyle, heightStyle] --, style "padding" (String.fromInt model.defaultCellPadding)]
                        [heightStyle, style "padding" (String.fromInt model.defaultCellPadding)]
            
            in       
            html <| div
                (editCellFormat ++ pivotAttrs)
                [ input (editCellAttributes) [] ]

                
            

headerContent : List (Attribute msg) -> String -> String -> Element msg
headerContent textAlign hoverText headerText =
    if hoverText == "" then
        el textAlign <| text headerText
    else
        column [centerX, centerY]
            [ -- el textAlign <| text headerText , -- per evitare sfarfallio
            el textAlign <| text hoverText
            ]


viewModalColumnWidth : Model -> Element Msg
viewModalColumnWidth model =
    if model.showModal then
        let
            currentWidth = model.tempColumnWidth |> Maybe.withDefault model.defaultColumnWidth
            curMouseClickPosition = model.mouseClickPosition |> Maybe.withDefault (0,0)
        in
        viewModalCommon ("Set width: " ++ String.fromInt currentWidth) currentWidth 50 500 
            AdjustColumnWidth 
            ConfirmColumnWidthChange 
            CancelColumnWidthChange
            curMouseClickPosition
    else
        Element.none

viewModalRowHeight : Model -> Element Msg
viewModalRowHeight model =
    if model.showModal then
        let
            currentHeight = model.tempRowHeight |> Maybe.withDefault model.defaultRowHeight
            curMouseClickPosition = model.mouseClickPosition |> Maybe.withDefault (0,0)
        in
        viewModalCommon ("Set height: " ++ String.fromInt currentHeight) currentHeight 10 500
            AdjustRowHeight 
            ConfirmRowHeightChange 
            CancelRowHeightChange
            curMouseClickPosition
    else
        Element.none

viewModalCommon : String -> Int -> Int -> Int -> (Int -> Msg) -> Msg -> Msg -> (Int, Int) -> Element Msg
viewModalCommon label currentValue minValue maxValue onChangeMsg confirmMsg cancelMsg (clientX, clientY)=
    column [ width (px 300), padding 20, centerX, centerY, Background.color white, Border.rounded 6
           , htmlAttribute (style "position" "absolute")
           , htmlAttribute (style "left" (String.fromInt (clientX+20) ++ "px"))
           , htmlAttribute (style "top" (String.fromInt (clientY+20) ++ "px")) 
           , htmlAttribute (style "z-index" "3")
           ]
        [ Input.slider
            [ height <| px 30
            , behindContent <|
                el [ width fill
                   , height <| px 20
                   , centerY
                   , Background.color blue
                   , Border.rounded 6
                   ]
                   Element.none
            ]
            { onChange = round >> onChangeMsg
            , label = Input.labelAbove [] <| text label
            , min = toFloat minValue
            , max = toFloat maxValue
            , step = Just 5
            , value = toFloat currentValue
            , thumb = Input.defaultThumb 
            }
        , row [ spacing 10 ] -- Row to place buttons side by side
            [ createButton "OK" confirmMsg
            , createButton "Cancel" cancelMsg
            ]
        ]

createButton : String -> Msg -> Element Msg
createButton buttonText msg =
    Input.button
        [ padding 10
        , Border.width 3
        , Border.rounded 6
        , Border.color blue
        , Background.color lightBlue
        , UiFont.variant UiFont.smallCaps
        , mouseDown [ Background.color blue, Border.color blue, UiFont.color white ]
        , mouseOver [ Background.color white, Border.color lightGray ]
        ]
        { onPress = Just msg, label = text buttonText }


-- presa da Korban p. 121
htmlAttrs : List (Html.Attribute Msg) -> List (Attribute Msg) 
htmlAttrs =
    List.map htmlAttribute

-- DnDList


getCellId : Int -> Int -> String
getCellId rowIndex coIndex =
    "cell-" ++ String.fromInt rowIndex ++ "-" ++ String.fromInt coIndex ++ "-input"

getTabIndex : Int -> Int -> Int -> Int
getTabIndex rowIndex coIndex nrCols =
    rowIndex * nrCols + coIndex + 1-- 1 based, needed to avoid wrong focus tabbing from cell(0,0) to cell(0,1)

-- Decoding key press

type alias KeyboardEvent =
    { keyCode : Int
    , ctrlPressed : Bool
    }

-- Decode keyboard event to Msg
keyCodeEventToMsg : Int -> Int -> Model -> String -> KeyboardEvent -> Msg
keyCodeEventToMsg rowIndex colIndex model cellValue event =

    case event.keyCode of
        8 ->
            if event.ctrlPressed then
                -- Ctrl + Backspace logic
                SaveCell rowIndex colIndex XEmpty
            else
                -- Handle just Backspace key logic if needed
                NoOp
        13 ->
            -- Enter key logic
            let
                checkedCellValue = 
                    if cellValue == "" then 
                        XEmpty
                    else 
                        (XParser.parse cellValue (isCellText rowIndex colIndex model))
            in
            SaveCell rowIndex colIndex checkedCellValue
        27 ->
            -- Escape key logic
            Cancel rowIndex colIndex
        _ ->
            NoOp
-- current implementation
keyCodeToMsg : Int -> Int -> Model -> String -> Int -> Msg
keyCodeToMsg rowIndex colIndex model cellValue keyCode =
    if model.ctrlPressed && keyCode == 8 then
        -- Ctrl + Backspace logic
        (SaveCell rowIndex colIndex XEmpty)
    else if keyCode == 13 then  -- Enter key
        let
            checkedCellValue = 
                if cellValue == "" then 
                    XEmpty
                else 
                    (XParser.parse cellValue (isCellText rowIndex colIndex model))
        in
        SaveCell rowIndex colIndex checkedCellValue
    else if keyCode == 27 then  -- Escape key
        Cancel rowIndex colIndex
    else
        NoOp

-- Custom onClick handler for dialog
onClickRowHeaderWithPosition : Int -> Html.Attribute Msg
onClickRowHeaderWithPosition rowIndex =
    HtmlEvents.on "click" (Decode.map (OpenRowHeightDialog rowIndex) clickPositionDecoder)

onClickColHeaderWithPosition : Int -> Html.Attribute Msg
onClickColHeaderWithPosition colIndex =
    HtmlEvents.on "click" (Decode.map (OpenColWidthDialog colIndex) clickPositionDecoder)

-- le chiamate ad update vanno nei decoder
clickPositionDecoder : Decode.Decoder (Int, Int)
clickPositionDecoder =
    Decode.map2 Tuple.pair
        (Decode.field "clientX" Decode.int)
        (Decode.field "clientY" Decode.int)

-- Custom onKeyDown handler, follow keyCodeToMsg to see how Msg is created

-- attempt to handle ctrl+backspace, aborted
-- onKeyDownEditDecoder : Int -> Int -> String -> Decode.Decoder Msg
-- onKeyDownEditDecoder rowIndex colIndex cellValue =
--     let
--         decodeKeyCode = Decode.field "keyCode" Decode.int
--         decodeCtrlPressed = Decode.field "ctrlKey" Decode.bool
        
--         decodeKeyboardEvent =
--             Decode.map2 KeyboardEvent
--                 decodeKeyCode
--                 decodeCtrlPressed
--     in
--     Decode.map (keyCodeEventToMsg rowIndex colIndex cellValue) decodeKeyboardEvent


onKeyDownEditDecoder : Int -> Int -> Model -> String -> Decode.Decoder Msg
onKeyDownEditDecoder rowIndex colIndex model cellValue=
    let
        keyDecoder = Decode.field "keyCode" Decode.int
    in
    Decode.map (keyCodeToMsg rowIndex colIndex model cellValue) keyDecoder

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
        "Backspace" ->
            -- Only produce Backspace-related Msg if you need it here,
            -- and you can check your application's state to see if Ctrl is pressed.
            Decode.succeed BackspacePressed
        _ ->
            Decode.fail "Not a key we're interested in"

-- keyUpDecoder : Decode.Decoder Msg
-- keyUpDecoder =
--     let _ = Debug.log ("keyUpDecoder") in
--     Decode.succeed (CtrlPressed False)

keyUpDecoder : Decode.Decoder Msg
keyUpDecoder =
    Decode.field "key" Decode.string
        |> Decode.andThen keyUpToMsg

keyUpToMsg : String -> Decode.Decoder Msg
keyUpToMsg keyString =
    case keyString of
        "Control" ->
            Decode.succeed (CtrlPressed True)
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
onKeyDownWithPreventDefault : Decode.Decoder (Msg, Bool) -> Html.Attribute Msg
onKeyDownWithPreventDefault decoder =
    HtmlEvents.preventDefaultOn "keydown" decoder

noEditKeyDecoderWithPreventDefault : Int -> Int -> Int -> Int -> Decode.Decoder (Msg, Bool)
noEditKeyDecoderWithPreventDefault rowIndex colIndex nrRows nrCols =
    Decode.map2 Tuple.pair
        (noEditKeyPressDecoder rowIndex colIndex nrRows nrCols) 
        (Decode.succeed True) -- Always succeed with True to prevent the default

noEditKeyPressDecoder : Int -> Int -> Int -> Int -> Decode.Decoder Msg
noEditKeyPressDecoder rowIndex colIndex nrRows nrCols =
    let
        keyDecoder = Decode.field "key" Decode.string
        shiftKeyDecoder = Decode.field "shiftKey" Decode.bool
    in
    Decode.map2 (\key shiftKey ->
        case key of
            "Tab" ->
                if shiftKey then
                    -- Handle Shift+Tab
                    moveToPreviousCell rowIndex colIndex nrRows nrCols
                else
                    -- Handle Tab
                    moveToNextCell rowIndex colIndex nrRows nrCols
            "ArrowUp" ->
                SelectCell (max 0 (rowIndex - 1)) colIndex
            "ArrowDown" ->
                SelectCell (min (nrRows - 1) (rowIndex + 1)) colIndex
            "ArrowLeft" ->
                SelectCell rowIndex (max 0 (colIndex - 1))
            "ArrowRight" ->
                SelectCell rowIndex (min (nrCols - 1) (colIndex + 1))
            "Backspace" ->
                SaveCell rowIndex colIndex XEmpty
            _ ->
                if String.length key == 1 && (isAlphanumeric (stringHead key |> Maybe.withDefault ' ') || key == "\"") then
                    EditCell rowIndex colIndex key
                else
                    NoOp
    ) keyDecoder shiftKeyDecoder


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
        NoOp  -- At the end of the spreadsheet, do nothing or wrap around based on your preference

moveToPreviousCell : Int -> Int -> Int -> Int -> Msg
moveToPreviousCell rowIndex colIndex nrRows nrCols =
    if colIndex > 0 then
        SelectCell rowIndex (colIndex - 1)
    else if rowIndex > 0 then
        SelectCell (rowIndex - 1) (nrCols - 1)
    else
        NoOp  -- At the beginning of the spreadsheet, do nothing or wrap around based on your preference


focusCommand : String -> Cmd Msg
focusCommand elementId =
    Dom.focus elementId
        |> Task.attempt FocusResult

focusA1 : Cmd Msg
focusA1 =
    focusCommand (getCellId 0 0) -- Focus on cell [0,0]

init : DatasetRef -> (Model, XModel, Cmd Msg)
init datasetRef =
    let
        xModel = XModel.myXModel
        model = initialModel xModel datasetRef

        initialFocusCmd = focusCommand (getCellId 0 0)  -- Focus on cell [0,0]
    in
    (model, xModel, initialFocusCmd)

-- Pivot table


formatAttrs : List (Element.Attribute msg)
formatAttrs =
        [ Element.width Element.shrink
        , Border.width 1 -- prende un div che con shrink è tutta la tabella
        , Border.color <| Element.rgb255 0 0 0
        , padding 3]


getCurrentSpreadsheetAndIndexFromView : Model -> XModel -> (Array2D XValue, Array2D (Int, Int))
getCurrentSpreadsheetAndIndexFromView model xModel = 
-- procedura che riflette viewPivotTable senza la parte di visualizzazione
-- usata in Main.elm nelle procedure di update per reshape DnDTray
    XView.generateSpreadsheetAndIndexFromView xModel.dims model.curDataset model.curDatasetView

-- main view function used by main
-- chatGpt refactoring, bagno di sangue
-- rispetto a MyPivotTable, nelle local functions ho dovuto cambiare i msg in Msg e i comparable in String
-- prende Tree di header text in ordine di livelli gerachici e restituisce "colonne" di Element Msg 

topLeftCorner : String -> Element msg
topLeftCorner gridAreaTopLeft =
    Element.paragraph
        [ htmlAttribute <| style "display" "inline-grid"
        , htmlAttribute <| style "grid-template-columns" "subgrid"
        , htmlAttribute <| style "grid-template-rows" "subgrid"
        -- per sticky partire da 1/1/-1/-1 e cambiare pos fino a cui si blocca + 1, qui y4
        , htmlAttribute <| style "grid-area" gridAreaTopLeft -- xStart/yStart/xEnd+1/yEnd+1 1-based
        , htmlAttribute <| style "position" "sticky"
        , htmlAttribute <| style "left" "0px"
        , htmlAttribute <| style "z-index" "3"
        , Background.color lightGray
        ]
        [text ""]

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
        , Border.color lightGray
        --, width (px 300) -- non fa un tubo
        ]
        -- Replace with actual data cells content
        dataCellsArg

-- creates headers using trayStrings, gets Array2D of seetData.data, iterates on i rows and j cols
-- and calls viewCellInPivot for each cell (that gets values from cellsUI)
-- gets getSpreadsheetDataForView from current model.dtaView
-- no data shaping here, only computes the headers' shapes
viewPivotTableFromSpreadsheetView :
    Model  -> XModel -> Element Msg
-- and generateSpreadsheetAndIndex in MyPivotTable.elm the shared logic into helper functions
-- and move it to MyPivotTable.elm modifyng the three functions
-- TO extract from function viewPivotTableFromSpreadsheet here and viewPivotTable
-- in order to use the newly created helper functions
viewPivotTableFromSpreadsheetView model xModel =
    let
        sheetData = XView.getSpreadsheetDataForView xModel.dims model.curDataset model.curDatasetView
        sheetArray2D = sheetData.data
        -- nr of flatIndices without dVar reference
        numRowsData = Array2D.rows sheetArray2D
        -- nr of dVars
        numColsData = Array2D.columns sheetArray2D

        pageTrayStrings = sheetData.pageTrayStrings
        rowTrayStrings = sheetData.rowTrayStrings
        colTrayStrings = sheetData.colTrayStrings

        -- Group the rows based on the rowGroupFields and convert them to a tree structure
        rowGroup : XModel.XTree Int String
        rowGroup =
            XView.trayGroup rowTrayStrings

        -- Group the rows based on the colGroupFields and convert them to a tree structure
        colGroup : XModel.XTree Int String
        colGroup =
            XView.trayGroup colTrayStrings

        -- Calculate the depth of the rowGroupFields and colGroupFields
        rowDepth : Int
        rowDepth = List.length rowTrayStrings

        colDepth : Int
        colDepth = List.length colTrayStrings

        -- Calculate the row indices sets for each level of the rowGroupFields


        -- Generate the row headers for the pivot table
        rowHeaders : List (Element Msg)
        rowHeaders = rowViewHeadersHelper rowGroup

        -- Helper function to generate the row headers for each level of the rowGroupFields
        rowViewHeadersHelper : XModel.XTree row String -> List (Element Msg)
        rowViewHeadersHelper grp =
            let
                -- Helper function to process each level of the rowGroupFields
                processLevel : Int -> List (String, XModel.XTree row String) -> List (Element Msg)
                processLevel i levelList =
                    List.indexedMap (\curRowIndex (c, subTree) ->
                        let
                            curDepth = i
                            curSpan = XModel.getWidth subTree
                            curOffset = List.take curRowIndex levelList |> List.map (\(_, sub) -> XModel.getWidth sub) |> List.sum
                        in
                        viewRowHeaderInPivot model curDepth curSpan curOffset rowDepth colDepth curRowIndex c
                    ) levelList
            in
            grp
                |> XModel.applyHorizontally identity
                |> List.indexedMap processLevel
                |> List.concat

        -- Generate the column headers for the pivot table
        colHeaders : List (Element Msg)
        colHeaders = colViewHeadersHelper colGroup

        -- Helper function to generate the column headers for each level of the colGroupFields
        colViewHeadersHelper : XModel.XTree row String -> List (Element Msg)
        colViewHeadersHelper grp =
            let
                -- Helper function to process each level of the colGroupFields
                processLevel : Int -> List (String, XModel.XTree row String) -> List (Element Msg)
                processLevel i levelList =
                    List.indexedMap (\curColIndex (c, subTree) ->
                        let
                            curDepth = i
                            curSpan = XModel.getWidth subTree
                            curOffset = List.take curColIndex levelList |> List.map (\(_, sub) -> XModel.getWidth sub) |> List.sum
                        in
                        viewColHeaderInPivot model curDepth curSpan curOffset rowDepth colDepth curColIndex c
                    ) levelList
            in
            grp
                |> XModel.applyHorizontally identity
                |> List.indexedMap processLevel
                |> List.concat

        -- Generate the data cells for the pivot table
        dataCells : List (Element Msg)
        dataCells = 
            List.concatMap (\i -> 
                List.map (\j -> 
                    viewCellInPivot model i j rowDepth colDepth) (List.range 0 (numColsData - 1))
            ) (List.range 0 (numRowsData - 1))

    in
    Element.el
        [ Element.scrollbarY, width fill, height fill ]
    -- row height and col width arre best set here at css grid level
    (Element.paragraph
        [ htmlAttribute <| style "display" "inline-grid"
        -- , htmlAttribute <| style "grid-template-areas" "'col-headers col-headers' 'row-headers data-cells'"
        , htmlAttribute <| style "grid-template-rows"    <| String.join " " <| List.repeat (colDepth + XModel.getWidth rowGroup) "auto"
        --, htmlAttribute <| style "grid-template-columns" (getColumnWidthsAuto (rowDepth + XModel.getWidth colGroup))
        , htmlAttribute <| style "grid-template-columns" (getColumnWidths  rowDepth model.columnWidths)
            -- <| String.join " " 
            -- <| List.repeat (rowDepth + XModel.getWidth colGroup) getColumWidthForGridPx --"auto"
        --, width fill
        , height fill
        --, Background.color MyColors.lightRed
        ]
        [ if xor (colDepth == 0) (rowDepth == 0) then 
            Element.none
        else
            topLeftCorner ("1/1/" ++ String.fromInt (colDepth + 1) ++ "/" ++ String.fromInt (rowDepth + 1))
        , if rowDepth > 0 then
            rowHeadersContainer rowHeaders ("1/1/-1/" ++ String.fromInt (rowDepth + 1))
        else 
            Element.none
        , if colDepth > 0 then 
            columnHeadersContainer colHeaders ("1/1/" ++ String.fromInt (colDepth + 1) ++ "/-1")
        else
            Element.none
        , dataCellsContainer dataCells
        ])

getColumnWidths : Int -> Array Int -> String
getColumnWidths nrHeaderColumns dataColumnWidths =
    let
        -- Create an array of "auto" for the header columns
        headerColumns =
            Array.repeat nrHeaderColumns "auto"

        -- Convert data column widths to strings with "px"
        dataColumns =
            Array.map (\width -> String.fromInt(width) ++ "px") dataColumnWidths

        -- Combine the two arrays
        combinedColumns =
            Array.append headerColumns dataColumns
    in
    -- Convert the array to a string
    Array.toList combinedColumns
        |> String.join " "

getColumnWidthsAuto : Int -> String
getColumnWidthsAuto nrColumns  =
    let
        -- Create an array of "auto" for the header columns
        headerColumns =
            Array.repeat nrColumns "auto"

    in
    -- Convert the array to a string
    Array.toList headerColumns
        |> String.join " "