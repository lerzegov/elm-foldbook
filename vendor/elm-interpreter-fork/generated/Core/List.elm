module Core.List exposing (all, any, append, concat, concatMap, cons, drop, filter, filterMap, foldl, foldr, foldrHelper, functions, head, indexedMap, intersperse, isEmpty, length, map, map2, map3, map4, map5, maximum, maybeCons, member, minimum, operators, partition, product, range, rangeHelp, repeat, repeatHelp, reverse, singleton, sort, sortBy, sortWith, sum, tail, take, takeFast, takeReverse, takeTailRec, unzip)

{-| 
@docs functions, operators, singleton, repeat, repeatHelp, range, rangeHelp, cons, map, indexedMap, foldl, foldr, foldrHelper, filter, filterMap, maybeCons, length, reverse, member, all, any, maximum, minimum, sum, product, append, concat, concatMap, intersperse, map2, map3, map4, map5, sort, sortBy, sortWith, isEmpty, head, tail, take, takeFast, takeTailRec, takeReverse, drop, partition, unzip
-}


import Elm.Syntax.Expression
import Elm.Syntax.Infix
import Elm.Syntax.Node
import Elm.Syntax.Pattern
import FastDict
import H


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "singleton", singleton )
        , ( "repeat", repeat )
        , ( "repeatHelp", repeatHelp )
        , ( "range", range )
        , ( "rangeHelp", rangeHelp )
        , ( "cons", cons )
        , ( "map", map )
        , ( "indexedMap", indexedMap )
        , ( "foldl", foldl )
        , ( "foldr", foldr )
        , ( "foldrHelper", foldrHelper )
        , ( "filter", filter )
        , ( "filterMap", filterMap )
        , ( "maybeCons", maybeCons )
        , ( "length", length )
        , ( "reverse", reverse )
        , ( "member", member )
        , ( "all", all )
        , ( "any", any )
        , ( "maximum", maximum )
        , ( "minimum", minimum )
        , ( "sum", sum )
        , ( "product", product )
        , ( "append", append )
        , ( "concat", concat )
        , ( "concatMap", concatMap )
        , ( "intersperse", intersperse )
        , ( "map2", map2 )
        , ( "map3", map3 )
        , ( "map4", map4 )
        , ( "map5", map5 )
        , ( "sort", sort )
        , ( "sortBy", sortBy )
        , ( "sortWith", sortWith )
        , ( "isEmpty", isEmpty )
        , ( "head", head )
        , ( "tail", tail )
        , ( "take", take )
        , ( "takeFast", takeFast )
        , ( "takeTailRec", takeTailRec )
        , ( "takeReverse", takeReverse )
        , ( "drop", drop )
        , ( "partition", partition )
        , ( "unzip", unzip )
        ]


operators : List ( String, Elm.Syntax.Pattern.QualifiedNameRef )
operators =
    [ ( "::", { moduleName = [ "List" ], name = "cons" } ) ]


singleton : Elm.Syntax.Expression.FunctionImplementation
singleton =
    { name = H.node1 55 1 10 "List.singleton"
    , arguments = [ H.node1 55 11 16 (Elm.Syntax.Pattern.VarPattern "value") ]
    , expression =
        H.node1
            56
            3
            10
            (Elm.Syntax.Expression.ListExpr [ H.node1 56 4 9 (H.val "value") ])
    }


repeat : Elm.Syntax.Expression.FunctionImplementation
repeat =
    { name = H.node1 64 1 7 "List.repeat"
    , arguments =
        [ H.node1 64 8 9 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 64 10 15 (Elm.Syntax.Pattern.VarPattern "value")
        ]
    , expression =
        H.node1
            65
            3
            24
            (Elm.Syntax.Expression.Application
                [ H.node1 65 3 13 (H.val "repeatHelp")
                , H.node1 65 14 16 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 65 17 18 (H.val "n")
                , H.node1 65 19 24 (H.val "value")
                ]
            )
    }


repeatHelp : Elm.Syntax.Expression.FunctionImplementation
repeatHelp =
    { name = H.node1 69 1 11 "List.repeatHelp"
    , arguments =
        [ H.node1 69 12 18 (Elm.Syntax.Pattern.VarPattern "result")
        , H.node1 69 19 20 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 69 21 26 (Elm.Syntax.Pattern.VarPattern "value")
        ]
    , expression =
        H.node
            70
            3
            74
            49
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    70
                    6
                    12
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Non
                        (H.node1 70 6 7 (H.val "n"))
                        (H.node1 70 11 12 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node1 71 5 11 (H.val "result"))
                (H.node1
                    74
                    5
                    49
                    (Elm.Syntax.Expression.Application
                        [ H.node1 74 5 15 (H.val "repeatHelp")
                        , H.node1
                            74
                            16
                            35
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    74
                                    17
                                    34
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 74 17 21 (H.val "cons")
                                        , H.node1 74 22 27 (H.val "value")
                                        , H.node1 74 28 34 (H.val "result")
                                        ]
                                    )
                                )
                            )
                        , H.node1
                            74
                            36
                            43
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    74
                                    37
                                    42
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "-"
                                        Elm.Syntax.Infix.Left
                                        (H.node1 74 37 38 (H.val "n"))
                                        (H.node1
                                            74
                                            41
                                            42
                                            (Elm.Syntax.Expression.Integer 1)
                                        )
                                    )
                                )
                            )
                        , H.node1 74 44 49 (H.val "value")
                        ]
                    )
                )
            )
    }


range : Elm.Syntax.Expression.FunctionImplementation
range =
    { name = H.node1 85 1 6 "List.range"
    , arguments =
        [ H.node1 85 7 9 (Elm.Syntax.Pattern.VarPattern "lo")
        , H.node1 85 10 12 (Elm.Syntax.Pattern.VarPattern "hi")
        ]
    , expression =
        H.node1
            86
            3
            21
            (Elm.Syntax.Expression.Application
                [ H.node1 86 3 12 (H.val "rangeHelp")
                , H.node1 86 13 15 (H.val "lo")
                , H.node1 86 16 18 (H.val "hi")
                , H.node1 86 19 21 (Elm.Syntax.Expression.ListExpr [])
                ]
            )
    }


rangeHelp : Elm.Syntax.Expression.FunctionImplementation
rangeHelp =
    { name = H.node1 90 1 10 "List.rangeHelp"
    , arguments =
        [ H.node1 90 11 13 (Elm.Syntax.Pattern.VarPattern "lo")
        , H.node1 90 14 16 (Elm.Syntax.Pattern.VarPattern "hi")
        , H.node1 90 17 21 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            91
            3
            95
            9
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    91
                    6
                    14
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Non
                        (H.node1 91 6 8 (H.val "lo"))
                        (H.node1 91 12 14 (H.val "hi"))
                    )
                )
                (H.node1
                    92
                    5
                    41
                    (Elm.Syntax.Expression.Application
                        [ H.node1 92 5 14 (H.val "rangeHelp")
                        , H.node1 92 15 17 (H.val "lo")
                        , H.node1
                            92
                            18
                            26
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    92
                                    19
                                    25
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "-"
                                        Elm.Syntax.Infix.Left
                                        (H.node1 92 19 21 (H.val "hi"))
                                        (H.node1
                                            92
                                            24
                                            25
                                            (Elm.Syntax.Expression.Integer 1)
                                        )
                                    )
                                )
                            )
                        , H.node1
                            92
                            27
                            41
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    92
                                    28
                                    40
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 92 28 32 (H.val "cons")
                                        , H.node1 92 33 35 (H.val "hi")
                                        , H.node1 92 36 40 (H.val "list")
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                )
                (H.node1 95 5 9 (H.val "list"))
            )
    }


cons : Elm.Syntax.Expression.FunctionImplementation
cons =
    { name = H.node1 107 1 5 "List.cons"
    , arguments = []
    , expression =
        H.node1
            108
            3
            23
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "cons"
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = H.node1 124 1 4 "List.map"
    , arguments =
        [ H.node1 124 5 6 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 124 7 9 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node1
            125
            3
            41
            (Elm.Syntax.Expression.Application
                [ H.node1 125 3 8 (H.val "foldr")
                , H.node1
                    125
                    9
                    35
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            125
                            10
                            34
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        125
                                        11
                                        12
                                        (Elm.Syntax.Pattern.VarPattern "x")
                                    , H.node1
                                        125
                                        13
                                        16
                                        (Elm.Syntax.Pattern.VarPattern "acc")
                                    ]
                                , expression =
                                    H.node1
                                        125
                                        20
                                        34
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 125 20 24 (H.val "cons")
                                            , H.node1
                                                125
                                                25
                                                30
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        125
                                                        26
                                                        29
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                125
                                                                26
                                                                27
                                                                (H.val "f")
                                                            , H.node1
                                                                125
                                                                28
                                                                29
                                                                (H.val "x")
                                                            ]
                                                        )
                                                    )
                                                )
                                            , H.node1 125 31 34 (H.val "acc")
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , H.node1 125 36 38 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 125 39 41 (H.val "xs")
                ]
            )
    }


