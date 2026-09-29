module Core.Process exposing (functions, kill, sleep, spawn)

{-| 
@docs functions, spawn, sleep, kill
-}


import Elm.Syntax.Expression
import Elm.Syntax.Node
import FastDict
import H


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "spawn", spawn ), ( "sleep", sleep ), ( "kill", kill ) ]


spawn : Elm.Syntax.Expression.FunctionImplementation
spawn =
    { name = H.node1 83 1 6 "Process.spawn"
    , arguments = []
    , expression =
        H.node1
            84
            3
            29
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Scheduler" ]
                "spawn"
            )
    }


sleep : Elm.Syntax.Expression.FunctionImplementation
sleep =
    { name = H.node1 94 1 6 "Process.sleep"
    , arguments = []
    , expression =
        H.node1
            95
            3
            27
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Process" ]
                "sleep"
            )
    }


kill : Elm.Syntax.Expression.FunctionImplementation
kill =
    { name = H.node1 104 1 5 "Process.kill"
    , arguments = []
    , expression =
        H.node1
            105
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Scheduler" ]
                "kill"
            )
    }