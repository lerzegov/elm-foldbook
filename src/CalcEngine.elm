module CalcEngine exposing (CallTreeZipper, Model, Msg(..)
                ,initialModel, update, viewCommands, viewConsole, getXModelFromEnv, setXModelToEnv
                ,updateEnvFromXModel, getLhsExpressions, getEnvFunctions, getExprDataArray)
-- modified by Luca, disabled callTree and logLines to avoid clutter
-- INTEGRATED XArrayEngine -----------------------------------------

-- TODO:
-- 1. try to use FuncDataArray in the Kernel
-- 2. align funcDataArrayPair in XModel FuncDataArray in order to work without passing the xModel

import Element exposing (Attribute, Element
        , alignBottom, alignRight, alignTop, column, el
        , fill, height, paragraph, px, row, shrink, text, width
        , fillPortion)
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Lazy
import Elm.Parser
import Elm.Syntax.Declaration as Declaration
import Elm.Syntax.Expression as Expression
import Elm.Syntax.Node as Node exposing (Node(..))
import Elm.Syntax.Pattern as Pattern
import Elm.Syntax.Range exposing (Location)
import Eval
import Eval.Module as Module
import Eval.Types as Types
import Expression.Extra
import Hex
import Html
import Json.Encode
import List.Extra
import Rope
import Types exposing (CallTree(..), Error(..), Value(..), Env, Eval)
import UI.Source as Source
import UI.Theme as Theme
import Value
import FastDict as Dict exposing (Dict)
import Array exposing (Array)
import TypesXModel exposing (..)
import XModel
import List exposing (partition)
import FastDict as Dict exposing (Dict)
import AppUtil exposing (cmdMsg, myLog)
import Debug exposing (log)
import Array exposing (get)
import Core.Basics exposing (le)
import Maybe.Extra exposing (prev)




type Msg
    = Input String
    | EvalFormulas
    | EvalFormula String (List String)-- DatasetRef not needed, is prepended to the expression before __
    | UpdateFormulas
    | Focus
        { parent : Maybe CallTreeZipper
        , current : CallTree
        }
    | NoOp


type alias Model = -- data for calculation process
    { datasetRef : DatasetRef
    , input : String -- code in the console
    , parsed : Maybe (Node Expression.Expression)
    , output : Result String String
    , countUpdates : Int
    , callTrees : List CallTree
    , logLines : List String
    , focus : Maybe CallTreeZipper
    -- added by Luca
    -- , env : Result Error Types.Env -- moved to Main.elm
    , pendingExpressions : List String
    , log : String
    , dependentDatasetRefs : List DatasetRef
    }



-- evalWithEnv works only with whole module defined in console with main expression
-- eval works also with only expression in console

-- testing my change of evalRecordUpdate keeping all the record fields not only the updated ones
-- Module is name must be datasetRef


initialModel : Result Error Env -> DatasetRef -> Model
initialModel env datasetRef =
    let 
        initSource = case getXModelFromEnv env of
            Just xModel -> 
                case Dict.get datasetRef xModel.datasets of
                    Just dataset -> 
                        dataset.formulas
                    Nothing -> ""
            Nothing -> ""
        initParsed = Nothing -- tryParse initSource -- disabled by Luca not relevant
        initEnv = env
        initOutput = case initEnv of
            Ok okEnv -> Ok ("Initial model, Ok, for dataset " ++ datasetRef )
            Err error -> Err (Types.errorToString error)
    in
    -- Debug.log ("initialModel for dataset: " ++ datasetRef ) <|
    { datasetRef = datasetRef
    , input = initSource -- initial code in the console
    , parsed = initParsed -- disabled by Luca
    , output = initOutput
    , countUpdates = 0
    , callTrees = []
    , logLines = []
    , focus = Nothing
    , pendingExpressions = []
    , log = ""
    , dependentDatasetRefs = []
    }
-- issue: editing the input in the console causes the env to be reset to Nothing
-- so I lose the computed values in previous evaluations
reinit : Model -> Result Error Env -> String -> (Model, Result Error Env, Cmd Msg)
reinit model prevEnv input =
    -- Debug.log ("reinit model: " ++ Debug.toString input) <|
    if String.endsWith "\n\n" input then
        let
            curEnv : Maybe Env
            curEnv = case prevEnv of
                Ok env -> Just env
                Err _ -> Nothing
            initSource = input
            initParsed = Nothing -- tryParse initSource -- disabled not relevant
            initEnv = makeCalcEnv initSource curEnv
            (initOutput, initDatasetRef)  = case initEnv of
                Ok env -> (Ok ("Reinit model, parsed = " ++ Debug.toString initParsed)
                                , env.currentModule |> List.head |> Maybe.withDefault ""
                                )
                Err error -> (Err (Types.errorToString error), "")
            
        in
    -- input is the code to be executed, converted to a default module with a main function
    -- or itself as a module if it starts with "module" wich may contain
    -- a main function or not plus other functions and expression
    -- see examples in strings passed to init
    -- in my refactoring module must be defined in the input, toModule does not work
       -- Debug.log ("reinit input: ")
       ( { datasetRef = initDatasetRef
        , input = initSource 
        -- gets the expression of the main function, 
        -- only to pass to viewParsed and display it in the "Parsed as" box
        , parsed = initParsed -- disabled by Luca
        , output = initOutput -- the result of the evaluation
        , countUpdates = 0
        , callTrees = []
        , logLines = []
        , focus = Nothing
        -- calls Module.buildInitialEnv that calls values = XModel.createTestEnvValues
        , pendingExpressions = []
        , log = ""
        , dependentDatasetRefs = []
        }
        , initEnv
        , Cmd.none )
    else -- code is not executable
        ({ datasetRef = ""
        , input = input 
        -- gets the expression of the main function, 
        -- only to pass to viewParsed and display it in the "Parsed as" box
        , parsed = Nothing -- tryParse input -- disabled by Luca
        , output = Ok "" -- the result of the evaluation
        , countUpdates = 0
        , callTrees = []
        , logLines = []
        , focus = Nothing
        , pendingExpressions = []
        , log = ""
        , dependentDatasetRefs = []
        }
        , Err (IncompleteCodeError "Code not executable")
        , Cmd.none
        )

