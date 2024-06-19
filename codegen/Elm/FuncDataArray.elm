module FuncDataArray exposing (..)

-- copied to /codegen to have Value manipulation functions used in elm-interpreter
-- self-sufficient module with code extracted from XModel
-- twin module in /src to compile check code
-- added dummy aliases to make JsArray  seen there
import Array exposing (Array)
import Array.Extra
import Types exposing (Value(..))
import FastDict as Dict exposing (Dict) 

-- ADDED CODE FOR COMPILED VERSION HERE



-- TODO to produce interprter code
-- * remove ADDED CODE FOR COMPILED VERSION HERE above
-- * substitute JsArray. with JsArray. in the code below




-- INTERPRETER CODE
type alias DimRef = String

type alias Coord = String
type alias CoordVec = List Coord
type alias DatasetRef = String

type alias DataArrayRef = String
-- to avoid Variant type, we use a record with both number and text
-- text may be used for numbers as well, for example to hold formatted numbers
-- for string values, text should be the only field used

-- type alias Dims = Dict DimRef (JsArray Coord) -- compiler version
-- changed to marshal Dims as a list of tuples instead of a Dict
-- Dict is not supported in Elm interpreter
type alias Dims = List (DimRef, (JsArray Coord))

type alias DimsDict = Dict DimRef (Array Coord)

type IndexSpecifier
    = SingleIndex CoordIndex -- single coord index
    | IndexRange (CoordIndex, CoordIndex) -- contiguous range of coord indices
    | IndexArray (Array CoordIndex) -- sparse list of coord indices
    | IndexNone -- no filter, all coord indices

type CoordSpecifier
    = SingleCoord Coord -- single coord
    | CoordRange (Coord, Coord) -- contiguous range of coords
    | CoordArray (Array Coord) -- sparse list of coords
    | CoordNone -- no filter, all coords

type alias FlatIndex = Int
type alias Stride = Int
type alias Size = Int

-- NB here localDims is a List not a Dict, both  localDims and localDimRefs are not Maybe => Nothing is converted into empty List
type alias DataArray = 
    { ref : DataArrayRef -- name
    , datasetRef : Maybe DatasetRef -- name of the container dataset
    , data : JsArray Float
    , text : JsArray String
    , localDims : Dims -- local dims for the DataArray as a List of tuples [ (DimRef, JsArray Coord)]
    , localDimRefs : (List DimRef) -- local dimRefs for the DataArray
    }
type alias CoordIndex = Int

type alias CoordDict = Dict Coord CoordIndex

type alias PosVec = List CoordIndex

-- coords are in List to avoid mismatch between Array and JsArray
dimsToDict : Dims -> DimsDict
dimsToDict dims = 
    List.foldl (\(dimRef, coordArray) accDict -> Dict.insert dimRef coordArray accDict) Dict.empty dims

dimsToList : DimsDict -> Dims 
dimsToList dimsDict =
    let
        dimList = Dict.toList <| Dict.map (\_ coords -> coords ) dimsDict            
    in
    dimList

emptyDataArray : DataArray
emptyDataArray = { 
                 ref = ""
                 , datasetRef = Nothing
                 , data = JsArray.empty
                 , text = JsArray.empty
                 , localDims = []
                 , localDimRefs = []}

isDataArrayText : DataArray -> Bool
isDataArrayText dataArray =
     (dataArray.data == JsArray.empty) && not (dataArray.text == JsArray.empty)

isDataArrayData : DataArray -> Bool
isDataArrayData dataArray =
    not (dataArray.data == JsArray.empty) && (dataArray.text == JsArray.empty)

isDataArrayMixed : DataArray -> Bool
isDataArrayMixed dataArray =
    not (dataArray.data == JsArray.empty) && not (dataArray.text == JsArray.empty)

isDataArrayEmpty : DataArray -> Bool
isDataArrayEmpty dataArray =
    (dataArray.data == JsArray.empty) && (dataArray.text == JsArray.empty)


-- FUNCTIONS FOR DATAARRAY
-- NB when executed by interpreter, these functions are not type-checked as they are in compiled Elm code
-- interpreter expects all args to be a Value of any type (but Value types cannot be pattern-matched in the interpreter!!)
-- =>  native DataArray type are not visible to the interpreter, but also to rely on Value.Record!
-- maybe it's better to use DataArray explicitly to make the funcs here simpler and more readable => GONE FOR THIS

-- NB interpreter funcs are better coded here so that they can be used in compiled Elm code as well
-- and code completion and type-checkong is supported

-- autoconversion from DataArray to Value.Record
-- but local functions expect JSArray, not Array
-- JsArray funcs defined in Kernel/JsArray.elm, JsArray is a native Elm type behind Array

type alias UnaryFuncFloat = Float -> Float
type alias AggrUnaryFuncFloat = Array Float -> Float 

type alias BinaryFuncFloat = Float -> Float -> Float
type alias AggrBinaryFuncFloat = Array Float -> Array Float -> Float 

arSum : AggrUnaryFuncFloat
arSum floatArray = JsArray.foldl (+) 0 floatArray

