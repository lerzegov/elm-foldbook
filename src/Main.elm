module Main exposing (..)

import Browser
import Browser.Navigation as Navigation
import Html exposing (Html, div, text)
import Element exposing (..)
import Element.Font exposing (Font)
import Home
import DatasetPage
import Routes exposing (..)
import Types exposing (..)
import Ports exposing (..)
import Url exposing (Url, Protocol(..))
import Eval.Module as Module
import XModel
import TypesXModel exposing (..)
import FastDict as Dict exposing (Dict)


type alias Model =
    { page : Routes.Page
    , env : Result Error Types.Env
    , homeModel : Home.Model
    , datasetModels : Dict String DatasetPage.Model
    , key : Navigation.Key
    }

type Msg
    = UrlChanged Url
    | HomeMsg Home.Msg
    | DatasetMsg String DatasetPage.Msg
    | EnvUpdated (Result Error Env)
    | OpenDatasetInNewTab String

init : () -> Url -> Navigation.Key -> (Model, Cmd Msg)
init _ url key =
    let
        startEnv = Module.emptyEnvWithCoreFunctions
        startXModel = XModel.myXModel
        startEnvWithXModel = { startEnv | envXModel = Just startXModel }
        startDSets = startXModel.datasets |> Dict.values
        startEnvWithFormulas = 
            List.foldl (\dSet envAcc ->
                case  Module.makeEnv dSet.formulas envAcc of
                    Ok newEnv -> Just newEnv
                    Err _ -> envAcc
             ) (Just startEnvWithXModel) startDSets
        maybeInitialEnv = startEnvWithFormulas
        initialEnv =
            case maybeInitialEnv of
                Just env -> Ok env
                Nothing -> Err (IncompleteCodeError "Failed to initialize environment")
        initDatasetPages = List.foldl (\dSet dPageAcc ->
            let (dPageModel, _ , _) = DatasetPage.init initialEnv dSet.ref in
            Dict.insert dSet.ref dPageModel dPageAcc
            ) Dict.empty startDSets
        
        initialModel =
            { page = parseUrl url
            , env = initialEnv
            , homeModel = Home.init maybeInitialEnv
            , datasetModels = initDatasetPages
            , key = key
            }
    in
    (initialModel, Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        UrlChanged url ->
            let
                newPage = parseUrl url
            in
            ( { model | page = newPage }, Cmd.none )

        HomeMsg homeMsg ->
            let
                (newHomeModel, homeCmd) = Home.update homeMsg model.homeModel
            in
            ( { model | homeModel = newHomeModel }, Cmd.map HomeMsg homeCmd )

        DatasetMsg datasetName datasetMsg ->
            let
                (newDatasetModel, newEnv, datasetCmd) =
                    case Dict.get datasetName model.datasetModels of
                        Just datasetModel ->
                            DatasetPage.update datasetMsg model.env datasetModel

                        Nothing ->
                            DatasetPage.init model.env datasetName
            in
            -- esegue EvalFormulas senza errori non aggiorna lo spreadsheet
            -- Debug.log ("DatasetMsg for " ++ datasetName ++ Debug.toString datasetMsg) 
            ( 
            { model 
            | env = newEnv 
            , datasetModels = Dict.insert datasetName newDatasetModel model.datasetModels 
            }
            , Cmd.map (DatasetMsg datasetName) datasetCmd
            )

        EnvUpdated newEnv ->
            ( { model | env = newEnv }
            , Cmd.none
            )
        OpenDatasetInNewTab datasetName ->
            let
                url = "/#/dataset/" ++ datasetName
            in
            (model, Ports.openNewTab url)

view : Model -> Browser.Document Msg
view model =
    let
        title =
            let
                modelRef = getModelRefFromEnv model.env
            in
            case model.page of
                HomePage ->
                    "foldBook: " ++ modelRef ++ " Home"   

                DatasetPage datasetName ->
                    "foldSheet: " ++ modelRef ++ " " ++ datasetName
        
        bodyContent =
            case model.page of
                HomePage ->
                    Element.layout [] 
                        (Element.map HomeMsg (Home.view model.homeModel))

                DatasetPage  datasetName ->
                    case Dict.get datasetName model.datasetModels of
                        Just datasetModel ->
                            Element.layout [] 
                                (Element.map (DatasetMsg datasetName) (DatasetPage.view model.env datasetModel))
                            
                        Nothing ->
                            Html.div [] [ Html.text ("Dataset page " ++ datasetName ++ " not found") ]
    in
    { title = title
    , body = [ bodyContent ]
    }

getModelRefFromEnv : Result Error Types.Env -> String 
getModelRefFromEnv env  =
    case env of
        Ok envOk ->
            case envOk.envXModel of
                Just xModel -> xModel.modelRef
                Nothing -> "No modelRef"
        Err _ -> "No env for modelRef"



subscriptions : Model -> Sub Msg
subscriptions model =
    let
        homeSubs =
            Home.subscriptions model.homeModel
                |> Sub.map HomeMsg

        datasetSubs =
            Dict.toList model.datasetModels
                |> List.map (\(datasetName, datasetModel) -> DatasetPage.subscriptions datasetModel |> Sub.map (DatasetMsg datasetName))
    in
    Sub.batch
        (homeSubs::datasetSubs)

onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest urlRequest =
    case urlRequest of
        Browser.Internal url ->
            UrlChanged url

        Browser.External href ->
            UrlChanged (Url.fromString href |> Maybe.withDefault (Url Http "" Nothing "" Nothing Nothing))


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = onUrlRequest
        }
