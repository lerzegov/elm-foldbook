module Core.Elm.JsArray exposing (appendN, empty, foldl, foldr, functions, indexedMap, initialize, initializeFromList, length, map, push, singleton, slice, unsafeGet, unsafeSet)

{-| 
@docs functions, empty, singleton, length, initialize, initializeFromList, unsafeGet, unsafeSet, push, foldl, foldr, map, indexedMap, slice, appendN
-}


import Elm.Syntax.Expression
import Elm.Syntax.Node
import FastDict
import H


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "empty", empty )
        , ( "singleton", singleton )
        , ( "length", length )
        , ( "initialize", initialize )
        , ( "initializeFromList", initializeFromList )
        , ( "unsafeGet", unsafeGet )
        , ( "unsafeSet", unsafeSet )
        , ( "push", push )
        , ( "foldl", foldl )
        , ( "foldr", foldr )
        , ( "map", map )
        , ( "indexedMap", indexedMap )
        , ( "slice", slice )
        , ( "appendN", appendN )
        ]


empty : Elm.Syntax.Expression.FunctionImplementation
empty =
    { name = H.node1 54 1 6 "Elm.JsArray.empty"
    , arguments = []
    , expression =
        H.node1
            55
            5
            29
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "empty"
            )
    }


singleton : Elm.Syntax.Expression.FunctionImplementation
singleton =
    { name = H.node1 61 1 10 "Elm.JsArray.singleton"
    , arguments = []
    , expression =
        H.node1
            62
            5
            33
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "singleton"
            )
    }


length : Elm.Syntax.Expression.FunctionImplementation
length =
    { name = H.node1 68 1 7 "Elm.JsArray.length"
    , arguments = []
    , expression =
        H.node1
            69
            5
            30
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "length"
            )
    }


initialize : Elm.Syntax.Expression.FunctionImplementation
initialize =
    { name = H.node1 81 1 11 "Elm.JsArray.initialize"
    , arguments = []
    , expression =
        H.node1
            82
            5
            34
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "initialize"
            )
    }


initializeFromList : Elm.Syntax.Expression.FunctionImplementation
initializeFromList =
    { name = H.node1 96 1 19 "Elm.JsArray.initializeFromList"
    , arguments = []
    , expression =
        H.node1
            97
            5
            42
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "initializeFromList"
            )
    }


unsafeGet : Elm.Syntax.Expression.FunctionImplementation
unsafeGet =
    { name = H.node1 106 1 10 "Elm.JsArray.unsafeGet"
    , arguments = []
    , expression =
        H.node1
            107
            5
            33
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "unsafeGet"
            )
    }


unsafeSet : Elm.Syntax.Expression.FunctionImplementation
unsafeSet =
    { name = H.node1 116 1 10 "Elm.JsArray.unsafeSet"
    , arguments = []
    , expression =
        H.node1
            117
            5
            33
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "unsafeSet"
            )
    }


push : Elm.Syntax.Expression.FunctionImplementation
push =
    { name = H.node1 123 1 5 "Elm.JsArray.push"
    , arguments = []
    , expression =
        H.node1
            124
            5
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "push"
            )
    }


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = H.node1 130 1 6 "Elm.JsArray.foldl"
    , arguments = []
    , expression =
        H.node1
            131
            5
            29
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "foldl"
            )
    }


foldr : Elm.Syntax.Expression.FunctionImplementation
foldr =
    { name = H.node1 137 1 6 "Elm.JsArray.foldr"
    , arguments = []
    , expression =
        H.node1
            138
            5
            29
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "foldr"
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = H.node1 144 1 4 "Elm.JsArray.map"
    , arguments = []
    , expression =
        H.node1
            145
            5
            27
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "map"
            )
    }


indexedMap : Elm.Syntax.Expression.FunctionImplementation
indexedMap =
    { name = H.node1 154 1 11 "Elm.JsArray.indexedMap"
    , arguments = []
    , expression =
        H.node1
            155
            5
            34
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "indexedMap"
            )
    }


slice : Elm.Syntax.Expression.FunctionImplementation
slice =
    { name = H.node1 170 1 6 "Elm.JsArray.slice"
    , arguments = []
    , expression =
        H.node1
            171
            5
            29
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "slice"
            )
    }


appendN : Elm.Syntax.Expression.FunctionImplementation
appendN =
    { name = H.node1 180 1 8 "Elm.JsArray.appendN"
    , arguments = []
    , expression =
        H.node1
            181
            5
            31
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "JsArray" ]
                "appendN"
            )
    }