initializeEvaluation : Model -> List String -> Model
initializeEvaluation model expressions =
    { model | pendingExpressions = expressions }

-- viewConsole : Model -> Element Msg
-- viewConsole model =
--     let
--         moduleSource : String
--         moduleSource =
--             if String.startsWith "module " model.input then
--                 model.input

--             else
--                 Eval.toModule model.input
--     in
--     Theme.column []
--     [ Theme.row [ width fill]
--         [ viewInput model
--         -- , ( viewSource moduleSource model)
--         , viewCommands 
--         ]
--     , Theme.row [width fill ]
--             [ (viewOutput model.output model.countUpdates) ]
--                     -- callTrees or none if empty
--                     -- , viewCallTrees model.callTrees

--     ]
viewConsole : Model  -> Element Msg
viewConsole model  =
    column []
        [ viewOutput model.output model.countUpdates
        , ( viewSource model.input model)
        ]

-- substituted by viewConsole
viewInput : Model -> Element Msg
viewInput model =
        Theme.column
            [ Theme.padding
            , width (px 1000) --<| fillPortion 30
            ]
            -- textbox for code input
            [ Theme.box "Input" 
                [ width fill, Font.size 20 ]
                [ Input.multiline
                    [ width fill
                    , monospace
                    , Font.size 14
                    ]
                    { spellcheck = False
                    , text = model.input -- input box linked to model.input
                    , onChange = Input -- update action
                    , label = Input.labelHidden "Input"
                    , placeholder = Nothing
                    }
                ]
            ]
viewCommands : Element Msg
viewCommands  =
        Theme.boxRow "Commands" [width <| fillPortion 1, alignTop] <|
                [ Theme.button []
                    { onPress = Just (EvalFormulas) -- to force the update of the dataset
                    , label = text <| "Eval formulas" -- ++ toRun
                    }
                , Theme.button []
                    { onPress = Just (UpdateFormulas ) -- to force the update of the dataset
                    , label = text <| "Update formulas" -- ++ toRun
                    }
                ]

-- displays the result of the evaluation from model.output
-- passed as `o`
viewOutput : Result String String -> Int -> Element Msg
viewOutput output countUpdates =
    case output of
        Ok "" ->
            Element.none

        Ok o ->
            paragraph
                [ width fill 
                --Theme.style "max-width" ("calc(100vw - " ++ String.fromInt (2 * Theme.rythm) ++ "px)")
                , Border.width 1
                , Theme.padding
                , alignTop
                ]
                [ el [ Font.bold ] <| text "Result: "
                , el [ monospace ] <| text ((String.fromInt countUpdates) ++ "\n" ++ o) -- here `o` is displayed
                ]

        Err e ->
            e
                |> String.split "\n"
                |> List.map (\line -> paragraph [] [ text line ])
                |> Theme.box "Errorazzo" []



viewSource : String -> Model ->  Element Msg
viewSource moduleSource model =
            -- commented source code, trees and logLines to avoid clutter:
            -- source code syntax highlighted and parsed as Elm
    Theme.wrappedRow [ width fill ]
            [ Element.Lazy.lazy viewParsed model.parsed
            , if moduleSource == model.input then
                Element.none -- don't show the full source if the input is already a module
                            -- a valid module will be parsed and shown in the "Parsed as" box

            else
                Theme.box "Full source"
                    [ width fill ]
                    [ Source.view [] -- see Source.elm complex source parsing and highlighting
                        { highlight = Nothing
                        , buttons = []
                        , source = moduleSource
                        }
                    ]
            ]


    
            
        