keepNotNaN : BinaryFuncFloat
keepNotNaN val1 val2 = if isNaN val1  then val2 else val1

-- hard coded, only for test
taxMultiplier : UnaryFuncFloat
taxMultiplier val = val * 0.2

arPairSumProduct : AggrBinaryFuncFloat
arPairSumProduct floatArray1 floatArray2 = 
    let
        floatArray = Array.Extra.map2 (*) floatArray1 floatArray2
    in
    
    JsArray.foldl (+) 0 floatArray


funcDataArrayUnaryAr : Result String DataArray -> UnaryFuncFloat 
    -> Result String DataArray
funcDataArrayUnaryAr arSrc unaryFunc = 
    case arSrc of
        Ok arJust  -> --pattern matching su Value type `Record arJust` non funziona nell'interpreter
            let
                calcData = JsArray.map unaryFunc arJust.data
                -- calcData = Array.map unaryFunc (jsArrayToArray arJust.data)
            in
            Ok ( { arJust | data = calcData } )
            -- Ok ( { arJust | data = (arrayToJsArray calcData) } )
               
        Err err -> Err (err ++ " catched in funcDataArrayUnaryAr")


-- used in elm-interpreter 
aggrDataArrayUnaryAr : Result String DataArray -> AggrUnaryFuncFloat -> List DimRef -> DataArrayRef
    -> Result String DataArray
aggrDataArrayUnaryAr arSrc aggrFunc aggrDimRefs dataArrayRef = 
    case arSrc of
        Ok arJust -> 
            let
                (srcDimRefs , srcDimsAsList) = (arJust.localDimRefs, arJust.localDims)
                srcDims = dimsToDict srcDimsAsList
            in
            case (srcDims,  srcDimRefs) of
                ( srcDimsJust,  srcDimRefsJust) ->
                    if List.all (\aggrDimRef -> List.member aggrDimRef srcDimRefsJust) aggrDimRefs then
                        let
                            keptDimRefs = List.filter (\dimRef -> not (List.member dimRef aggrDimRefs)) srcDimRefsJust
                            -- error here on Dict.foldl called by Dict.filter
                            keptDimsDict = Dict.filter (\key _ -> List.member key keptDimRefs) srcDimsJust
                            aggrData = Array.map (\coordVec -> 
                                let
                                    coordSpecifiers = List.map2 (\ dimRef coord -> toSingleCoordAr dimRef coord) keptDimRefs coordVec

                                    coordVecDAr = locAr arJust coordSpecifiers |> Maybe.withDefault emptyDataArray
                                    floatArray = coordVecDAr.data
                                in
                                aggrFunc floatArray
                                ) (itemCoordVecsForDims keptDimsDict keptDimRefs)
                        in
                        -- Debug.log ("returning aggrDataArrayUnaryAr ")
                        Ok { arJust | ref = dataArrayRef, data = arrayToJsArray aggrData, localDims = dimsToList keptDimsDict, localDimRefs = keptDimRefs} 
                    else
                        Err ("aggrDimRefs not in srcDimRefs" ++ Debug.toString (srcDims,  srcDimRefs))

        Err err -> Err (err ++ " catched in aggrDataArrayUnaryAr")


-- applies a binary function to the two DataArrays data, assuming DataArrays are passed with localDims
-- if dims are different, matches the data by coords onto arDest .data
-- returns Result DataArray
funcDataArrayPairAr : Result String DataArray -> Result String DataArray  -> BinaryFuncFloat -> Result String DataArray
funcDataArrayPairAr arSrc arDest binaryFunc = 
    case (arSrc, arDest) of
        (Ok arSrcOk, Ok arDestOk) ->
            let 
                (dimRefsSrc , dimsSrc) = (arSrcOk.localDimRefs, dimsToDict arSrcOk.localDims)
                (dimRefsDest , dimsDest) = (arDestOk.localDimRefs, dimsToDict arDestOk.localDims)
                pivotRef = pivotDimRefForDims dimsSrc dimsDest
                arSrcDataAsArray = jsArrayToArray arSrcOk.data
                arDestDataAsArray = jsArrayToArray arDestOk.data
                arSrcdata = 
                    -- brute force map calc on the whole data arrays with the same localDims
                    -- with single coord array mapping does not work
                    if dimsSrc == dimsDest
                        && dimRefsSrc == dimRefsDest
                        && (Array.length arSrcDataAsArray) == (Array.length arDestDataAsArray) then
                            arSrcDataAsArray
                    -- if same dims except one with one coord, data are parallel and can be passed as is
                    else if pivotRef /= Nothing then
                            arSrcDataAsArray
                    else
                    -- map the data of the source DataArray to the destination DataArray by dim/coords
                    -- TODO to be re-checked
                        let
                            mappedIndices = mapFlatIndices arSrcOk arDestOk -- mapping needs localDims
                        in
                        Array.map (\flIdx -> Array.get flIdx arSrcDataAsArray |> Maybe.withDefault (0/0) ) mappedIndices   
                calcData = List.map2 binaryFunc (Array.toList arSrcdata) (Array.toList arDestDataAsArray )  |> Array.fromList            
            in
            Ok { arDestOk | data = arrayToJsArray calcData } -- keeps dims and dimRefs, but changes data as calculated
            --arSrc
        _ -> Err "Error in funcDataArrayPairAr"


