module Alignment exposing (..)

import Array exposing (Array)
import FastDict as Dict exposing (Dict)
import Set
import Array.Extra

import List.Extra
import XModel exposing (..)
import TypesXModel exposing (..)
import Core.Basics exposing (le)
import Types exposing (Value(..))




testAggrDataArrayUnary = 
    let
        valoreDArWithDims = 
            if valoreDAr == XModel.emptyDataArray then
                Err "Error: got emptyDataArray"
            else
                Ok valoreDAr

    in
    aggrDataArrayUnary xm valoreDArWithDims arSum [ "azienda" ] "ValoreSumByYear"

testAggrDataArrayUnaryAr = 
    let
        valoreDArWithDims = 
            if valoreDAr == XModel.emptyDataArray then
                Err "Error: got emptyDataArray"
            else
                Ok valoreDAr

    in
    aggrDataArrayUnaryAr valoreDArWithDims arSum [ "anno" ] "ValoreSumByYear"


-- test of recalc in a data array, partial arrays are calculated and stored as local variables
-- update of the whole Dataset is done at the end
testUpdatedCeDAr = 
    let
        valoreDArWithDims = 
            if valoreDAr == XModel.emptyDataArray then
                Err "Error: got emptyDataArray"
            else
                Ok valoreDAr
        fxAr = inputArForAll xm cambioDAr "anno"
        calcAr = calcArForSingleCoordFromTwoArs xm "voce"
        calcTaxAr = calcArForSingleCoordFromOneAr xm "voce" "Tax"
        ricavi = inputArForSingleCoord xm valoreDAr "voce" "Ricavi"
        costoVen = inputArForSingleCoord xm valoreDAr "voce" "CostoVen"
        speseVGA = inputArForSingleCoord xm valoreDAr "voce" "SpeseVGA"
        amm = inputArForSingleCoord xm valoreDAr "voce" "Amm"

        margContrib = calcAr "MargContrib" costoVen ricavi (-) -- subtracted item first TODO funcDataArrayPairWithLocalDims streamline arg order
        ebitda = calcAr "EBITDA" speseVGA margContrib (-)
        ebit = calcAr "EBIT"  amm ebitda (-) 
        tax = calcTaxAr ebit taxMultiplier
        unlevNetIncome = calcAr "UnlevNetIncome" tax ebit (-)
        calcItems = [ margContrib, ebitda, ebit, tax, unlevNetIncome]
        ceEur = List.foldl (\arPart arWhole -> 
            case arPart of
                Ok _ -> updateDataArrayPair xm arWhole arPart keepNotNaN
                Err err -> Err err
            ) valoreDArWithDims calcItems
        ceUsd = case (ceEur, fxAr) of 
            (Ok ceEurOk, Ok fxArOk) -> 
                -- con fxArOk ceEurOk ok primo anno azienda resto NaN, con ceEurOk fxArOk ok primo anno azienda resto manca
                 Ok (funcDataArrayPair xm fxArOk ceEurOk (*))
            _ -> Err "Error in updateDataArrayPairWithLocalDims ceUsd" 
    in
        -- Debug.log ("\nRicavi: " ++ Debug.toString(ricavi))
        -- Debug.log ("\nCostoVen: " ++ Debug.toString(costoVen))
        -- Debug.log ("\nmargContrib: " ++ Debug.toString(margContrib))
        ceUsd



testFuncDataArrayPairInflazione : (Maybe DataArray, Maybe DimRef)
testFuncDataArrayPairInflazione = funcDataArrayPair xm
    { inflazioneDAr | localDims = Just xm.dims, localDimRefs = Just macro.dimRefs }
    { valoreDAr | localDims = Just xm.dims, localDimRefs = Just ceForTest.dimRefs }
    -- { valoreDAr | localDims = Just xm.dims, localDimRefs = Just ce.dimRefs }
    (\val infl -> val * (1 + infl))