indexedMap : Elm.Syntax.Expression.FunctionImplementation
indexedMap =
    { name = H.node1 134 1 11 "List.indexedMap"
    , arguments =
        [ H.node1 134 12 13 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 134 14 16 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node1
            135
            3
            38
            (Elm.Syntax.Expression.Application
                [ H.node1 135 3 7 (H.val "map2")
                , H.node1 135 8 9 (H.val "f")
                , H.node1
                    135
                    10
                    35
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            135
                            11
                            34
                            (Elm.Syntax.Expression.Application
                                [ H.node1 135 11 16 (H.val "range")
                                , H.node1
                                    135
                                    17
                                    18
                                    (Elm.Syntax.Expression.Integer 0)
                                , H.node1
                                    135
                                    19
                                    34
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            135
                                            20
                                            33
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "-"
                                                Elm.Syntax.Infix.Left
                                                (H.node1
                                                    135
                                                    20
                                                    29
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            135
                                                            20
                                                            26
                                                            (H.val "length")
                                                        , H.node1
                                                            135
                                                            27
                                                            29
                                                            (H.val "xs")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    135
                                                    32
                                                    33
                                                    (Elm.Syntax.Expression.Integer
                                                        1
                                                    )
                                                )
                                            )
                                        )
                                    )
                                ]
                            )
                        )
                    )
                , H.node1 135 36 38 (H.val "xs")
                ]
            )
    }


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = H.node1 151 1 6 "List.foldl"
    , arguments =
        [ H.node1 151 7 11 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 151 12 15 (Elm.Syntax.Pattern.VarPattern "acc")
        , H.node1 151 16 20 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            152
            3
            157
            33
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 152 8 12 (H.val "list")
                , cases =
                    [ ( H.node1 153 5 7 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 154 7 10 (H.val "acc")
                      )
                    , ( H.node1
                            156
                            5
                            12
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    156
                                    5
                                    6
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    156
                                    10
                                    12
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node1
                            157
                            7
                            33
                            (Elm.Syntax.Expression.Application
                                [ H.node1 157 7 12 (H.val "foldl")
                                , H.node1 157 13 17 (H.val "func")
                                , H.node1
                                    157
                                    18
                                    30
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            157
                                            19
                                            29
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    157
                                                    19
                                                    23
                                                    (H.val "func")
                                                , H.node1 157 24 25 (H.val "x")
                                                , H.node1
                                                    157
                                                    26
                                                    29
                                                    (H.val "acc")
                                                ]
                                            )
                                        )
                                    )
                                , H.node1 157 31 33 (H.val "xs")
                                ]
                            )
                      )
                    ]
                }
            )
    }


foldr : Elm.Syntax.Expression.FunctionImplementation
foldr =
    { name = H.node1 173 1 6 "List.foldr"
    , arguments =
        [ H.node1 173 7 9 (Elm.Syntax.Pattern.VarPattern "fn")
        , H.node1 173 10 13 (Elm.Syntax.Pattern.VarPattern "acc")
        , H.node1 173 14 16 (Elm.Syntax.Pattern.VarPattern "ls")
        ]
    , expression =
        H.node1
            174
            5
            28
            (Elm.Syntax.Expression.Application
                [ H.node1 174 5 16 (H.val "foldrHelper")
                , H.node1 174 17 19 (H.val "fn")
                , H.node1 174 20 23 (H.val "acc")
                , H.node1 174 24 25 (Elm.Syntax.Expression.Integer 0)
                , H.node1 174 26 28 (H.val "ls")
                ]
            )
    }