-- updates the data of arWhole DataArray with the data of the arPart DataArray using the binaryFunc to choose or calc the resulting data
updateDataArrayPairAr : Result String DataArray -> Result String DataArray  -> BinaryFuncFloat -> Result String DataArray
updateDataArrayPairAr arWhole arPart binaryFunc = 
    case (arWhole, arPart) of
        (Ok arWholeOk, Ok arPartOk) ->
            let
                (wholeDimRefs , dimsWhole) = (arWholeOk.localDimRefs, dimsToDict arWholeOk.localDims)
                (partDimRefs , dimsPart) = (arPartOk.localDimRefs, dimsToDict arPartOk.localDims)
                arWholeDataAsArray = jsArrayToArray arWholeOk.data
                arPartDataAsArray = jsArrayToArray arPartOk.data
                arWholedataTuples = 
                        -- brute force map calc on the whole data arrays with the same localDims
                        if dimsWhole == dimsPart && (Array.length arWholeDataAsArray) == (Array.length arPartDataAsArray) then
                            let 
                                indexArray = Array.fromList (List.range 0 (Array.length arWholeDataAsArray)) 
                                dataTuples = zipAr arWholeDataAsArray arPartDataAsArray

                            in
                            zipAr indexArray dataTuples
                        else
                        -- get indices in whole DataArray for each coord in part DataArray and calc the data
                            let
                                mappedIndices = mapFlatIndices arWholeOk arPartOk    
                                extractedWholeDataTuples = List.map2 (\ wholeFlIdx partDatum -> 
                                    (wholeFlIdx 
                                    ,  ( (Array.get wholeFlIdx arWholeDataAsArray) |> Maybe.withDefault (0/0)
                                    , partDatum) )
                                        ) (Array.toList mappedIndices) (Array.toList arPartDataAsArray)
                                        |> Array.fromList
                            in
                            extractedWholeDataTuples
                updatatedWholeData = Array.foldl (\(flIdx, (valWhole, valPart)) dataWhole ->
                    let
                        valCalc = binaryFunc valPart valWhole -- if valPart is NaN, valWhole is kept
                    in
                    Array.set flIdx valCalc dataWhole
                    ) arWholeDataAsArray arWholedataTuples
            in
            Ok { arWholeOk | data = arrayToJsArray updatatedWholeData } -- keeps dims and dimRefs, but changes data as calculated
        _  -> 
                -- Debug.log ("arWhole: " ++ Debug.toString(arWhole))
                -- Debug.log ("\narPart: " ++ Debug.toString(arPart))
            Err "Error in updateDataArrayPair >= WRONG (Ok arWholeOk, Ok arPartOk)"

-- from Alignment.elm
-- here single ar is passed containing both coords, subArs created in the function
calcArForSingleCoordFromTwoCoords : DataArray -> DimRef -> Coord -> Coord -> Coord -> BinaryFuncFloat 
    -> Result String DataArray
calcArForSingleCoordFromTwoCoords ar dimRef coordCalc coordInput1 coordInput2 binaryFunc = 
    let
        input1Ar = locAr ar [ toSingleCoordAr dimRef coordInput1] |> Maybe.withDefault emptyDataArray 
        input2Ar = locAr ar [ toSingleCoordAr dimRef coordInput2] |> Maybe.withDefault emptyDataArray 
        -- skip check pivotDimRef, dimRef should match by construction 
        calcAr = funcDataArrayPairAr (Ok input1Ar) (Ok input2Ar) binaryFunc |> Result.withDefault emptyDataArray
        calcDimsRaw = dimsToDict calcAr.localDims
        calcDims = Dict.insert dimRef (Array.fromList [coordCalc]) calcDimsRaw
        calcArRet = { calcAr | localDims = dimsToList calcDims }
        -- calcArRet = calcAr
    in 
    -- raw check TODO improve
    if JsArray.length input1Ar.data ==  JsArray.length calcArRet.data then
        Ok calcArRet
    else    
        Err "Error in calcArForSingleCoordFromTwoCoords"

-- same as calcArForSingleCoordFromTwoCoords, but tow ars for the coords are passed
-- NB here inputArs are passed as Result, not DataArray
calcArForSingleCoordFromTwoArs : DimRef -> Coord -> Result String DataArray -> Result String DataArray -> BinaryFuncFloat 
    -> Result String DataArray
calcArForSingleCoordFromTwoArs dimRef coordCalc input1ArRes input2ArRes binaryFunc = 
    let
        input1Ar = input1ArRes |> Result.withDefault emptyDataArray
        calcAr = funcDataArrayPairAr input1ArRes input2ArRes binaryFunc |> Result.withDefault emptyDataArray
        calcDimsRaw = dimsToDict calcAr.localDims
        calcDims = Dict.insert dimRef (Array.fromList [coordCalc] |> arrayToJsArray ) calcDimsRaw
        calcArRet = { calcAr | localDims = dimsToList calcDims }
    in 
    if JsArray.length input1Ar.data ==  JsArray.length calcArRet.data then
        Ok calcArRet
    else    
        Err "Error in calcArForSingleCoordFromTwoArs"    

