module Home exposing (..)

import Element exposing (..)
import Element.Events exposing (onClick)
import Browser.Navigation as Navigation
import Types exposing (CallTree(..), Error(..), Value(..), Env, Eval)
import CalcEngine
import Ports
import Element.Font exposing (Font)
import Element.Font as Font
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes exposing (id)

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
    column [ spacing 10, padding 20 , width fill]
        [ row [width fill] [logo, (header "Welcome to elm-foldBook") ]
        , textPrompt
        , datasetListView datasetList
        ]

header : String -> Element Msg
header title =
    el [ Font.size 32, Font.bold, alignTop, alignLeft, padding 20 ] (text title)

logo : Element Msg
logo =
    el [ height (px 60), width (px 250), alignLeft ]
        (Element.image [  ] { src = "/assets/logo.png", description = "elmFoldbook Logo" })


textPrompt : Element Msg
textPrompt =
    el [ Font.size 20, Font.italic, alignLeft, padding 20 ]
        (text "Click to open a foldSheet")

datasetListView : List String -> Element Msg
datasetListView datasets =
    row [ spacing 10, padding 20, alignLeft ]
        (List.map datasetLink datasets)

datasetLink : String -> Element Msg
datasetLink datasetName =
    el [ padding 10, Border.width 1, Border.color (Element.rgb 0 0 0), Border.rounded 5, Background.color (Element.rgb 240 240 240), Font.size 18, Font.bold, centerX ]
        (Input.button [  ]
                { onPress = Just (OpenDataset datasetName), label = text datasetName } )

openDatasetInNewTab : String -> Cmd Msg
openDatasetInNewTab datasetName =
    let
        url = "/#/dataset/" ++ datasetName
    in
    Ports.openNewTab url
