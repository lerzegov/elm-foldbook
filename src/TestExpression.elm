module TestExpression exposing (..)
-- remember to import FastDict, not Dict!!!

import Elm.Syntax.Expression exposing (Expression(..), FunctionImplementation)
import Elm.Syntax.Pattern exposing( Pattern(..), QualifiedNameRef)
import Elm.Syntax.Infix exposing ( Infix, InfixDirection(..) )
import Elm.Syntax.Node exposing (Node(..))
import Eval.Expression
import Eval.Module exposing (makeEnv, eval)
import Syntax exposing (fakeNode)
import Types exposing (EvalResult, Env, Value(..), EnvValues, Error(..), CallTree(..))
import FastDict as Dict exposing (Dict)
import Elm.Syntax.ModuleName exposing (ModuleName)
import Rope exposing (Rope)
import CalcEngine exposing (getExprDataArray, getLhsExpressions)
import TypesXModel exposing (XModel)
import XModel


initEnvSource : String
initEnvSource = """module TestExpression exposing (..)
-- ce__valore_margContrib = ce__valore_ricavi - ce__valore_costoVen
ce__valore_margContrib = ce__valore_ricavi / az__nrDip -- sembra funzionare dopo aggiunta anno ad Az
ce__valore_ebitda = ce__valore_margContrib - ce__valore_speseVGA
ce__valore_ebit = ce__valore_ebitda - ce__valore_amm 
taxRate = 0.3
ce__valore_tax = ce__valore_ebit * taxRate
ce__valore_unlevNetIncome = ce__valore_ebit - ce__valore_tax


"""
initEnvSourceOld : String
initEnvSourceOld = """module TestExpression exposing (..)
retValue = 8888
xm = xModelValue
dataArValue = xm.datasets.ce.dataArrays.valore
valore = ce__valore
ulu = ce__valore_Ricavi - ce__valore_CostoVen
doubleRicavi = ce__valore_Ricavi + ce__valore_Ricavi
squareRicavi = ce__valore_Ricavi * ce__valore_Ricavi
halfRicavi = ce__valore_Ricavi / 2.0
squareRicavi2 = ce__valore_Ricavi ^ 2.0
doubleRicavi2 = ce__valore_Ricavi * 2.0
price = 
    let
        a=100
        b=4
        myAnag = { coupon = 3.2, maturity=10 , faceValue = 100.0 }
        listNpv = List.map (\\si -> Financial.npv -si [5,5,105] 0.08) (List.range 95 200)
        bondPrice = Financial.pvBondAnag myAnag 0 0.02
        bondPrice2 = Financial.pvBond myAnag.coupon (toFloat (myAnag.maturity - 0)) myAnag.faceValue 0.02
    in 
    bondPrice2

"""
-- NameError is managed in Expression.elm
-- marked nameError call with "gigN" in Expression.elm to debug
-- missing env values raise nameError in evalNonVariant err gig7

-- use simpler Module.eval function not using Node and Env
testEval :  Result Error Value
testEval = eval 
    initEnvSource
    (FunctionOrValue [] "price")

testEvalExpr : String -> Result Error Value
testEvalExpr expr = eval 
    initEnvSource
    (FunctionOrValue [] expr)

-- used by Debug in Module.elm
getFuncName : Node FunctionImplementation -> String
getFuncName (Node _ funcImpl) =
    case funcImpl.name of
        (Node _ retName) -> retName




-- dummy module for dummy environment, but Module.elm loads generated modules anyway
mdName : ModuleName
mdName = ["TestExpression"]
valueTuples : List (String, Value)
valueTuples =
    [ ("tre", Int 3)
    , ("due", Int 2)
    ]

initValues : EnvValues
initValues = 
    Dict.fromList valueTuples
-- from H.elm
val : String -> Expression
val name =
    FunctionOrValue [] name

-- from generated/Core/Financial.elm
myE : Elm.Syntax.Expression.FunctionImplementation
myE =
    { name = fakeNode "TestExpression.myE"
    , arguments = []
    , expression =
        fakeNode (Floatable 2.718281828459045)
    }

myExp : Elm.Syntax.Expression.FunctionImplementation
myExp =
    { name = fakeNode "TestExpression.myExp"
    , arguments = [ fakeNode (VarPattern "x") ]
    , expression =
        fakeNode
            (Elm.Syntax.Expression.OperatorApplication
                "^"
                Right
                (fakeNode (val "myE"))
                (fakeNode (val "x"))
            )
    }

initFunctions : Dict ModuleName (Dict String FunctionImplementation)
initFunctions = Dict.fromList [(
        mdName -- ModuleName
        , Dict.fromList [ ("myExp", myExp)-- func names without module name
                        , ("myE", myE)
                        ]
    )]

initEnv : Env
initEnv =
    { currentModule = mdName
    , functions = initFunctions
    , functionCalcOrders = Dict.empty
    , values = initValues
    , callStack = []
    , envXModel = Just XModel.myXModel
    }
emptyEnv : Env
emptyEnv =
    { currentModule = []
    , functions = Dict.empty
    , functionCalcOrders = Dict.empty
    , values = Dict.empty
    , callStack = []
    , envXModel = Just XModel.emptyXModel
    }
myEnv : Result Error Env
myEnv = makeEnv initEnvSource (Just initEnv) 
-- if initEnv module name /= initEnvSource module name
-- passing initEnv raises NameError in testExpression

sourceEnv : Result Error Env
sourceEnv = makeEnv initEnvSource (Just emptyEnv)

getMyEnv : Env
getMyEnv = 
    case myEnv of
        Ok env -> env
        Err _ -> initEnv

getSourceEnv : Env
getSourceEnv = 
    case sourceEnv of
        Ok env -> env
        Err _ -> initEnv

testExpression : Result Error Value
testExpression =
    let
        curEnv = case myEnv of
            Ok env -> env
            Err _ -> initEnv
        ( result, callTrees, logLines ) = Eval.Expression.evalExpression 
            -- here only values or 0-arg funcs or RHS of exprs defined in source
            (fakeNode (FunctionOrValue [] "due")) 
            { trace = True }
            curEnv
    in
    Result.mapError Types.EvalError result
-- this call gets the hierachical parse error also on valid source expr "ricavi2021"
traceExpression : String -> ( Result Error Value, Rope CallTree, Rope String )
traceExpression expr =
    let
        curEnv = case myEnv of
            Ok env -> env
            Err _ -> initEnv
        ( result, callTrees, logLines ) = Eval.Expression.evalExpression 
            -- here only values or 0-arg funcs or RHS of exprs defined in source
            (fakeNode (FunctionOrValue [] expr)) 
            { trace = False }
            curEnv
    in
    ( Result.mapError Types.EvalError result
    , callTrees
    , logLines
    )