-- same for unary functions
calcArForSingleCoordFromOneAr : DimRef -> Coord -> Result String DataArray -> UnaryFuncFloat
    -> Result String DataArray
calcArForSingleCoordFromOneAr dimRef coordCalc input1ArRes unaryFunc = 
    let
        input1Ar = input1ArRes |> Result.withDefault emptyDataArray
        calcAr = funcDataArrayUnaryAr input1ArRes unaryFunc |> Result.withDefault emptyDataArray
        calcDimsRaw = dimsToDict calcAr.localDims
        calcDims = Dict.insert dimRef (Array.fromList [coordCalc] |> arrayToJsArray ) calcDimsRaw
        calcArRet = { calcAr | localDims = dimsToList calcDims }
    in 
    if JsArray.length input1Ar.data ==  JsArray.length calcArRet.data then
        Ok calcArRet
    else    
        Err "Error in calcArForSingleCoordFromOneArs"    

-- utility function to create ars for single coords
inputArForSingleCoord : Result String DataArray -> DimRef -> Coord 
    -> Result String DataArray
inputArForSingleCoord ar dimRef coord = 
    case ar of
        Ok arOk -> 
            let
                inputAr = locAr arOk [ toSingleCoordAr dimRef coord] 
            in
            case inputAr of 
                Just arJust -> Ok arJust
                Nothing -> Err "Error in applying locAr to input DataArray"
        _ -> Err "Error in getting input DataArray"

-- returns a new DataArray with the data shifted by the given stride along the given dimension
shiftDataArray : Result String DataArray -> DimRef -> Int -> Result String DataArray
shiftDataArray ar dimRef step = 
    case ar of
        Ok arOk -> 
            let
                (dims, dimRefs) = (dimsToDict arOk.localDims, arOk.localDimRefs)
                dimIndex = Maybe.withDefault -1 (elemIndex dimRef (Array.fromList dimRefs) )
                posVecs = itemPosVecsForDims dims dimRefs
                shiftedPosVecs = Array.map (\posVec -> 
                        let
                            pos = Maybe.withDefault -1 (getAt dimIndex posVec)
                            shiftedPos = if pos == -1 then -1 else pos + step
                        in
                        setAt dimIndex shiftedPos posVec
                    ) posVecs
                shiftedIndices = calcFlatIndicesFast dims dimRefs shiftedPosVecs
                shiftedData = 
                    Array.map (\flIdx -> Array.get flIdx (jsArrayToArray arOk.data) |> Maybe.withDefault (0/0) ) shiftedIndices 
            in
            Ok { arOk | data = (arrayToJsArray shiftedData) }
        _ -> Err "Error in shiftDataArray"

--- uses of shiftDataArray

-- shifted array has same dims so no need to use funcDataArrayPairWithLocalDims, map2 on .data instead
diffDataArray : Result String DataArray -> DimRef -> Result String DataArray
diffDataArray ar dimRef = 
    case ar of
        Ok arOk -> 
            let
                shiftedAr = shiftDataArray ar dimRef -1
                diffArData = case shiftedAr of
                    Ok shiftedArOk -> 
                        List.map2 (\valPrev valThis -> valThis - valPrev) 
                            (jsArrayToArray shiftedArOk.data |> Array.toList)  
                            (jsArrayToArray arOk.data |> Array.toList)
                            |> Array.fromList
                    _ -> Array.empty
            in
            Ok { arOk | data = (arrayToJsArray diffArData) }
        _ -> Err "Error in diffDataArray"

pctChangeDataArray : Result String DataArray -> DimRef -> Result String DataArray
pctChangeDataArray ar dimRef = 
    case ar of
        Ok arOk -> 
            let
                shiftedAr = shiftDataArray ar dimRef -1
                diffArData = case shiftedAr of
                    Ok shiftedArOk -> 
                        List.map2 (\valPrev valThis -> valThis / valPrev - 1) 
                            (jsArrayToArray shiftedArOk.data |> Array.toList)  
                            (jsArrayToArray arOk.data |> Array.toList)
                            |> Array.fromList
                    _ -> Array.empty
            in
            Ok { arOk | data = (arrayToJsArray diffArData) }
        _ -> Err "Error in diffDataArray"

--- =================== UTILITY FUNCTIONS ===================

toSingleCoordAr : DimRef -> Coord -> (DimRef, CoordSpecifier)
toSingleCoordAr dimRef coord = ( dimRef, SingleCoord coord)

itemCoordVecsForDims : DimsDict -> List DimRef -> Array CoordVec
itemCoordVecsForDims dimsDict dimRefs =
    let     
        curCoords = List.map (\dimRef -> Dict.get dimRef dimsDict 
                        |> Maybe.withDefault JsArray.empty |> jsArrayToArray |> Array.toList  ) dimRefs
        posVecs = cartesianProduct curCoords
    in
    Array.fromList posVecs