-- in component must add xModel to update in order to send/receive xModel to/from XModelEngine
-- no need to add it in Main, it is already thereupdate : Msg -> Model -> XModel -> (Model, XModel, Cmd Msg)
update : Msg -> Model -> Result Error Env -> (Model, Result Error Env , Cmd Msg)
update msg model prevEnv =
    case msg of
        EvalFormulas ->
            let
                datasetRef = model.datasetRef
                lhsExpressions = getLhsExpressions prevEnv datasetRef |> Result.withDefault []
                modelWithExpressions = initializeEvaluation model lhsExpressions
                prevXModel = getXModelFromEnv prevEnv |> Maybe.withDefault XModel.emptyXModel
                updatedDatasetsToRecalc = -- clear recalc flag in xModel before starting the evaluation
                    List.filter (\dRef -> dRef /= datasetRef) prevXModel.datasetsToRecalc
                        -- ++ model.dependentDatasetRefs -- moved to calcExpressionToXModel
                updatedXModelCleared = { prevXModel | datasetsToRecalc = updatedDatasetsToRecalc }
                clearedEnv = setXModelToEnv prevEnv updatedXModelCleared
                startLog = "Evaluating formulas\n"
            in
            -- Debug.log ("datasetsToRecalc: " ++ Debug.toString updatedDatasetsToRecalc ++ "\n ") <| -- ++ "LHS: " ++ Debug.toString lhsExpressions ) <|
            case lhsExpressions of
                firstExpression :: restExpressions ->
                    let
                        nextMsg = EvalFormula firstExpression restExpressions
                    in
                    ( { modelWithExpressions | log = startLog }
                    , clearedEnv, Cmd.batch [Cmd.none, cmdMsg  nextMsg])
                [] ->
                    (model, prevEnv, Cmd.none)

        EvalFormula expression remainingExpressions ->
            let
                newLog = model.log ++ "EvalFormula expr: " ++ expression ++ "\n"
                            -- ++ "Remaining expressions: " ++ Debug.toString remainingExpressions ++ "\n"
                (newModel, newEnv) = calcExpressionToXModel model.input expression model prevEnv

                nextCmd =
                    case remainingExpressions of
                        nextExpression :: rest ->
                            cmdMsg (EvalFormula nextExpression rest)
                        [] ->
                            Cmd.none
            in
            -- Debug.log ("EvalFormula: " ++ newLog)
            ( { newModel | pendingExpressions = remainingExpressions, log = newLog, output = Ok newLog}
            , newEnv
            , Cmd.batch [Cmd.none, nextCmd] ) -- Cmd.none added as in EvalFormulas seems not to be needed

        UpdateFormulas  -> -- remakes env, updates formulas for dataset in xModel and env, and recalculates the dataset
            let
                updatedFormulas = model.input
                newEnv = case prevEnv of
                    Ok env -> 
                        makeCalcEnv updatedFormulas (Just env)
                    Err error -> Err error
                curXModel = getXModelFromEnv newEnv |> Maybe.withDefault XModel.emptyXModel
                curDataset = Dict.get model.datasetRef curXModel.datasets |> Maybe.withDefault XModel.emptyDataset
                updatedDataset = { curDataset | formulas = updatedFormulas }
                updatedXModel = { curXModel 
                    | datasets = Dict.insert model.datasetRef updatedDataset curXModel.datasets 
                    }
                updatedEnv = setXModelToEnv newEnv updatedXModel
            in
            case updatedEnv of
                Ok okEnv -> 
                    ( {model | log = "Updating formulas " }
                    , updatedEnv
                    , cmdMsg (EvalFormulas ) )
                Err error -> 
                    ( { model | output = Err (Types.errorToString error) }
                    , prevEnv
                    , Cmd.none )

        Input input -> -- no update of formulas in xModel
            reinit model prevEnv input

        Focus focus ->
            ({ model | focus = Just (CallTreeZipper focus) }, prevEnv, Cmd.none)
        NoOp ->
            (model, prevEnv, Cmd.none)
makeCalcEnv : String -> Maybe Env -> Result Error Env
makeCalcEnv source curEnv  =
    let
        newEnv = Module.makeEnv source curEnv 
        curXmodel = getXModelFromEnv newEnv |> Maybe.withDefault XModel.emptyXModel

        updatedXModel = 
            Dict.foldl (\datasetRef dataset accXModel ->
                let
                    dSetFormulas = getFormulasForDSetRef datasetRef newEnv
                    curDataset = dataset
                    updatedDataset = updatePointedFormulasForDSet curXmodel curDataset dSetFormulas
                in
                { accXModel | datasets = Dict.insert datasetRef updatedDataset accXModel.datasets }
                ) curXmodel curXmodel.datasets
        updatedEnv = setXModelToEnv newEnv updatedXModel
    in
    updatedEnv

getFormulasForDSetRef : DatasetRef -> Result Error Env -> List String
getFormulasForDSetRef datasetRef  resEnv =
    case resEnv of
        Ok env ->
            case Dict.get [datasetRef] env.functionsInFormulas of
                Just funcDict ->
                    funcDict.functionCalcOrder
                Nothing ->
                    []
        Err _ ->
                    []
getXModelFromEnv : Result Error Env -> Maybe XModel
getXModelFromEnv envModelField  = 
            case envModelField of 
                Ok curEnvOk ->
                    curEnvOk.envXModel
                Err err -> Nothing

setXModelToEnv : Result Error Env -> XModel -> Result Error Env
setXModelToEnv envModelField xModel = 
            case envModelField of 
                Ok curEnvOk ->
                    let
                        updatedEnv = { curEnvOk | envXModel = Just xModel }
                    in
                    Ok updatedEnv
                Err err -> Err err

getLhsExpressions : Result Error Env -> DatasetRef -> Result Error (List String)
getLhsExpressions envModelField datasetRef = 
            case envModelField of 
                Ok curEnvOk ->
                    let
                        funcList = Dict.get [datasetRef] curEnvOk.functionsInFormulas
                            |> Maybe.andThen (\funcDict -> Just funcDict.functionCalcOrder)
                            |> Maybe.withDefault []

                    in
                    if List.isEmpty funcList then
                        Err (IncompleteCodeError "Empty functions in envModelField")
                    else
                        Ok funcList
                Err err -> Err err

getEnvFunctions : Result Error Env -> DatasetRef -> Maybe (Dict String Expression.FunctionImplementation)
getEnvFunctions envModelField datasetRef = 
            case envModelField of 
                Ok curEnvOk ->
                    let
                        funcList = Dict.get [datasetRef] curEnvOk.functions

                    in
                    funcList
                Err _ -> Nothing

-- used to get the dataArray for LHS expressions, without data if they are not calculated yet
type DArOrFuncName = DAr DataArray | FuncName String
getExprDataArray : Maybe XModel -> DatasetRef -> String -> Result String DArOrFuncName
getExprDataArray maybeXModel curDatasetRef expression = 
    case maybeXModel of
        Nothing -> Err "No XModel in getExprDataArray"
        Just xModel ->
            let
                retRangeDef = XModel.rangeNameToDef xModel curDatasetRef expression
            in
            case retRangeDef of
                    Ok rangeDef ->
                        case (rangeDef.datasetRef, rangeDef.dataArrayRef, rangeDef.dimCoords) of
                            (Just datasetRef, Just dataArrayRef, Just []) ->
                                case XModel.getDataArrayWithDimsFromXModel xModel datasetRef dataArrayRef of
                                    Just parsedArray -> Ok (DAr parsedArray)
                                    Nothing -> "DataArray not found in getExprDataArray"  |> Err
                            (Just datasetRef, Just dataArrayRef, Just dimCoordTuples) ->
                                     case XModel.locDataArrayfromRangeDef maybeXModel datasetRef dataArrayRef dimCoordTuples of
                                        Just parsedArray -> Ok (DAr parsedArray)
                                        _ -> Err "loc on DataArray failed in getExprDataArray"
                            (_, _, _) ->
                                Err "other error in getExprDataArray from rangeNameToDef"
                    Err errMsg ->
                        -- Err ("Error in getExprDataArray from rangeNameToDef: " ++ errMsg)
                        Ok (FuncName expression)
