module XView exposing (..)

import AppUtil
import Array exposing (Array)
import Array.Extra
import Array2D exposing (Array2D)
import DnDTray exposing ( TrayToken)
import FastDict as Dict exposing (Dict)
import List.Extra
import MyColors exposing (..)
import TypesXModel exposing (..)
import XModel
import XParser exposing (XValue(..))



-- DatasetView is a typoe used to support diplaying of a pivoted view on a dataset in a spreadsheet


type alias DatasetView =
    { name : String
    , datasetRef : String
    , pageTray : List ( DimVariant, CoordSpecifier ) -- uses dimVariant becau
    , rowTray : List ( DimVariant, CoordSpecifier ) -- all trays can be filtered
    , colTray : List ( DimVariant, CoordSpecifier )
    , errMsg : String
    }

-- data structure to hold data as XParser.XValue for rendering a spreadsheet view
-- for dimVariantRefs=>Coords use String for generality in importing models to avoid type errors (maybe)

type alias SpreadsheetViewData =
    { pageTrayCoords : List ( DimVariantRef, Array Coord ) -- dimRef, coords
    , rowTrayCoords : List ( DimVariantRef, Array Coord )
    , colTrayCoords : List ( DimVariantRef, Array Coord )
    , pageTrayIndices : List ( DimVariant, Array Index )
    , rowTrayIndices : List ( DimVariant, Array Index )
    , colTrayIndices : List ( DimVariant, Array Index )
    , data : Array2D ( XValue, Index, Index )
    }


type alias SpreadsheetUIData =
    { spreadsheet : Array2D XValue
    , spreadsheetIndex : Array2D ( Int, Int ) -- (flatIndex, dVarIndex) of cells in spreadsheet
    , numDataRows : Int
    , numDataCols : Int
    , rowHeaderDepth : Int
    , colHeaderDepth : Int
    , rowDimVariantRefs : List DimVariantRef
    , colDimVariantRefs : List DimVariantRef
    , headerTrees : { row : List HeaderTree, col : List HeaderTree }
    , trayData : List TrayToken
    }




-- default view for dataset in a xModel
-- PROVISIONAL assigns dVar to colTray and anno if presente, others to rowTray
-- dVar coords are filtered to defaultDataArrayRef


defaultDatasetView : XModel -> DatasetRef -> String -> DatasetView
defaultDatasetView xModel datasetRef name =
    let
        myDataset : Dataset
        myDataset =
            XModel.getDatasetByRef datasetRef xModel.datasets |> Maybe.withDefault XModel.emptyDataset

        ( annoRefList, filteredDimRefs ) =
            AppUtil.splitSelected myDataset.dimRefs "anno"

        defaultDataArrayRef =
            XModel.getDefaultDataArrayRef myDataset

        annoRef =
            List.map (\dimRef -> ( CategDimRef dimRef, CoordNone )) annoRefList

        hardCodedPageTray =
            [ ( DVarDimRef dVarIdentifier, SingleCoord "valore" ) ]

        hardCodedRowTray =
            [ ( CategDimRef "voce", CoordNone ), ( CategDimRef "azienda", CoordNone ) ]

        -- hardCodedColTray = [(CategDimRef "anno", CoordNone)]
    in
    { name = name
    , datasetRef = datasetRef
    , pageTray = []
    , rowTray = List.map (\dimRef -> ( CategDimRef dimRef, CoordNone )) filteredDimRefs
    , colTray =
        ( DVarDimRef dVarIdentifier, CoordNone )
            -- all dVar coords = data arrays
            --SingleCoord defaultDataArrayRef)
            :: annoRef

    --, colTray = hardCodedColTray -- annoRef ++ [(DVarDimRef XModel.dVarIdentifier, CoordNone)]
    , errMsg = ""
    }



-- updates trays in dataview
-- called at DnDTray events triggering reshape