locAr : DataArray -> List (DimRef, CoordSpecifier) -> Maybe (DataArray )
locAr dataArray dimRefCoordsTuples =
    -- Convert dimCoordsTuples to IndexSpecifiers and call iloc
    let
        indexSpecifiers = List.map (\(dimRef, coordSpecifier) -> 
            (dimRef, convertSpecifierAr dataArray dimRef coordSpecifier |> Maybe.withDefault IndexNone)
            ) dimRefCoordsTuples
    in
    -- Debug.log ("dimRefCoordsTuples: " ++ Debug.toString dimRefCoordsTuples)
    ilocAr dataArray indexSpecifiers

-- used to test the slowness of ilocAr, ilocArSpeedy is thrice faster
ilocArSpeedy : DataArray -> List (DimRef, IndexSpecifier) -> Maybe (DataArray)
ilocArSpeedy dataArray dimRefIndicesTuples = Just dataArray
-- used on complete DataArray, dataset DVars not handled only one DVar oer DataArray
ilocAr : DataArray -> List (DimRef, IndexSpecifier) -> Maybe (DataArray)
ilocAr dataArray dimRefIndicesTuples =
    let
        dimRefs = dataArray.localDimRefs 
        dimsDict = dimsToDict dataArray.localDims
        
        completeDimRefIndicesTuples :  List (DimRef, IndexSpecifier) 
        completeDimRefIndicesTuples = 
            List.map (\dimRef -> 
                let
                    filteredTuple = List.filter (\(d, _) -> d == dimRef) dimRefIndicesTuples
                    foundSpecifier = filteredTuple
                        |> List.head
                        |> Maybe.map Tuple.second
                        |> Maybe.withDefault IndexNone
                in
                -- Debug.log ("iloc filteredTuple: " ++ Debug.toString filteredTuple)
                (dimRef, foundSpecifier)
            ) dimRefs -- false to exclude DVarDimRef
        
        localExpandSpecifier dimRefArg dimIndexSpecifier = expandIndexSpecifierAr dimsDict dimRefArg dimIndexSpecifier
        
        expandedIndices = List.map 
                    (\locTuple -> 
                        localExpandSpecifier (Tuple.first locTuple) (Tuple.second locTuple)
                    ) completeDimRefIndicesTuples
        updatedDimsAsList : List (DimRef, Array Coord)
        updatedDimsAsList = -- returns a list of dim records with filtered coords
            List.map2 (\dimRef indices ->
                let
                    dimCoords = Dict.get dimRef dimsDict |> Maybe.withDefault JsArray.empty  |> jsArrayToArray -- coords are in Arrays
                    filteredCoords = Array.map (\idx -> Array.get idx dimCoords |> Maybe.withDefault "") indices |> arrayToJsArray
                in
                (dimRef, filteredCoords)
            ) dimRefs expandedIndices
        -- updatedDims : DimsDict
        -- updatedDims = Dict.fromList updatedDimsList

        -- updatedDimsAsList = dimsToList updatedDims

        flatIndices = Just expandedIndices -- gets posVecs from expandedIndices then calculates flat indices
            |> cartesianProductPosVecs
            |> Maybe.andThen (\posVecs -> calcFlatIndicesAr dataArray (Just posVecs))

        (filteredData, filteredText)  = case flatIndices of
            Just indices ->
                (extractElementsArray dataArray.data indices, extractElementsArray dataArray.text indices)
                -- removing text extraction does not improve performance
                -- (extractElementsArray dataArray.data indices, JsArray.empty)
            Nothing -> -- if flatIndices is Nothing, return an empty ArrayVariant of tyhe same type
                (JsArray.empty,JsArray.empty)
    in
    -- Debug.log ("dimRefIndicesTuples: " ++ Debug.toString dimRefIndicesTuples)
    -- Return the filtered DataArray with updated dimensions and data
    Just { dataArray | data = filteredData, text = filteredText, localDims = updatedDimsAsList, localDimRefs = dimRefs }

cartesianProduct : List (List a) -> List (List a)
cartesianProduct ll =
    case ll of
        [] ->
            [ [] ]

        xs :: xss ->
            lift2 (::) xs (cartesianProduct xss)
lift2 : (a -> b -> c) -> List a -> List b -> List c
lift2 f la lb =
    la |> andThen (\a -> lb |> andThen (\b -> [ f a b ]))

andThen : (a -> List b) -> List a -> List b
andThen =
    List.concatMap

cartesianProductPosVecs : Maybe (List (Array CoordIndex)) -> Maybe (Array PosVec)
cartesianProductPosVecs maybeLists =
    case maybeLists of
        Just lists ->
            Just (cartesianProductListOfArToArOfList lists)
        Nothing ->
            Nothing

-- only handles unpacking of List to/from Arrays
cartesianProductListOfArToArOfList : List (Array a) -> Array (List a)
cartesianProductListOfArToArOfList listOfArrays =
    listOfArrays
        |> List.map Array.toList
        |> cartesianProduct
        |> Array.fromList