testFuncDataArrayPairCambio : (Maybe DataArray, Maybe DimRef)
testFuncDataArrayPairCambio = 
    let
        cambioDArFiltered = XModel.loc xm.dims macro cambioDAr [ scenarioWorst ]
            |> Maybe.withDefault XModel.emptyDataArray
    in
    funcDataArrayPair xm
        cambioDArFiltered -- assigns localDims and localDimRefs
        { valoreDAr | localDims = Just xm.dims, localDimRefs = Just ceForTest.dimRefs }
        -- { valoreDAr | localDims = Just xm.dims, localDimRefs = Just ce.dimRefs }
        (*)

-- gets a data array for a single coord in a dimension, i.e. "Ricavi" in "voce"
inputArForSingleCoordCe : DataArray -> DimRef -> Coord 
    -> Result String DataArray
inputArForSingleCoordCe ar dimRef coord = 
    case (XModel.loc xm.dims ceForTest ar [ toSingleCoord dimRef coord] ) of 
        Just arJust -> Ok arJust
        Nothing -> Err "Error in getting input DataArray"

inputArForSingleCoord : XModel -> DataArray -> DimRef -> Coord 
    -> Result String DataArray
inputArForSingleCoord xModel ar dimRef coord = 
    let
        dims = xModel.dims
        dataset = XModel.datasetForDataArray xm ar |> Maybe.withDefault XModel.emptyDataset
    in
    case (XModel.loc dims dataset ar [ toSingleCoord dimRef coord] ) of 
        Just arJust -> Ok arJust
        Nothing -> Err "Error in getting input DataArray"

-- provvisorio per usare loc metto CoordNone per un DimRef
inputArForAllMacro : DataArray -> DimRef 
    -> Result String DataArray
inputArForAllMacro ar dimRef  = 
    case (XModel.loc xm.dims macro ar [ toCoordNone dimRef] ) of 
        Just arJust -> Ok arJust
        Nothing -> Err "Error in getting input DataArray"
-- utility function to get a DataArray for all coords in a dimension
-- used to set input data for a calculation
inputArForAll : XModel -> DataArray -> DimRef 
    -> Result String DataArray
inputArForAll xModel ar dimRef  = 
    let
        dims = xModel.dims
        dataset = XModel.datasetForDataArray xm ar |> Maybe.withDefault XModel.emptyDataset
    in
    case (XModel.loc dims dataset ar [ toCoordNone dimRef] ) of 
        Just arJust -> Ok arJust
        Nothing -> Err "Error in getting input DataArray"

-- CALCULATION FUNCTIONS NOT MOVED TO XModel and FuncDataArray
calcArForSingleCoordFromTwoCoords : XModel -> DataArray -> DimRef -> Coord -> Coord -> Coord -> BinaryFuncFloat 
    -> Result String DataArray
calcArForSingleCoordFromTwoCoords xModel ar dimRef coordCalc coordInput1 coordInput2 binaryFunc = 
    let
        dims = xModel.dims
        dataset = XModel.datasetForDataArray xm ar |> Maybe.withDefault XModel.emptyDataset
        input1Ar = XModel.loc dims dataset ar [ toSingleCoord dimRef coordInput1] |> Maybe.withDefault XModel.emptyDataArray
        input2Ar = XModel.loc dims dataset ar [ toSingleCoord dimRef coordInput2] |> Maybe.withDefault XModel.emptyDataArray
        calcArTuple = funcDataArrayPair xModel input1Ar input2Ar binaryFunc
        calcAr = case Tuple.first calcArTuple of
            Just calcArJust -> calcArJust
            Nothing -> XModel.emptyDataArray
        matchedDimRef = case Tuple.second calcArTuple of
            Just dimRefJust -> dimRefJust
            Nothing -> ""
        calcDimsRaw = calcAr.localDims |> Maybe.withDefault Dict.empty
        calcDims = Dict.insert dimRef (Array.fromList [coordCalc]) calcDimsRaw
    in 
    if matchedDimRef == dimRef && dimRef /= "" then
        Ok { calcAr | localDims = Just calcDims }
    else if dimRef == "" then
        Err "EMPTY dimRef in matching input and calculated pivotDimRef"
    else    
        Err "Other error in matching input and calculated pivotDimRef"

