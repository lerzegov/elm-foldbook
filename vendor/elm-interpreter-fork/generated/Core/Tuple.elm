module Core.Tuple exposing (first, functions, mapBoth, mapFirst, mapSecond, pair, second)

{-| 
@docs functions, pair, first, second, mapFirst, mapSecond, mapBoth
-}


import Elm.Syntax.Expression
import Elm.Syntax.Node
import Elm.Syntax.Pattern
import FastDict
import H


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "pair", pair )
        , ( "first", first )
        , ( "second", second )
        , ( "mapFirst", mapFirst )
        , ( "mapSecond", mapSecond )
        , ( "mapBoth", mapBoth )
        ]


pair : Elm.Syntax.Expression.FunctionImplementation
pair =
    { name = H.node1 55 1 5 "Tuple.pair"
    , arguments =
        [ H.node1 55 6 7 (Elm.Syntax.Pattern.VarPattern "a")
        , H.node1 55 8 9 (Elm.Syntax.Pattern.VarPattern "b")
        ]
    , expression =
        H.node1
            56
            3
            9
            (Elm.Syntax.Expression.TupledExpression
                [ H.node1 56 4 5 (H.val "a"), H.node1 56 7 8 (H.val "b") ]
            )
    }


first : Elm.Syntax.Expression.FunctionImplementation
first =
    { name = H.node1 69 1 6 "Tuple.first"
    , arguments =
        [ H.node1
            69
            7
            12
            (Elm.Syntax.Pattern.TuplePattern
                [ H.node1 69 8 9 (Elm.Syntax.Pattern.VarPattern "x")
                , H.node1 69 10 11 Elm.Syntax.Pattern.AllPattern
                ]
            )
        ]
    , expression = H.node1 70 3 4 (H.val "x")
    }


second : Elm.Syntax.Expression.FunctionImplementation
second =
    { name = H.node1 79 1 7 "Tuple.second"
    , arguments =
        [ H.node1
            79
            8
            13
            (Elm.Syntax.Pattern.TuplePattern
                [ H.node1 79 9 10 Elm.Syntax.Pattern.AllPattern
                , H.node1 79 11 12 (Elm.Syntax.Pattern.VarPattern "y")
                ]
            )
        ]
    , expression = H.node1 80 3 4 (H.val "y")
    }


mapFirst : Elm.Syntax.Expression.FunctionImplementation
mapFirst =
    { name = H.node1 95 1 9 "Tuple.mapFirst"
    , arguments =
        [ H.node1 95 10 14 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1
            95
            15
            20
            (Elm.Syntax.Pattern.TuplePattern
                [ H.node1 95 16 17 (Elm.Syntax.Pattern.VarPattern "x")
                , H.node1 95 18 19 (Elm.Syntax.Pattern.VarPattern "y")
                ]
            )
        ]
    , expression =
        H.node1
            96
            3
            14
            (Elm.Syntax.Expression.TupledExpression
                [ H.node1
                    96
                    4
                    10
                    (Elm.Syntax.Expression.Application
                        [ H.node1 96 4 8 (H.val "func")
                        , H.node1 96 9 10 (H.val "x")
                        ]
                    )
                , H.node1 96 12 13 (H.val "y")
                ]
            )
    }


mapSecond : Elm.Syntax.Expression.FunctionImplementation
mapSecond =
    { name = H.node1 105 1 10 "Tuple.mapSecond"
    , arguments =
        [ H.node1 105 11 15 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1
            105
            16
            21
            (Elm.Syntax.Pattern.TuplePattern
                [ H.node1 105 17 18 (Elm.Syntax.Pattern.VarPattern "x")
                , H.node1 105 19 20 (Elm.Syntax.Pattern.VarPattern "y")
                ]
            )
        ]
    , expression =
        H.node1
            106
            3
            14
            (Elm.Syntax.Expression.TupledExpression
                [ H.node1 106 4 5 (H.val "x")
                , H.node1
                    106
                    7
                    13
                    (Elm.Syntax.Expression.Application
                        [ H.node1 106 7 11 (H.val "func")
                        , H.node1 106 12 13 (H.val "y")
                        ]
                    )
                ]
            )
    }


mapBoth : Elm.Syntax.Expression.FunctionImplementation
mapBoth =
    { name = H.node1 117 1 8 "Tuple.mapBoth"
    , arguments =
        [ H.node1 117 9 14 (Elm.Syntax.Pattern.VarPattern "funcA")
        , H.node1 117 15 20 (Elm.Syntax.Pattern.VarPattern "funcB")
        , H.node1
            117
            21
            26
            (Elm.Syntax.Pattern.TuplePattern
                [ H.node1 117 22 23 (Elm.Syntax.Pattern.VarPattern "x")
                , H.node1 117 24 25 (Elm.Syntax.Pattern.VarPattern "y")
                ]
            )
        ]
    , expression =
        H.node1
            118
            3
            23
            (Elm.Syntax.Expression.TupledExpression
                [ H.node1
                    118
                    5
                    12
                    (Elm.Syntax.Expression.Application
                        [ H.node1 118 5 10 (H.val "funcA")
                        , H.node1 118 11 12 (H.val "x")
                        ]
                    )
                , H.node1
                    118
                    14
                    21
                    (Elm.Syntax.Expression.Application
                        [ H.node1 118 14 19 (H.val "funcB")
                        , H.node1 118 20 21 (H.val "y")
                        ]
                    )
                ]
            )
    }