foldrHelper : Elm.Syntax.Expression.FunctionImplementation
foldrHelper =
    { name = H.node1 178 1 12 "List.foldrHelper"
    , arguments =
        [ H.node1 178 13 15 (Elm.Syntax.Pattern.VarPattern "fn")
        , H.node1 178 16 19 (Elm.Syntax.Pattern.VarPattern "acc")
        , H.node1 178 20 23 (Elm.Syntax.Pattern.VarPattern "ctr")
        , H.node1 178 24 26 (Elm.Syntax.Pattern.VarPattern "ls")
        ]
    , expression =
        H.node
            179
            5
            206
            70
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 179 10 12 (H.val "ls")
                , cases =
                    [ ( H.node1 180 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 181 13 16 (H.val "acc")
                      )
                    , ( H.node1
                            183
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    183
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                )
                                (H.node1
                                    183
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "r1")
                                )
                            )
                      , H.node
                            184
                            13
                            206
                            70
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 184 18 20 (H.val "r1")
                                , cases =
                                    [ ( H.node1
                                            185
                                            17
                                            19
                                            (Elm.Syntax.Pattern.ListPattern [])
                                      , H.node1
                                            186
                                            21
                                            29
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1 186 21 23 (H.val "fn")
                                                , H.node1 186 24 25 (H.val "a")
                                                , H.node1
                                                    186
                                                    26
                                                    29
                                                    (H.val "acc")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            188
                                            17
                                            24
                                            (Elm.Syntax.Pattern.UnConsPattern
                                                (H.node1
                                                    188
                                                    17
                                                    18
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                )
                                                (H.node1
                                                    188
                                                    22
                                                    24
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "r2"
                                                    )
                                                )
                                            )
                                      , H.node
                                            189
                                            21
                                            206
                                            70
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        189
                                                        26
                                                        28
                                                        (H.val "r2")
                                                , cases =
                                                    [ ( H.node1
                                                            190
                                                            25
                                                            27
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , H.node1
                                                            191
                                                            29
                                                            44
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    191
                                                                    29
                                                                    31
                                                                    (H.val "fn")
                                                                , H.node1
                                                                    191
                                                                    32
                                                                    33
                                                                    (H.val "a")
                                                                , H.node1
                                                                    191
                                                                    34
                                                                    44
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            191
                                                                            35
                                                                            43
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    191
                                                                                    35
                                                                                    37
                                                                                    (H.val
                                                                                        "fn"
                                                                                    )
                                                                                , H.node1
                                                                                    191
                                                                                    38
                                                                                    39
                                                                                    (H.val
                                                                                        "b"
                                                                                    )
                                                                                , H.node1
                                                                                    191
                                                                                    40
                                                                                    43
                                                                                    (H.val
                                                                                        "acc"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            193
                                                            25
                                                            32
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    193
                                                                    25
                                                                    26
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "c"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    193
                                                                    30
                                                                    32
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "r3"
                                                                    )
                                                                )
                                                            )
                                                      , H.node
                                                            194
                                                            29
                                                            206
                                                            70
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    H.node1
                                                                        194
                                                                        34
                                                                        36
                                                                        (H.val
                                                                            "r3"
                                                                        )
                                                                , cases =
                                                                    [ ( H.node1
                                                                            195
                                                                            33
                                                                            35
                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                []
                                                                            )
                                                                      , H.node1
                                                                            196
                                                                            37
                                                                            59
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    196
                                                                                    37
                                                                                    39
                                                                                    (H.val
                                                                                        "fn"
                                                                                    )
                                                                                , H.node1
                                                                                    196
                                                                                    40
                                                                                    41
                                                                                    (H.val
                                                                                        "a"
                                                                                    )
                                                                                , H.node1
                                                                                    196
                                                                                    42
                                                                                    59
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (H.node1
                                                                                            196
                                                                                            43
                                                                                            58
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    196
                                                                                                    43
                                                                                                    45
                                                                                                    (H.val
                                                                                                        "fn"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    196
                                                                                                    46
                                                                                                    47
                                                                                                    (H.val
                                                                                                        "b"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    196
                                                                                                    48
                                                                                                    58
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (H.node1
                                                                                                            196
                                                                                                            49
                                                                                                            57
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ H.node1
                                                                                                                    196
                                                                                                                    49
                                                                                                                    51
                                                                                                                    (H.val
                                                                                                                        "fn"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    196
                                                                                                                    52
                                                                                                                    53
                                                                                                                    (H.val
                                                                                                                        "c"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    196
                                                                                                                    54
                                                                                                                    57
                                                                                                                    (H.val
                                                                                                                        "acc"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( H.node1
                                                                            198
                                                                            33
                                                                            40
                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                (H.node1
                                                                                    198
                                                                                    33
                                                                                    34
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "d"
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    198
                                                                                    38
                                                                                    40
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "r4"
                                                                                    )
                                                                                )
                                                                            )
                                                                      , H.node
                                                                            199
                                                                            37
                                                                            206
                                                                            70
                                                                            (Elm.Syntax.Expression.LetExpression
                                                                                { declarations =
                                                                                    [ H.node
                                                                                        200
                                                                                        41
                                                                                        204
                                                                                        80
                                                                                        (Elm.Syntax.Expression.LetFunction
                                                                                            { documentation =
                                                                                                Nothing
                                                                                            , signature =
                                                                                                Nothing
                                                                                            , declaration =
                                                                                                H.node
                                                                                                    200
                                                                                                    41
                                                                                                    204
                                                                                                    80
                                                                                                    { name =
                                                                                                        H.node1
                                                                                                            200
                                                                                                            41
                                                                                                            44
                                                                                                            "res"
                                                                                                    , arguments =
                                                                                                        []
                                                                                                    , expression =
                                                                                                        H.node
                                                                                                            201
                                                                                                            45
                                                                                                            204
                                                                                                            80
                                                                                                            (Elm.Syntax.Expression.IfBlock
                                                                                                                (H.node1
                                                                                                                    201
                                                                                                                    48
                                                                                                                    57
                                                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                                                        ">"
                                                                                                                        Elm.Syntax.Infix.Non
                                                                                                                        (H.node1
                                                                                                                            201
                                                                                                                            48
                                                                                                                            51
                                                                                                                            (H.val
                                                                                                                                "ctr"
                                                                                                                            )
                                                                                                                        )
                                                                                                                        (H.node1
                                                                                                                            201
                                                                                                                            54
                                                                                                                            57
                                                                                                                            (Elm.Syntax.Expression.Integer
                                                                                                                                500
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                )
                                                                                                                (H.node1
                                                                                                                    202
                                                                                                                    49
                                                                                                                    74
                                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                                        [ H.node1
                                                                                                                            202
                                                                                                                            49
                                                                                                                            54
                                                                                                                            (H.val
                                                                                                                                "foldl"
                                                                                                                            )
                                                                                                                        , H.node1
                                                                                                                            202
                                                                                                                            55
                                                                                                                            57
                                                                                                                            (H.val
                                                                                                                                "fn"
                                                                                                                            )
                                                                                                                        , H.node1
                                                                                                                            202
                                                                                                                            58
                                                                                                                            61
                                                                                                                            (H.val
                                                                                                                                "acc"
                                                                                                                            )
                                                                                                                        , H.node1
                                                                                                                            202
                                                                                                                            62
                                                                                                                            74
                                                                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                                (H.node1
                                                                                                                                    202
                                                                                                                                    63
                                                                                                                                    73
                                                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                                                        [ H.node1
                                                                                                                                            202
                                                                                                                                            63
                                                                                                                                            70
                                                                                                                                            (H.val
                                                                                                                                                "reverse"
                                                                                                                                            )
                                                                                                                                        , H.node1
                                                                                                                                            202
                                                                                                                                            71
                                                                                                                                            73
                                                                                                                                            (H.val
                                                                                                                                                "r4"
                                                                                                                                            )
                                                                                                                                        ]
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        ]
                                                                                                                    )
                                                                                                                )
                                                                                                                (H.node1
                                                                                                                    204
                                                                                                                    49
                                                                                                                    80
                                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                                        [ H.node1
                                                                                                                            204
                                                                                                                            49
                                                                                                                            60
                                                                                                                            (H.val
                                                                                                                                "foldrHelper"
                                                                                                                            )
                                                                                                                        , H.node1
                                                                                                                            204
                                                                                                                            61
                                                                                                                            63
                                                                                                                            (H.val
                                                                                                                                "fn"
                                                                                                                            )
                                                                                                                        , H.node1
                                                                                                                            204
                                                                                                                            64
                                                                                                                            67
                                                                                                                            (H.val
                                                                                                                                "acc"
                                                                                                                            )
                                                                                                                        , H.node1
                                                                                                                            204
                                                                                                                            68
                                                                                                                            77
                                                                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                                (H.node1
                                                                                                                                    204
                                                                                                                                    69
                                                                                                                                    76
                                                                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                        "+"
                                                                                                                                        Elm.Syntax.Infix.Left
                                                                                                                                        (H.node1
                                                                                                                                            204
                                                                                                                                            69
                                                                                                                                            72
                                                                                                                                            (H.val
                                                                                                                                                "ctr"
                                                                                                                                            )
                                                                                                                                        )
                                                                                                                                        (H.node1
                                                                                                                                            204
                                                                                                                                            75
                                                                                                                                            76
                                                                                                                                            (Elm.Syntax.Expression.Integer
                                                                                                                                                1
                                                                                                                                            )
                                                                                                                                        )
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        , H.node1
                                                                                                                            204
                                                                                                                            78
                                                                                                                            80
                                                                                                                            (H.val
                                                                                                                                "r4"
                                                                                                                            )
                                                                                                                        ]
                                                                                                                    )
                                                                                                                )
                                                                                                            )
                                                                                                    }
                                                                                            }
                                                                                        )
                                                                                    ]
                                                                                , expression =
                                                                                    H.node1
                                                                                        206
                                                                                        41
                                                                                        70
                                                                                        (Elm.Syntax.Expression.Application
                                                                                            [ H.node1
                                                                                                206
                                                                                                41
                                                                                                43
                                                                                                (H.val
                                                                                                    "fn"
                                                                                                )
                                                                                            , H.node1
                                                                                                206
                                                                                                44
                                                                                                45
                                                                                                (H.val
                                                                                                    "a"
                                                                                                )
                                                                                            , H.node1
                                                                                                206
                                                                                                46
                                                                                                70
                                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                    (H.node1
                                                                                                        206
                                                                                                        47
                                                                                                        69
                                                                                                        (Elm.Syntax.Expression.Application
                                                                                                            [ H.node1
                                                                                                                206
                                                                                                                47
                                                                                                                49
                                                                                                                (H.val
                                                                                                                    "fn"
                                                                                                                )
                                                                                                            , H.node1
                                                                                                                206
                                                                                                                50
                                                                                                                51
                                                                                                                (H.val
                                                                                                                    "b"
                                                                                                                )
                                                                                                            , H.node1
                                                                                                                206
                                                                                                                52
                                                                                                                69
                                                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                    (H.node1
                                                                                                                        206
                                                                                                                        53
                                                                                                                        68
                                                                                                                        (Elm.Syntax.Expression.Application
                                                                                                                            [ H.node1
                                                                                                                                206
                                                                                                                                53
                                                                                                                                55
                                                                                                                                (H.val
                                                                                                                                    "fn"
                                                                                                                                )
                                                                                                                            , H.node1
                                                                                                                                206
                                                                                                                                56
                                                                                                                                57
                                                                                                                                (H.val
                                                                                                                                    "c"
                                                                                                                                )
                                                                                                                            , H.node1
                                                                                                                                206
                                                                                                                                58
                                                                                                                                68
                                                                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                                    (H.node1
                                                                                                                                        206
                                                                                                                                        59
                                                                                                                                        67
                                                                                                                                        (Elm.Syntax.Expression.Application
                                                                                                                                            [ H.node1
                                                                                                                                                206
                                                                                                                                                59
                                                                                                                                                61
                                                                                                                                                (H.val
                                                                                                                                                    "fn"
                                                                                                                                                )
                                                                                                                                            , H.node1
                                                                                                                                                206
                                                                                                                                                62
                                                                                                                                                63
                                                                                                                                                (H.val
                                                                                                                                                    "d"
                                                                                                                                                )
                                                                                                                                            , H.node1
                                                                                                                                                206
                                                                                                                                                64
                                                                                                                                                67
                                                                                                                                                (H.val
                                                                                                                                                    "res"
                                                                                                                                                )
                                                                                                                                            ]
                                                                                                                                        )
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            ]
                                                                                                                        )
                                                                                                                    )
                                                                                                                )
                                                                                                            ]
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                            ]
                                                                                        )
                                                                                }
                                                                            )
                                                                      )
                                                                    ]
                                                                }
                                                            )
                                                      )
                                                    ]
                                                }
                                            )
                                      )
                                    ]
                                }
                            )
                      )
                    ]
                }
            )
    }