convertSpecifierAr : DataArray -> DimRef -> CoordSpecifier -> Maybe IndexSpecifier
convertSpecifierAr dataArray dim specifier =
    let
        dimsAsList = dataArray.localDims
        dims = dimsToDict dimsAsList
        coordsforDim = Dict.get dim dims |> Maybe.withDefault JsArray.empty--coords are in List
        coordDictLocal = 
            Dict.fromList (
                coordsforDim
                |> jsArrayToArray
                |> Array.toList
                |> List.indexedMap (\j coord -> (coord,j))
            )
    in

    case specifier of
        SingleCoord coord ->
            Dict.get coord coordDictLocal |> Maybe.map SingleIndex

        CoordRange (startCoord, endCoord) ->
            case (Dict.get startCoord coordDictLocal, Dict.get endCoord coordDictLocal) of
                (Just startIndex, Just endIndex) ->
                    if startIndex <= endIndex then
                        Just (IndexRange (startIndex, endIndex))
                    else
                        Nothing
                _ ->
                    Nothing

        CoordArray coords -> 
            let
                indices = Array.map (\coord -> 
                    Dict.get coord coordDictLocal |> Maybe.withDefault -1) coords
            in
                Just (IndexArray indices)

        CoordNone ->
            Just IndexNone

-- used on complete DataArrays
expandIndexSpecifierAr : DimsDict -> DimRef -> IndexSpecifier -> Array CoordIndex
expandIndexSpecifierAr dimsDict dimRef specifier =
    let
        dimCoords = Dict.get dimRef dimsDict |> Maybe.withDefault JsArray.empty --|> Array.toList
        -- dimCoords = jsArrayToArray dimCoordsJs |> Array.toList
    in
    case specifier of
        SingleIndex idx ->
            Array.fromList [idx]
        IndexRange (idxStart, idxEnd) ->
            Array.fromList (List.range idxStart idxEnd)
        IndexArray indices ->
            indices
        IndexNone ->
            Array.fromList (List.range 0 (JsArray.length dimCoords - 1) )

-- it is not the cause of slow performance, tested without Array.get, same speed
extractElementsArray : JsArray a -> Array Int -> JsArray a
extractElementsArray jsArr indices =
    let
        arr = jsArrayToArray jsArr
    in
    indices
        |> Array.map (\index -> Array.get index arr)
        |> arrayExtraFilterMap identity -- unpacks Maybe values
        |> arrayToJsArray

-- funzione dummy per test, non fa nulla
-- riduce i tempi di calcolo di poco, meno di 1 sec su 9 su 10 chiamate
calcFlatIndicesArSpeedy :  DataArray -> Maybe (Array PosVec) -> Maybe (Array FlatIndex)
calcFlatIndicesArSpeedy dataArray maybePosVecs =
    let
        posVecs = Maybe.withDefault (Array.empty) maybePosVecs
        listCounter = List.range 0 (Array.length posVecs)
    in 
        Just (Array.fromList listCounter)
        

calcFlatIndicesAr :  DataArray -> Maybe (Array PosVec) -> Maybe (Array FlatIndex)
calcFlatIndicesAr dataArray maybePosVecs =
    let
        dimsAsList = dataArray.localDims 
        dimsDict =  dimsToDict dimsAsList
        dimRefs = dataArray.localDimRefs 
    in
    case maybePosVecs of -- non controllo che le dimensioni di posvec e strides siano uguali
        Just posVecs ->
            let
                curShape = shapeDim dimsDict dimRefs
                strides = calculateStrides curShape
            in
            Just <| Array.map (\posVec -> 
                         if List.member -1 posVec then 
                            -1
                        else
                        -- same as calcFlatIndexFast strides indices withouth Maybe
                        List.foldl (\(index, stride) acc -> acc + index * stride) 0 (zip posVec strides)
                        ) posVecs
        Nothing ->
            Nothing
calcFlatIndicesFast :  DimsDict -> List DimRef -> Array (PosVec)  -> Array FlatIndex
calcFlatIndicesFast dimsDict dimRefs posVecs  =
            let
                sizes = shapeDim dimsDict dimRefs 
                strides = calculateStrides sizes
            in
            Array.map (\posVec -> 
                        if List.member -1 posVec then 
                            -1
                        else
                        -- same as calcFlatIndexFast strides indices withouth Maybe
                            List.foldl (\(index, stride) acc -> acc + index * stride) 0 (zip posVec strides)
                        ) posVecs

shapeDim : DimsDict -> List DimRef -> List Int
shapeDim dimsDict dimRefs = 
    List.map (\dRef ->
                let
                    dimCoords = Dict.get dRef dimsDict |> Maybe.withDefault JsArray.empty 
                in
                JsArray.length dimCoords
             ) dimRefs

calculateStrides : List Size -> List Stride
calculateStrides sizes =
    let
        reversedSizes = List.reverse sizes
        cumulativeProduct = scanl (*) 1 (reversedSizes)
    in
    cumulativeProduct
        |> List.reverse
        |> List.drop 1