updatePointedFormulasForDSet : XModel -> Dataset -> List String -> Dataset
updatePointedFormulasForDSet xModel dataset formulaList =
    let
        -- Clear the pointedFormulas for all data arrays in the dataset
        clearedDArs = 
            Dict.foldl (\dArRef dAr accDict ->
                Dict.insert dArRef { dAr | pointedFormulas = Dict.empty } accDict
                ) Dict.empty dataset.dataArrays
        clearedDataset = 
            { dataset 
            | dataArrays = clearedDArs
            }

        -- Update the pointedFormulas for each formula in the formulaList
        finalDataset = 
            List.foldl (\formula accDataset ->
                let
                    prevDArray = Dict.get dArRef accDataset.dataArrays |> Maybe.withDefault XModel.emptyDataArray
                    (dArRef, pointedDict) = updatePointedFormulasForExpr 
                        (Just xModel) dataset.ref formula Dict.empty
                    mergedDict = Dict.union prevDArray.pointedFormulas pointedDict
                    updatedDArray = { prevDArray | pointedFormulas = mergedDict }
                    updatedDataset = { accDataset | dataArrays = Dict.insert dArRef updatedDArray accDataset.dataArrays }
                in
                updatedDataset 
            ) clearedDataset formulaList
    in
    finalDataset


updatePointedFormulasForExpr : Maybe XModel -> DatasetRef -> String -> Dict Int String 
    -> (DataArrayRef, Dict Int String)
updatePointedFormulasForExpr maybeXModel curDatasetRef expression prevPointedFormulas  = 
    case maybeXModel of
        Nothing -> ("", Dict.empty)
        Just xModel ->
            let
                resLocArray = getExprDataArray maybeXModel curDatasetRef expression
                okLocArray = case resLocArray of
                    Ok (DAr dataArray) -> dataArray
                    _ -> XModel.emptyDataArray
                fullArray = XModel.getDataArrayWithDimsFromXModel xModel curDatasetRef okLocArray.ref
                flatIndicesToPoint = 
                    case fullArray of
                        Just fullArrayJust ->
                            XModel.mapFlatIndices okLocArray fullArrayJust
                        Nothing -> Array.empty
                updatedPointedFormulasDict =
                    Array.foldl (\flatIndex accDict ->
                        Dict.insert flatIndex expression accDict
                        ) prevPointedFormulas flatIndicesToPoint
            in
            (okLocArray.ref, updatedPointedFormulasDict)



