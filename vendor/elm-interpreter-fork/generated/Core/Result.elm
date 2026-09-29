module Core.Result exposing (andThen, fromMaybe, functions, isOk, map, map2, map3, map4, map5, mapError, toMaybe, withDefault)

{-| 
@docs functions, withDefault, map, map2, map3, map4, map5, andThen, mapError, toMaybe, fromMaybe, isOk
-}


import Elm.Syntax.Expression
import Elm.Syntax.Node
import Elm.Syntax.Pattern
import FastDict
import H


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "withDefault", withDefault )
        , ( "map", map )
        , ( "map2", map2 )
        , ( "map3", map3 )
        , ( "map4", map4 )
        , ( "map5", map5 )
        , ( "andThen", andThen )
        , ( "mapError", mapError )
        , ( "toMaybe", toMaybe )
        , ( "fromMaybe", fromMaybe )
        , ( "isOk", isOk )
        ]


withDefault : Elm.Syntax.Expression.FunctionImplementation
withDefault =
    { name = H.node1 44 1 12 "Result.withDefault"
    , arguments =
        [ H.node1 44 13 16 (Elm.Syntax.Pattern.VarPattern "def")
        , H.node1 44 17 23 (Elm.Syntax.Pattern.VarPattern "result")
        ]
    , expression =
        H.node
            45
            3
            50
            12
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 45 8 14 (H.val "result")
                , cases =
                    [ ( H.node1
                            46
                            5
                            9
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ H.node1
                                    46
                                    8
                                    9
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , H.node1 47 9 10 (H.val "a")
                      )
                    , ( H.node1
                            49
                            5
                            10
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ H.node1 49 9 10 Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , H.node1 50 9 12 (H.val "def")
                      )
                    ]
                }
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = H.node1 60 1 4 "Result.map"
    , arguments =
        [ H.node1 60 5 9 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 60 10 12 (Elm.Syntax.Pattern.VarPattern "ra")
        ]
    , expression =
        H.node
            61
            3
            66
            12
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 61 8 10 (H.val "ra")
                , cases =
                    [ ( H.node1
                            62
                            5
                            9
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ H.node1
                                    62
                                    8
                                    9
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , H.node1
                            63
                            7
                            18
                            (Elm.Syntax.Expression.Application
                                [ H.node1 63 7 9 (H.val "Ok")
                                , H.node1
                                    63
                                    10
                                    18
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            63
                                            11
                                            17
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    63
                                                    11
                                                    15
                                                    (H.val "func")
                                                , H.node1 63 16 17 (H.val "a")
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      )
                    , ( H.node1
                            65
                            5
                            10
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ H.node1
                                    65
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "e")
                                ]
                            )
                      , H.node1
                            66
                            7
                            12
                            (Elm.Syntax.Expression.Application
                                [ H.node1 66 7 10 (H.val "Err")
                                , H.node1 66 11 12 (H.val "e")
                                ]
                            )
                      )
                    ]
                }
            )
    }


map2 : Elm.Syntax.Expression.FunctionImplementation
map2 =
    { name = H.node1 81 1 5 "Result.map2"
    , arguments =
        [ H.node1 81 6 10 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 81 11 13 (Elm.Syntax.Pattern.VarPattern "ra")
        , H.node1 81 14 16 (Elm.Syntax.Pattern.VarPattern "rb")
        ]
    , expression =
        H.node
            82
            3
            92
            24
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 82 8 10 (H.val "ra")
                , cases =
                    [ ( H.node1
                            83
                            5
                            10
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ H.node1
                                    83
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                ]
                            )
                      , H.node1
                            84
                            7
                            12
                            (Elm.Syntax.Expression.Application
                                [ H.node1 84 7 10 (H.val "Err")
                                , H.node1 84 11 12 (H.val "x")
                                ]
                            )
                      )
                    , ( H.node1
                            86
                            5
                            9
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ H.node1
                                    86
                                    8
                                    9
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , H.node
                            87
                            7
                            92
                            24
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 87 12 14 (H.val "rb")
                                , cases =
                                    [ ( H.node1
                                            88
                                            9
                                            14
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Err"
                                                }
                                                [ H.node1
                                                    88
                                                    13
                                                    14
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                ]
                                            )
                                      , H.node1
                                            89
                                            11
                                            16
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1 89 11 14 (H.val "Err")
                                                , H.node1 89 15 16 (H.val "x")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            91
                                            9
                                            13
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "Ok" }
                                                [ H.node1
                                                    91
                                                    12
                                                    13
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , H.node1
                                            92
                                            11
                                            24
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1 92 11 13 (H.val "Ok")
                                                , H.node1
                                                    92
                                                    14
                                                    24
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            92
                                                            15
                                                            23
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    92
                                                                    15
                                                                    19
                                                                    (H.val
                                                                        "func"
                                                                    )
                                                                , H.node1
                                                                    92
                                                                    20
                                                                    21
                                                                    (H.val "a")
                                                                , H.node1
                                                                    92
                                                                    22
                                                                    23
                                                                    (H.val "b")
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
                    ]
                }
            )
    }