-- functions for binary operations on DataArrays
-- Helper functions for array functions
-- given coordVecDest in the destination DataArray, returns the posVec in the source DataArray
-- used to get data in a formula from another DataArray with different dims (ex fron scenario to ce)
mapPosVec : DimsDict -> List DimRef -> List DimRef -> CoordVec -> Maybe PosVec
mapPosVec dimsSrcDict dimRefsSrc dimRefsDest coordVecDest =
    -- loop on dimRefsSrc
    List.foldl (\dimRef posVec ->
        let
            -- gett coords for the dimRef
            coordsSrc = Dict.get dimRef dimsSrcDict |> Maybe.withDefault JsArray.empty |> jsArrayToArray
            -- create a dict of coordIndices by coords for the dimRef
            coordDictSrc = coordDictFast coordsSrc
        in
        -- gets pos of current dimRef in dimRefsDest
        case elemIndexList dimRef dimRefsDest of
            -- if the dimRef is in dimRefsDest tries to match the coord in coordVecDest
            Just destIndex ->
                let
                    -- get the coord for the destIndex in coordVecDest passed to the function
                    maybeCoord = getAt destIndex coordVecDest 
                    srcIndex = case maybeCoord of
                        -- if the coord is in the coordsSrc
                        Just coord ->
                            -- gets the coordIndex for the coord in dimsSrc
                            -- fi not found the dict is corrupted and returns -1
                            Maybe.withDefault -1 (Dict.get coord coordDictSrc)
                        -- if the coord is not in the coordsSrc
                        Nothing -> -1
                in
                Maybe.map (\vec -> vec ++ [srcIndex]) posVec
            -- if the dimRef is only in srcDims, adds the 1st coordIndex in dimsSrc
            Nothing ->
                Maybe.map (\vec -> vec ++ [0]) posVec
    ) (Just []) dimRefsSrc


coordDictFast : Array Coord -> CoordDict
coordDictFast coordsforDim = 
    Dict.fromList (
        List.indexedMap (\j coord -> (coord,j)) (Array.toList coordsforDim)
    ) 

-- given an arDest consuming data in a formula from arSrc, 
-- returns an array of posVecs in the src DataArray parallel to the posVecs in the dest DataArray
-- and the dims and dimRefs of the src DataArray
mapPosVecs : DataArray -> DataArray ->  Maybe (Array PosVec, DimsDict, List DimRef)
mapPosVecs arSrc arDest =
    let
        srcDims = arSrc.localDims
        srcDimRefs = arSrc.localDimRefs
        destDims = arDest.localDims
        destDimRefs = arDest.localDimRefs
    in
    case (srcDims, srcDimRefs) of
        ([], []) -> Nothing
        ([], _) -> Nothing
        (_, []) -> Nothing
        (_, _) ->
            case (destDims, destDimRefs) of
                ([], []) -> Nothing
                ([], _) -> Nothing
                (_, []) -> Nothing
                (_, _) ->
                    let
                        srcDimsDict = dimsToDict srcDims
                        destDimsDict = dimsToDict destDims
                        coordVecs = itemCoordVecsForDims destDimsDict destDimRefs
                        posVecs = Array.map (\coordVecDest -> 
                                case mapPosVec srcDimsDict srcDimRefs destDimRefs coordVecDest of
                                    Just posVec -> posVec
                                    Nothing -> []
                            ) coordVecs
                    in 
                    Just (posVecs, srcDimsDict, srcDimRefs) 



mapPosVecsTest : DataArray -> DataArray ->String
mapPosVecsTest arSrc arDest =
    let
        srcDims = arSrc.localDims
        srcDimRefs = arSrc.localDimRefs
        destDims = arDest.localDims
        destDimRefs = arDest.localDimRefs
    in
    case (srcDims, srcDimRefs) of
        ([], []) -> Debug.toString (" srcDims and srcDimRefs are empty")
        ([], _) -> Debug.toString (" srcDims is empty")
        (_, []) -> Debug.toString (" srcDimRefs is empty")
        (_, _) ->
            case (destDims, destDimRefs) of
                ([], []) -> Debug.toString (" destDims and destDimRefs are empty")
                ([], _) -> Debug.toString (" destDims is empty")
                (_, []) -> Debug.toString (" destDimRefs is empty")
                (_, _) ->
                    let
                        srcDimsDict = dimsToDict srcDims
                        dimsDestDict = dimsToDict destDims
                        coordVecs = itemCoordVecsForDims srcDimsDict destDimRefs
                        posVecs = Array.map (\coordVecDest -> 
                                case mapPosVec srcDimsDict srcDimRefs destDimRefs coordVecDest of
                                    Just posVec -> posVec
                                    Nothing -> []
                            ) coordVecs
                    in 
                    Debug.toString ( (posVecs, srcDimsDict, srcDimRefs) )




-- returns an array of flatIndices in the src DataArray parallel to the flatIndices in the dest DataArray
-- used to get data from the src DataArray and consume them in the dest DataArray
mapFlatIndices : DataArray -> DataArray ->  Array FlatIndex
mapFlatIndices arSrc arDest = -- arDest is the DataArray consuming data from arSrc
    let
        maybePosVecs = mapPosVecs arSrc arDest
    in
    case maybePosVecs of
        Just (posVecs, dimsDict, dimRefs) -> 
            calcFlatIndicesFast dimsDict dimRefs posVecs

        Nothing -> Array.empty


