module Main exposing (..)

import Browser
import Browser.Navigation as Navigation
import Html exposing (Html, div, text)
import Element exposing (..)
import Element.Font exposing (Font)
import Home
import DatasetPage exposing (Msg(..))
import Routes exposing (..)
import Types exposing (..)
import Ports exposing (..)
import Url exposing (Url, Protocol(..))
import Eval.Module as Module
import XModel
import TypesXModel exposing (..)
import FastDict as Dict exposing (Dict)
import AppUtil exposing (cmdMsg)
import CalcEngine exposing (getXModelFromEnv, Msg(..))
import Html.Attributes exposing (default)


type alias Model =
    { page : Routes.Page
    , env : Result Error Types.Env
    , homeModel : Home.Model
    , datasetModels : Dict String DatasetPage.Model
    , key : Navigation.Key
    , counter : Int
    }

type Msg
    = UrlChanged Url
    | HomeMsg Home.Msg
    | DatasetMsg String DatasetPage.Msg
    | EnvUpdated


init : () -> Url -> Navigation.Key -> (Model, Cmd Msg)
init _ url key =
    let
        startEnv = Module.emptyEnvWithCoreFunctions
        defaultXModel = XModel.myXModel
        startXModel = { defaultXModel | datasetsToRecalc = ["Az", "Macro", "Ce"] }
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
                Just env -> Ok { env | msgLine = "init" }
                Nothing -> Err (IncompleteCodeError "Failed to initialize environment")
        initDatasetPages = List.foldl (\dSet dPageAcc ->
            let 
                (dPageModel, pageEnv , pageCmd) = DatasetPage.init initialEnv dSet.ref
            in
            Dict.insert dSet.ref dPageModel dPageAcc
            ) Dict.empty startDSets
        
        initialModel =
            { page = parseUrl url
            , env = initialEnv
            , homeModel = Home.init maybeInitialEnv
            , datasetModels = initDatasetPages
            , key = key
            , counter = 0
            }
    in
    -- Debug.log "called Main.init" <| called also on new tab open but once
    (initialModel, cmdMsg EnvUpdated) -- trigger initial recalc


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
                (envCmd, envWithrecalcMsgLine) = 
                    case newEnv of
                        Ok envOk ->
                            if hasEnvToRecalculate model.env then
                                -- Trigger EnvUpdated action
                                (cmdMsg EnvUpdated
                                , Ok {envOk | msgLine = envOk.msgLine ++ " - Env to recalculate for " ++ datasetName ++ " dataset"}
                                )
                            else
                                (Cmd.none, Ok envOk) --"No env to recalculate for " ++ datasetName ++ " dataset")
                        Err _ ->
                            (Cmd.none, addMsgLine "err Env" newEnv)
                combinedCmds =
                    Cmd.batch ([Cmd.map (DatasetMsg datasetName) datasetCmd] ++ [envCmd])
                
            in
            ( 
            { model 
            | env = envWithrecalcMsgLine
            , datasetModels = Dict.insert datasetName newDatasetModel model.datasetModels 
            }
            , combinedCmds
            )

        EnvUpdated -> -- triggered by parent dataset modification or update formulas
        -- not triggered by child dataset modification (e.g. Ce SaveCell)
            let
                curXModel = getXModelFromEnv model.env |> Maybe.withDefault XModel.emptyXModel
                datasetsToRecalc = curXModel.datasetsToRecalc
                (recalculatedDSetModels, recalculatedEnv, recalcCmds) =
                    List.foldl (\dSetRef (newDSetModels, newEnv, newCmds) -> 
                        case Dict.get dSetRef newDSetModels of
                            Just dSetModel ->
                                let 
                                    (recalcDSetModel, recalcEnv, recalcCmd) = recalculateDataset dSetModel newEnv
                                in
                                (Dict.insert dSetRef recalcDSetModel newDSetModels, recalcEnv, newCmds ++ [recalcCmd])
                            Nothing ->
                                (newDSetModels, newEnv, newCmds)
                        ) (model.datasetModels, model.env, []) datasetsToRecalc
                currentCounter = model.counter +1
                newMsgLine =  " - EnvUpdated nr " ++ String.fromInt currentCounter  ++ " for " ++ Debug.toString datasetsToRecalc ++ " datasets"
            in
            ( { model 
                | env = addMsgLine newMsgLine recalculatedEnv
                , datasetModels = recalculatedDSetModels
                , counter = currentCounter
              }
            , Cmd.batch recalcCmds
            )
addMsgLine : String -> Result Error Env -> Result Error Env
addMsgLine msg env =
    case env of
        Ok envOk ->
            Ok {envOk | msgLine = envOk.msgLine ++ " - " ++ msg}
        Err _ ->
            env
getMsgLine : Result Error Env -> String
getMsgLine env =
    case env of
        Ok envOk -> envOk.msgLine
        Err _ -> "No msgLine for Err Env"
hasEnvToRecalculate : Result Error Env -> Bool
hasEnvToRecalculate env =
    let maybeXModel = getXModelFromEnv env in
    case maybeXModel of
            Just xModel ->
                List.length xModel.datasetsToRecalc > 0
            Nothing ->
                False


-- helper function to recalc changed datasets
recalculateDataset : DatasetPage.Model -> Result Error Env -> (DatasetPage.Model, Result Error Env, Cmd Msg)
recalculateDataset datasetModel env  =
    let
        curCalcModel = datasetModel.calcModel
        datasetRef = curCalcModel.datasetRef
        (finalCalcModel, finalEnv, finalCmd) =
            case env of
                Ok validEnv ->
                    let 
                        (newCalcModel, newEnv, newCmd) = CalcEngine.update EvalFormulas curCalcModel (Ok validEnv)
                        remappedNewCmd = Cmd.map DatasetPage.CalcMsg newCmd
                        remappedNewCmd2 = Cmd.map (DatasetMsg datasetRef) remappedNewCmd
                    in
                    (newCalcModel, newEnv, remappedNewCmd2)
                Err _ ->
                    (curCalcModel, env, Cmd.none)
        finalDatasetModel = { datasetModel 
                    | calcModel = finalCalcModel 
                    }   
    in
            (finalDatasetModel, finalEnv, finalCmd)




view : Model -> Browser.Document Msg
view model =
    let
        title =
            let
                modelRef = getXModelRefFromEnv model.env
            in
            case model.page of
                HomePage ->
                    "foldBook: " ++ modelRef ++ " Home"   

                DatasetPage datasetName ->
                    "foldSheet: " ++ modelRef ++ " " ++ datasetName
        
        bodyContent =
            case model.page of
                HomePage ->
                        (Element.map HomeMsg (Home.view model.homeModel))

                DatasetPage datasetName ->
                    case Dict.get datasetName model.datasetModels of
                        Just datasetModel ->
                            column [] 
                                [ msgLine model 
                                , Element.map (DatasetMsg datasetName) 
                                    (DatasetPage.view model.key model.env datasetModel)
                                
                                ]
                            
                        Nothing ->
                            el [] (Element.text ("Dataset page " ++ datasetName ++ " not found") )

    in
    { title = title
    , body = [ ( Element.layout [] bodyContent)
             ]
    }

msgLine : Model -> Element Msg
msgLine model =
    Element.paragraph [] [(Element.text ("\n" ++ getMsgLine model.env ++ "\n"))]

getXModelRefFromEnv : Result Error Types.Env -> String 
getXModelRefFromEnv env  =
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