updateDatasetViewTrays : Dims -> Dataset -> DatasetView -> List String -> List String -> List String -> DatasetView
updateDatasetViewTrays dims dataset datasetView pageTrayNames rowTrayNames colTrayNames =
    let
        pageTray =
            List.map
                (\dimName ->
                    -- default select first coord, waiting for combo box
                    let
                        curDimVariant =
                            XModel.dimVariantRefByDimName dataset dimName

                        curCoords =
                            XModel.dimVariantCoords dims dataset curDimVariant
                    in
                    ( curDimVariant
                    , SingleCoord (Maybe.withDefault "Missing coord" (Array.get 0 curCoords))
                    )
                )
                pageTrayNames

        rowTray =
            List.map
                (\dimName ->
                    ( XModel.dimVariantRefByDimName dataset dimName, CoordNone )
                )
                rowTrayNames

        colTray =
            List.map
                (\dimName ->
                    ( XModel.dimVariantRefByDimName dataset dimName, CoordNone )
                )
                colTrayNames

        -- update datasetView first trays then data
        updatedTrayDatasetView =
            { datasetView | pageTray = pageTray, rowTray = rowTray, colTray = colTray }
    in
    updatedTrayDatasetView


updateDropdownOption : String -> String -> DatasetView -> DatasetView
updateDropdownOption dropdownId option datasetView =
    let
        updateCoordSpecForDimVariant ( dimVariantRef, coordSpec ) =
            case dimVariantRef of
                CategDimRef dimRef ->
                    if dimRef == dropdownId then
                        ( CategDimRef dimRef, SingleCoord option )

                    else
                        -- leave as is
                        ( dimVariantRef, coordSpec )

                DVarDimRef dVarRef ->
                    if dVarRef == dropdownId then
                        ( DVarDimRef dVarRef, SingleCoord option )

                    else
                        -- leave as is
                        ( dimVariantRef, coordSpec )

        updatedPageTray =
            List.map updateCoordSpecForDimVariant datasetView.pageTray
    in
    -- loops on DimVariants in pageTray and updates the one with dropdownId
    -- Debug.log ("updateDropdownOption: " ++ Debug.toString updatedPageTray)  -- funziona
    { datasetView | pageTray = updatedPageTray }






-- specific function to get data to send for Spreadsheet creation


