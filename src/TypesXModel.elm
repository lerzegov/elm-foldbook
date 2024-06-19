module TypesXModel exposing (..)
-- created to allow import in Types.elm for xModel in Env
-- imported also in XModel.elm
import Array exposing (Array)
import FastDict exposing (Dict)



type alias DimRef = String

type alias Coord = String

type alias DatasetRef = String

type alias DataArrayRef = String
-- to avoid Variant type, we use a record with both number and text
-- text may be used for numbers as well, for example to hold formatted numbers
-- for string values, text should be the only field used

-- final store of dimension data
type alias Dims = Dict DimRef (Array Coord)

type alias DataArray = 
    { ref : DataArrayRef -- name
    , datasetRef : Maybe DatasetRef -- name of the container dataset
    , data : Array Float
    , text : Array String
    , localDims : Maybe Dims -- local dims for the DataArray
    , localDimRefs : Maybe (List DimRef) -- local dimRefs for the DataArray
    }

-- final store of array data
type alias DataArrays = Dict DataArrayRef DataArray
type alias ModuleSource = String

type alias Dataset = 
    { ref : DatasetRef -- name
    , dimRefs : List DimRef -- ordered list of dims
    , dataArrayRefs : List DataArrayRef -- ordered list of data arrays names (DVars)
    , dataArrays : DataArrays
    , formulas : ModuleSource
    , defaultDataArrayRef : Maybe DataArrayRef
    }
getDefaultDataArrayRef : Dataset -> DataArrayRef
getDefaultDataArrayRef dataset = 
    case dataset.defaultDataArrayRef of
        Just ref -> ref
        Nothing -> -- if no default, return the first one
            case dataset.dataArrayRefs of
                [] -> ""
                ref :: _ -> ref

type alias Datasets = Dict DatasetRef Dataset
-- single source of truth for the data
type alias XModel = 
    { modelRef : String
    , datasetRefs : List DatasetRef
    , datasets : Datasets
    , dims : Dims
    , datasetToRecalc : Maybe DatasetRef
    }