filter : Elm.Syntax.Expression.FunctionImplementation
filter =
    { name = H.node1 214 1 7 "List.filter"
    , arguments =
        [ H.node1 214 8 14 (Elm.Syntax.Pattern.VarPattern "isGood")
        , H.node1 214 15 19 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node1
            215
            3
            62
            (Elm.Syntax.Expression.Application
                [ H.node1 215 3 8 (H.val "foldr")
                , H.node1
                    215
                    9
                    54
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            215
                            10
                            53
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        215
                                        11
                                        12
                                        (Elm.Syntax.Pattern.VarPattern "x")
                                    , H.node1
                                        215
                                        13
                                        15
                                        (Elm.Syntax.Pattern.VarPattern "xs")
                                    ]
                                , expression =
                                    H.node1
                                        215
                                        19
                                        53
                                        (Elm.Syntax.Expression.IfBlock
                                            (H.node1
                                                215
                                                22
                                                30
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        215
                                                        22
                                                        28
                                                        (H.val "isGood")
                                                    , H.node1
                                                        215
                                                        29
                                                        30
                                                        (H.val "x")
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                215
                                                36
                                                45
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        215
                                                        36
                                                        40
                                                        (H.val "cons")
                                                    , H.node1
                                                        215
                                                        41
                                                        42
                                                        (H.val "x")
                                                    , H.node1
                                                        215
                                                        43
                                                        45
                                                        (H.val "xs")
                                                    ]
                                                )
                                            )
                                            (H.node1 215 51 53 (H.val "xs"))
                                        )
                                }
                            )
                        )
                    )
                , H.node1 215 55 57 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 215 58 62 (H.val "list")
                ]
            )
    }


filterMap : Elm.Syntax.Expression.FunctionImplementation
filterMap =
    { name = H.node1 229 1 10 "List.filterMap"
    , arguments =
        [ H.node1 229 11 12 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 229 13 15 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node1
            230
            3
            28
            (Elm.Syntax.Expression.Application
                [ H.node1 230 3 8 (H.val "foldr")
                , H.node1
                    230
                    9
                    22
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            230
                            10
                            21
                            (Elm.Syntax.Expression.Application
                                [ H.node1 230 10 19 (H.val "maybeCons")
                                , H.node1 230 20 21 (H.val "f")
                                ]
                            )
                        )
                    )
                , H.node1 230 23 25 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 230 26 28 (H.val "xs")
                ]
            )
    }


maybeCons : Elm.Syntax.Expression.FunctionImplementation
maybeCons =
    { name = H.node1 234 1 10 "List.maybeCons"
    , arguments =
        [ H.node1 234 11 12 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 234 13 15 (Elm.Syntax.Pattern.VarPattern "mx")
        , H.node1 234 16 18 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node
            235
            3
            240
            9
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        235
                        8
                        12
                        (Elm.Syntax.Expression.Application
                            [ H.node1 235 8 9 (H.val "f")
                            , H.node1 235 10 12 (H.val "mx")
                            ]
                        )
                , cases =
                    [ ( H.node1
                            236
                            5
                            11
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    236
                                    10
                                    11
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                ]
                            )
                      , H.node1
                            237
                            7
                            16
                            (Elm.Syntax.Expression.Application
                                [ H.node1 237 7 11 (H.val "cons")
                                , H.node1 237 12 13 (H.val "x")
                                , H.node1 237 14 16 (H.val "xs")
                                ]
                            )
                      )
                    , ( H.node1
                            239
                            5
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 240 7 9 (H.val "xs")
                      )
                    ]
                }
            )
    }


length : Elm.Syntax.Expression.FunctionImplementation
length =
    { name = H.node1 251 1 7 "List.length"
    , arguments = [ H.node1 251 8 10 (Elm.Syntax.Pattern.VarPattern "xs") ]
    , expression =
        H.node1
            252
            3
            29
            (Elm.Syntax.Expression.Application
                [ H.node1 252 3 8 (H.val "foldl")
                , H.node1
                    252
                    9
                    24
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            252
                            10
                            23
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        252
                                        11
                                        12
                                        Elm.Syntax.Pattern.AllPattern
                                    , H.node1
                                        252
                                        13
                                        14
                                        (Elm.Syntax.Pattern.VarPattern "i")
                                    ]
                                , expression =
                                    H.node1
                                        252
                                        18
                                        23
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "+"
                                            Elm.Syntax.Infix.Left
                                            (H.node1 252 18 19 (H.val "i"))
                                            (H.node1
                                                252
                                                22
                                                23
                                                (Elm.Syntax.Expression.Integer 1
                                                )
                                            )
                                        )
                                }
                            )
                        )
                    )
                , H.node1 252 25 26 (Elm.Syntax.Expression.Integer 0)
                , H.node1 252 27 29 (H.val "xs")
                ]
            )
    }


reverse : Elm.Syntax.Expression.FunctionImplementation
reverse =
    { name = H.node1 260 1 8 "List.reverse"
    , arguments = [ H.node1 260 9 13 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node1
            261
            3
            21
            (Elm.Syntax.Expression.Application
                [ H.node1 261 3 8 (H.val "foldl")
                , H.node1 261 9 13 (H.val "cons")
                , H.node1 261 14 16 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 261 17 21 (H.val "list")
                ]
            )
    }


member : Elm.Syntax.Expression.FunctionImplementation
member =
    { name = H.node1 270 1 7 "List.member"
    , arguments =
        [ H.node1 270 8 9 (Elm.Syntax.Pattern.VarPattern "x")
        , H.node1 270 10 12 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node1
            271
            3
            24
            (Elm.Syntax.Expression.Application
                [ H.node1 271 3 6 (H.val "any")
                , H.node1
                    271
                    7
                    21
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            271
                            8
                            20
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        271
                                        9
                                        10
                                        (Elm.Syntax.Pattern.VarPattern "a")
                                    ]
                                , expression =
                                    H.node1
                                        271
                                        14
                                        20
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "=="
                                            Elm.Syntax.Infix.Non
                                            (H.node1 271 14 15 (H.val "a"))
                                            (H.node1 271 19 20 (H.val "x"))
                                        )
                                }
                            )
                        )
                    )
                , H.node1 271 22 24 (H.val "xs")
                ]
            )
    }


all : Elm.Syntax.Expression.FunctionImplementation
all =
    { name = H.node1 281 1 4 "List.all"
    , arguments =
        [ H.node1 281 5 11 (Elm.Syntax.Pattern.VarPattern "isOkay")
        , H.node1 281 12 16 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node1
            282
            3
            33
            (Elm.Syntax.Expression.Application
                [ H.node1 282 3 6 (H.val "not")
                , H.node1
                    282
                    7
                    33
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            282
                            8
                            32
                            (Elm.Syntax.Expression.Application
                                [ H.node1 282 8 11 (H.val "any")
                                , H.node1
                                    282
                                    12
                                    27
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            282
                                            13
                                            26
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "<<"
                                                Elm.Syntax.Infix.Left
                                                (H.node1 282 13 16 (H.val "not")
                                                )
                                                (H.node1
                                                    282
                                                    20
                                                    26
                                                    (H.val "isOkay")
                                                )
                                            )
                                        )
                                    )
                                , H.node1 282 28 32 (H.val "list")
                                ]
                            )
                        )
                    )
                ]
            )
    }


any : Elm.Syntax.Expression.FunctionImplementation
any =
    { name = H.node1 292 1 4 "List.any"
    , arguments =
        [ H.node1 292 5 11 (Elm.Syntax.Pattern.VarPattern "isOkay")
        , H.node1 292 12 16 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            293
            3
            303
            22
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 293 8 12 (H.val "list")
                , cases =
                    [ ( H.node1 294 5 7 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 295 7 12 (H.val "False")
                      )
                    , ( H.node1
                            297
                            5
                            12
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    297
                                    5
                                    6
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    297
                                    10
                                    12
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node
                            299
                            7
                            303
                            22
                            (Elm.Syntax.Expression.IfBlock
                                (H.node1
                                    299
                                    10
                                    18
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 299 10 16 (H.val "isOkay")
                                        , H.node1 299 17 18 (H.val "x")
                                        ]
                                    )
                                )
                                (H.node1 300 9 13 (H.val "True"))
                                (H.node1
                                    303
                                    9
                                    22
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 303 9 12 (H.val "any")
                                        , H.node1 303 13 19 (H.val "isOkay")
                                        , H.node1 303 20 22 (H.val "xs")
                                        ]
                                    )
                                )
                            )
                      )
                    ]
                }
            )
    }