-- to solve no recalc added envWithCoreFunctions to main.Init 
-- and added moduleFromDataset to calcExpressionToXModel in Module.evalModuleWithEnv
calcExpressionToXModel : String -> String -> Model -> Result Error Env -> (Model, Result Error Env)
calcExpressionToXModel moduleSource expression curModel prevEnv =
    let
        curXModel = getXModelFromEnv prevEnv |> Maybe.withDefault XModel.emptyXModel

        curDatasetRef = curModel.datasetRef
        -- get the LHS of the formula as a DataArray with data as before calc
        exprDataArrayOrFunc = getExprDataArray (Just curXModel) curDatasetRef expression
        moduleFromDataset = curDatasetRef -- module name is the datasetRef, both capitalized

        -- handle result of getExprDataArray if it is a structured dataArray reference
        retModelEnv  = case exprDataArrayOrFunc of
            Ok dataArrayOrFunc ->
                let
                    -- trigger the evaluation of the expression and get result plus logging and trace info
                    ( result, callTree, logLines ) =
                        Module.evalModuleWithEnv
                            "" -- moduleSource => not passed to avoid repeated useless parsing
                            (Expression.FunctionOrValue [moduleFromDataset] expression)
                            prevEnv
                    -- preliminary trace of the callTree
                    callTrees : List CallTree
                    callTrees = Rope.toList callTree
                    updatedModelWithTrace =
                        { curModel 
                        | countUpdates = curModel.countUpdates + 1
                        , callTrees = callTrees
                        , logLines = Rope.toList logLines
                        , focus =
                            case callTrees of
                                [ tree ] -> Just (CallTreeZipper { parent = Nothing, current = tree })
                                _ -> Nothing
                        }
                    -- main calc loop
                    (calcUpdatedModel, calcUpdatedEnv)  = 
                        case dataArrayOrFunc of
                            FuncName funcName -> -- managed non dataArray references (PROVISIONAL)
                                case result of
                                    Ok (List listValue) ->
                                        let
                                            depDSetRefs = 
                                                if funcName == "dependentDatasetRefs" then
                                                    XModel.valueToStrList (List listValue)
                                                else
                                                    []
                                            updatedDSetsToRecalc = curXModel.datasetsToRecalc ++ depDSetRefs
                                            updatedXModel = { curXModel | datasetsToRecalc = updatedDSetsToRecalc }
                                            updatedEnv = setXModelToEnv prevEnv updatedXModel
                                        in
                                        -- Debug.log ("depDSetRefs: " ++ Debug.toString depDSetRefs) <|
                                        ({ updatedModelWithTrace | dependentDatasetRefs = depDSetRefs }
                                        , updatedEnv)
                                    _ -> (updatedModelWithTrace , prevEnv)
                            DAr dataArray ->
                                case result of -- result may wrap a structured dataArray reference
                                    -- TODO add cases for singleton results and external dataarray
                                    --      that is not currently remapped
                                    Ok (Float floatValue) ->
                                        let
                                            expandedArray = Array.repeat (dataArray.data |> Array.length) floatValue
                                            updatedDataArray = { dataArray | data = expandedArray }
                                            updatedEnv = updateEnvFromDa updatedDataArray prevEnv
                                        in
                                        ({ updatedModelWithTrace | log = "Float result: " ++ Debug.toString floatValue ++ "\n" }
                                        , updatedEnv)
                                    Ok (Int intValue) ->
                                        let
                                            floatValue = toFloat intValue
                                            expandedArray = Array.repeat (dataArray.data |> Array.length) floatValue
                                            updatedDataArray = { dataArray | data = expandedArray }
                                            updatedEnv = updateEnvFromDa updatedDataArray prevEnv
                                        in
                                        ({ updatedModelWithTrace | log = "Float result: " ++ Debug.toString floatValue ++ "\n" }
                                        , updatedEnv)
                                    Ok (JsArray jsArrayValue) -> -- TODO how to express in formulas??
                                        let
                                            calculatedArray = XModel.valueToFloatArray (JsArray jsArrayValue)

                                            calculatedArLen = Array.length calculatedArray |> toFloat
                                            destArLen = XModel.calcDataLengthFromDims dataArray
                                                |> Maybe.withDefault 0 |> toFloat
                                            errorRetFloat = 0/0 --calculatedArLen*1000 + destArLen
                                        in
                                    -- Debug.log ("List value: " ++ Debug.toString listValue) <|
                                        if calculatedArLen /= destArLen then
                                            let 
                                                errorReturnDataArray = { dataArray | data = Array.repeat (Array.length dataArray.data) errorRetFloat }
                                                updatedEnv = updateEnvFromDa errorReturnDataArray prevEnv
                                                curLog = "Error: calculated array length " ++ (Array.length calculatedArray |> Debug.toString) ++ " differs from dataArray length " ++ (Array.length dataArray.data |> Debug.toString)
                                            in
                                            ({ updatedModelWithTrace | log = curLog }
                                            , updatedEnv)
                                        else
                                            let
                                                updatedDataArray = { dataArray | data = calculatedArray }
                                                updatedEnv = updateEnvFromDa updatedDataArray prevEnv
                                            in
                                            ({ updatedModelWithTrace | log = "JsArray updated\n" }
                                            , updatedEnv)
                                    Ok (List listValue) ->
                                        let
                                            calculatedArray = XModel.valueToFloatArray (List listValue)
                                            calculatedArLen = Array.length calculatedArray |> toFloat
                                            destArLen = XModel.calcDataLengthFromDims dataArray
                                                |> Maybe.withDefault 0 |> toFloat
                                            errorRetFloat = 0/0 --calculatedArLen*1000 + destArLen
                                        in
                                    -- Debug.log ("List value: " ++ Debug.toString listValue) <|
                                        if calculatedArLen /= destArLen then
                                            let 
                                                errorReturnDataArray = { dataArray | data = Array.repeat (Array.length dataArray.data) errorRetFloat }
                                                updatedEnv = updateEnvFromDa errorReturnDataArray prevEnv
                                                curLog = "Error: calculated array length " ++ (Array.length calculatedArray |> Debug.toString) ++ " differs from dataArray length " ++ (Array.length dataArray.data |> Debug.toString)
                                            in
                                            ({ updatedModelWithTrace | log = curLog }
                                            , updatedEnv)
                                        else
                                            let
                                                updatedDataArray = { dataArray | data = calculatedArray }
                                                updatedEnv = updateEnvFromDa updatedDataArray prevEnv
                                            in
                                            ({ updatedModelWithTrace | log = "JsArray updated\n" }
                                                , updatedEnv)
                                    Ok (DataAr calcDataArValue) ->
                                        let
                                            calculatedDAr = XModel.valueToDataArray (DataAr calcDataArValue)
                                            -- fix the datasetRef and localDims of the calculated DataArray to the computed LHS
                                            calculatedDArRenamed = { calculatedDAr 
                                                | ref = dataArray.ref
                                                , datasetRef = Just curModel.datasetRef -- dataset currently calculated
                                                , localDims = dataArray.localDims
                                                , localDimRefs = dataArray.localDimRefs }
                                            updatedEnv = updateEnvFromDa calculatedDArRenamed prevEnv
                                        in
                                        ({ updatedModelWithTrace | log = "DataAr updated\n" }
                                        , updatedEnv)
                                    
                                    Ok _ ->
                                        let curLog = "Unmanaged Ok _: " ++ Debug.toString result
                                        in 
                                        ({ updatedModelWithTrace | log = curLog ++ "\nResult value is not a structured dataArray reference\n"}
                                        , prevEnv)
                                    Err error -> 
                                        ({ updatedModelWithTrace | log = curModel.log ++ "\nErr case of Result  => " ++ (Types.errorToString error)  ++ "\n" }
                                        , prevEnv)
                in
                -- Debug.log ("Result for expression " ++ expression ++ ": " ++ Debug.toString result) <|
                (calcUpdatedModel, calcUpdatedEnv) 
            Err err ->
                ({ curModel | output = Err (err ++ ", or no RangeName") }, prevEnv)
    in
    retModelEnv
