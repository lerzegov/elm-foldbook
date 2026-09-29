module Core.Elm.Kernel.List exposing (functions, map2, map3, map4, map5, mergeWith, sortBy, sortWith, split)

{-| 
@docs functions, map2, map3, map4, map5, sortBy, sortWith, split, mergeWith
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
        [ ( "map2", map2 )
        , ( "map3", map3 )
        , ( "map4", map4 )
        , ( "map5", map5 )
        , ( "sortBy", sortBy )
        , ( "sortWith", sortWith )
        , ( "split", split )
        , ( "mergeWith", mergeWith )
        ]


map2 : Elm.Syntax.Expression.FunctionImplementation
map2 =
    { name = H.node1 5 1 5 "Elm.Kernel.List.map2"
    , arguments =
        [ H.node1 5 6 7 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 5 8 11 (Elm.Syntax.Pattern.VarPattern "xas")
        , H.node1 5 12 15 (Elm.Syntax.Pattern.VarPattern "xbs")
        ]
    , expression =
        H.node
            6
            5
            21
            18
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        7
                        9
                        19
                        54
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    8
                                    9
                                    19
                                    54
                                    { name = H.node1 8 9 11 "go"
                                    , arguments =
                                        [ H.node1
                                            8
                                            12
                                            14
                                            (Elm.Syntax.Pattern.VarPattern "ao")
                                        , H.node1
                                            8
                                            15
                                            17
                                            (Elm.Syntax.Pattern.VarPattern "bo")
                                        , H.node1
                                            8
                                            18
                                            21
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            9
                                            13
                                            19
                                            54
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1 9 18 20 (H.val "ao")
                                                , cases =
                                                    [ ( H.node1
                                                            10
                                                            17
                                                            19
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , H.node1
                                                            11
                                                            21
                                                            37
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    11
                                                                    21
                                                                    33
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , H.node1
                                                                    11
                                                                    34
                                                                    37
                                                                    (H.val "acc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            13
                                                            17
                                                            25
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    13
                                                                    17
                                                                    19
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "ah"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    13
                                                                    23
                                                                    25
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "at"
                                                                    )
                                                                )
                                                            )
                                                      , H.node
                                                            14
                                                            21
                                                            19
                                                            54
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    H.node1
                                                                        14
                                                                        26
                                                                        28
                                                                        (H.val
                                                                            "bo"
                                                                        )
                                                                , cases =
                                                                    [ ( H.node1
                                                                            15
                                                                            25
                                                                            27
                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                []
                                                                            )
                                                                      , H.node1
                                                                            16
                                                                            29
                                                                            45
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    16
                                                                                    29
                                                                                    41
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "List"
                                                                                        ]
                                                                                        "reverse"
                                                                                    )
                                                                                , H.node1
                                                                                    16
                                                                                    42
                                                                                    45
                                                                                    (H.val
                                                                                        "acc"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( H.node1
                                                                            18
                                                                            25
                                                                            33
                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                (H.node1
                                                                                    18
                                                                                    25
                                                                                    27
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bh"
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    18
                                                                                    31
                                                                                    33
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bt"
                                                                                    )
                                                                                )
                                                                            )
                                                                      , H.node1
                                                                            19
                                                                            29
                                                                            54
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    19
                                                                                    29
                                                                                    31
                                                                                    (H.val
                                                                                        "go"
                                                                                    )
                                                                                , H.node1
                                                                                    19
                                                                                    32
                                                                                    34
                                                                                    (H.val
                                                                                        "at"
                                                                                    )
                                                                                , H.node1
                                                                                    19
                                                                                    35
                                                                                    37
                                                                                    (H.val
                                                                                        "bt"
                                                                                    )
                                                                                , H.node1
                                                                                    19
                                                                                    38
                                                                                    54
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (H.node1
                                                                                            19
                                                                                            39
                                                                                            53
                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                "::"
                                                                                                Elm.Syntax.Infix.Right
                                                                                                (H.node1
                                                                                                    19
                                                                                                    39
                                                                                                    46
                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                        [ H.node1
                                                                                                            19
                                                                                                            39
                                                                                                            40
                                                                                                            (H.val
                                                                                                                "f"
                                                                                                            )
                                                                                                        , H.node1
                                                                                                            19
                                                                                                            41
                                                                                                            43
                                                                                                            (H.val
                                                                                                                "ah"
                                                                                                            )
                                                                                                        , H.node1
                                                                                                            19
                                                                                                            44
                                                                                                            46
                                                                                                            (H.val
                                                                                                                "bh"
                                                                                                            )
                                                                                                        ]
                                                                                                    )
                                                                                                )
                                                                                                (H.node1
                                                                                                    19
                                                                                                    50
                                                                                                    53
                                                                                                    (H.val
                                                                                                        "acc"
                                                                                                    )
                                                                                                )
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
                                                    ]
                                                }
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        21
                        5
                        18
                        (Elm.Syntax.Expression.Application
                            [ H.node1 21 5 7 (H.val "go")
                            , H.node1 21 8 11 (H.val "xas")
                            , H.node1 21 12 15 (H.val "xbs")
                            , H.node1
                                21
                                16
                                18
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


map3 : Elm.Syntax.Expression.FunctionImplementation
map3 =
    { name = H.node1 25 1 5 "Elm.Kernel.List.map3"
    , arguments =
        [ H.node1 25 6 7 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 25 8 11 (Elm.Syntax.Pattern.VarPattern "xas")
        , H.node1 25 12 15 (Elm.Syntax.Pattern.VarPattern "xbs")
        , H.node1 25 16 19 (Elm.Syntax.Pattern.VarPattern "xcs")
        ]
    , expression =
        H.node
            26
            5
            46
            22
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        27
                        9
                        44
                        68
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    28
                                    9
                                    44
                                    68
                                    { name = H.node1 28 9 11 "go"
                                    , arguments =
                                        [ H.node1
                                            28
                                            12
                                            14
                                            (Elm.Syntax.Pattern.VarPattern "ao")
                                        , H.node1
                                            28
                                            15
                                            17
                                            (Elm.Syntax.Pattern.VarPattern "bo")
                                        , H.node1
                                            28
                                            18
                                            20
                                            (Elm.Syntax.Pattern.VarPattern "co")
                                        , H.node1
                                            28
                                            21
                                            24
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            29
                                            13
                                            44
                                            68
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        29
                                                        18
                                                        20
                                                        (H.val "ao")
                                                , cases =
                                                    [ ( H.node1
                                                            30
                                                            17
                                                            19
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , H.node1
                                                            31
                                                            21
                                                            37
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    31
                                                                    21
                                                                    33
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , H.node1
                                                                    31
                                                                    34
                                                                    37
                                                                    (H.val "acc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            33
                                                            17
                                                            25
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    33
                                                                    17
                                                                    19
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "ah"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    33
                                                                    23
                                                                    25
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "at"
                                                                    )
                                                                )
                                                            )
                                                      , H.node
                                                            34
                                                            21
                                                            44
                                                            68
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    H.node1
                                                                        34
                                                                        26
                                                                        28
                                                                        (H.val
                                                                            "bo"
                                                                        )
                                                                , cases =
                                                                    [ ( H.node1
                                                                            35
                                                                            25
                                                                            27
                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                []
                                                                            )
                                                                      , H.node1
                                                                            36
                                                                            29
                                                                            45
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    36
                                                                                    29
                                                                                    41
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "List"
                                                                                        ]
                                                                                        "reverse"
                                                                                    )
                                                                                , H.node1
                                                                                    36
                                                                                    42
                                                                                    45
                                                                                    (H.val
                                                                                        "acc"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( H.node1
                                                                            38
                                                                            25
                                                                            33
                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                (H.node1
                                                                                    38
                                                                                    25
                                                                                    27
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bh"
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    38
                                                                                    31
                                                                                    33
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bt"
                                                                                    )
                                                                                )
                                                                            )
                                                                      , H.node
                                                                            39
                                                                            29
                                                                            44
                                                                            68
                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                { expression =
                                                                                    H.node1
                                                                                        39
                                                                                        34
                                                                                        36
                                                                                        (H.val
                                                                                            "co"
                                                                                        )
                                                                                , cases =
                                                                                    [ ( H.node1
                                                                                            40
                                                                                            33
                                                                                            35
                                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                                []
                                                                                            )
                                                                                      , H.node1
                                                                                            41
                                                                                            37
                                                                                            53
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    41
                                                                                                    37
                                                                                                    49
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        [ "List"
                                                                                                        ]
                                                                                                        "reverse"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    41
                                                                                                    50
                                                                                                    53
                                                                                                    (H.val
                                                                                                        "acc"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      )
                                                                                    , ( H.node1
                                                                                            43
                                                                                            33
                                                                                            41
                                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                                (H.node1
                                                                                                    43
                                                                                                    33
                                                                                                    35
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "ch"
                                                                                                    )
                                                                                                )
                                                                                                (H.node1
                                                                                                    43
                                                                                                    39
                                                                                                    41
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "ct"
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                      , H.node1
                                                                                            44
                                                                                            37
                                                                                            68
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    44
                                                                                                    37
                                                                                                    39
                                                                                                    (H.val
                                                                                                        "go"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    44
                                                                                                    40
                                                                                                    42
                                                                                                    (H.val
                                                                                                        "at"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    44
                                                                                                    43
                                                                                                    45
                                                                                                    (H.val
                                                                                                        "bt"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    44
                                                                                                    46
                                                                                                    48
                                                                                                    (H.val
                                                                                                        "ct"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    44
                                                                                                    49
                                                                                                    68
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (H.node1
                                                                                                            44
                                                                                                            50
                                                                                                            67
                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                "::"
                                                                                                                Elm.Syntax.Infix.Right
                                                                                                                (H.node1
                                                                                                                    44
                                                                                                                    50
                                                                                                                    60
                                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                                        [ H.node1
                                                                                                                            44
                                                                                                                            50
                                                                                                                            51
                                                                                                                            (H.val
                                                                                                                                "f"
                                                                                                                            )
                                                                                                                        , H.node1
                                                                                                                            44
                                                                                                                            52
                                                                                                                            54
                                                                                                                            (H.val
                                                                                                                                "ah"
                                                                                                                            )
                                                                                                                        , H.node1
                                                                                                                            44
                                                                                                                            55
                                                                                                                            57
                                                                                                                            (H.val
                                                                                                                                "bh"
                                                                                                                            )
                                                                                                                        , H.node1
                                                                                                                            44
                                                                                                                            58
                                                                                                                            60
                                                                                                                            (H.val
                                                                                                                                "ch"
                                                                                                                            )
                                                                                                                        ]
                                                                                                                    )
                                                                                                                )
                                                                                                                (H.node1
                                                                                                                    44
                                                                                                                    64
                                                                                                                    67
                                                                                                                    (H.val
                                                                                                                        "acc"
                                                                                                                    )
                                                                                                                )
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
                                                                    ]
                                                                }
                                                            )
                                                      )
                                                    ]
                                                }
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        46
                        5
                        22
                        (Elm.Syntax.Expression.Application
                            [ H.node1 46 5 7 (H.val "go")
                            , H.node1 46 8 11 (H.val "xas")
                            , H.node1 46 12 15 (H.val "xbs")
                            , H.node1 46 16 19 (H.val "xcs")
                            , H.node1
                                46
                                20
                                22
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


map4 : Elm.Syntax.Expression.FunctionImplementation
map4 =
    { name = H.node1 50 1 5 "Elm.Kernel.List.map4"
    , arguments =
        [ H.node1 50 6 7 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 50 8 11 (Elm.Syntax.Pattern.VarPattern "xas")
        , H.node1 50 12 15 (Elm.Syntax.Pattern.VarPattern "xbs")
        , H.node1 50 16 19 (Elm.Syntax.Pattern.VarPattern "xcs")
        , H.node1 50 20 23 (Elm.Syntax.Pattern.VarPattern "xds")
        ]
    , expression =
        H.node
            51
            5
            76
            26
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        52
                        9
                        74
                        82
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    53
                                    9
                                    74
                                    82
                                    { name = H.node1 53 9 11 "go"
                                    , arguments =
                                        [ H.node1
                                            53
                                            12
                                            14
                                            (Elm.Syntax.Pattern.VarPattern "ao")
                                        , H.node1
                                            53
                                            15
                                            17
                                            (Elm.Syntax.Pattern.VarPattern "bo")
                                        , H.node1
                                            53
                                            18
                                            20
                                            (Elm.Syntax.Pattern.VarPattern "co")
                                        , H.node1
                                            53
                                            21
                                            23
                                            (Elm.Syntax.Pattern.VarPattern "do")
                                        , H.node1
                                            53
                                            24
                                            27
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            54
                                            13
                                            74
                                            82
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        54
                                                        18
                                                        20
                                                        (H.val "ao")
                                                , cases =
                                                    [ ( H.node1
                                                            55
                                                            17
                                                            19
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , H.node1
                                                            56
                                                            21
                                                            37
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    56
                                                                    21
                                                                    33
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , H.node1
                                                                    56
                                                                    34
                                                                    37
                                                                    (H.val "acc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            58
                                                            17
                                                            25
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    58
                                                                    17
                                                                    19
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "ah"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    58
                                                                    23
                                                                    25
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "at"
                                                                    )
                                                                )
                                                            )
                                                      , H.node
                                                            59
                                                            21
                                                            74
                                                            82
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    H.node1
                                                                        59
                                                                        26
                                                                        28
                                                                        (H.val
                                                                            "bo"
                                                                        )
                                                                , cases =
                                                                    [ ( H.node1
                                                                            60
                                                                            25
                                                                            27
                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                []
                                                                            )
                                                                      , H.node1
                                                                            61
                                                                            29
                                                                            45
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    61
                                                                                    29
                                                                                    41
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "List"
                                                                                        ]
                                                                                        "reverse"
                                                                                    )
                                                                                , H.node1
                                                                                    61
                                                                                    42
                                                                                    45
                                                                                    (H.val
                                                                                        "acc"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( H.node1
                                                                            63
                                                                            25
                                                                            33
                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                (H.node1
                                                                                    63
                                                                                    25
                                                                                    27
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bh"
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    63
                                                                                    31
                                                                                    33
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bt"
                                                                                    )
                                                                                )
                                                                            )
                                                                      , H.node
                                                                            64
                                                                            29
                                                                            74
                                                                            82
                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                { expression =
                                                                                    H.node1
                                                                                        64
                                                                                        34
                                                                                        36
                                                                                        (H.val
                                                                                            "co"
                                                                                        )
                                                                                , cases =
                                                                                    [ ( H.node1
                                                                                            65
                                                                                            33
                                                                                            35
                                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                                []
                                                                                            )
                                                                                      , H.node1
                                                                                            66
                                                                                            37
                                                                                            53
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    66
                                                                                                    37
                                                                                                    49
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        [ "List"
                                                                                                        ]
                                                                                                        "reverse"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    66
                                                                                                    50
                                                                                                    53
                                                                                                    (H.val
                                                                                                        "acc"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      )
                                                                                    , ( H.node1
                                                                                            68
                                                                                            33
                                                                                            41
                                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                                (H.node1
                                                                                                    68
                                                                                                    33
                                                                                                    35
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "ch"
                                                                                                    )
                                                                                                )
                                                                                                (H.node1
                                                                                                    68
                                                                                                    39
                                                                                                    41
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "ct"
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                      , H.node
                                                                                            69
                                                                                            37
                                                                                            74
                                                                                            82
                                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                                { expression =
                                                                                                    H.node1
                                                                                                        69
                                                                                                        42
                                                                                                        44
                                                                                                        (H.val
                                                                                                            "do"
                                                                                                        )
                                                                                                , cases =
                                                                                                    [ ( H.node1
                                                                                                            70
                                                                                                            41
                                                                                                            43
                                                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                                                []
                                                                                                            )
                                                                                                      , H.node1
                                                                                                            71
                                                                                                            45
                                                                                                            61
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ H.node1
                                                                                                                    71
                                                                                                                    45
                                                                                                                    57
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        [ "List"
                                                                                                                        ]
                                                                                                                        "reverse"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    71
                                                                                                                    58
                                                                                                                    61
                                                                                                                    (H.val
                                                                                                                        "acc"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                      )
                                                                                                    , ( H.node1
                                                                                                            73
                                                                                                            41
                                                                                                            49
                                                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                                                (H.node1
                                                                                                                    73
                                                                                                                    41
                                                                                                                    43
                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                        "dh"
                                                                                                                    )
                                                                                                                )
                                                                                                                (H.node1
                                                                                                                    73
                                                                                                                    47
                                                                                                                    49
                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                        "dt"
                                                                                                                    )
                                                                                                                )
                                                                                                            )
                                                                                                      , H.node1
                                                                                                            74
                                                                                                            45
                                                                                                            82
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ H.node1
                                                                                                                    74
                                                                                                                    45
                                                                                                                    47
                                                                                                                    (H.val
                                                                                                                        "go"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    74
                                                                                                                    48
                                                                                                                    50
                                                                                                                    (H.val
                                                                                                                        "at"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    74
                                                                                                                    51
                                                                                                                    53
                                                                                                                    (H.val
                                                                                                                        "bt"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    74
                                                                                                                    54
                                                                                                                    56
                                                                                                                    (H.val
                                                                                                                        "ct"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    74
                                                                                                                    57
                                                                                                                    59
                                                                                                                    (H.val
                                                                                                                        "dt"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    74
                                                                                                                    60
                                                                                                                    82
                                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                        (H.node1
                                                                                                                            74
                                                                                                                            61
                                                                                                                            81
                                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                "::"
                                                                                                                                Elm.Syntax.Infix.Right
                                                                                                                                (H.node1
                                                                                                                                    74
                                                                                                                                    61
                                                                                                                                    74
                                                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                                                        [ H.node1
                                                                                                                                            74
                                                                                                                                            61
                                                                                                                                            62
                                                                                                                                            (H.val
                                                                                                                                                "f"
                                                                                                                                            )
                                                                                                                                        , H.node1
                                                                                                                                            74
                                                                                                                                            63
                                                                                                                                            65
                                                                                                                                            (H.val
                                                                                                                                                "ah"
                                                                                                                                            )
                                                                                                                                        , H.node1
                                                                                                                                            74
                                                                                                                                            66
                                                                                                                                            68
                                                                                                                                            (H.val
                                                                                                                                                "bh"
                                                                                                                                            )
                                                                                                                                        , H.node1
                                                                                                                                            74
                                                                                                                                            69
                                                                                                                                            71
                                                                                                                                            (H.val
                                                                                                                                                "ch"
                                                                                                                                            )
                                                                                                                                        , H.node1
                                                                                                                                            74
                                                                                                                                            72
                                                                                                                                            74
                                                                                                                                            (H.val
                                                                                                                                                "dh"
                                                                                                                                            )
                                                                                                                                        ]
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (H.node1
                                                                                                                                    74
                                                                                                                                    78
                                                                                                                                    81
                                                                                                                                    (H.val
                                                                                                                                        "acc"
                                                                                                                                    )
                                                                                                                                )
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
                            }
                        )
                    ]
                , expression =
                    H.node1
                        76
                        5
                        26
                        (Elm.Syntax.Expression.Application
                            [ H.node1 76 5 7 (H.val "go")
                            , H.node1 76 8 11 (H.val "xas")
                            , H.node1 76 12 15 (H.val "xbs")
                            , H.node1 76 16 19 (H.val "xcs")
                            , H.node1 76 20 23 (H.val "xds")
                            , H.node1
                                76
                                24
                                26
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


map5 : Elm.Syntax.Expression.FunctionImplementation
map5 =
    { name = H.node1 80 1 5 "Elm.Kernel.List.map5"
    , arguments =
        [ H.node1 80 6 7 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 80 8 11 (Elm.Syntax.Pattern.VarPattern "xas")
        , H.node1 80 12 15 (Elm.Syntax.Pattern.VarPattern "xbs")
        , H.node1 80 16 19 (Elm.Syntax.Pattern.VarPattern "xcs")
        , H.node1 80 20 23 (Elm.Syntax.Pattern.VarPattern "xds")
        , H.node1 80 24 27 (Elm.Syntax.Pattern.VarPattern "xes")
        ]
    , expression =
        H.node
            81
            5
            111
            30
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        82
                        9
                        109
                        96
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    83
                                    9
                                    109
                                    96
                                    { name = H.node1 83 9 11 "go"
                                    , arguments =
                                        [ H.node1
                                            83
                                            12
                                            14
                                            (Elm.Syntax.Pattern.VarPattern "ao")
                                        , H.node1
                                            83
                                            15
                                            17
                                            (Elm.Syntax.Pattern.VarPattern "bo")
                                        , H.node1
                                            83
                                            18
                                            20
                                            (Elm.Syntax.Pattern.VarPattern "co")
                                        , H.node1
                                            83
                                            21
                                            23
                                            (Elm.Syntax.Pattern.VarPattern "do")
                                        , H.node1
                                            83
                                            24
                                            26
                                            (Elm.Syntax.Pattern.VarPattern "eo")
                                        , H.node1
                                            83
                                            27
                                            30
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            84
                                            13
                                            109
                                            96
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        84
                                                        18
                                                        20
                                                        (H.val "ao")
                                                , cases =
                                                    [ ( H.node1
                                                            85
                                                            17
                                                            19
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , H.node1
                                                            86
                                                            21
                                                            37
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    86
                                                                    21
                                                                    33
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , H.node1
                                                                    86
                                                                    34
                                                                    37
                                                                    (H.val "acc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            88
                                                            17
                                                            25
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    88
                                                                    17
                                                                    19
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "ah"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    88
                                                                    23
                                                                    25
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "at"
                                                                    )
                                                                )
                                                            )
                                                      , H.node
                                                            89
                                                            21
                                                            109
                                                            96
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    H.node1
                                                                        89
                                                                        26
                                                                        28
                                                                        (H.val
                                                                            "bo"
                                                                        )
                                                                , cases =
                                                                    [ ( H.node1
                                                                            90
                                                                            25
                                                                            27
                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                []
                                                                            )
                                                                      , H.node1
                                                                            91
                                                                            29
                                                                            45
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    91
                                                                                    29
                                                                                    41
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "List"
                                                                                        ]
                                                                                        "reverse"
                                                                                    )
                                                                                , H.node1
                                                                                    91
                                                                                    42
                                                                                    45
                                                                                    (H.val
                                                                                        "acc"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( H.node1
                                                                            93
                                                                            25
                                                                            33
                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                (H.node1
                                                                                    93
                                                                                    25
                                                                                    27
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bh"
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    93
                                                                                    31
                                                                                    33
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bt"
                                                                                    )
                                                                                )
                                                                            )
                                                                      , H.node
                                                                            94
                                                                            29
                                                                            109
                                                                            96
                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                { expression =
                                                                                    H.node1
                                                                                        94
                                                                                        34
                                                                                        36
                                                                                        (H.val
                                                                                            "co"
                                                                                        )
                                                                                , cases =
                                                                                    [ ( H.node1
                                                                                            95
                                                                                            33
                                                                                            35
                                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                                []
                                                                                            )
                                                                                      , H.node1
                                                                                            96
                                                                                            37
                                                                                            53
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    96
                                                                                                    37
                                                                                                    49
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        [ "List"
                                                                                                        ]
                                                                                                        "reverse"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    96
                                                                                                    50
                                                                                                    53
                                                                                                    (H.val
                                                                                                        "acc"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      )
                                                                                    , ( H.node1
                                                                                            98
                                                                                            33
                                                                                            41
                                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                                (H.node1
                                                                                                    98
                                                                                                    33
                                                                                                    35
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "ch"
                                                                                                    )
                                                                                                )
                                                                                                (H.node1
                                                                                                    98
                                                                                                    39
                                                                                                    41
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "ct"
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                      , H.node
                                                                                            99
                                                                                            37
                                                                                            109
                                                                                            96
                                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                                { expression =
                                                                                                    H.node1
                                                                                                        99
                                                                                                        42
                                                                                                        44
                                                                                                        (H.val
                                                                                                            "do"
                                                                                                        )
                                                                                                , cases =
                                                                                                    [ ( H.node1
                                                                                                            100
                                                                                                            41
                                                                                                            43
                                                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                                                []
                                                                                                            )
                                                                                                      , H.node1
                                                                                                            101
                                                                                                            45
                                                                                                            61
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ H.node1
                                                                                                                    101
                                                                                                                    45
                                                                                                                    57
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        [ "List"
                                                                                                                        ]
                                                                                                                        "reverse"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    101
                                                                                                                    58
                                                                                                                    61
                                                                                                                    (H.val
                                                                                                                        "acc"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                      )
                                                                                                    , ( H.node1
                                                                                                            103
                                                                                                            41
                                                                                                            49
                                                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                                                (H.node1
                                                                                                                    103
                                                                                                                    41
                                                                                                                    43
                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                        "dh"
                                                                                                                    )
                                                                                                                )
                                                                                                                (H.node1
                                                                                                                    103
                                                                                                                    47
                                                                                                                    49
                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                        "dt"
                                                                                                                    )
                                                                                                                )
                                                                                                            )
                                                                                                      , H.node
                                                                                                            104
                                                                                                            45
                                                                                                            109
                                                                                                            96
                                                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                                                { expression =
                                                                                                                    H.node1
                                                                                                                        104
                                                                                                                        50
                                                                                                                        52
                                                                                                                        (H.val
                                                                                                                            "eo"
                                                                                                                        )
                                                                                                                , cases =
                                                                                                                    [ ( H.node1
                                                                                                                            105
                                                                                                                            49
                                                                                                                            51
                                                                                                                            (Elm.Syntax.Pattern.ListPattern
                                                                                                                                []
                                                                                                                            )
                                                                                                                      , H.node1
                                                                                                                            106
                                                                                                                            53
                                                                                                                            69
                                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                                [ H.node1
                                                                                                                                    106
                                                                                                                                    53
                                                                                                                                    65
                                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                        [ "List"
                                                                                                                                        ]
                                                                                                                                        "reverse"
                                                                                                                                    )
                                                                                                                                , H.node1
                                                                                                                                    106
                                                                                                                                    66
                                                                                                                                    69
                                                                                                                                    (H.val
                                                                                                                                        "acc"
                                                                                                                                    )
                                                                                                                                ]
                                                                                                                            )
                                                                                                                      )
                                                                                                                    , ( H.node1
                                                                                                                            108
                                                                                                                            49
                                                                                                                            57
                                                                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                                                                (H.node1
                                                                                                                                    108
                                                                                                                                    49
                                                                                                                                    51
                                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                                        "eh"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (H.node1
                                                                                                                                    108
                                                                                                                                    55
                                                                                                                                    57
                                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                                        "et"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                      , H.node1
                                                                                                                            109
                                                                                                                            53
                                                                                                                            96
                                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                                [ H.node1
                                                                                                                                    109
                                                                                                                                    53
                                                                                                                                    55
                                                                                                                                    (H.val
                                                                                                                                        "go"
                                                                                                                                    )
                                                                                                                                , H.node1
                                                                                                                                    109
                                                                                                                                    56
                                                                                                                                    58
                                                                                                                                    (H.val
                                                                                                                                        "at"
                                                                                                                                    )
                                                                                                                                , H.node1
                                                                                                                                    109
                                                                                                                                    59
                                                                                                                                    61
                                                                                                                                    (H.val
                                                                                                                                        "bt"
                                                                                                                                    )
                                                                                                                                , H.node1
                                                                                                                                    109
                                                                                                                                    62
                                                                                                                                    64
                                                                                                                                    (H.val
                                                                                                                                        "ct"
                                                                                                                                    )
                                                                                                                                , H.node1
                                                                                                                                    109
                                                                                                                                    65
                                                                                                                                    67
                                                                                                                                    (H.val
                                                                                                                                        "dt"
                                                                                                                                    )
                                                                                                                                , H.node1
                                                                                                                                    109
                                                                                                                                    68
                                                                                                                                    70
                                                                                                                                    (H.val
                                                                                                                                        "et"
                                                                                                                                    )
                                                                                                                                , H.node1
                                                                                                                                    109
                                                                                                                                    71
                                                                                                                                    96
                                                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                                        (H.node1
                                                                                                                                            109
                                                                                                                                            72
                                                                                                                                            95
                                                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                                "::"
                                                                                                                                                Elm.Syntax.Infix.Right
                                                                                                                                                (H.node1
                                                                                                                                                    109
                                                                                                                                                    72
                                                                                                                                                    88
                                                                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                                                                        [ H.node1
                                                                                                                                                            109
                                                                                                                                                            72
                                                                                                                                                            73
                                                                                                                                                            (H.val
                                                                                                                                                                "f"
                                                                                                                                                            )
                                                                                                                                                        , H.node1
                                                                                                                                                            109
                                                                                                                                                            74
                                                                                                                                                            76
                                                                                                                                                            (H.val
                                                                                                                                                                "ah"
                                                                                                                                                            )
                                                                                                                                                        , H.node1
                                                                                                                                                            109
                                                                                                                                                            77
                                                                                                                                                            79
                                                                                                                                                            (H.val
                                                                                                                                                                "bh"
                                                                                                                                                            )
                                                                                                                                                        , H.node1
                                                                                                                                                            109
                                                                                                                                                            80
                                                                                                                                                            82
                                                                                                                                                            (H.val
                                                                                                                                                                "ch"
                                                                                                                                                            )
                                                                                                                                                        , H.node1
                                                                                                                                                            109
                                                                                                                                                            83
                                                                                                                                                            85
                                                                                                                                                            (H.val
                                                                                                                                                                "dh"
                                                                                                                                                            )
                                                                                                                                                        , H.node1
                                                                                                                                                            109
                                                                                                                                                            86
                                                                                                                                                            88
                                                                                                                                                            (H.val
                                                                                                                                                                "eh"
                                                                                                                                                            )
                                                                                                                                                        ]
                                                                                                                                                    )
                                                                                                                                                )
                                                                                                                                                (H.node1
                                                                                                                                                    109
                                                                                                                                                    92
                                                                                                                                                    95
                                                                                                                                                    (H.val
                                                                                                                                                        "acc"
                                                                                                                                                    )
                                                                                                                                                )
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
                            }
                        )
                    ]
                , expression =
                    H.node1
                        111
                        5
                        30
                        (Elm.Syntax.Expression.Application
                            [ H.node1 111 5 7 (H.val "go")
                            , H.node1 111 8 11 (H.val "xas")
                            , H.node1 111 12 15 (H.val "xbs")
                            , H.node1 111 16 19 (H.val "xcs")
                            , H.node1 111 20 23 (H.val "xds")
                            , H.node1 111 24 27 (H.val "xes")
                            , H.node1
                                111
                                28
                                30
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


sortBy : Elm.Syntax.Expression.FunctionImplementation
sortBy =
    { name = H.node1 115 1 7 "Elm.Kernel.List.sortBy"
    , arguments =
        [ H.node1 115 8 9 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 115 10 12 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node1
            116
            5
            46
            (Elm.Syntax.Expression.Application
                [ H.node1 116 5 13 (H.val "sortWith")
                , H.node1
                    116
                    14
                    43
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            116
                            15
                            42
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        116
                                        16
                                        17
                                        (Elm.Syntax.Pattern.VarPattern "l")
                                    , H.node1
                                        116
                                        18
                                        19
                                        (Elm.Syntax.Pattern.VarPattern "r")
                                    ]
                                , expression =
                                    H.node1
                                        116
                                        23
                                        42
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                116
                                                23
                                                30
                                                (H.val "compare")
                                            , H.node1
                                                116
                                                31
                                                36
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        116
                                                        32
                                                        35
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                116
                                                                32
                                                                33
                                                                (H.val "f")
                                                            , H.node1
                                                                116
                                                                34
                                                                35
                                                                (H.val "l")
                                                            ]
                                                        )
                                                    )
                                                )
                                            , H.node1
                                                116
                                                37
                                                42
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        116
                                                        38
                                                        41
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                116
                                                                38
                                                                39
                                                                (H.val "f")
                                                            , H.node1
                                                                116
                                                                40
                                                                41
                                                                (H.val "r")
                                                            ]
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , H.node1 116 44 46 (H.val "xs")
                ]
            )
    }


sortWith : Elm.Syntax.Expression.FunctionImplementation
sortWith =
    { name = H.node1 120 1 9 "Elm.Kernel.List.sortWith"
    , arguments =
        [ H.node1 120 10 11 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 120 12 14 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node
            121
            5
            133
            61
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 121 10 12 (H.val "xs")
                , cases =
                    [ ( H.node1 122 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 123 13 15 (H.val "xs")
                      )
                    , ( H.node1
                            125
                            9
                            14
                            (Elm.Syntax.Pattern.ListPattern
                                [ H.node1
                                    125
                                    11
                                    12
                                    Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , H.node1 126 13 15 (H.val "xs")
                      )
                    , ( H.node1 128 9 10 Elm.Syntax.Pattern.AllPattern
                      , H.node
                            129
                            13
                            133
                            61
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ H.node
                                        130
                                        17
                                        131
                                        29
                                        (Elm.Syntax.Expression.LetDestructuring
                                            (H.node1
                                                130
                                                17
                                                32
                                                (Elm.Syntax.Pattern.TuplePattern
                                                    [ H.node1
                                                        130
                                                        19
                                                        23
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "left"
                                                        )
                                                    , H.node1
                                                        130
                                                        25
                                                        30
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "right"
                                                        )
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                131
                                                21
                                                29
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        131
                                                        21
                                                        26
                                                        (H.val "split")
                                                    , H.node1
                                                        131
                                                        27
                                                        29
                                                        (H.val "xs")
                                                    ]
                                                )
                                            )
                                        )
                                    ]
                                , expression =
                                    H.node1
                                        133
                                        13
                                        61
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                133
                                                13
                                                22
                                                (H.val "mergeWith")
                                            , H.node1 133 23 24 (H.val "f")
                                            , H.node1
                                                133
                                                25
                                                42
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        133
                                                        26
                                                        41
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                133
                                                                26
                                                                34
                                                                (H.val
                                                                    "sortWith"
                                                                )
                                                            , H.node1
                                                                133
                                                                35
                                                                36
                                                                (H.val "f")
                                                            , H.node1
                                                                133
                                                                37
                                                                41
                                                                (H.val "left")
                                                            ]
                                                        )
                                                    )
                                                )
                                            , H.node1
                                                133
                                                43
                                                61
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        133
                                                        44
                                                        60
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                133
                                                                44
                                                                52
                                                                (H.val
                                                                    "sortWith"
                                                                )
                                                            , H.node1
                                                                133
                                                                53
                                                                54
                                                                (H.val "f")
                                                            , H.node1
                                                                133
                                                                55
                                                                60
                                                                (H.val "right")
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
    }


split : Elm.Syntax.Expression.FunctionImplementation
split =
    { name = H.node1 137 1 6 "Elm.Kernel.List.split"
    , arguments = [ H.node1 137 7 9 (Elm.Syntax.Pattern.VarPattern "xs") ]
    , expression =
        H.node
            138
            5
            157
            20
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        139
                        9
                        146
                        49
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    140
                                    9
                                    146
                                    49
                                    { name = H.node1 140 9 15 "goLeft"
                                    , arguments =
                                        [ H.node1
                                            140
                                            16
                                            17
                                            (Elm.Syntax.Pattern.VarPattern "l")
                                        , H.node1
                                            140
                                            18
                                            22
                                            (Elm.Syntax.Pattern.VarPattern
                                                "lacc"
                                            )
                                        , H.node1
                                            140
                                            23
                                            27
                                            (Elm.Syntax.Pattern.VarPattern
                                                "racc"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            141
                                            13
                                            146
                                            49
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        141
                                                        18
                                                        19
                                                        (H.val "l")
                                                , cases =
                                                    [ ( H.node1
                                                            142
                                                            17
                                                            19
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , H.node1
                                                            143
                                                            21
                                                            35
                                                            (Elm.Syntax.Expression.TupledExpression
                                                                [ H.node1
                                                                    143
                                                                    23
                                                                    27
                                                                    (H.val
                                                                        "lacc"
                                                                    )
                                                                , H.node1
                                                                    143
                                                                    29
                                                                    33
                                                                    (H.val
                                                                        "racc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            145
                                                            17
                                                            25
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    145
                                                                    17
                                                                    19
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "lh"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    145
                                                                    23
                                                                    25
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "lt"
                                                                    )
                                                                )
                                                            )
                                                      , H.node1
                                                            146
                                                            21
                                                            49
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    146
                                                                    21
                                                                    28
                                                                    (H.val
                                                                        "goRight"
                                                                    )
                                                                , H.node1
                                                                    146
                                                                    29
                                                                    31
                                                                    (H.val "lt")
                                                                , H.node1
                                                                    146
                                                                    32
                                                                    44
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            146
                                                                            33
                                                                            43
                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                "::"
                                                                                Elm.Syntax.Infix.Right
                                                                                (H.node1
                                                                                    146
                                                                                    33
                                                                                    35
                                                                                    (H.val
                                                                                        "lh"
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    146
                                                                                    39
                                                                                    43
                                                                                    (H.val
                                                                                        "lacc"
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                    )
                                                                , H.node1
                                                                    146
                                                                    45
                                                                    49
                                                                    (H.val
                                                                        "racc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    ]
                                                }
                                            )
                                    }
                            }
                        )
                    , H.node
                        148
                        9
                        155
                        48
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    149
                                    9
                                    155
                                    48
                                    { name = H.node1 149 9 16 "goRight"
                                    , arguments =
                                        [ H.node1
                                            149
                                            17
                                            18
                                            (Elm.Syntax.Pattern.VarPattern "l")
                                        , H.node1
                                            149
                                            19
                                            23
                                            (Elm.Syntax.Pattern.VarPattern
                                                "lacc"
                                            )
                                        , H.node1
                                            149
                                            24
                                            28
                                            (Elm.Syntax.Pattern.VarPattern
                                                "racc"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            150
                                            13
                                            155
                                            48
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        150
                                                        18
                                                        19
                                                        (H.val "l")
                                                , cases =
                                                    [ ( H.node1
                                                            151
                                                            17
                                                            19
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , H.node1
                                                            152
                                                            21
                                                            35
                                                            (Elm.Syntax.Expression.TupledExpression
                                                                [ H.node1
                                                                    152
                                                                    23
                                                                    27
                                                                    (H.val
                                                                        "lacc"
                                                                    )
                                                                , H.node1
                                                                    152
                                                                    29
                                                                    33
                                                                    (H.val
                                                                        "racc"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            154
                                                            17
                                                            25
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    154
                                                                    17
                                                                    19
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "lh"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    154
                                                                    23
                                                                    25
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "lt"
                                                                    )
                                                                )
                                                            )
                                                      , H.node1
                                                            155
                                                            21
                                                            48
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    155
                                                                    21
                                                                    27
                                                                    (H.val
                                                                        "goLeft"
                                                                    )
                                                                , H.node1
                                                                    155
                                                                    28
                                                                    30
                                                                    (H.val "lt")
                                                                , H.node1
                                                                    155
                                                                    31
                                                                    35
                                                                    (H.val
                                                                        "lacc"
                                                                    )
                                                                , H.node1
                                                                    155
                                                                    36
                                                                    48
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            155
                                                                            37
                                                                            47
                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                "::"
                                                                                Elm.Syntax.Infix.Right
                                                                                (H.node1
                                                                                    155
                                                                                    37
                                                                                    39
                                                                                    (H.val
                                                                                        "lh"
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    155
                                                                                    43
                                                                                    47
                                                                                    (H.val
                                                                                        "racc"
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    ]
                                                }
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        157
                        5
                        20
                        (Elm.Syntax.Expression.Application
                            [ H.node1 157 5 11 (H.val "goLeft")
                            , H.node1 157 12 14 (H.val "xs")
                            , H.node1
                                157
                                15
                                17
                                (Elm.Syntax.Expression.ListExpr [])
                            , H.node1
                                157
                                18
                                20
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


mergeWith : Elm.Syntax.Expression.FunctionImplementation
mergeWith =
    { name = H.node1 161 1 10 "Elm.Kernel.List.mergeWith"
    , arguments =
        [ H.node1 161 11 12 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 161 13 15 (Elm.Syntax.Pattern.VarPattern "ls")
        , H.node1 161 16 18 (Elm.Syntax.Pattern.VarPattern "rs")
        ]
    , expression =
        H.node
            162
            5
            180
            58
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 162 10 12 (H.val "ls")
                , cases =
                    [ ( H.node1 163 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 164 13 15 (H.val "rs")
                      )
                    , ( H.node1
                            166
                            9
                            17
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    166
                                    9
                                    11
                                    (Elm.Syntax.Pattern.VarPattern "lh")
                                )
                                (H.node1
                                    166
                                    15
                                    17
                                    (Elm.Syntax.Pattern.VarPattern "lt")
                                )
                            )
                      , H.node
                            167
                            13
                            180
                            58
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 167 18 20 (H.val "rs")
                                , cases =
                                    [ ( H.node1
                                            168
                                            17
                                            19
                                            (Elm.Syntax.Pattern.ListPattern [])
                                      , H.node1 169 21 23 (H.val "ls")
                                      )
                                    , ( H.node1
                                            171
                                            17
                                            25
                                            (Elm.Syntax.Pattern.UnConsPattern
                                                (H.node1
                                                    171
                                                    17
                                                    19
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rh"
                                                    )
                                                )
                                                (H.node1
                                                    171
                                                    23
                                                    25
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rt"
                                                    )
                                                )
                                            )
                                      , H.node
                                            172
                                            21
                                            180
                                            58
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        172
                                                        26
                                                        33
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                172
                                                                26
                                                                27
                                                                (H.val "f")
                                                            , H.node1
                                                                172
                                                                28
                                                                30
                                                                (H.val "lh")
                                                            , H.node1
                                                                172
                                                                31
                                                                33
                                                                (H.val "rh")
                                                            ]
                                                        )
                                                , cases =
                                                    [ ( H.node1
                                                            173
                                                            25
                                                            27
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "LT"
                                                                }
                                                                []
                                                            )
                                                      , H.node1
                                                            174
                                                            29
                                                            52
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Right
                                                                (H.node1
                                                                    174
                                                                    29
                                                                    31
                                                                    (H.val "lh")
                                                                )
                                                                (H.node1
                                                                    174
                                                                    35
                                                                    52
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            174
                                                                            35
                                                                            44
                                                                            (H.val
                                                                                "mergeWith"
                                                                            )
                                                                        , H.node1
                                                                            174
                                                                            45
                                                                            46
                                                                            (H.val
                                                                                "f"
                                                                            )
                                                                        , H.node1
                                                                            174
                                                                            47
                                                                            49
                                                                            (H.val
                                                                                "lt"
                                                                            )
                                                                        , H.node1
                                                                            174
                                                                            50
                                                                            52
                                                                            (H.val
                                                                                "rs"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                      )
                                                    , ( H.node1
                                                            176
                                                            25
                                                            27
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "GT"
                                                                }
                                                                []
                                                            )
                                                      , H.node1
                                                            177
                                                            29
                                                            52
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Right
                                                                (H.node1
                                                                    177
                                                                    29
                                                                    31
                                                                    (H.val "rh")
                                                                )
                                                                (H.node1
                                                                    177
                                                                    35
                                                                    52
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            177
                                                                            35
                                                                            44
                                                                            (H.val
                                                                                "mergeWith"
                                                                            )
                                                                        , H.node1
                                                                            177
                                                                            45
                                                                            46
                                                                            (H.val
                                                                                "f"
                                                                            )
                                                                        , H.node1
                                                                            177
                                                                            47
                                                                            49
                                                                            (H.val
                                                                                "ls"
                                                                            )
                                                                        , H.node1
                                                                            177
                                                                            50
                                                                            52
                                                                            (H.val
                                                                                "rt"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                      )
                                                    , ( H.node1
                                                            179
                                                            25
                                                            27
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "EQ"
                                                                }
                                                                []
                                                            )
                                                      , H.node1
                                                            180
                                                            29
                                                            58
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Right
                                                                (H.node1
                                                                    180
                                                                    29
                                                                    31
                                                                    (H.val "lh")
                                                                )
                                                                (H.node1
                                                                    180
                                                                    35
                                                                    58
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "::"
                                                                        Elm.Syntax.Infix.Right
                                                                        (H.node1
                                                                            180
                                                                            35
                                                                            37
                                                                            (H.val
                                                                                "rh"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            180
                                                                            41
                                                                            58
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    180
                                                                                    41
                                                                                    50
                                                                                    (H.val
                                                                                        "mergeWith"
                                                                                    )
                                                                                , H.node1
                                                                                    180
                                                                                    51
                                                                                    52
                                                                                    (H.val
                                                                                        "f"
                                                                                    )
                                                                                , H.node1
                                                                                    180
                                                                                    53
                                                                                    55
                                                                                    (H.val
                                                                                        "lt"
                                                                                    )
                                                                                , H.node1
                                                                                    180
                                                                                    56
                                                                                    58
                                                                                    (H.val
                                                                                        "rt"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                )
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