module Core.Debug exposing (functions, log, toString, todo)

{-| 
@docs functions, toString, log, todo
-}


import Elm.Syntax.Expression
import Elm.Syntax.Node
import FastDict
import H


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "toString", toString ), ( "log", log ), ( "todo", todo ) ]


toString : Elm.Syntax.Expression.FunctionImplementation
toString =
    { name = H.node1 37 1 9 "Debug.toString"
    , arguments = []
    , expression =
        H.node1
            38
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Debug" ]
                "toString"
            )
    }


log : Elm.Syntax.Expression.FunctionImplementation
log =
    { name = H.node1 60 1 4 "Debug.log"
    , arguments = []
    , expression =
        H.node1
            61
            3
            23
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Debug" ]
                "log"
            )
    }


todo : Elm.Syntax.Expression.FunctionImplementation
todo =
    { name = H.node1 95 1 5 "Debug.todo"
    , arguments = []
    , expression =
        H.node1
            96
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Debug" ]
                "todo"
            )
    }