getSpreadsheetDataForView : Dims -> Dataset -> DatasetView -> SpreadsheetViewData
getSpreadsheetDataForView dims dataset datasetView =
    let
        datasetDimNames =
            -- iterating order of dims in dataset
            dataset.dimRefs

        datasetViewDimDVarNames =
            -- iterating order of DimVariants in view
            Tuple.first (List.unzip (pageTrayCoords ++ rowTrayCoords ++ colTrayCoords))

        datasetViewDimNames =
            -- filter dimRefs to exclude dVar and get iterating order of dims in view
            List.filter (\d -> d /= dVarIdentifier) datasetViewDimDVarNames

        -- metto view come original perché sono le dims della view a dover essere shuffled
        -- shufIdxs used to shuffle posVecs ordered as in view to get them in Dataset order
        shufIdxs =
            AppUtil.shuffledIndices datasetViewDimNames datasetDimNames

        ( pageTrayCoords, pageTrayIndices ) =
            getTrayCoordsIndices dims dataset datasetView.pageTray

        ( rowTrayCoords, rowTrayIndices ) =
            getTrayCoordsIndices dims dataset datasetView.rowTray

        ( colTrayCoords, colTrayIndices ) =
            getTrayCoordsIndices dims dataset datasetView.colTray

        ( pagePosVecs, pageDVarIndices ) =
            getPosVecDVarIndexForTray pageTrayIndices

        ( rowPosVecs, rowDVarIndices ) =
            getPosVecDVarIndexForTray rowTrayIndices

        ( colPosVecs, colDVarIndices ) =
            getPosVecDVarIndexForTray colTrayIndices

        nrDVars =
            List.length dataset.dataArrayRefs

        -- multiplies by DVar rowNr or colNr of rows or cols contain DVar
        -- pageTray unrelevant if contains DVar has only 1
        rowNrDVarMultiplier =
            if List.any (\dimVar -> XModel.isDVarDim dimVar) (Tuple.first (List.unzip rowTrayIndices)) then
                nrDVars

            else
                1

        colNrDVarMultiplier =
            if List.any (\dimVar -> XModel.isDVarDim dimVar) (Tuple.first (List.unzip colTrayIndices)) then
                nrDVars

            else
                1

        array2DnrRows =
            if Array.length rowPosVecs > 0 then
                Array.length rowPosVecs

            else
                rowNrDVarMultiplier

        array2DnrCols =
            if Array.length colPosVecs > 0 then
                Array.length colPosVecs

            else
                colNrDVarMultiplier

        strides =
            XModel.calculateStrides (XModel.shapeDim dims dataset.dimRefs)

        dataXValueArray2D : Array2D ( XValue, Index, Index )
        dataXValueArray2D =
            --Array2D.initialize  1 1 (\_ _ -> "")
            Array2D.initialize array2DnrRows
                array2DnrCols
                (\i j ->
                    let
                        clean curPosVec curIndexForDVar =
                            let
                                posVecArray =
                                    Array.fromList curPosVec

                                dVarIdx =
                                    Array.get curIndexForDVar posVecArray |> Maybe.withDefault -1

                                cleanedPosVec =
                                    Array.Extra.removeAt curIndexForDVar posVecArray
                                        |> Array.toList
                            in
                            ( cleanedPosVec, dVarIdx )

                        -- page refs don't change with row i and col j
                        posVecPage =
                            Array.get 0 pagePosVecs |> Maybe.withDefault []

                        dVarIndexPage =
                            Array.get 0 pageDVarIndices |> Maybe.withDefault -1

                        posVecRow =
                            Array.get i rowPosVecs |> Maybe.withDefault []

                        dVarIndexRow =
                            Array.get i rowDVarIndices |> Maybe.withDefault -1

                        posVecCol =
                            Array.get j colPosVecs |> Maybe.withDefault []

                        dVarIndexCol =
                            Array.get j colDVarIndices |> Maybe.withDefault -1

                        ( cleanedPosVecPage, pageDVarIndex ) =
                            clean posVecPage dVarIndexPage

                        ( cleanedPosVecRow, rowDVarIndex ) =
                            clean posVecRow dVarIndexRow

                        ( cleanedPosVecCol, colDVarIndex ) =
                            clean posVecCol dVarIndexCol

                        mergedPosVec =
                            cleanedPosVecPage ++ cleanedPosVecRow ++ cleanedPosVecCol

                        shuffledPosVec =
                            AppUtil.shuffleNumbersBy shufIdxs mergedPosVec

                        dVar =
                            List.maximum [ pageDVarIndex, rowDVarIndex, colDVarIndex ] |> Maybe.withDefault -1

                        mergedFlatIdx =
                            XModel.calcFlatIndexFast shuffledPosVec strides |> Maybe.withDefault -1

                        cellVal =
                            XModel.getXValueDatumFromDatasetForFlatIndexDVarIndex dataset mergedFlatIdx dVar
                    in
                    -- Debug.log ("cellVal: " ++ cellVal ++ " i,j: " ++ Debug.toString (i,j)
                    --     ++ " mergedPosVec: " ++ Debug.toString mergedPosVec
                    --     ++ " shuffledPosVec: " ++ Debug.toString shuffledPosVec
                    --     ++ " dVarIndexPage: " ++ Debug.toString dVarIndexPage
                    --     ++ " dVarIndexRow: " ++ Debug.toString dVarIndexRow
                    --     ++ " dVarIndexCol: " ++ Debug.toString dVarIndexCol
                    --     ++ " (pagePosVecs: " ++ Debug.toString pagePosVecs
                    --     ++ " (posVecPage, cleanedPosVecPage, pageDVarIndex): "
                    --         ++ Debug.toString (posVecPage, cleanedPosVecPage, pageDVarIndex)
                    --     ++ " (cleanedPosVecRow, rowDVarIndex): " ++ Debug.toString (cleanedPosVecRow, rowDVarIndex)
                    --     ++ " (posVecCol, cleanedPosVecCol, colDVarIndex): " ++ Debug.toString (posVecCol, cleanedPosVecCol, colDVarIndex)
                    --     ++ " dVar: " ++ Debug.toString dVar)
                    ( cellVal, mergedFlatIdx, dVar )
                )
    in
    -- Debug.log ("nrRows: " ++ Debug.toString array2DnrRows ++ " nrCols: " ++ Debug.toString array2DnrCols )
    -- -- Debug.log ("rowTrayIndices: " ++ Debug.toString rowTrayIndices)
    -- -- Debug.log ("colTrayIndices: " ++ Debug.toString colTrayIndices)
    -- Debug.log ("pagePosVecs: " ++ Debug.toString pagePosVecs)
    -- Debug.log ("pageDVarIndices: " ++ Debug.toString pageDVarIndices)
    -- Debug.log ("rowPosVecs: " ++ Debug.toString rowPosVecs)
    -- Debug.log ("rowDVarIndices: " ++ Debug.toString rowDVarIndices)
    -- Debug.log ("colPosVecs: " ++ Debug.toString colPosVecs)
    -- Debug.log ("colDVarIndices: " ++ Debug.toString colDVarIndices)
    -- Debug.log ("colTrayStrings: " ++ Debug.toString colTrayStrings)
    { pageTrayCoords = pageTrayCoords
    , pageTrayIndices = pageTrayIndices
    , rowTrayCoords = rowTrayCoords
    , rowTrayIndices = rowTrayIndices
    , colTrayCoords = colTrayCoords
    , colTrayIndices = colTrayIndices
    , data = dataXValueArray2D
    }



