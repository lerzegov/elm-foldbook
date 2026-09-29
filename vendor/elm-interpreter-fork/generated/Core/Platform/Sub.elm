module Core.Platform.Sub exposing (batch, functions, map, none)

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
    { name = H.node1 55 1 5 "Platform.Sub.none"
    , arguments = []
    , expression =
        H.node1
            56
            3
            11
            (Elm.Syntax.Expression.Application
                [ H.node1 56 3 8 (H.val "batch")
                , H.node1 56 9 11 (Elm.Syntax.Expression.ListExpr [])
                ]
            )
    }


batch : Elm.Syntax.Expression.FunctionImplementation
batch =
    { name = H.node1 66 1 6 "Platform.Sub.batch"
    , arguments = []
    , expression =
        H.node1
            67
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Platform" ]
                "batch"
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = H.node1 83 1 4 "Platform.Sub.map"
    , arguments = []
    , expression =
        H.node1
            84
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Platform" ]
                "map"
            )
    }