calcArForSingleCoordFromTwoArs : XModel -> DimRef -> Coord -> Result String DataArray -> Result String DataArray -> BinaryFuncFloat 
    -> Result String DataArray
calcArForSingleCoordFromTwoArs xModel dimRef coordCalc input1Ar input2Ar binaryFunc = 
    let
        calcArTuple = case (input1Ar, input2Ar) of
            (Ok input1ArJust, Ok input2ArJust) ->
                funcDataArrayPair xModel input1ArJust input2ArJust binaryFunc
            _ -> (Nothing, Nothing)
        calcAr = case Tuple.first calcArTuple of
            Just calcArJust -> calcArJust
            Nothing -> XModel.emptyDataArray
        matchedDimRef = case Tuple.second calcArTuple of
            Just dimRefJust -> dimRefJust
            Nothing -> ""
        datasetRef = case input1Ar of
            Ok input1ArJust -> input1ArJust.datasetRef
            Err _ -> Nothing
        calcArWithDataset = { calcAr | datasetRef = datasetRef }
        (_, calcDimsRaw) = XModel.dimInfoForDataArray xModel calcArWithDataset-- calcArOk.localDims |> Maybe.withDefault Dict.empty
        calcDims = case calcDimsRaw of
            Just calcDimsJust -> Dict.insert dimRef (Array.fromList [coordCalc]) calcDimsJust
            Nothing -> Dict.empty
    in 
    if matchedDimRef == dimRef && dimRef /= "" then
        Ok { calcAr | localDims = Just calcDims }
    else if matchedDimRef == "" then
        Err ( ("EMPTY matchedDimRef in matching input and calculated pivotDimRef\n\n\n" 
            ++ Debug.toString(input1Ar) ++ "\n\n\n" ++ Debug.toString(input2Ar) ) |> String.replace "\\" "")
    else    
        Err ("Other error in matching input and calculated pivotDimRef: " ++ dimRef ++ " != " ++ matchedDimRef)
        

calcArForSingleCoordFromOneAr : XModel -> DimRef -> Coord -> Result String DataArray -> UnaryFuncFloat
    -> Result String DataArray
calcArForSingleCoordFromOneAr xModel dimRef coordCalc input1Ar unaryFunc = 
    let
        datasetRef = case input1Ar of
            Ok input1ArJust -> input1ArJust.datasetRef
            Err _ -> Nothing
        calcAr = funcDataArrayUnary input1Ar unaryFunc 
        calcArOk = case calcAr of
            Ok calcArJust -> calcArJust
            Err _ -> XModel.emptyDataArray
        calcArOkWithDataset = { calcArOk | datasetRef = datasetRef }
        (_, calcDimsRaw) = XModel.dimInfoForDataArray xModel calcArOkWithDataset-- calcArOk.localDims |> Maybe.withDefault Dict.empty
        calcDims = case calcDimsRaw of
            Just calcDimsJust -> Dict.insert dimRef (Array.fromList [coordCalc]) calcDimsJust
            Nothing -> Dict.empty
    in 
    case calcAr of -- duplicated Result check TODO
        Ok calcArRet -> Ok { calcArRet | localDims = Just calcDims }
        Err _ -> Err "Error in calcArForSingleCoordFromOneAr "

testItemPosVecsForDim : Array PosVec
testItemPosVecsForDim = XModel.itemPosVecsForDims dimsCe ceForTest.dimRefs

testItemCoordVecsForDim : Array CoordVec
testItemCoordVecsForDim = XModel.itemCoordVecsForDims dimsCe ceForTest.dimRefs


testMapPosVec : CoordVec -> Maybe PosVec
testMapPosVec coordVec= mapPosVec
    xm.dims
    macro.dimRefs
    ceForTest.dimRefs
    coordVec

testMapPosVecs : Maybe (Array PosVec, Dims, List DimRef)
testMapPosVecs = 
    let
        cambioDArFiltered = XModel.loc xm.dims macro cambioDAr [ scenarioWorst ]
            |> Maybe.withDefault XModel.emptyDataArray
    in
    mapPosVecs
        -- cambioDArFiltered 
        margContribStatic
        { valoreDAr | localDims = Just xm.dims, localDimRefs = Just ceForTest.dimRefs }