-- returns tuple of (list  of DimVariantRefs=>coords, list of DimVariantRefs=>indices)


getTrayCoordsIndices : Dims -> Dataset -> List ( DimVariant, CoordSpecifier ) 
    -> ( List ( DimVariantRef, Array Coord ), List ( DimVariant, Array Index ) )
getTrayCoordsIndices dims dataset tray =
    let
        processTrayItem : ( DimVariant, CoordSpecifier ) -> ( ( String, Array Coord ), ( DimVariant, Array Index ) )
        processTrayItem ( dimVarRef, locSpecifier ) =
            let
                dimVarCoords =
                    XModel.dimVariantCoords dims dataset dimVarRef

                --dimVarDict : Dict Coord Int
                dimVarDict =
                    XModel.coordDict dims dataset dimVarRef

                getCoordRangeString : ( Coord, Coord ) -> ( Array String, Array Index )
                getCoordRangeString ( startCoord, endCoord ) =
                    let
                        idxSpec =
                            XModel.convertSpecifier dims dataset dimVarRef (CoordRange ( startCoord, endCoord ))
                                |> Maybe.withDefault IndexNone

                        indicesRange =
                            XModel.expandIndexSpecifier dims dataset dimVarRef idxSpec

                        coordsRange =
                            Array.map (\idx -> Array.get idx dimVarCoords |> Maybe.withDefault "") indicesRange
                    in
                    ( coordsRange, indicesRange )

                dimName =
                    XModel.dimVariantName dimVarRef

                coordsIndices =
                    case locSpecifier of
                        SingleCoord coord ->
                            ( Array.fromList [ coord ], Array.repeat 1 (XModel.coordToIndex dimVarDict coord) )

                        CoordRange ( startCoord, endCoord ) ->
                            getCoordRangeString ( startCoord, endCoord )

                        -- retuns a tuple (Array String, Array Index)
                        CoordList coordsList ->
                            ( coordsList, Array.map (\crd -> XModel.coordToIndex dimVarDict crd) coordsList )

                        CoordNone ->
                            ( dimVarCoords, Array.fromList (List.range 0 (Array.length dimVarCoords - 1)) )
            in
            ( ( dimName, Tuple.first coordsIndices ), ( dimVarRef, Tuple.second coordsIndices ) )

        trayItems =
            List.map processTrayItem tray

        ( dimCoordsList, indicesList ) =
            List.unzip trayItems
    in
    ( dimCoordsList, indicesList )



-- gets  posVecs for the dims in the tray
-- posvecs not cleaned (= still including dVar) and index for dVar


getPosVecDVarIndexForTray :
    List ( DimVariant, Array Index )
    -> ( Array (List Index), Array Index )
