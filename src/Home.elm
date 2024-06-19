module Home exposing (..)

import Element exposing (..)
import Element.Events exposing (onClick)
import Browser.Navigation as Navigation
import Types exposing (CallTree(..), Error(..), Value(..), Env, Eval)
import CalcEngine
import Ports
import Element.Font exposing (Font)
import Element.Font as Font

type alias Model =
    { env : Result Error Env
    }

type Msg
    = OpenDataset String

init : Maybe Env -> Model
init maybeEnv =
    case maybeEnv of
        Nothing -> 
            { env = Err (IncompleteCodeError "No environment")
            }
        Just env ->
            { env = Ok env
            }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        OpenDataset datasetName ->
            (model, openDatasetInNewTab datasetName)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

view : Model -> Element Msg
view model =
    let 
        maybeXModel = CalcEngine.getXModelFromEnv model.env
        datasetList = case maybeXModel of
            Just xModel -> xModel.datasetRefs
            Nothing  -> []
    in
    column [Font.size 20]
        [ text "Datasets:"
        , column [Font.size 18]
            (List.map datasetLink datasetList)
        ]

datasetLink : String -> Element Msg
datasetLink datasetName =
    el []
        (link [ onClick (OpenDataset datasetName) ] 
            { url = "#"
            , label = (text datasetName)
            }
        )

openDatasetInNewTab : String -> Cmd Msg
openDatasetInNewTab datasetName =
    let
        url = "/#/dataset/" ++ datasetName
    in
    Ports.openNewTab url