testMapFlatIndices = mapFlatIndices
    { valoreDAr | localDims = Just xm.dims, localDimRefs = Just ceForTest.dimRefs }
    margContribStatic
    -- reducedCeDArARicAmm
    -- { inflazioneDAr | localDims = Just xm.dims, localDimRefs = Just macro.dimRefs }
testMapFlatIndices2 = mapFlatIndices
    margContribStatic
    { valoreDAr | localDims = Just xm.dims, localDimRefs = Just ceForTest.dimRefs }

-- SHIFT FUNCTIONALITY

-- returns a new DataArray with the data shifted by the given stride along the given dimension
shiftDataArray : DataArray -> DimRef -> Int -> Maybe DataArray
shiftDataArray ar dimRef step = 
    case (ar.localDims, ar.localDimRefs) of
        (Just dims, Just dimRefs) ->
            let
                dimIndex = Maybe.withDefault -1 (List.Extra.elemIndex dimRef dimRefs)
                posVecs = XModel.itemPosVecsForDims dims dimRefs
                shiftedPosVecs = Array.map (\posVec -> 
                        let
                            pos = Maybe.withDefault -1 (List.Extra.getAt dimIndex posVec)
                            shiftedPos = if pos == -1 then -1 else pos + step
                        in
                        List.Extra.setAt dimIndex shiftedPos posVec
                    ) posVecs
                shiftedIndices = XModel.calcFlatIndicesFast dims dimRefs shiftedPosVecs
                shiftedData = 
                    Array.map (\flIdx -> Array.get flIdx ar.data |> Maybe.withDefault (0/0) ) shiftedIndices 
            in
            Just { ar | data = shiftedData }
        _ -> Nothing

-- shifted array has same dims so no need to use funcDataArrayPairWithLocalDims, map2 on .data instead
diffDataArray : DataArray -> DimRef -> Maybe DataArray
diffDataArray ar dimRef = 
        let
            shiftedAr = shiftDataArray ar dimRef -1
            diffArData = case shiftedAr of
                Just shiftedArJust -> 
                    Array.Extra.map2 (\valPrev valThis -> valThis - valPrev) shiftedArJust.data ar.data
                _ -> Array.empty
        in
        Just { ar | data = diffArData }

pctChangeDataArray : DataArray -> DimRef -> Maybe DataArray
pctChangeDataArray ar dimRef = 
        let
            shiftedAr = shiftDataArray ar dimRef -1
            diffArData = case shiftedAr of
                Just shiftedArJust -> 
                    Array.Extra.map2 (\valPrev valThis -> valThis / valPrev - 1) shiftedArJust.data ar.data
                _ -> Array.empty
        in
        Just { ar | data = diffArData }
    
testShiftDataArray = shiftDataArray
    { valoreDAr | localDims = Just xm.dims, localDimRefs = Just ceForTest.dimRefs }
    "voce"
    -1

testDiffDataArray = diffDataArray
    { valoreDAr | localDims = Just xm.dims, localDimRefs = Just ceForTest.dimRefs }
    "anno"


testPctChangeDataArray = pctChangeDataArray
    { valoreDAr | localDims = Just xm.dims, localDimRefs = Just ceForTest.dimRefs }
    "anno"


-- IDEAS FOR ALIGNMENT TAKEN FROM PYTHON XARRAY
-- reproduced from python xarray/core/alignment.py
type JoinOption = Inner | Outer | Left | Right | Override

{-
 Given any number of Dataset and/or DataArray objects, returns new
    objects with aligned indexes and dimension sizes.

    Array from the aligned objects are suitable as input to mathematical
    operators, because along each dimension they have the same index and size.

    Missing values (if ``join != 'inner'``) are filled with ``fill_value``.
    The default fill value is NaN.
-}
-- align : List Dataset -> List DataArray -> JoinOptions -> Maybe XValue -> (List Dataset, List DataArray)
-- align datasets dataArrays join fillValue = TODO!!