getPosVecDVarIndexForTray trayIndices =
    if trayIndices == [] then
        ( Array.empty, Array.empty )

    else
        let
            dimVars =
                List.map Tuple.first trayIndices |> Array.fromList

            -- indices = List.map (Tuple.second >> Array.toList) trayIndices
            indices : List (Array Index)
            indices =
                List.map Tuple.second trayIndices

            indexForDVar =
                XModel.findDVarDimIndex dimVars |> Maybe.withDefault -1

            -- cleanedDims = List.filter (\dimVar -> not (isDVarDim dimVar)) dimVars
            posVecs : Array (List Index)
            posVecs =
                XModel.cartesianProductPosVecs (Just indices) |> Maybe.withDefault Array.empty

            -- remove from posVecs the item for the dVar
            --(posVecsCleaned, dVarIdxs) = cleanPosVecsAndDVar posVecs indexForDVar
            --posVecsShuffled = Array.map (DatasetUtil.shuffleNumbersBy shuffleIdxs) posVecsCleaned
            --flatIndices = calcFlatIndicesNoMaybeDim (Array.toList posVecsShuffled) datasetDims
            posVecslength =
                Array.length posVecs
        in
        ( posVecs, Array.repeat posVecslength indexForDVar )



-- generates the data for the spreadsheet as XParser.XValues from the dataset and the view
-- refactored using DatasetView data structure instead of Array2D Cell that is a Spreadsheet
-- maybe add an equivalent to Array2D data/text to DatasetView
-- the mapping from flat data to Array2D is already done here


-- returns a tuple of (Array2D XValue => view spreadsheet data, Array2D (Index, Index) => overlapped (flatIndex, dVarIndex) ) 
-- separates array2D data created in getSpreadsheetDataForView
generateSpreadsheetUIDataFromView : Dims -> Dataset -> DatasetView -> SpreadsheetUIData
generateSpreadsheetUIDataFromView dims dataset datasetView =
    let
        sheetData =
            getSpreadsheetDataForView dims dataset datasetView

        sheetArray2D =
            sheetData.data

        -- nr of flatIndices without dVar reference
        numRows =
            Array2D.rows sheetArray2D

        -- nr of dVars
        numCols =
            Array2D.columns sheetArray2D

        createCell ( i, j ) =
            let
                ( cellValue, flatIndex, dVarIndex ) =
                    Array2D.get i j sheetArray2D |> Maybe.withDefault ( XEmpty, -1, -1 )

                --cell = parseExtra cellValue
                cell =
                    cellValue
            in
            ( ( i, j ), cell, ( flatIndex, dVarIndex ) )

        emptyCell =
            XEmpty

        emptySpreadsheet =
            Array2D.initialize numRows numCols (\_ _ -> emptyCell)

        emptyIndex =
            Array2D.initialize numRows numCols (\_ _ -> ( -1, -1 ))

        -- caledd by foldl to accumulate cell values and flatIndexExt in the repsective Array2D
        foldFunc ( ( i, j ), cell, ( flatIndex, dVarIndex ) ) ( accSpreadsheet, accIndex ) =
            ( Array2D.set i j cell accSpreadsheet
              -- accSpreadsheet starts from emptySpreadsheet
            , Array2D.set i j ( flatIndex, dVarIndex ) accIndex
              -- accIndex starts from emptyIndex
            )

        indicesRowMajor =
            List.range 0 (numRows - 1)
                |> List.concatMap (\i -> List.range 0 (numCols - 1) |> List.map (\j -> ( i, j )))

        cellsList =
            List.map createCell indicesRowMajor

        ( retSpreadsheet, retIndex ) =
            List.foldl foldFunc ( emptySpreadsheet, emptyIndex ) cellsList
    in
    { spreadsheet = retSpreadsheet
    , spreadsheetIndex = retIndex
    , numDataRows = numRows
    , numDataCols = numCols
    , rowHeaderDepth = List.length sheetData.rowTrayCoords
    , colHeaderDepth = List.length sheetData.colTrayCoords
    , rowDimVariantRefs = List.map Tuple.first sheetData.rowTrayCoords
    , colDimVariantRefs = List.map Tuple.first sheetData.colTrayCoords
    , headerTrees = { row = trayGroup sheetData.rowTrayCoords, col = trayGroup sheetData.colTrayCoords }
    , trayData = createTrayData sheetData
    }