map3 : Elm.Syntax.Expression.FunctionImplementation
map3 =
    { name = H.node1 97 1 5 "Result.map3"
    , arguments =
        [ H.node1 97 6 10 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 97 11 13 (Elm.Syntax.Pattern.VarPattern "ra")
        , H.node1 97 14 16 (Elm.Syntax.Pattern.VarPattern "rb")
        , H.node1 97 17 19 (Elm.Syntax.Pattern.VarPattern "rc")
        ]
    , expression =
        H.node
            98
            3
            113
            30
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 98 8 10 (H.val "ra")
                , cases =
                    [ ( H.node1
                            99
                            5
                            10
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ H.node1
                                    99
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                ]
                            )
                      , H.node1
                            100
                            7
                            12
                            (Elm.Syntax.Expression.Application
                                [ H.node1 100 7 10 (H.val "Err")
                                , H.node1 100 11 12 (H.val "x")
                                ]
                            )
                      )
                    , ( H.node1
                            102
                            5
                            9
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ H.node1
                                    102
                                    8
                                    9
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , H.node
                            103
                            7
                            113
                            30
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 103 12 14 (H.val "rb")
                                , cases =
                                    [ ( H.node1
                                            104
                                            9
                                            14
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Err"
                                                }
                                                [ H.node1
                                                    104
                                                    13
                                                    14
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                ]
                                            )
                                      , H.node1
                                            105
                                            11
                                            16
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    105
                                                    11
                                                    14
                                                    (H.val "Err")
                                                , H.node1 105 15 16 (H.val "x")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            107
                                            9
                                            13
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "Ok" }
                                                [ H.node1
                                                    107
                                                    12
                                                    13
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , H.node
                                            108
                                            11
                                            113
                                            30
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        108
                                                        16
                                                        18
                                                        (H.val "rc")
                                                , cases =
                                                    [ ( H.node1
                                                            109
                                                            13
                                                            18
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Err"
                                                                }
                                                                [ H.node1
                                                                    109
                                                                    17
                                                                    18
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "x"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            110
                                                            15
                                                            20
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    110
                                                                    15
                                                                    18
                                                                    (H.val "Err"
                                                                    )
                                                                , H.node1
                                                                    110
                                                                    19
                                                                    20
                                                                    (H.val "x")
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            112
                                                            13
                                                            17
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Ok"
                                                                }
                                                                [ H.node1
                                                                    112
                                                                    16
                                                                    17
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "c"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            113
                                                            15
                                                            30
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    113
                                                                    15
                                                                    17
                                                                    (H.val "Ok")
                                                                , H.node1
                                                                    113
                                                                    18
                                                                    30
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            113
                                                                            19
                                                                            29
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    113
                                                                                    19
                                                                                    23
                                                                                    (H.val
                                                                                        "func"
                                                                                    )
                                                                                , H.node1
                                                                                    113
                                                                                    24
                                                                                    25
                                                                                    (H.val
                                                                                        "a"
                                                                                    )
                                                                                , H.node1
                                                                                    113
                                                                                    26
                                                                                    27
                                                                                    (H.val
                                                                                        "b"
                                                                                    )
                                                                                , H.node1
                                                                                    113
                                                                                    28
                                                                                    29
                                                                                    (H.val
                                                                                        "c"
                                                                                    )
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
                                    ]
                                }
                            )
                      )
                    ]
                }
            )
    }