maximum : Elm.Syntax.Expression.FunctionImplementation
maximum =
    { name = H.node1 312 1 8 "List.maximum"
    , arguments = [ H.node1 312 9 13 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node
            313
            3
            318
            14
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 313 8 12 (H.val "list")
                , cases =
                    [ ( H.node1
                            314
                            5
                            12
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    314
                                    5
                                    6
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    314
                                    10
                                    12
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node1
                            315
                            7
                            28
                            (Elm.Syntax.Expression.Application
                                [ H.node1 315 7 11 (H.val "Just")
                                , H.node1
                                    315
                                    12
                                    28
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            315
                                            13
                                            27
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    315
                                                    13
                                                    18
                                                    (H.val "foldl")
                                                , H.node1
                                                    315
                                                    19
                                                    22
                                                    (H.val "max")
                                                , H.node1 315 23 24 (H.val "x")
                                                , H.node1 315 25 27 (H.val "xs")
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      )
                    , ( H.node1 317 5 6 Elm.Syntax.Pattern.AllPattern
                      , H.node1 318 7 14 (H.val "Nothing")
                      )
                    ]
                }
            )
    }


minimum : Elm.Syntax.Expression.FunctionImplementation
minimum =
    { name = H.node1 327 1 8 "List.minimum"
    , arguments = [ H.node1 327 9 13 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node
            328
            3
            333
            14
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 328 8 12 (H.val "list")
                , cases =
                    [ ( H.node1
                            329
                            5
                            12
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    329
                                    5
                                    6
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    329
                                    10
                                    12
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node1
                            330
                            7
                            28
                            (Elm.Syntax.Expression.Application
                                [ H.node1 330 7 11 (H.val "Just")
                                , H.node1
                                    330
                                    12
                                    28
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            330
                                            13
                                            27
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    330
                                                    13
                                                    18
                                                    (H.val "foldl")
                                                , H.node1
                                                    330
                                                    19
                                                    22
                                                    (H.val "min")
                                                , H.node1 330 23 24 (H.val "x")
                                                , H.node1 330 25 27 (H.val "xs")
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      )
                    , ( H.node1 332 5 6 Elm.Syntax.Pattern.AllPattern
                      , H.node1 333 7 14 (H.val "Nothing")
                      )
                    ]
                }
            )
    }


sum : Elm.Syntax.Expression.FunctionImplementation
sum =
    { name = H.node1 344 1 4 "List.sum"
    , arguments = [ H.node1 344 5 12 (Elm.Syntax.Pattern.VarPattern "numbers") ]
    , expression =
        H.node1
            345
            3
            22
            (Elm.Syntax.Expression.Application
                [ H.node1 345 3 8 (H.val "foldl")
                , H.node1 345 9 12 (Elm.Syntax.Expression.PrefixOperator "+")
                , H.node1 345 13 14 (Elm.Syntax.Expression.Integer 0)
                , H.node1 345 15 22 (H.val "numbers")
                ]
            )
    }


product : Elm.Syntax.Expression.FunctionImplementation
product =
    { name = H.node1 356 1 8 "List.product"
    , arguments = [ H.node1 356 9 16 (Elm.Syntax.Pattern.VarPattern "numbers") ]
    , expression =
        H.node1
            357
            3
            22
            (Elm.Syntax.Expression.Application
                [ H.node1 357 3 8 (H.val "foldl")
                , H.node1 357 9 12 (Elm.Syntax.Expression.PrefixOperator "*")
                , H.node1 357 13 14 (Elm.Syntax.Expression.Integer 1)
                , H.node1 357 15 22 (H.val "numbers")
                ]
            )
    }


append : Elm.Syntax.Expression.FunctionImplementation
append =
    { name = H.node1 372 1 7 "List.append"
    , arguments =
        [ H.node1 372 8 10 (Elm.Syntax.Pattern.VarPattern "xs")
        , H.node1 372 11 13 (Elm.Syntax.Pattern.VarPattern "ys")
        ]
    , expression =
        H.node
            373
            3
            378
            23
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 373 8 10 (H.val "ys")
                , cases =
                    [ ( H.node1 374 5 7 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 375 7 9 (H.val "xs")
                      )
                    , ( H.node1 377 5 6 Elm.Syntax.Pattern.AllPattern
                      , H.node1
                            378
                            7
                            23
                            (Elm.Syntax.Expression.Application
                                [ H.node1 378 7 12 (H.val "foldr")
                                , H.node1 378 13 17 (H.val "cons")
                                , H.node1 378 18 20 (H.val "ys")
                                , H.node1 378 21 23 (H.val "xs")
                                ]
                            )
                      )
                    ]
                }
            )
    }


concat : Elm.Syntax.Expression.FunctionImplementation
concat =
    { name = H.node1 386 1 7 "List.concat"
    , arguments = [ H.node1 386 8 13 (Elm.Syntax.Pattern.VarPattern "lists") ]
    , expression =
        H.node1
            387
            3
            24
            (Elm.Syntax.Expression.Application
                [ H.node1 387 3 8 (H.val "foldr")
                , H.node1 387 9 15 (H.val "append")
                , H.node1 387 16 18 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 387 19 24 (H.val "lists")
                ]
            )
    }


concatMap : Elm.Syntax.Expression.FunctionImplementation
concatMap =
    { name = H.node1 395 1 10 "List.concatMap"
    , arguments =
        [ H.node1 395 11 12 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 395 13 17 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node1
            396
            3
            22
            (Elm.Syntax.Expression.Application
                [ H.node1 396 3 9 (H.val "concat")
                , H.node1
                    396
                    10
                    22
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            396
                            11
                            21
                            (Elm.Syntax.Expression.Application
                                [ H.node1 396 11 14 (H.val "map")
                                , H.node1 396 15 16 (H.val "f")
                                , H.node1 396 17 21 (H.val "list")
                                ]
                            )
                        )
                    )
                ]
            )
    }


intersperse : Elm.Syntax.Expression.FunctionImplementation
intersperse =
    { name = H.node1 404 1 12 "List.intersperse"
    , arguments =
        [ H.node1 404 13 16 (Elm.Syntax.Pattern.VarPattern "sep")
        , H.node1 404 17 19 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node
            405
            3
            417
            24
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 405 8 10 (H.val "xs")
                , cases =
                    [ ( H.node1 406 5 7 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 407 7 9 (Elm.Syntax.Expression.ListExpr [])
                      )
                    , ( H.node1
                            409
                            5
                            13
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    409
                                    5
                                    7
                                    (Elm.Syntax.Pattern.VarPattern "hd")
                                )
                                (H.node1
                                    409
                                    11
                                    13
                                    (Elm.Syntax.Pattern.VarPattern "tl")
                                )
                            )
                      , H.node
                            410
                            7
                            417
                            24
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ H.node
                                        411
                                        9
                                        412
                                        33
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    411
                                                    9
                                                    412
                                                    33
                                                    { name =
                                                        H.node1 411 9 13 "step"
                                                    , arguments =
                                                        [ H.node1
                                                            411
                                                            14
                                                            15
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "x"
                                                            )
                                                        , H.node1
                                                            411
                                                            16
                                                            20
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "rest"
                                                            )
                                                        ]
                                                    , expression =
                                                        H.node1
                                                            412
                                                            11
                                                            33
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    412
                                                                    11
                                                                    15
                                                                    (H.val
                                                                        "cons"
                                                                    )
                                                                , H.node1
                                                                    412
                                                                    16
                                                                    19
                                                                    (H.val "sep"
                                                                    )
                                                                , H.node1
                                                                    412
                                                                    20
                                                                    33
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            412
                                                                            21
                                                                            32
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    412
                                                                                    21
                                                                                    25
                                                                                    (H.val
                                                                                        "cons"
                                                                                    )
                                                                                , H.node1
                                                                                    412
                                                                                    26
                                                                                    27
                                                                                    (H.val
                                                                                        "x"
                                                                                    )
                                                                                , H.node1
                                                                                    412
                                                                                    28
                                                                                    32
                                                                                    (H.val
                                                                                        "rest"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                    }
                                            }
                                        )
                                    , H.node
                                        414
                                        9
                                        415
                                        27
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    414
                                                    9
                                                    415
                                                    27
                                                    { name =
                                                        H.node1
                                                            414
                                                            9
                                                            16
                                                            "spersed"
                                                    , arguments = []
                                                    , expression =
                                                        H.node1
                                                            415
                                                            11
                                                            27
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    415
                                                                    11
                                                                    16
                                                                    (H.val
                                                                        "foldr"
                                                                    )
                                                                , H.node1
                                                                    415
                                                                    17
                                                                    21
                                                                    (H.val
                                                                        "step"
                                                                    )
                                                                , H.node1
                                                                    415
                                                                    22
                                                                    24
                                                                    (Elm.Syntax.Expression.ListExpr
                                                                        []
                                                                    )
                                                                , H.node1
                                                                    415
                                                                    25
                                                                    27
                                                                    (H.val "tl")
                                                                ]
                                                            )
                                                    }
                                            }
                                        )
                                    ]
                                , expression =
                                    H.node1
                                        417
                                        9
                                        24
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 417 9 13 (H.val "cons")
                                            , H.node1 417 14 16 (H.val "hd")
                                            , H.node1
                                                417
                                                17
                                                24
                                                (H.val "spersed")
                                            ]
                                        )
                                }
                            )
                      )
                    ]
                }
            )
    }


map2 : Elm.Syntax.Expression.FunctionImplementation
map2 =
    { name = H.node1 438 1 5 "List.map2"
    , arguments = []
    , expression =
        H.node1
            439
            3
            23
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "map2"
            )
    }


