module Core.Platform.Cmd exposing (batch, functions, map, none)

{-| 
@docs functions, none, batch, map
-}


import Elm.Syntax.Expression
import Elm.Syntax.Node
import FastDict
import H


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList [ ( "none", none ), ( "batch", batch ), ( "map", map ) ]


none : Elm.Syntax.Expression.FunctionImplementation
none =
    { name = H.node1 54 1 5 "Platform.Cmd.none"
    , arguments = []
    , expression =
        H.node1
            55
            3
            11
            (Elm.Syntax.Expression.Application
                [ H.node1 55 3 8 (H.val "batch")
                , H.node1 55 9 11 (Elm.Syntax.Expression.ListExpr [])
                ]
            )
    }


batch : Elm.Syntax.Expression.FunctionImplementation
batch =
    { name = H.node1 67 1 6 "Platform.Cmd.batch"
    , arguments = []
    , expression =
        H.node1
            68
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Platform" ]
                "batch"
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = H.node1 84 1 4 "Platform.Cmd.map"
    , arguments = []
    , expression =
        H.node1
            85
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Platform" ]
                "map"
            )
    }