-- create to handle result /= DataAr, generalized to DataAr after testing
-- add error management in Result here also to avoid updates with no data change
updateEnvFromDa : DataArray -> Result Error Env ->  Result Error Env
updateEnvFromDa calculatedDArRenamed prevEnv =
    let
        -- convert the calculated DataAr value to an XModel.DataArray
        -- force to String
        curXModel = getXModelFromEnv prevEnv |> Maybe.withDefault XModel.emptyXModel
        datasetRef = calculatedDArRenamed.datasetRef |> Maybe.withDefault "" -- taken from prev step
        arRef = calculatedDArRenamed.ref -- calc destination dataArrayRef
        dataset = Dict.get datasetRef curXModel.datasets |> Maybe.withDefault XModel.emptyDataset -- containing dataset
        -- cannot use dataArray from above? no, it is a range dataArray, not a full dataArray
        daToUpdate = Dict.get arRef dataset.dataArrays |> Maybe.withDefault XModel.emptyDataArray
        updatedDArResult = XModel.updateDataArrayPair curXModel 
            (Ok daToUpdate) (Ok calculatedDArRenamed) XModel.refreshWithValPart
        updatedDAr = updatedDArResult |> Result.withDefault XModel.emptyDataArray
        updatedArrays = Dict.insert arRef updatedDAr dataset.dataArrays
        updatedDataset = { dataset | dataArrays = updatedArrays }
        updatedDatasets = Dict.insert datasetRef updatedDataset curXModel.datasets
        updatedXModelFromDa = { curXModel 
                    | datasets = updatedDatasets 
                }
        updatedEnvFromDa = updateEnvFromXModel prevEnv updatedXModelFromDa

    in 
    -- Debug.log ("dArRenamed.ref: " ++ Debug.toString arRef) <|
    if curXModel /=  XModel.emptyXModel || dataset /= XModel.emptyDataset then
        updatedEnvFromDa
    else 
       prevEnv

-- returns the expression of the main function calling findMain
-- not interesting for code validation, shows the implementation of the main function
tryParse : String -> Maybe (Node Expression.Expression)
tryParse input =
    let
        fixedInput : String
        fixedInput =
            if String.startsWith "module" input then
                input

            else
                Eval.toModule input
    in
    fixedInput
        |> Elm.Parser.parseToFile
        |> Result.toMaybe
        |> Maybe.andThen
            (\file ->
                file.declarations
                    |> List.Extra.findMap (Node.value >> findMain)
            )

-- returns the expression of the main function
findMain : Declaration.Declaration -> Maybe (Node Expression.Expression)
findMain declaration =
    case declaration of
        Declaration.FunctionDeclaration function ->
            let
                implementation : Expression.FunctionImplementation
                implementation =
                    Node.value function.declaration
            in
            if Node.value implementation.name == "main" then
                Just implementation.expression

            else
                Nothing

        _ ->
            Nothing


resultToString : Result Error Value -> Result String String
resultToString result =
    case result of
        Ok value ->
            Ok <| Value.toString value

        Err e ->
            Err <| Types.errorToString e

resultToPlainString : Result Error Value -> String
resultToPlainString result =
    case result of
        Ok value ->
            Value.toString value  -- Convert the Value to a String directly

        Err _ ->
            ""  -- Return an empty string in case of an error

-- no longer used with calc on xModel
updateEnvFromXModel : Result Error Env -> XModel -> Result Error Env
updateEnvFromXModel prevEnv xModel =
    let
        updatedEnv : Result Error Types.Env
        updatedEnv = case prevEnv of
            Ok envRec ->
                let
                    updatedEnvRec = { envRec | envXModel = Just xModel }
                in
                Ok updatedEnvRec
            Err _ -> prevEnv
    in
    updatedEnv

-- TRACING AND DEBUGGING FUNCTIONS
-- DISABLED BY LUCA
type CallTreeZipper
    = CallTreeZipper
        { parent : Maybe CallTreeZipper
        , current : CallTree
        }

viewCallTrees : List CallTree -> Element Msg
viewCallTrees =
    Element.Lazy.lazy <|
        \callTrees ->
            if List.isEmpty callTrees then
                Element.none

            else
                Theme.box "Call tree" [] <|
                    [ callTrees
                        |> List.map
                            (\callTree ->
                                focusButton []
                                    { parent = Nothing
                                    , current = callTree
                                    , child = Nothing
                                    }
                            )
                        |> Theme.wrappedRow [ width fill ]
                    ]


focusButton :
    List (Attribute Msg)
    ->
        { parent : Maybe CallTreeZipper
        , current : CallTree
        , child : Maybe CallTree
        }
    -> Element Msg
focusButton attrs zipper =
    Theme.button (monospace :: attrs)
        { label = viewNode zipper.current zipper.child
        , onPress =
            Just <|
                Focus
                    { parent = zipper.parent
                    , current = zipper.current
                    }
        }


viewParsed : Maybe (Node Expression.Expression) -> Element Msg
viewParsed maybeExpr =
    case maybeExpr of
        Nothing ->
            Element.none

        Just expr ->
            Theme.box "Parsed as" [] <|
                [ el [ monospace ] <|
                    viewExpression expr
                ]


monospace : Attribute msg
monospace =
    Font.family
        [ Font.typeface "Fira Code"
        , Font.monospace
        ]