-- DEPRECATED after refactoring to use HeaderTree
--The XTree used Int as the value type for leaves because, in the broader context of your application,
-- these leaves are intended to hold integer indices corresponding to data positions in your multidimensional dataset.
-- Even though the current implementation of groupTrayStrings creates empty leaves (Leaf []),
-- the tree structure is designed to accommodate integer values at the leaves,
--  which can be populated later in the data processing pipeline.


trayGroup : List (DimVariantRef, Array Coord) -> List HeaderTree
trayGroup trayCoords =
    let
        ret = groupTrayCoords trayCoords
    in
    --Debug.log ("trayGroup: " ++ Debug.toString ret ++ "|||||||") <| 
    ret


groupTrayCoords : List (DimVariantRef, Array Coord) -> List HeaderTree
groupTrayCoords trayCoords =
    let
        -- Recursive function to build the tree for all dimensions
        buildTree : List (DimVariantRef, Array Coord) -> List HeaderTree
        buildTree dims =
            case dims of
                [] ->
                    -- No more dimensions to process
                    []

                [(dimVariantRef, coords)] ->
                    -- Base case: The last dimension creates HeaderLeaf nodes
                    Array.toList coords
                        |> List.map (\coord -> HeaderLeaf (dimVariantRef, coord))

                (dimVariantRef, coords) :: rest ->
                    -- Recursive case: Create HeaderNodes for this dimension
                    let
                        -- Generate subtrees for the remaining dimensions
                        subTreesForRest =
                            buildTree rest

                        -- Create a HeaderNode for each coordinate in the current dimension
                        nodesForCurrentDim =
                            Array.toList coords
                                |> List.map (\coord -> HeaderNode (dimVariantRef, coord) subTreesForRest)
                    in
                    nodesForCurrentDim
    in
    -- Start building the tree from the top-level dimensions
    buildTree trayCoords











-- helper to return dim names and coords as strings to Spreadsheet
-- overridden by getTrayCoordsIndices


getTrayCoords : Dims -> Dataset -> List ( DimVariant, CoordSpecifier ) -> List ( DimVariantRef, Array Coord )
getTrayCoords dims dataset tray =
    List.map
        (\( dimVar, locSpecifier ) ->
            let
                dimVarCoords =
                    XModel.dimVariantCoords dims dataset dimVar

                getCoordRangeString : ( Coord, Coord ) -> Array String
                getCoordRangeString ( startCoord, endCoord ) =
                    let
                        idxSpec =
                            XModel.convertSpecifier dims dataset dimVar (CoordRange ( startCoord, endCoord ))
                                |> Maybe.withDefault IndexNone

                        indices =
                            XModel.expandIndexSpecifier dims dataset dimVar idxSpec

                        coordsRange =
                            Array.map (\idx -> Array.get idx dimVarCoords |> Maybe.withDefault "") indices
                    in
                    coordsRange

                dimName =
                    XModel.dimVariantName dimVar

                coords =
                    case locSpecifier of
                        SingleCoord coord ->
                            Array.fromList [ coord ]

                        CoordRange ( startCoord, endCoord ) ->
                            getCoordRangeString ( startCoord, endCoord )

                        CoordList coordsList ->
                            coordsList

                        CoordNone ->
                            dimVarCoords
            in
            ( dimName, coords )
        )
        tray



-- check completeness and correctness of the dataset view


checkDatasetView : Dims -> Dataset -> DatasetView -> Result String ()
checkDatasetView dims dataset datasetView =
    let
        -- disabled for now, maybe DnD adds dim before dop and creates duplicate or logic is wrong
        checkTrays =
            checkTraysContainAllDims dataset datasetView

        checkCoords =
            checkCoordsInTrays dims dataset datasetView

        checkPageTray =
            checkPageTrayForSingleCoord datasetView
    in
    case ( checkTrays, checkCoords, checkPageTray ) of
        ( Ok (), Ok (), Ok () ) ->
            Ok ()

        ( Err msg, _, _ ) ->
            Err msg

        ( _, Err msg, _ ) ->
            Err msg

        ( _, _, Err msg ) ->
            Err msg