-- compares two Dims to check if they have the same dim/coords for all dims
-- except a "pivot" one where both have a single coord, and returns the DimRef for that one
pivotDimRefForDims : DimsDict -> DimsDict -> Maybe DimRef 
pivotDimRefForDims dims1 dims2 =
    let
        dim1Refs = Dict.keys dims1
        dim2Refs = Dict.keys dims2
        matchesCheckResult = 
            if dim1Refs == dim2Refs then
                List.foldl (\curRef curMatchRefTuple -> 
                    let
                        coords1 = Dict.get curRef dims1 |> Maybe.withDefault JsArray.empty
                        coords2 = Dict.get curRef dims2 |> Maybe.withDefault JsArray.empty
                        coordsNotEmptyMatch = (coords1 == coords2 && coords1 /= JsArray.empty)
                        bothSingleCoords = (JsArray.length coords1 == 1 && JsArray.length coords2 == 1)
                        prevMatches = Tuple.first curMatchRefTuple
                        prevRef = Tuple.second curMatchRefTuple
                    in
                    if coordsNotEmptyMatch then -- same coords, increases the match count
                        (prevMatches + 1, prevRef)
                    else if bothSingleCoords then
                        (prevMatches, curRef) -- different coords, but both single, sets the pivot dimRef, not increasing the match count
                    else
                        (prevMatches, prevRef) -- different multiple coords, no match
                ) (0,"") dim1Refs

            else -- no match if dimRefs are different
                (0,"")
        pivotDimRef = 
            -- if all dims match, prevMatches is equal to the length of dim1Refs, if one dows not match, prevMatches is less 1
            if Tuple.first matchesCheckResult == List.length dim1Refs - 1 then
                Just (Tuple.second matchesCheckResult)
            else 
                Nothing
    in
    pivotDimRef
    -- Just (Debug.toString dim1Refs ++ "\n" ++ Debug.toString dim2Refs ++ "\n" ++ Debug.toString matchesCheckResult)


itemPosVecsForDims : DimsDict -> List DimRef -> Array PosVec
itemPosVecsForDims dims dimRefs =
    let     
        sizes = shapeDim dims dimRefs
        indicesByDim = List.map (\size -> List.range 0 (size - 1)) sizes
        posVecs = cartesianProduct indicesByDim
    in
    Array.fromList posVecs


-- general functions
scanl : (a -> b -> b) -> b -> List a -> List b
scanl f b xs =
    let
        scan1 x accAcc =
            case accAcc of
                acc :: _ ->
                    f x acc :: accAcc

                [] ->
                    []

        -- impossible
    in
    List.reverse (List.foldl scan1 [ b ] xs)

zip : List a -> List b -> List ( a, b )
zip =
    List.map2 Tuple.pair

zipAr : Array a -> Array b -> Array ( a, b )
zipAr arr1 arr2 =
    let
        zipList = zip (Array.toList arr1) (Array.toList arr2)
    in
    Array.fromList zipList

jsArrayToArray : JsArray a -> Array a
jsArrayToArray jsArray = 
    JsArray.foldl (\el acc -> Array.push el acc) Array.empty jsArray

arrayToJsArray : Array a -> JsArray a
arrayToJsArray array = 
    Array.foldl (\el acc -> JsArray.push el acc) JsArray.empty array

arrayExtraFilterMap :
    (element -> Maybe narrowElement)
    -> (Array element -> Array narrowElement)
arrayExtraFilterMap tryMap =
    Array.toList
        >> List.filterMap tryMap
        >> Array.fromList

elemIndex : a -> Array a -> Maybe Int
elemIndex x arr =
    findIndex ((==) x) arr

findIndex : (a -> Bool) -> Array a -> Maybe Int
findIndex predicate arr =
    findIndexHelp 0 predicate arr

findIndexHelp : Int -> (a -> Bool) -> Array a -> Maybe Int
findIndexHelp index predicate arr =
    if index >= Array.length arr then
        Nothing
    else
        case Array.get index arr of
            Just x ->
                if predicate x then
                    Just index
                else
                    findIndexHelp (index + 1) predicate arr
            Nothing ->
                Nothing

elemIndexList : a -> List a -> Maybe Int
elemIndexList x =
    findIndexList ((==) x)

findIndexList : (a -> Bool) -> List a -> Maybe Int
findIndexList =
    findIndexHelpList 0


findIndexHelpList : Int -> (a -> Bool) -> List a -> Maybe Int
findIndexHelpList index predicate list =
    case list of
        [] ->
            Nothing

        x :: xs ->
            if predicate x then
                Just index

            else
                findIndexHelpList (index + 1) predicate xs


getAt : Int -> List a -> Maybe a
getAt idx xs =
    if idx < 0 then
        Nothing

    else
        List.head <| List.drop idx xs

setAt : Int -> a -> List a -> List a
setAt index value =
    updateAt index (always value)

updateAt : Int -> (a -> a) -> List a -> List a
updateAt index fn list =
    if index < 0 then
        list

    else
        let
            tail : List a
            tail =
                List.drop index list
        in
        case tail of
            x :: xs ->
                List.take index list ++ fn x :: xs

            [] ->
                list