-- data structure to align dimensions in a pair of DataArrays
-- returns a Triple of flatIndices mappin the positions of the coord in the two source DataArrays
-- and in the resulting DataArray
type alias DictCoordIndices =
     Dict (DimRef, Coord) (FlatIndex, FlatIndex, FlatIndex) -- indexA, indexB, indexAandB


-- given two lists of strings, return the first list ++ the elements of the second list that are not in the first list
-- in the same order as they appear in the second list
-- e.g. ["a", "b", "c"] ++ ["b", "d", "e"] = ["a", "b", "c", "d", "e"]
unionList : List String -> List String -> List String
unionList list1 list2 = 
    let
        set1 = Set.fromList list1
        list2Filtered = List.filter (\x -> not (Set.member x set1)) list2
    in
        list1 ++ list2Filtered


unionArray : Array String -> Array String -> Array String
unionArray array1 array2 = 
    let
        set1 = Set.fromList (Array.toList array1)
        array2Filtered = Array.filter (\x -> not (Set.member x set1)) array2
    in
        Array.append array1 array2Filtered

intersectionArray : Array String -> Array String -> Array String
intersectionArray array1 array2 = 
    let
        set2 = Set.fromList (Array.toList array2)
        array1Filtered = Array.filter (\x -> Set.member x set2) array1
    in
    array1Filtered

-- from the xModel dims, return the list of complete coord names for the union
-- of the two lists of dimRefs A and B
-- NB: if B has a coord preceding A's coords in the dim, the union is not sorted
-- MAYBE NOT USED, EXPERIMENT BEFORE CALCULATION FUNCTIONS ON ARRAYS
joinedDimsModel : Dims -> List DimRef -> List DimRef -> (Dims, List DimRef)
joinedDimsModel dims dimRefsA dimRefsB  = 
    let
        joinedDimRefs = unionList dimRefsA dimRefsB
        joinedDims = List.foldl (\dimRef retDict -> 
            case Dict.get dimRef dims of

                Just coords -> Dict.insert dimRef coords retDict
                Nothing -> retDict
            
            ) Dict.empty joinedDimRefs
    in
        (joinedDims, joinedDimRefs)


-- returns a tuple of the joinedDims and the joinedDimRefs built from the two DataArrays
-- given a JoinOption
-- dimsA should be model.dims if used
-- NB: if B has a coord preceding A's coords in the dim, the union is not sorted
joinedDimsLocal : Dims -> List DimRef -> Dims -> List DimRef -> JoinOption -> (Dims, List DimRef)
joinedDimsLocal dimsA dimRefsA dimsB dimRefsB  joinOption = 
    let
        joinedDimRefs = unionList dimRefsA dimRefsB

        joinedDims = List.foldl (\dimRef retDict -> 
            let
                coords =
                    case (Dict.get dimRef dimsA, Dict.get dimRef dimsB) of
                        (Just coordsA, Just coordsB) -> 
                            case joinOption of
                                    Inner -> intersectionArray coordsA coordsB
                                    Outer -> unionArray coordsA coordsB
                                    Left -> coordsA
                                    Right -> coordsB
                                    Override -> coordsA

                        (Just coordsA, Nothing) ->
                            case joinOption of
                                Inner -> Array.empty
                                Outer -> coordsA
                                Left -> coordsA
                                Right -> Array.empty
                                Override -> coordsA

                        (Nothing, Just coordsB) ->
                            case joinOption of
                                Inner -> Array.empty
                                Outer -> coordsB
                                Left -> Array.empty
                                Right -> coordsB
                                Override -> Array.empty

                        (Nothing, Nothing) -> Array.empty
            in
            if Array.isEmpty coords then
                retDict
            else
                Dict.insert dimRef coords retDict   
            
            ) Dict.empty joinedDimRefs
    in
        (joinedDims, joinedDimRefs)


testjoinedDimsLocal = joinedDimsLocal -- takes JoinOption as last argument
    (reducedCeDArA.localDims |> Maybe.withDefault Dict.empty)
    (reducedCeDArA.localDimRefs |> Maybe.withDefault [])
    (reducedCeDArB.localDims |> Maybe.withDefault Dict.empty)
    (reducedCeDArB.localDimRefs |> Maybe.withDefault [])