map3 : Elm.Syntax.Expression.FunctionImplementation
map3 =
    { name = H.node1 444 1 5 "List.map3"
    , arguments = []
    , expression =
        H.node1
            445
            3
            23
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "map3"
            )
    }


map4 : Elm.Syntax.Expression.FunctionImplementation
map4 =
    { name = H.node1 450 1 5 "List.map4"
    , arguments = []
    , expression =
        H.node1
            451
            3
            23
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "map4"
            )
    }


map5 : Elm.Syntax.Expression.FunctionImplementation
map5 =
    { name = H.node1 456 1 5 "List.map5"
    , arguments = []
    , expression =
        H.node1
            457
            3
            23
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "map5"
            )
    }


sort : Elm.Syntax.Expression.FunctionImplementation
sort =
    { name = H.node1 469 1 5 "List.sort"
    , arguments = [ H.node1 469 6 8 (Elm.Syntax.Pattern.VarPattern "xs") ]
    , expression =
        H.node1
            470
            3
            21
            (Elm.Syntax.Expression.Application
                [ H.node1 470 3 9 (H.val "sortBy")
                , H.node1 470 10 18 (H.val "identity")
                , H.node1 470 19 21 (H.val "xs")
                ]
            )
    }


sortBy : Elm.Syntax.Expression.FunctionImplementation
sortBy =
    { name = H.node1 485 1 7 "List.sortBy"
    , arguments = []
    , expression =
        H.node1
            486
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "sortBy"
            )
    }


sortWith : Elm.Syntax.Expression.FunctionImplementation
sortWith =
    { name = H.node1 503 1 9 "List.sortWith"
    , arguments = []
    , expression =
        H.node1
            504
            3
            27
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "List" ]
                "sortWith"
            )
    }


isEmpty : Elm.Syntax.Expression.FunctionImplementation
isEmpty =
    { name = H.node1 519 1 8 "List.isEmpty"
    , arguments = [ H.node1 519 9 11 (Elm.Syntax.Pattern.VarPattern "xs") ]
    , expression =
        H.node
            520
            3
            525
            12
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 520 8 10 (H.val "xs")
                , cases =
                    [ ( H.node1 521 5 7 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 522 7 11 (H.val "True")
                      )
                    , ( H.node1 524 5 6 Elm.Syntax.Pattern.AllPattern
                      , H.node1 525 7 12 (H.val "False")
                      )
                    ]
                }
            )
    }


head : Elm.Syntax.Expression.FunctionImplementation
head =
    { name = H.node1 537 1 5 "List.head"
    , arguments = [ H.node1 537 6 10 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node
            538
            3
            543
            14
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 538 8 12 (H.val "list")
                , cases =
                    [ ( H.node1
                            539
                            5
                            12
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    539
                                    5
                                    6
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    539
                                    10
                                    12
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node1
                            540
                            7
                            13
                            (Elm.Syntax.Expression.Application
                                [ H.node1 540 7 11 (H.val "Just")
                                , H.node1 540 12 13 (H.val "x")
                                ]
                            )
                      )
                    , ( H.node1 542 5 7 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 543 7 14 (H.val "Nothing")
                      )
                    ]
                }
            )
    }


tail : Elm.Syntax.Expression.FunctionImplementation
tail =
    { name = H.node1 555 1 5 "List.tail"
    , arguments = [ H.node1 555 6 10 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node
            556
            3
            561
            14
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 556 8 12 (H.val "list")
                , cases =
                    [ ( H.node1
                            557
                            5
                            12
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    557
                                    5
                                    6
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    557
                                    10
                                    12
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node1
                            558
                            7
                            14
                            (Elm.Syntax.Expression.Application
                                [ H.node1 558 7 11 (H.val "Just")
                                , H.node1 558 12 14 (H.val "xs")
                                ]
                            )
                      )
                    , ( H.node1 560 5 7 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 561 7 14 (H.val "Nothing")
                      )
                    ]
                }
            )
    }


