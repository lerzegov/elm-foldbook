module TypesMarkup exposing (..)

import Dict exposing (Dict)
import Dict exposing (values)
import Mark.Internal.Description as Desc exposing (Description(..))
import Mark.Internal.Id as Id exposing (Id)

type alias MarkupEnv =
    { values : Values
    , equations : Dict String String
    , pendingEqn : Maybe String
    -- editing
    , editState : Maybe EditState
    , parsedDetails : Maybe Desc.Description
    , showValues : ShowValues
    }
type ShowValues = Editable | NotEditable

emptyMarkupEnv : MarkupEnv
emptyMarkupEnv =
    { values = Dict.empty
    , equations = Dict.empty
    , pendingEqn = Nothing
    , editState = Nothing
    , parsedDetails = Nothing
    , showValues = NotEditable
    }
type alias EditState =
    { id : Id
    , content : String
    }
-- Values
-- generic dictionary to store runtime values
-- similar to elm-interpreter Env
type alias Values =
    Dict.Dict String Float


getValue : String -> Values -> Float
getValue name values =
    values
        |> Dict.get name
        -- Values that are not kept track of yet are assumed to be the default
        |> Maybe.withDefault 0