testjoinedDimsModelLocal = joinedDimsLocal
    dimsCe
    ceForTest.dimRefs
    (reducedCeDArB.localDims |> Maybe.withDefault Dict.empty)
    (reducedCeDArB.localDimRefs |> Maybe.withDefault [])



--  DATA FOR TESTS

xm = XModel.myXModel
ceForTest = Dict.get XModel.ce xm.datasets |> Maybe.withDefault XModel.emptyDataset

az = Dict.get "az" xm.datasets |> Maybe.withDefault XModel.emptyDataset
macro = Dict.get "macro" xm.datasets |> Maybe.withDefault XModel.emptyDataset
dimsCe = XModel.dimsForDataset xm.dims ceForTest
dimsAz = XModel.dimsForDataset xm.dims az
dimsScen = XModel.dimsForDataset xm.dims macro

dimRefsCeAndAz = unionList ceForTest.dimRefs az.dimRefs

-- for testing calc across dimension
ricaviStatic = XModel.loc xm.dims ceForTest valoreDAr [ toSingleCoord "voce" "Ricavi"] |> Maybe.withDefault XModel.emptyDataArray
costoVenStatic = XModel.loc xm.dims ceForTest valoreDAr [ toSingleCoord "voce" "CostoVen"] |> Maybe.withDefault XModel.emptyDataArray



-- !! testFuncDataArrayPairWithLocalDims fa casino, non funziona across dimension
-- margContrib = funcDataArrayPairWithLocalDims costoVen ricavi (-) |> Maybe.withDefault XModel.emptyDataArray 

-- manual TEST implementation assuming same localDims except "voce"
margContribStatic = 
    let
        ricaviDims = ricaviStatic.localDims |> Maybe.withDefault Dict.empty
        calcData = Array.Extra.map2 (-) ricaviStatic.data costoVenStatic.data
        calcDims = Dict.insert "voce" (Array.fromList ["MargContrib"]) ricaviDims
    in
    { ricaviStatic | data = calcData, localDims = Just calcDims }


valoreDAr = 
    let
        arProvvi = Dict.get "valore" ceForTest.dataArrays |> Maybe.withDefault XModel.emptyDataArray
    in 
    { arProvvi | datasetRef = Just XModel.ce, localDims = Just xm.dims, localDimRefs = Just ceForTest.dimRefs }
inflazioneDAr = Dict.get "inflazione" macro.dataArrays |> Maybe.withDefault XModel.emptyDataArray
cambioDAr = Dict.get "cambioUsdEur" macro.dataArrays |> Maybe.withDefault XModel.emptyDataArray
reducedCeDArA = XModel.loc xm.dims ceForTest valoreDAr [ anniPrimi2] |> Maybe.withDefault XModel.emptyDataArray
reducedCeDArB = XModel.loc xm.dims ceForTest valoreDAr [ anniUltimi2] |> Maybe.withDefault XModel.emptyDataArray
reducedCeDArARic = XModel.loc xm.dims ceForTest valoreDAr [ toSingleCoord "voce" "Ricavi", anniPrimi2] |> Maybe.withDefault XModel.emptyDataArray
reducedCeDArARicAmm = XModel.loc xm.dims ceForTest valoreDAr [ XModel.toCoordList "voce" (Array.fromList ["Ricavi","Amm"]), XModel.toCoordList "anno" (Array.fromList ["2021","2022"])] |> Maybe.withDefault XModel.emptyDataArray

anniPrimi2 = (CategDimRef "anno", CoordList (Array.fromList ["2021","2022"]) )
anniUltimi2 = (CategDimRef "anno", CoordList (Array.fromList ["2022","2023"]) )

primoAnno = (CategDimRef "anno", SingleCoord "2021" )
scenarioWorst = (CategDimRef "scenario", SingleCoord "Worst" )

testjoinedDimsModel = joinedDimsModel xm.dims ceForTest.dimRefs az.dimRefs