-- Function to check if all trays combined contain all dims from the dataset without duplications
-- disable, maybe DnD adds dim before dop and creates duplicate or logic is wrong


checkTraysContainAllDims : Dataset -> DatasetView -> Result String ()
checkTraysContainAllDims dataset datasetView =
    let
        -- Extract dims from trays
        trayDims =
            List.concat [ List.map Tuple.first datasetView.pageTray, List.map Tuple.first datasetView.rowTray, List.map Tuple.first datasetView.colTray ]

        -- Check for duplications
        noDuplicates =
            List.length trayDims == List.length (List.Extra.unique trayDims)

        -- Check if all dataset dims are covered
        allDimVariants : List DimVariant
        allDimVariants =
            List.map CategDimRef dataset.dimRefs ++ [ DVarDimRef dVarIdentifier ]

        allDimsCovered =
            List.all (\dim -> List.member dim allDimVariants) trayDims
    in
    case ( noDuplicates, allDimsCovered ) of
        ( True, True ) ->
            Ok ()

        ( False, _ ) ->
            Err "Duplicate dims in trays"

        ( _, False ) ->
            Err "Not all dataset dims are covered in trays"


checkCoordsInTrays : Dims -> Dataset -> DatasetView -> Result String ()
checkCoordsInTrays dims dataset datasetView =
    let
        -- called by checkTray
        checkCoordsInDim : DimVariant -> CoordSpecifier -> Result String ()
        checkCoordsInDim dimVar coordSpecifier =
            let
                dimVarCoords =
                    XModel.dimVariantCoords dims dataset dimVar

                dimVarName =
                    XModel.dimVariantName dimVar
            in
            case coordSpecifier of
                SingleCoord coord ->
                    if Array.Extra.member coord dimVarCoords then
                        Ok ()

                    else
                        Err ("Missing coord " ++ coord ++ " in dim " ++ dimVarName)

                CoordRange ( startCoord, endCoord ) ->
                    if Array.Extra.member startCoord dimVarCoords && Array.Extra.member endCoord dimVarCoords then
                        Ok ()

                    else
                        Err ("Missing coord range " ++ startCoord ++ "-" ++ endCoord ++ " in dim " ++ dimVarName)

                CoordList coords ->
                    if Array.Extra.all (\coord -> Array.Extra.member coord dimVarCoords) coords then
                        Ok ()

                    else
                        Err ("Missing coords in " ++ dimVarName)

                CoordNone ->
                    Ok ()

        checkTray : List ( DimVariant, CoordSpecifier ) -> Result String ()
        checkTray tray =
            List.foldl
                (\( dimVar, spec ) acc ->
                    case acc of
                        Err msg ->
                            Err msg

                        Ok () ->
                            if spec == CoordNone then
                                Ok ()

                            else
                                checkCoordsInDim dimVar spec
                )
                (Ok ())
                tray

        allTrays =
            datasetView.pageTray ++ datasetView.rowTray ++ datasetView.colTray
    in
    checkTray allTrays


checkPageTrayForSingleCoord : DatasetView -> Result String ()
checkPageTrayForSingleCoord datasetView =
    List.foldr
        (\( dimVariant, specifier ) acc ->
            case acc of
                Err msg ->
                    Err msg

                Ok () ->
                    case specifier of
                        SingleCoord _ ->
                            Ok ()

                        _ ->
                            Err ("More than one coord set in pageTray for dim " ++ XModel.dimVariantName dimVariant)
        )
        (Ok ())
        datasetView.pageTray



-- gestione TrayTokens used in DnD


createTrayToken : Tray -> String -> Array String -> Int -> Int -> TrayToken
createTrayToken tray name items iterOrder width =
    TrayToken tray
        name
        items
        (if name == "footer" then
            myTransparent

         else
            lightGray
        )
        iterOrder
        width


