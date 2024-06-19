# Multipage spreadsheet app
I want to upgrade the structure and UI of my spreadsheet app.
now the app:
 - runs a single XModel;
 - displays on a single web page an XView for a current Dataset mapped onto a SpreadsheetUI that provides the UI for displaying and modifying spreadsheet data, and pivoting on table dimensions supported by DnDTray;
 - for the current XView+Dataset displays a code editor with the formulas used to calculate computed values in the dataset

 I want to change it to a multi-page app that:
 - still runs a single XModel;
 - provides a home page displaying the model name and a navigation list of the Datasets in the XModel
 - clicking on a Dataset name, a new browser tab is opened and a page is loaded with the content and funcitonality of the current single page app for the selected Dataset

 Please guide me through the refactoring process, maybe starting from the models of the modules managing the different functionalities. Here they are:

 ## Main.elm
 type alias Model =
    { spreadsheetUIModel : SpreadsheetUI.Model
    , dndTrayModel : DnDTray.Model
    , calcModel : CalcEngine.Model
    , autoRecalc : Bool 
    , hints : List String 
    }

# SEE CHATGPT FOR RESPONSE

## CalcEngine.elm
type alias Model =
    { input : String -- code in the console
    , parsed : Maybe (Node Expression.Expression)
    , output : Result String String
    , countUpdates : Int
    , callTrees : List CallTree
    , logLines : List String
    , focus : Maybe CallTreeZipper
    -- added by Luca
    , env : Result Error Types.Env -- no longer contains XModel as a Value
    , pendingExpressions : List String
    , log : String
    }

## SpreadsheetUI.elm
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

## DnDTray.elm
 type alias Model =
    -- DnD
    { dnd : DnDList.Groups.Model
    , trayData : List TrayToken
    -- Dropdown
    , dropdownStates : Dict String (Dropdown.State Item)
    , dropdownOptions : Dict String (List String)
    , dropdownSelectedOptions : Dict String (Maybe Item)
    }