-- recursive expression composition returning an Element msg
viewExpression : Node Expression.Expression -> Element msg
viewExpression (Node _ expr) =
    case expr of
        Expression.OperatorApplication name _ l r ->
            boxxxy_ name [ viewExpressions [ l, r ] ]

        Expression.FunctionOrValue moduleName name ->
            boxxxy0 <| String.join "." (moduleName ++ [ name ])

        Expression.Application children ->
            boxxxy_ "Application" [ viewExpressions children ]

        Expression.Literal s ->
            boxxxy0 <| Json.Encode.encode 0 <| Json.Encode.string s

        Expression.Integer i ->
            boxxxy0 <| String.fromInt i

        Expression.Floatable f ->
            boxxxy0 <| String.fromFloat f

        Expression.CharLiteral c ->
            boxxxy0 <| "'" ++ String.fromChar c ++ "'"

        Expression.Hex i ->
            boxxxy0 <| "0x" ++ Hex.toString i

        Expression.LetExpression { declarations, expression } ->
            boxxxy_ "let/in"
                [ row [] <| List.map viewLetDeclaration declarations
                , viewExpression expression
                ]

        Expression.UnitExpr ->
            boxxxy0 "()"

        Expression.Negation expression ->
            boxxxy_ "-" [ viewExpression expression ]

        Expression.PrefixOperator name ->
            boxxxy0 <| "(" ++ name ++ ")"

        Expression.Operator name ->
            boxxxy0 <| "(" ++ name ++ ")"

        Expression.ParenthesizedExpression expression ->
            boxxxy_ "()" [ viewExpression expression ]

        Expression.IfBlock c t f ->
            boxxxy [ text "if ", viewExpression c, text " then" ]
                [ row []
                    [ viewExpression t
                    , el [ alignTop ] <| text " else "
                    , viewExpression f
                    ]
                ]

        Expression.TupledExpression children ->
            boxxxy_
                (if List.length children == 2 then
                    "(,)"

                 else
                    "(,,)"
                )
                [ viewExpressions children ]

        Expression.ListExpr children ->
            boxxxy_ "[]" [ viewExpressions children ]

        Expression.RecordAccess chil (Node _ name) ->
            boxxxy_ "." [ row [] [ viewExpression chil, text <| " " ++ name ] ]

        Expression.RecordUpdateExpression (Node _ name) setters ->
            boxxxy_ ("{ " ++ name ++ " | }") [ viewSetters setters ]

        Expression.RecordExpr setters ->
            boxxxy_ "{}" [ viewSetters setters ]

        Expression.RecordAccessFunction name ->
            boxxxy0 name

        Expression.GLSLExpression code ->
            boxxxy_ "glsl" [ boxxxy0 code ]

        Expression.CaseExpression _ ->
            boxxxy0 "branch 'CaseExpression _' not implemented"

        Expression.LambdaExpression _ ->
            boxxxy0 "branch 'LambdaExpression _' not implemented"


viewSetters : List (Node Expression.RecordSetter) -> Element msg
viewSetters setters =
    row [] (List.map viewSetter setters)


viewSetter : Node Expression.RecordSetter -> Element msg
viewSetter (Node _ ( Node _ name, value )) =
    boxxxy_ (name ++ " =") [ viewExpression value ]


boxxxy0 : String -> Element msg
boxxxy0 name =
    el
        [ alignTop
        , Border.width 1
        , Theme.padding
        ]
        (text name)


boxxxy_ : String -> List (Element msg) -> Element msg
boxxxy_ name children =
    boxxxy [ text name ] children


boxxxy : List (Element msg) -> List (Element msg) -> Element msg
boxxxy name children =
    Theme.column
        [ alignTop
        , Border.width 1
        , Theme.padding
        ]
        (row [] name :: children)


viewLetDeclaration : Node Expression.LetDeclaration -> Element msg
viewLetDeclaration (Node _ letDeclaration) =
    case letDeclaration of
        Expression.LetFunction function ->
            viewFunction function

        Expression.LetDestructuring pattern expression ->
            column []
                [ viewPattern pattern
                , viewExpression expression
                ]


viewFunction : Expression.Function -> Element msg
viewFunction function =
    let
        declaration : Expression.FunctionImplementation
        declaration =
            Node.value function.declaration
    in
    boxxxy
        (text (Node.value declaration.name)
            :: List.map viewPattern declaration.arguments
        )
        [ viewExpression declaration.expression ]


viewPattern : Node Pattern.Pattern -> Element msg
viewPattern (Node _ pattern) =
    let
        commaJoined : String -> (a -> Element msg) -> List a -> String -> Element msg
        commaJoined before viewChild children after =
            if List.isEmpty children then
                boxxxy0 <| before ++ after

            else
                boxxxy
                    (text (before ++ " ")
                        :: List.intersperse
                            (text ", ")
                            (List.map viewChild children)
                        ++ [ text <| " " ++ after ]
                    )
                    []
    in
    case pattern of
        Pattern.AllPattern ->
            boxxxy0 "_"

        Pattern.UnitPattern ->
            boxxxy0 "()"

        Pattern.CharPattern '\'' ->
            boxxxy0 "'\\''"

        Pattern.CharPattern c ->
            boxxxy0 <| "'" ++ String.fromChar c ++ "'"

        Pattern.StringPattern _ ->
            boxxxy0 "branch 'StringPattern _' not implemented"

        Pattern.IntPattern i ->
            boxxxy0 <| String.fromInt i

        Pattern.HexPattern h ->
            boxxxy0 <| "0x" ++ Hex.toString h

        Pattern.FloatPattern f ->
            boxxxy0 <| String.fromFloat f

        Pattern.ParenthesizedPattern child ->
            commaJoined "(" viewPattern [ child ] ")"

        Pattern.TuplePattern children ->
            commaJoined "(" viewPattern children ")"

        Pattern.ListPattern children ->
            commaJoined "[" viewPattern children "]"

        Pattern.RecordPattern children ->
            commaJoined "{" (Node.value >> text) children "}"

        Pattern.UnConsPattern _ _ ->
            boxxxy0 "branch 'UnConsPattern _ _' not implemented"

        Pattern.VarPattern v ->
            boxxxy0 v

        Pattern.NamedPattern _ _ ->
            boxxxy0 "branch 'NamedPattern _ _' not implemented"

        Pattern.AsPattern _ _ ->
            boxxxy0 "branch 'AsPattern _ _' not implemented"