take : Elm.Syntax.Expression.FunctionImplementation
take =
    { name = H.node1 569 1 5 "List.take"
    , arguments =
        [ H.node1 569 6 7 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 569 8 12 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node1
            570
            3
            20
            (Elm.Syntax.Expression.Application
                [ H.node1 570 3 11 (H.val "takeFast")
                , H.node1 570 12 13 (Elm.Syntax.Expression.Integer 0)
                , H.node1 570 14 15 (H.val "n")
                , H.node1 570 16 20 (H.val "list")
                ]
            )
    }


takeFast : Elm.Syntax.Expression.FunctionImplementation
takeFast =
    { name = H.node1 574 1 9 "List.takeFast"
    , arguments =
        [ H.node1 574 10 13 (Elm.Syntax.Pattern.VarPattern "ctr")
        , H.node1 574 14 15 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 574 16 20 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            575
            3
            598
            13
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    575
                    6
                    12
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Non
                        (H.node1 575 6 7 (H.val "n"))
                        (H.node1 575 11 12 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node1 576 5 7 (Elm.Syntax.Expression.ListExpr []))
                (H.node
                    578
                    5
                    598
                    13
                    (Elm.Syntax.Expression.CaseExpression
                        { expression =
                            H.node1
                                578
                                10
                                21
                                (Elm.Syntax.Expression.TupledExpression
                                    [ H.node1 578 12 13 (H.val "n")
                                    , H.node1 578 15 19 (H.val "list")
                                    ]
                                )
                        , cases =
                            [ ( H.node1
                                    579
                                    7
                                    16
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ H.node1
                                            579
                                            9
                                            10
                                            Elm.Syntax.Pattern.AllPattern
                                        , H.node1
                                            579
                                            12
                                            14
                                            (Elm.Syntax.Pattern.ListPattern [])
                                        ]
                                    )
                              , H.node1 580 9 13 (H.val "list")
                              )
                            , ( H.node1
                                    582
                                    7
                                    20
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ H.node1
                                            582
                                            9
                                            10
                                            (Elm.Syntax.Pattern.IntPattern 1)
                                        , H.node1
                                            582
                                            12
                                            18
                                            (Elm.Syntax.Pattern.UnConsPattern
                                                (H.node1
                                                    582
                                                    12
                                                    13
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                )
                                                (H.node1
                                                    582
                                                    17
                                                    18
                                                    Elm.Syntax.Pattern.AllPattern
                                                )
                                            )
                                        ]
                                    )
                              , H.node1
                                    583
                                    9
                                    14
                                    (Elm.Syntax.Expression.ListExpr
                                        [ H.node1 583 11 12 (H.val "x") ]
                                    )
                              )
                            , ( H.node1
                                    585
                                    7
                                    25
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ H.node1
                                            585
                                            9
                                            10
                                            (Elm.Syntax.Pattern.IntPattern 2)
                                        , H.node1
                                            585
                                            12
                                            23
                                            (Elm.Syntax.Pattern.UnConsPattern
                                                (H.node1
                                                    585
                                                    12
                                                    13
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                )
                                                (H.node1
                                                    585
                                                    17
                                                    23
                                                    (Elm.Syntax.Pattern.UnConsPattern
                                                        (H.node1
                                                            585
                                                            17
                                                            18
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "y"
                                                            )
                                                        )
                                                        (H.node1
                                                            585
                                                            22
                                                            23
                                                            Elm.Syntax.Pattern.AllPattern
                                                        )
                                                    )
                                                )
                                            )
                                        ]
                                    )
                              , H.node1
                                    586
                                    9
                                    17
                                    (Elm.Syntax.Expression.ListExpr
                                        [ H.node1 586 11 12 (H.val "x")
                                        , H.node1 586 14 15 (H.val "y")
                                        ]
                                    )
                              )
                            , ( H.node1
                                    588
                                    7
                                    30
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ H.node1
                                            588
                                            9
                                            10
                                            (Elm.Syntax.Pattern.IntPattern 3)
                                        , H.node1
                                            588
                                            12
                                            28
                                            (Elm.Syntax.Pattern.UnConsPattern
                                                (H.node1
                                                    588
                                                    12
                                                    13
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                )
                                                (H.node1
                                                    588
                                                    17
                                                    28
                                                    (Elm.Syntax.Pattern.UnConsPattern
                                                        (H.node1
                                                            588
                                                            17
                                                            18
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "y"
                                                            )
                                                        )
                                                        (H.node1
                                                            588
                                                            22
                                                            28
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    588
                                                                    22
                                                                    23
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "z"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    588
                                                                    27
                                                                    28
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        ]
                                    )
                              , H.node1
                                    589
                                    9
                                    20
                                    (Elm.Syntax.Expression.ListExpr
                                        [ H.node1 589 11 12 (H.val "x")
                                        , H.node1 589 14 15 (H.val "y")
                                        , H.node1 589 17 18 (H.val "z")
                                        ]
                                    )
                              )
                            , ( H.node1
                                    591
                                    7
                                    36
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ H.node1
                                            591
                                            9
                                            10
                                            Elm.Syntax.Pattern.AllPattern
                                        , H.node1
                                            591
                                            12
                                            34
                                            (Elm.Syntax.Pattern.UnConsPattern
                                                (H.node1
                                                    591
                                                    12
                                                    13
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                )
                                                (H.node1
                                                    591
                                                    17
                                                    34
                                                    (Elm.Syntax.Pattern.UnConsPattern
                                                        (H.node1
                                                            591
                                                            17
                                                            18
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "y"
                                                            )
                                                        )
                                                        (H.node1
                                                            591
                                                            22
                                                            34
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    591
                                                                    22
                                                                    23
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "z"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    591
                                                                    27
                                                                    34
                                                                    (Elm.Syntax.Pattern.UnConsPattern
                                                                        (H.node1
                                                                            591
                                                                            27
                                                                            28
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "w"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            591
                                                                            32
                                                                            34
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "tl"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        ]
                                    )
                              , H.node
                                    592
                                    9
                                    595
                                    76
                                    (Elm.Syntax.Expression.IfBlock
                                        (H.node1
                                            592
                                            12
                                            22
                                            (Elm.Syntax.Expression.OperatorApplication
                                                ">"
                                                Elm.Syntax.Infix.Non
                                                (H.node1 592 12 15 (H.val "ctr")
                                                )
                                                (H.node1
                                                    592
                                                    18
                                                    22
                                                    (Elm.Syntax.Expression.Integer
                                                        1000
                                                    )
                                                )
                                            )
                                        )
                                        (H.node1
                                            593
                                            11
                                            69
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    593
                                                    11
                                                    15
                                                    (H.val "cons")
                                                , H.node1 593 16 17 (H.val "x")
                                                , H.node1
                                                    593
                                                    18
                                                    69
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            593
                                                            19
                                                            68
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    593
                                                                    19
                                                                    23
                                                                    (H.val
                                                                        "cons"
                                                                    )
                                                                , H.node1
                                                                    593
                                                                    24
                                                                    25
                                                                    (H.val "y")
                                                                , H.node1
                                                                    593
                                                                    26
                                                                    68
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            593
                                                                            27
                                                                            67
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    593
                                                                                    27
                                                                                    31
                                                                                    (H.val
                                                                                        "cons"
                                                                                    )
                                                                                , H.node1
                                                                                    593
                                                                                    32
                                                                                    33
                                                                                    (H.val
                                                                                        "z"
                                                                                    )
                                                                                , H.node1
                                                                                    593
                                                                                    34
                                                                                    67
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (H.node1
                                                                                            593
                                                                                            35
                                                                                            66
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    593
                                                                                                    35
                                                                                                    39
                                                                                                    (H.val
                                                                                                        "cons"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    593
                                                                                                    40
                                                                                                    41
                                                                                                    (H.val
                                                                                                        "w"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    593
                                                                                                    42
                                                                                                    66
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (H.node1
                                                                                                            593
                                                                                                            43
                                                                                                            65
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ H.node1
                                                                                                                    593
                                                                                                                    43
                                                                                                                    54
                                                                                                                    (H.val
                                                                                                                        "takeTailRec"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    593
                                                                                                                    55
                                                                                                                    62
                                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                        (H.node1
                                                                                                                            593
                                                                                                                            56
                                                                                                                            61
                                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                "-"
                                                                                                                                Elm.Syntax.Infix.Left
                                                                                                                                (H.node1
                                                                                                                                    593
                                                                                                                                    56
                                                                                                                                    57
                                                                                                                                    (H.val
                                                                                                                                        "n"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (H.node1
                                                                                                                                    593
                                                                                                                                    60
                                                                                                                                    61
                                                                                                                                    (Elm.Syntax.Expression.Integer
                                                                                                                                        4
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    593
                                                                                                                    63
                                                                                                                    65
                                                                                                                    (H.val
                                                                                                                        "tl"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ]
                                            )
                                        )
                                        (H.node1
                                            595
                                            11
                                            76
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    595
                                                    11
                                                    15
                                                    (H.val "cons")
                                                , H.node1 595 16 17 (H.val "x")
                                                , H.node1
                                                    595
                                                    18
                                                    76
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            595
                                                            19
                                                            75
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    595
                                                                    19
                                                                    23
                                                                    (H.val
                                                                        "cons"
                                                                    )
                                                                , H.node1
                                                                    595
                                                                    24
                                                                    25
                                                                    (H.val "y")
                                                                , H.node1
                                                                    595
                                                                    26
                                                                    75
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            595
                                                                            27
                                                                            74
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    595
                                                                                    27
                                                                                    31
                                                                                    (H.val
                                                                                        "cons"
                                                                                    )
                                                                                , H.node1
                                                                                    595
                                                                                    32
                                                                                    33
                                                                                    (H.val
                                                                                        "z"
                                                                                    )
                                                                                , H.node1
                                                                                    595
                                                                                    34
                                                                                    74
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (H.node1
                                                                                            595
                                                                                            35
                                                                                            73
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    595
                                                                                                    35
                                                                                                    39
                                                                                                    (H.val
                                                                                                        "cons"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    595
                                                                                                    40
                                                                                                    41
                                                                                                    (H.val
                                                                                                        "w"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    595
                                                                                                    42
                                                                                                    73
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (H.node1
                                                                                                            595
                                                                                                            43
                                                                                                            72
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ H.node1
                                                                                                                    595
                                                                                                                    43
                                                                                                                    51
                                                                                                                    (H.val
                                                                                                                        "takeFast"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    595
                                                                                                                    52
                                                                                                                    61
                                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                        (H.node1
                                                                                                                            595
                                                                                                                            53
                                                                                                                            60
                                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                "+"
                                                                                                                                Elm.Syntax.Infix.Left
                                                                                                                                (H.node1
                                                                                                                                    595
                                                                                                                                    53
                                                                                                                                    56
                                                                                                                                    (H.val
                                                                                                                                        "ctr"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (H.node1
                                                                                                                                    595
                                                                                                                                    59
                                                                                                                                    60
                                                                                                                                    (Elm.Syntax.Expression.Integer
                                                                                                                                        1
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    595
                                                                                                                    62
                                                                                                                    69
                                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                        (H.node1
                                                                                                                            595
                                                                                                                            63
                                                                                                                            68
                                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                "-"
                                                                                                                                Elm.Syntax.Infix.Left
                                                                                                                                (H.node1
                                                                                                                                    595
                                                                                                                                    63
                                                                                                                                    64
                                                                                                                                    (H.val
                                                                                                                                        "n"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (H.node1
                                                                                                                                    595
                                                                                                                                    67
                                                                                                                                    68
                                                                                                                                    (Elm.Syntax.Expression.Integer
                                                                                                                                        4
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    595
                                                                                                                    70
                                                                                                                    72
                                                                                                                    (H.val
                                                                                                                        "tl"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ]
                                            )
                                        )
                                    )
                              )
                            , ( H.node1 597 7 8 Elm.Syntax.Pattern.AllPattern
                              , H.node1 598 9 13 (H.val "list")
                              )
                            ]
                        }
                    )
                )
            )
    }


takeTailRec : Elm.Syntax.Expression.FunctionImplementation
takeTailRec =
    { name = H.node1 601 1 12 "List.takeTailRec"
    , arguments =
        [ H.node1 601 13 14 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 601 15 19 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node1
            602
            3
            34
            (Elm.Syntax.Expression.Application
                [ H.node1 602 3 10 (H.val "reverse")
                , H.node1
                    602
                    11
                    34
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            602
                            12
                            33
                            (Elm.Syntax.Expression.Application
                                [ H.node1 602 12 23 (H.val "takeReverse")
                                , H.node1 602 24 25 (H.val "n")
                                , H.node1 602 26 30 (H.val "list")
                                , H.node1
                                    602
                                    31
                                    33
                                    (Elm.Syntax.Expression.ListExpr [])
                                ]
                            )
                        )
                    )
                ]
            )
    }


takeReverse : Elm.Syntax.Expression.FunctionImplementation
takeReverse =
    { name = H.node1 606 1 12 "List.takeReverse"
    , arguments =
        [ H.node1 606 13 14 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 606 15 19 (Elm.Syntax.Pattern.VarPattern "list")
        , H.node1 606 20 24 (Elm.Syntax.Pattern.VarPattern "kept")
        ]
    , expression =
        H.node
            607
            3
            615
            45
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    607
                    6
                    12
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Non
                        (H.node1 607 6 7 (H.val "n"))
                        (H.node1 607 11 12 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node1 608 5 9 (H.val "kept"))
                (H.node
                    610
                    5
                    615
                    45
                    (Elm.Syntax.Expression.CaseExpression
                        { expression = H.node1 610 10 14 (H.val "list")
                        , cases =
                            [ ( H.node1
                                    611
                                    7
                                    9
                                    (Elm.Syntax.Pattern.ListPattern [])
                              , H.node1 612 9 13 (H.val "kept")
                              )
                            , ( H.node1
                                    614
                                    7
                                    14
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (H.node1
                                            614
                                            7
                                            8
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        )
                                        (H.node1
                                            614
                                            12
                                            14
                                            (Elm.Syntax.Pattern.VarPattern "xs")
                                        )
                                    )
                              , H.node1
                                    615
                                    9
                                    45
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 615 9 20 (H.val "takeReverse")
                                        , H.node1
                                            615
                                            21
                                            28
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    615
                                                    22
                                                    27
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            615
                                                            22
                                                            23
                                                            (H.val "n")
                                                        )
                                                        (H.node1
                                                            615
                                                            26
                                                            27
                                                            (Elm.Syntax.Expression.Integer
                                                                1
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        , H.node1 615 29 31 (H.val "xs")
                                        , H.node1
                                            615
                                            32
                                            45
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    615
                                                    33
                                                    44
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            615
                                                            33
                                                            37
                                                            (H.val "cons")
                                                        , H.node1
                                                            615
                                                            38
                                                            39
                                                            (H.val "x")
                                                        , H.node1
                                                            615
                                                            40
                                                            44
                                                            (H.val "kept")
                                                        ]
                                                    )
                                                )
                                            )
                                        ]
                                    )
                              )
                            ]
                        }
                    )
                )
            )
    }


drop : Elm.Syntax.Expression.FunctionImplementation
drop =
    { name = H.node1 623 1 5 "List.drop"
    , arguments =
        [ H.node1 623 6 7 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 623 8 12 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            624
            3
            633
            24
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    624
                    6
                    12
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Non
                        (H.node1 624 6 7 (H.val "n"))
                        (H.node1 624 11 12 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node1 625 5 9 (H.val "list"))
                (H.node
                    628
                    5
                    633
                    24
                    (Elm.Syntax.Expression.CaseExpression
                        { expression = H.node1 628 10 14 (H.val "list")
                        , cases =
                            [ ( H.node1
                                    629
                                    7
                                    9
                                    (Elm.Syntax.Pattern.ListPattern [])
                              , H.node1 630 9 13 (H.val "list")
                              )
                            , ( H.node1
                                    632
                                    7
                                    14
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (H.node1
                                            632
                                            7
                                            8
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        )
                                        (H.node1
                                            632
                                            12
                                            14
                                            (Elm.Syntax.Pattern.VarPattern "xs")
                                        )
                                    )
                              , H.node1
                                    633
                                    9
                                    24
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 633 9 13 (H.val "drop")
                                        , H.node1
                                            633
                                            14
                                            21
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    633
                                                    15
                                                    20
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            633
                                                            15
                                                            16
                                                            (H.val "n")
                                                        )
                                                        (H.node1
                                                            633
                                                            19
                                                            20
                                                            (Elm.Syntax.Expression.Integer
                                                                1
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        , H.node1 633 22 24 (H.val "xs")
                                        ]
                                    )
                              )
                            ]
                        }
                    )
                )
            )
    }


partition : Elm.Syntax.Expression.FunctionImplementation
partition =
    { name = H.node1 643 1 10 "List.partition"
    , arguments =
        [ H.node1 643 11 15 (Elm.Syntax.Pattern.VarPattern "pred")
        , H.node1 643 16 20 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            644
            3
            652
            28
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        645
                        5
                        650
                        31
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    645
                                    5
                                    650
                                    31
                                    { name = H.node1 645 5 9 "step"
                                    , arguments =
                                        [ H.node1
                                            645
                                            10
                                            11
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        , H.node1
                                            645
                                            12
                                            27
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    645
                                                    13
                                                    18
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "trues"
                                                    )
                                                , H.node1
                                                    645
                                                    20
                                                    26
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "falses"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            646
                                            7
                                            650
                                            31
                                            (Elm.Syntax.Expression.IfBlock
                                                (H.node1
                                                    646
                                                    10
                                                    16
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            646
                                                            10
                                                            14
                                                            (H.val "pred")
                                                        , H.node1
                                                            646
                                                            15
                                                            16
                                                            (H.val "x")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    647
                                                    9
                                                    31
                                                    (Elm.Syntax.Expression.TupledExpression
                                                        [ H.node1
                                                            647
                                                            10
                                                            22
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    647
                                                                    10
                                                                    14
                                                                    (H.val
                                                                        "cons"
                                                                    )
                                                                , H.node1
                                                                    647
                                                                    15
                                                                    16
                                                                    (H.val "x")
                                                                , H.node1
                                                                    647
                                                                    17
                                                                    22
                                                                    (H.val
                                                                        "trues"
                                                                    )
                                                                ]
                                                            )
                                                        , H.node1
                                                            647
                                                            24
                                                            30
                                                            (H.val "falses")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    650
                                                    9
                                                    31
                                                    (Elm.Syntax.Expression.TupledExpression
                                                        [ H.node1
                                                            650
                                                            10
                                                            15
                                                            (H.val "trues")
                                                        , H.node1
                                                            650
                                                            17
                                                            30
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    650
                                                                    17
                                                                    21
                                                                    (H.val
                                                                        "cons"
                                                                    )
                                                                , H.node1
                                                                    650
                                                                    22
                                                                    23
                                                                    (H.val "x")
                                                                , H.node1
                                                                    650
                                                                    24
                                                                    30
                                                                    (H.val
                                                                        "falses"
                                                                    )
                                                                ]
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        652
                        5
                        28
                        (Elm.Syntax.Expression.Application
                            [ H.node1 652 5 10 (H.val "foldr")
                            , H.node1 652 11 15 (H.val "step")
                            , H.node1
                                652
                                16
                                23
                                (Elm.Syntax.Expression.TupledExpression
                                    [ H.node1
                                        652
                                        17
                                        19
                                        (Elm.Syntax.Expression.ListExpr [])
                                    , H.node1
                                        652
                                        20
                                        22
                                        (Elm.Syntax.Expression.ListExpr [])
                                    ]
                                )
                            , H.node1 652 24 28 (H.val "list")
                            ]
                        )
                }
            )
    }


unzip : Elm.Syntax.Expression.FunctionImplementation
unzip =
    { name = H.node1 660 1 6 "List.unzip"
    , arguments = [ H.node1 660 7 12 (Elm.Syntax.Pattern.VarPattern "pairs") ]
    , expression =
        H.node
            661
            3
            665
            30
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        662
                        5
                        663
                        29
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    662
                                    5
                                    663
                                    29
                                    { name = H.node1 662 5 9 "step"
                                    , arguments =
                                        [ H.node1
                                            662
                                            10
                                            15
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    662
                                                    11
                                                    12
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                , H.node1
                                                    662
                                                    13
                                                    14
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "y"
                                                    )
                                                ]
                                            )
                                        , H.node1
                                            662
                                            16
                                            23
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    662
                                                    17
                                                    19
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "xs"
                                                    )
                                                , H.node1
                                                    662
                                                    20
                                                    22
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "ys"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        H.node1
                                            663
                                            7
                                            29
                                            (Elm.Syntax.Expression.TupledExpression
                                                [ H.node1
                                                    663
                                                    8
                                                    17
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            663
                                                            8
                                                            12
                                                            (H.val "cons")
                                                        , H.node1
                                                            663
                                                            13
                                                            14
                                                            (H.val "x")
                                                        , H.node1
                                                            663
                                                            15
                                                            17
                                                            (H.val "xs")
                                                        ]
                                                    )
                                                , H.node1
                                                    663
                                                    19
                                                    28
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            663
                                                            19
                                                            23
                                                            (H.val "cons")
                                                        , H.node1
                                                            663
                                                            24
                                                            25
                                                            (H.val "y")
                                                        , H.node1
                                                            663
                                                            26
                                                            28
                                                            (H.val "ys")
                                                        ]
                                                    )
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        665
                        5
                        30
                        (Elm.Syntax.Expression.Application
                            [ H.node1 665 5 10 (H.val "foldr")
                            , H.node1 665 11 15 (H.val "step")
                            , H.node1
                                665
                                16
                                24
                                (Elm.Syntax.Expression.TupledExpression
                                    [ H.node1
                                        665
                                        17
                                        19
                                        (Elm.Syntax.Expression.ListExpr [])
                                    , H.node1
                                        665
                                        21
                                        23
                                        (Elm.Syntax.Expression.ListExpr [])
                                    ]
                                )
                            , H.node1 665 25 30 (H.val "pairs")
                            ]
                        )
                }
            )
    }