module TestRangeName exposing (..)

import XModel 
import TypesXModel exposing (..)
import Dict exposing (Dict)



xModel = XModel.myXModel
ce = XModel.getDatasetByRef "Ce" xModel.datasets |> Maybe.withDefault XModel.emptyDataset

searchDict = 
    XModel.makeCoordSearchDict xModel ce.ref []

testRangeName name = 
    XModel.rangeNameToDef xModel ce.ref name


roundTripRangeName name = 
    let rangeRec = testRangeName name in
    case rangeRec of
        Ok def -> 
            "From " ++ name ++ " I got " ++ (Debug.toString rangeRec)++ " and then " 
                ++ ( XModel.rangeDefToName xModel "Ce" def)
        Err _ -> "invalid range name: " ++ name

valoreDims = 
    let
        maybeDAr = XModel.getDataArrayWithDimsFromXModel xModel "Ce" "valore"
    in
    case maybeDAr of
        Just dAr  -> 
            case dAr.localDims of
                Just ld -> ld
                Nothing -> xModel.dims
        Nothing -> 
            xModel.dims

testPromptCoords name =
    XModel.promptCoordsForPartialRangeName xModel "Ce" name