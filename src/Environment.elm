module Environment exposing (addFunction, addFunctionCalcOrder, addValue, call, empty, with)

import Elm.Syntax.Expression exposing (FunctionImplementation)
import Elm.Syntax.ModuleName exposing (ModuleName)
import Elm.Syntax.Node as Node
import FastDict as Dict
import Types exposing (Env, EnvValues, Value)


addValue : String -> Value -> Env -> Env
addValue name value env =
    { env
        | values = Dict.insert name value env.values
    }


addFunction : ModuleName -> FunctionImplementation -> Env -> Env
addFunction moduleName function env =
    { env
        | functions =
            Dict.insert
                moduleName
                (Dict.insert (Node.value function.name)
                    function
                    (Maybe.withDefault Dict.empty
                        (Dict.get moduleName env.functions)
                    )
                )
                env.functions
    }


addFunctionCalcOrder : ModuleName -> String -> Env -> Env
addFunctionCalcOrder moduleName funcName env =
    let
        curCalcOrder =
            Maybe.withDefault []
                (Dict.get moduleName env.functionCalcOrders)
    in
    { env
        | functionCalcOrders =
            Dict.insert
                moduleName
                (curCalcOrder ++ [funcName])
                env.functionCalcOrders
    }


with : EnvValues -> Env -> Env
with newValues old =
    { old | values = Dict.union newValues old.values }


empty : ModuleName -> Env
empty moduleName =
    { currentModule = moduleName
    , callStack = []
    , functions = Dict.empty
    , functionCalcOrders = Dict.empty
    , values = Dict.empty
    , envXModel = Nothing
    }


call : ModuleName -> String -> Env -> Env
call moduleName name env =
    { env
        | currentModule = moduleName
        , callStack =
            { moduleName = moduleName, name = name }
                :: env.callStack
    }