map4 : Elm.Syntax.Expression.FunctionImplementation
map4 =
    { name = H.node1 118 1 5 "Result.map4"
    , arguments =
        [ H.node1 118 6 10 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 118 11 13 (Elm.Syntax.Pattern.VarPattern "ra")
        , H.node1 118 14 16 (Elm.Syntax.Pattern.VarPattern "rb")
        , H.node1 118 17 19 (Elm.Syntax.Pattern.VarPattern "rc")
        , H.node1 118 20 22 (Elm.Syntax.Pattern.VarPattern "rd")
        ]
    , expression =
        H.node
            119
            3
            139
            36
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 119 8 10 (H.val "ra")
                , cases =
                    [ ( H.node1
                            120
                            5
                            10
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ H.node1
                                    120
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                ]
                            )
                      , H.node1
                            121
                            7
                            12
                            (Elm.Syntax.Expression.Application
                                [ H.node1 121 7 10 (H.val "Err")
                                , H.node1 121 11 12 (H.val "x")
                                ]
                            )
                      )
                    , ( H.node1
                            123
                            5
                            9
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ H.node1
                                    123
                                    8
                                    9
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , H.node
                            124
                            7
                            139
                            36
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 124 12 14 (H.val "rb")
                                , cases =
                                    [ ( H.node1
                                            125
                                            9
                                            14
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Err"
                                                }
                                                [ H.node1
                                                    125
                                                    13
                                                    14
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                ]
                                            )
                                      , H.node1
                                            126
                                            11
                                            16
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    126
                                                    11
                                                    14
                                                    (H.val "Err")
                                                , H.node1 126 15 16 (H.val "x")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            128
                                            9
                                            13
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "Ok" }
                                                [ H.node1
                                                    128
                                                    12
                                                    13
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , H.node
                                            129
                                            11
                                            139
                                            36
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        129
                                                        16
                                                        18
                                                        (H.val "rc")
                                                , cases =
                                                    [ ( H.node1
                                                            130
                                                            13
                                                            18
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Err"
                                                                }
                                                                [ H.node1
                                                                    130
                                                                    17
                                                                    18
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "x"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            131
                                                            15
                                                            20
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    131
                                                                    15
                                                                    18
                                                                    (H.val "Err"
                                                                    )
                                                                , H.node1
                                                                    131
                                                                    19
                                                                    20
                                                                    (H.val "x")
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            133
                                                            13
                                                            17
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Ok"
                                                                }
                                                                [ H.node1
                                                                    133
                                                                    16
                                                                    17
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "c"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node
                                                            134
                                                            15
                                                            139
                                                            36
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    H.node1
                                                                        134
                                                                        20
                                                                        22
                                                                        (H.val
                                                                            "rd"
                                                                        )
                                                                , cases =
                                                                    [ ( H.node1
                                                                            135
                                                                            17
                                                                            22
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Err"
                                                                                }
                                                                                [ H.node1
                                                                                    135
                                                                                    21
                                                                                    22
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "x"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , H.node1
                                                                            136
                                                                            19
                                                                            24
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    136
                                                                                    19
                                                                                    22
                                                                                    (H.val
                                                                                        "Err"
                                                                                    )
                                                                                , H.node1
                                                                                    136
                                                                                    23
                                                                                    24
                                                                                    (H.val
                                                                                        "x"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( H.node1
                                                                            138
                                                                            17
                                                                            21
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Ok"
                                                                                }
                                                                                [ H.node1
                                                                                    138
                                                                                    20
                                                                                    21
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "d"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , H.node1
                                                                            139
                                                                            19
                                                                            36
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    139
                                                                                    19
                                                                                    21
                                                                                    (H.val
                                                                                        "Ok"
                                                                                    )
                                                                                , H.node1
                                                                                    139
                                                                                    22
                                                                                    36
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (H.node1
                                                                                            139
                                                                                            23
                                                                                            35
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    139
                                                                                                    23
                                                                                                    27
                                                                                                    (H.val
                                                                                                        "func"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    139
                                                                                                    28
                                                                                                    29
                                                                                                    (H.val
                                                                                                        "a"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    139
                                                                                                    30
                                                                                                    31
                                                                                                    (H.val
                                                                                                        "b"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    139
                                                                                                    32
                                                                                                    33
                                                                                                    (H.val
                                                                                                        "c"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    139
                                                                                                    34
                                                                                                    35
                                                                                                    (H.val
                                                                                                        "d"
                                                                                                    )
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


map5 : Elm.Syntax.Expression.FunctionImplementation
map5 =
    { name = H.node1 144 1 5 "Result.map5"
    , arguments =
        [ H.node1 144 6 10 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 144 11 13 (Elm.Syntax.Pattern.VarPattern "ra")
        , H.node1 144 14 16 (Elm.Syntax.Pattern.VarPattern "rb")
        , H.node1 144 17 19 (Elm.Syntax.Pattern.VarPattern "rc")
        , H.node1 144 20 22 (Elm.Syntax.Pattern.VarPattern "rd")
        , H.node1 144 23 25 (Elm.Syntax.Pattern.VarPattern "re")
        ]
    , expression =
        H.node
            145
            3
            170
            42
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 145 8 10 (H.val "ra")
                , cases =
                    [ ( H.node1
                            146
                            5
                            10
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ H.node1
                                    146
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                ]
                            )
                      , H.node1
                            147
                            7
                            12
                            (Elm.Syntax.Expression.Application
                                [ H.node1 147 7 10 (H.val "Err")
                                , H.node1 147 11 12 (H.val "x")
                                ]
                            )
                      )
                    , ( H.node1
                            149
                            5
                            9
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ H.node1
                                    149
                                    8
                                    9
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , H.node
                            150
                            7
                            170
                            42
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 150 12 14 (H.val "rb")
                                , cases =
                                    [ ( H.node1
                                            151
                                            9
                                            14
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Err"
                                                }
                                                [ H.node1
                                                    151
                                                    13
                                                    14
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "x"
                                                    )
                                                ]
                                            )
                                      , H.node1
                                            152
                                            11
                                            16
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    152
                                                    11
                                                    14
                                                    (H.val "Err")
                                                , H.node1 152 15 16 (H.val "x")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            154
                                            9
                                            13
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "Ok" }
                                                [ H.node1
                                                    154
                                                    12
                                                    13
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , H.node
                                            155
                                            11
                                            170
                                            42
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        155
                                                        16
                                                        18
                                                        (H.val "rc")
                                                , cases =
                                                    [ ( H.node1
                                                            156
                                                            13
                                                            18
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Err"
                                                                }
                                                                [ H.node1
                                                                    156
                                                                    17
                                                                    18
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "x"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            157
                                                            15
                                                            20
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    157
                                                                    15
                                                                    18
                                                                    (H.val "Err"
                                                                    )
                                                                , H.node1
                                                                    157
                                                                    19
                                                                    20
                                                                    (H.val "x")
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            159
                                                            13
                                                            17
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Ok"
                                                                }
                                                                [ H.node1
                                                                    159
                                                                    16
                                                                    17
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "c"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node
                                                            160
                                                            15
                                                            170
                                                            42
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    H.node1
                                                                        160
                                                                        20
                                                                        22
                                                                        (H.val
                                                                            "rd"
                                                                        )
                                                                , cases =
                                                                    [ ( H.node1
                                                                            161
                                                                            17
                                                                            22
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Err"
                                                                                }
                                                                                [ H.node1
                                                                                    161
                                                                                    21
                                                                                    22
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "x"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , H.node1
                                                                            162
                                                                            19
                                                                            24
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    162
                                                                                    19
                                                                                    22
                                                                                    (H.val
                                                                                        "Err"
                                                                                    )
                                                                                , H.node1
                                                                                    162
                                                                                    23
                                                                                    24
                                                                                    (H.val
                                                                                        "x"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( H.node1
                                                                            164
                                                                            17
                                                                            21
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Ok"
                                                                                }
                                                                                [ H.node1
                                                                                    164
                                                                                    20
                                                                                    21
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "d"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , H.node
                                                                            165
                                                                            19
                                                                            170
                                                                            42
                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                { expression =
                                                                                    H.node1
                                                                                        165
                                                                                        24
                                                                                        26
                                                                                        (H.val
                                                                                            "re"
                                                                                        )
                                                                                , cases =
                                                                                    [ ( H.node1
                                                                                            166
                                                                                            21
                                                                                            26
                                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                                { moduleName =
                                                                                                    []
                                                                                                , name =
                                                                                                    "Err"
                                                                                                }
                                                                                                [ H.node1
                                                                                                    166
                                                                                                    25
                                                                                                    26
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "x"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      , H.node1
                                                                                            167
                                                                                            23
                                                                                            28
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    167
                                                                                                    23
                                                                                                    26
                                                                                                    (H.val
                                                                                                        "Err"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    167
                                                                                                    27
                                                                                                    28
                                                                                                    (H.val
                                                                                                        "x"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      )
                                                                                    , ( H.node1
                                                                                            169
                                                                                            21
                                                                                            25
                                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                                { moduleName =
                                                                                                    []
                                                                                                , name =
                                                                                                    "Ok"
                                                                                                }
                                                                                                [ H.node1
                                                                                                    169
                                                                                                    24
                                                                                                    25
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "e"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      , H.node1
                                                                                            170
                                                                                            23
                                                                                            42
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    170
                                                                                                    23
                                                                                                    25
                                                                                                    (H.val
                                                                                                        "Ok"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    170
                                                                                                    26
                                                                                                    42
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (H.node1
                                                                                                            170
                                                                                                            27
                                                                                                            41
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ H.node1
                                                                                                                    170
                                                                                                                    27
                                                                                                                    31
                                                                                                                    (H.val
                                                                                                                        "func"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    170
                                                                                                                    32
                                                                                                                    33
                                                                                                                    (H.val
                                                                                                                        "a"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    170
                                                                                                                    34
                                                                                                                    35
                                                                                                                    (H.val
                                                                                                                        "b"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    170
                                                                                                                    36
                                                                                                                    37
                                                                                                                    (H.val
                                                                                                                        "c"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    170
                                                                                                                    38
                                                                                                                    39
                                                                                                                    (H.val
                                                                                                                        "d"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    170
                                                                                                                    40
                                                                                                                    41
                                                                                                                    (H.val
                                                                                                                        "e"
                                                                                                                    )
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


andThen : Elm.Syntax.Expression.FunctionImplementation
andThen =
    { name = H.node1 208 1 8 "Result.andThen"
    , arguments =
        [ H.node1 208 9 17 (Elm.Syntax.Pattern.VarPattern "callback")
        , H.node1 208 18 24 (Elm.Syntax.Pattern.VarPattern "result")
        ]
    , expression =
        H.node
            209
            5
            214
            16
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 209 10 16 (H.val "result")
                , cases =
                    [ ( H.node1
                            210
                            7
                            15
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ H.node1
                                    210
                                    10
                                    15
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                ]
                            )
                      , H.node1
                            211
                            9
                            23
                            (Elm.Syntax.Expression.Application
                                [ H.node1 211 9 17 (H.val "callback")
                                , H.node1 211 18 23 (H.val "value")
                                ]
                            )
                      )
                    , ( H.node1
                            213
                            7
                            14
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ H.node1
                                    213
                                    11
                                    14
                                    (Elm.Syntax.Pattern.VarPattern "msg")
                                ]
                            )
                      , H.node1
                            214
                            9
                            16
                            (Elm.Syntax.Expression.Application
                                [ H.node1 214 9 12 (H.val "Err")
                                , H.node1 214 13 16 (H.val "msg")
                                ]
                            )
                      )
                    ]
                }
            )
    }


mapError : Elm.Syntax.Expression.FunctionImplementation
mapError =
    { name = H.node1 232 1 9 "Result.mapError"
    , arguments =
        [ H.node1 232 10 11 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 232 12 18 (Elm.Syntax.Pattern.VarPattern "result")
        ]
    , expression =
        H.node
            233
            5
            238
            18
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 233 10 16 (H.val "result")
                , cases =
                    [ ( H.node1
                            234
                            7
                            11
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ H.node1
                                    234
                                    10
                                    11
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                ]
                            )
                      , H.node1
                            235
                            9
                            13
                            (Elm.Syntax.Expression.Application
                                [ H.node1 235 9 11 (H.val "Ok")
                                , H.node1 235 12 13 (H.val "v")
                                ]
                            )
                      )
                    , ( H.node1
                            237
                            7
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ H.node1
                                    237
                                    11
                                    12
                                    (Elm.Syntax.Pattern.VarPattern "e")
                                ]
                            )
                      , H.node1
                            238
                            9
                            18
                            (Elm.Syntax.Expression.Application
                                [ H.node1 238 9 12 (H.val "Err")
                                , H.node1
                                    238
                                    13
                                    18
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            238
                                            14
                                            17
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1 238 14 15 (H.val "f")
                                                , H.node1 238 16 17 (H.val "e")
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
    }


toMaybe : Elm.Syntax.Expression.FunctionImplementation
toMaybe =
    { name = H.node1 251 1 8 "Result.toMaybe"
    , arguments = [ H.node1 251 9 15 (Elm.Syntax.Pattern.VarPattern "result") ]
    , expression =
        H.node
            252
            5
            254
            23
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 252 10 16 (H.val "result")
                , cases =
                    [ ( H.node1
                            253
                            7
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ H.node1
                                    253
                                    11
                                    12
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                ]
                            )
                      , H.node1
                            253
                            16
                            22
                            (Elm.Syntax.Expression.Application
                                [ H.node1 253 16 20 (H.val "Just")
                                , H.node1 253 21 22 (H.val "v")
                                ]
                            )
                      )
                    , ( H.node1
                            254
                            7
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ H.node1
                                    254
                                    11
                                    12
                                    Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , H.node1 254 16 23 (H.val "Nothing")
                      )
                    ]
                }
            )
    }


fromMaybe : Elm.Syntax.Expression.FunctionImplementation
fromMaybe =
    { name = H.node1 267 1 10 "Result.fromMaybe"
    , arguments =
        [ H.node1 267 11 14 (Elm.Syntax.Pattern.VarPattern "err")
        , H.node1 267 15 20 (Elm.Syntax.Pattern.VarPattern "maybe")
        ]
    , expression =
        H.node
            268
            5
            270
            25
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 268 10 15 (H.val "maybe")
                , cases =
                    [ ( H.node1
                            269
                            7
                            13
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    269
                                    12
                                    13
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                ]
                            )
                      , H.node1
                            269
                            18
                            22
                            (Elm.Syntax.Expression.Application
                                [ H.node1 269 18 20 (H.val "Ok")
                                , H.node1 269 21 22 (H.val "v")
                                ]
                            )
                      )
                    , ( H.node1
                            270
                            7
                            14
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1
                            270
                            18
                            25
                            (Elm.Syntax.Expression.Application
                                [ H.node1 270 18 21 (H.val "Err")
                                , H.node1 270 22 25 (H.val "err")
                                ]
                            )
                      )
                    ]
                }
            )
    }


isOk : Elm.Syntax.Expression.FunctionImplementation
isOk =
    { name = H.node1 280 1 5 "Result.isOk"
    , arguments = [ H.node1 280 6 12 (Elm.Syntax.Pattern.VarPattern "result") ]
    , expression =
        H.node
            281
            3
            286
            12
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 281 8 14 (H.val "result")
                , cases =
                    [ ( H.node1
                            282
                            5
                            9
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Ok" }
                                [ H.node1 282 8 9 Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , H.node1 283 7 11 (H.val "True")
                      )
                    , ( H.node1
                            285
                            5
                            10
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Err" }
                                [ H.node1 285 9 10 Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , H.node1 286 7 12 (H.val "False")
                      )
                    ]
                }
            )
    }