-- iterates over a list of expressions and returns a row of elements
viewExpressions : List (Node Expression.Expression) -> Element msg
viewExpressions expressions =
    row [] <| List.map viewExpression expressions


-- callTree including the source code, environment, result and children
viewCallTree : String -> CallTreeZipper -> Element Msg
viewCallTree source ((CallTreeZipper { current, parent }) as zipper) =
    let
        (CallNode { expression, children, env, result }) =
            current

        sourceViewConfig : Source.Config Msg
        sourceViewConfig =
            if env.currentModule == [ "Main" ] then
                { highlight = Just <| Node.range expression
                , buttons =
                    Rope.toList children
                        |> List.map
                            (\((CallNode childData) as child) ->
                                { range = Node.range childData.expression
                                , onPress =
                                    Focus
                                        { current = child
                                        , parent = Just zipper
                                        }
                                        |> Just
                                , tooltip =
                                    case childData.result of
                                        Err _ ->
                                            Nothing

                                        Ok value ->
                                            Just (Value.toString value)
                                }
                            )
                , source = source
                }

            else
                { highlight =
                    Just
                        { start = { row = 6, column = 3 }
                        , end =
                            { row = round (1 / 0)
                            , column = 0
                            }
                        }
                , buttons = []
                , source =
                    "-- No full source available\n\nmodule "
                        ++ String.join "." env.currentModule
                        ++ " exposing (..)\n\n"
                        ++ "currentExpr =\n"
                        ++ Eval.indent 4 (Expression.Extra.toString expression)
                }

        parentButtons : List (Element Msg)
        parentButtons =
            let
                go : Maybe CallTreeZipper -> CallTree -> List (Element Msg)
                go node child =
                    case node of
                        Nothing ->
                            []

                        Just (CallTreeZipper z) ->
                            focusButton [ alignTop ]
                                { parent = z.parent
                                , child = Just child
                                , current = z.current
                                }
                                :: go z.parent z.current
            in
            go parent current
                |> List.reverse

        childrenButtons : List (Element Msg)
        childrenButtons =
            Rope.toList children
                |> List.sortBy (\node -> -(nodeSize node))
                |> List.map
                    (\child ->
                        focusButton [ alignTop ]
                            { current = child
                            , parent = Just zipper
                            , child = Nothing
                            }
                    )
    in
    Theme.box "Call tree"
        [ width fill ]
        [ Theme.row [ width fill ]
            [ Theme.box "Source"
                [ width fill ]
                [ Input.button []
                    { label = Source.view [ alignTop ] sourceViewConfig
                    , onPress = Maybe.map (\(CallTreeZipper z) -> Focus z) parent
                    }
                ]
            , Theme.column
                [ height fill
                , alignRight
                ]
                [ 
                -- Theme.box "Environment"
                --     [ alignTop
                --     , width fill
                --     , height fill
                --     ]
                --     [ viewEnv env ]
                -- , 
                  Theme.box "Result"
                    [ alignBottom
                    , width fill
                    ]
                    [ paragraph []
                        [ case
                            result
                                |> Result.mapError EvalError
                                |> resultToString
                          of
                            Ok r ->
                                text <| r

                            Err e ->
                                text <| "Error: " ++ e
                        ]
                    ]
                ]
            ]
        , Theme.box "Children"
            [ width fill ]
          <|
            [ Theme.wrappedRow
                [ width fill ]
                childrenButtons
            ]
        , if List.isEmpty parentButtons then
            Element.none

          else
            Theme.box "Parents"
                [ width fill ]
                [ Theme.wrappedRow [ width fill ] parentButtons ]
        ]


viewEnv : Types.Env -> Element msg
viewEnv { values } =
    if Dict.isEmpty values then
        Element.none

    else
        let
            cell : String -> Element msg
            cell value =
                el [ monospace ] <| text value
        in
        Element.table
            [ Theme.spacing
            , alignTop
            , width shrink
            ]
            { columns =
                [ { header = text "Name"
                  , view = \( name, _ ) -> cell name
                  , width = shrink
                  }
                , { header = text "Value"
                  , view = \( _, value ) -> cell <| Value.toString value
                  , width = shrink
                  }
                ]
            , data = Dict.toList values
            }


viewNode : CallTree -> Maybe CallTree -> Element msg
viewNode (CallNode { expression, result }) child =
    let
        expressionString : String
        expressionString =
            Expression.Extra.toString expression

        resultString : String
        resultString =
            case result of
                Ok v ->
                    Value.toString v

                Err e ->
                    Types.evalErrorToString e
    in
    Theme.row []
        [ Source.viewExpression []
            { source = expressionString
            , buttons = []
            , highlight =
                Maybe.map
                    (\(CallNode childNode) ->
                        let
                            expressionStart : Location
                            expressionStart =
                                (Node.range expression).start

                            { start, end } =
                                Node.range childNode.expression

                            move : Location -> Location
                            move location =
                                { row = location.row - expressionStart.row + 1
                                , column = location.column - expressionStart.column + 1
                                }
                        in
                        { start = move start
                        , end = move end
                        }
                    )
                    child
                    |> identity --Debug.log ("highlight for " ++ expressionString)
            }
        , el
            [ width <| px Theme.rythm
            , height fill
            , Border.width 1
            , Border.roundEach
                { topLeft = 0
                , bottomLeft = 0
                , topRight = 999
                , bottomRight = 999
                }
            ]
            Element.none
        , text resultString
        ]


nodeSize : CallTree -> number
nodeSize (CallNode { children }) =
    List.foldl (\child acc -> acc + nodeSize child) 1 (Rope.toList children)


viewLogLines : List String -> Element msg
viewLogLines logLines =
    if List.isEmpty logLines then
        Element.none

    else
        Element.html <| Html.pre [] [ Html.text <| String.join "\n" logLines ]



