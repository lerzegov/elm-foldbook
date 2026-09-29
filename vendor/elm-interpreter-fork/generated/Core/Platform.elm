module Core.Platform exposing (functions, sendToApp, sendToSelf, worker)

{-| 
@docs functions, worker, sendToApp, sendToSelf
-}


import Elm.Syntax.Expression
import Elm.Syntax.Node
import FastDict
import H


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "worker", worker )
        , ( "sendToApp", sendToApp )
        , ( "sendToSelf", sendToSelf )
        ]


worker : Elm.Syntax.Expression.FunctionImplementation
worker =
    { name = H.node1 71 1 7 "Platform.worker"
    , arguments = []
    , expression =
        H.node1
            72
            3
            29
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Platform" ]
                "worker"
            )
    }


sendToApp : Elm.Syntax.Expression.FunctionImplementation
sendToApp =
    { name = H.node1 108 1 10 "Platform.sendToApp"
    , arguments = []
    , expression =
        H.node1
            109
            3
            32
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Platform" ]
                "sendToApp"
            )
    }


sendToSelf : Elm.Syntax.Expression.FunctionImplementation
sendToSelf =
    { name = H.node1 119 1 11 "Platform.sendToSelf"
    , arguments = []
    , expression =
        H.node1
            120
            3
            33
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Platform" ]
                "sendToSelf"
            )
    }