createTrayData : SpreadsheetViewData -> List TrayToken
createTrayData sheetData =
    let
        rowFields =
            sheetData.rowTrayCoords

        -- List of tuples (dimName, Array String) coords
        colFields =
            sheetData.colTrayCoords

        rowWidths =
            List.map (\_ -> 40) rowFields

        colWidths =
            List.map (\_ -> 40) colFields

        rowTrayTokens =
            indexedMap2
                (\idx tupleRow width ->
                    createTrayToken RowTray (Tuple.first tupleRow) (Tuple.second tupleRow) idx width
                )
                rowFields
                rowWidths

        colTrayTokens =
            indexedMap2
                (\idx tupleCol width ->
                    createTrayToken ColumnTray (Tuple.first tupleCol) (Tuple.second tupleCol) (idx + List.length rowFields) width
                )
                colFields
                colWidths
    in
    [ -- createTrayToken Page "placeholder" 999 -1, tolto sdballava check
      createTrayToken PageTray "footer" Array.empty -1 -1
    ]
        ++ rowTrayTokens
        ++ [ createTrayToken RowTray "footer" Array.empty -1 -1 ]
        ++ colTrayTokens
        ++ [ createTrayToken ColumnTray "footer" Array.empty -1 -1 ]


defaultTrayData : Dims -> Dataset -> DatasetView -> List TrayToken
defaultTrayData dims dataset datasetView =
    let
        sheetData =
            getSpreadsheetDataForView dims dataset datasetView
    in
    createTrayData sheetData



-- replication of List.indexedMap2 for visibility by interpreter


indexedMap2 : (Int -> a -> b -> result) -> List a -> List b -> List result
indexedMap2 f list1 list2 =
    indexedMap2Help f list1 list2 0


indexedMap2Help : (Int -> a -> b -> result) -> List a -> List b -> Int -> List result
indexedMap2Help f list1 list2 index =
    case ( list1, list2 ) of
        ( x :: xs, y :: ys ) ->
            f index x y :: indexedMap2Help f xs ys (index + 1)

        _ ->
            []
renameDimRefInView : String -> String -> DatasetView -> DatasetView
renameDimRefInView oldName newName datasetView =
    let
        renameDimRefInTray : String -> List ( DimVariant, CoordSpecifier ) -> List ( DimVariant, CoordSpecifier )
        renameDimRefInTray oldNameArg tray =
            List.map
                (\( dimVar, coord ) -> -- rename only if dimVar is a CategDimRef
                    case dimVar of
                        CategDimRef dimRef ->
                            if dimRef == oldNameArg then
                                ( CategDimRef newName, coord )

                            else
                                ( dimVar, coord )
                        DVarDimRef _ ->
                            ( dimVar, coord )
                )
                tray

        pageTray =
            renameDimRefInTray oldName datasetView.pageTray

        rowTray =
            renameDimRefInTray oldName datasetView.rowTray

        colTray =
            renameDimRefInTray oldName datasetView.colTray
    in
    { datasetView | pageTray = pageTray, rowTray = rowTray, colTray = colTray }

-- provisional adds only at the end of the tray
addDimRefInView : String -> Tray -> DatasetView -> DatasetView
addDimRefInView dimRef tray datasetView =
    let
        addedDimSpec =
                    [ ( CategDimRef dimRef, CoordNone ) ]
    in
    { datasetView 
        | pageTray = datasetView.pageTray
        , rowTray = datasetView.rowTray ++ (if tray == RowTray then addedDimSpec else [])
        , colTray = datasetView.colTray ++ (if tray == ColumnTray then addedDimSpec else [])
    }

removeDimRefInView : String -> DatasetView -> DatasetView
removeDimRefInView dimRef datasetView =
    let
        deleteDimRefInTray : String -> List ( DimVariant, CoordSpecifier ) -> List ( DimVariant, CoordSpecifier )
        deleteDimRefInTray dimRefArg tray =
            List.filter
                (\( dimVar, _ ) ->
                    case dimVar of
                        CategDimRef dimRefJust ->
                            dimRefJust /= dimRefArg

                        DVarDimRef _ ->
                            True
                )
                tray

        pageTray =
            deleteDimRefInTray dimRef datasetView.pageTray

        rowTray =
            deleteDimRefInTray dimRef datasetView.rowTray

        colTray =
            deleteDimRefInTray dimRef datasetView.colTray
    in
    { datasetView | pageTray = pageTray, rowTray = rowTray, colTray = colTray }