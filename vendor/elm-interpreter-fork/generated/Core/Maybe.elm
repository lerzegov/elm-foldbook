module Core.Maybe exposing (andThen, destruct, functions, isJust, map, map2, map3, map4, map5, withDefault)

{-| 
@docs functions, withDefault, map, map2, map3, map4, map5, andThen, isJust, destruct
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
        , ( "isJust", isJust )
        , ( "destruct", destruct )
        ]


withDefault : Elm.Syntax.Expression.FunctionImplementation
withDefault =
    { name = H.node1 60 1 12 "Maybe.withDefault"
    , arguments =
        [ H.node1 60 13 20 (Elm.Syntax.Pattern.VarPattern "default")
        , H.node1 60 21 26 (Elm.Syntax.Pattern.VarPattern "maybe")
        ]
    , expression =
        H.node
            61
            5
            63
            25
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 61 10 15 (H.val "maybe")
                , cases =
                    [ ( H.node1
                            62
                            7
                            17
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    62
                                    12
                                    17
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                ]
                            )
                      , H.node1 62 21 26 (H.val "value")
                      )
                    , ( H.node1
                            63
                            7
                            14
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 63 18 25 (H.val "default")
                      )
                    ]
                }
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = H.node1 76 1 4 "Maybe.map"
    , arguments =
        [ H.node1 76 5 6 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 76 7 12 (Elm.Syntax.Pattern.VarPattern "maybe")
        ]
    , expression =
        H.node
            77
            3
            82
            14
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 77 8 13 (H.val "maybe")
                , cases =
                    [ ( H.node1
                            78
                            5
                            15
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    78
                                    10
                                    15
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                ]
                            )
                      , H.node1
                            79
                            7
                            21
                            (Elm.Syntax.Expression.Application
                                [ H.node1 79 7 11 (H.val "Just")
                                , H.node1
                                    79
                                    12
                                    21
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            79
                                            13
                                            20
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1 79 13 14 (H.val "f")
                                                , H.node1
                                                    79
                                                    15
                                                    20
                                                    (H.val "value")
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      )
                    , ( H.node1
                            81
                            5
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 82 7 14 (H.val "Nothing")
                      )
                    ]
                }
            )
    }


map2 : Elm.Syntax.Expression.FunctionImplementation
map2 =
    { name = H.node1 96 1 5 "Maybe.map2"
    , arguments =
        [ H.node1 96 6 10 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 96 11 13 (Elm.Syntax.Pattern.VarPattern "ma")
        , H.node1 96 14 16 (Elm.Syntax.Pattern.VarPattern "mb")
        ]
    , expression =
        H.node
            97
            3
            107
            26
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 97 8 10 (H.val "ma")
                , cases =
                    [ ( H.node1
                            98
                            5
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 99 7 14 (H.val "Nothing")
                      )
                    , ( H.node1
                            101
                            5
                            11
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    101
                                    10
                                    11
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , H.node
                            102
                            7
                            107
                            26
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 102 12 14 (H.val "mb")
                                , cases =
                                    [ ( H.node1
                                            103
                                            9
                                            16
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Nothing"
                                                }
                                                []
                                            )
                                      , H.node1 104 11 18 (H.val "Nothing")
                                      )
                                    , ( H.node1
                                            106
                                            9
                                            15
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Just"
                                                }
                                                [ H.node1
                                                    106
                                                    14
                                                    15
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , H.node1
                                            107
                                            11
                                            26
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    107
                                                    11
                                                    15
                                                    (H.val "Just")
                                                , H.node1
                                                    107
                                                    16
                                                    26
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            107
                                                            17
                                                            25
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    107
                                                                    17
                                                                    21
                                                                    (H.val
                                                                        "func"
                                                                    )
                                                                , H.node1
                                                                    107
                                                                    22
                                                                    23
                                                                    (H.val "a")
                                                                , H.node1
                                                                    107
                                                                    24
                                                                    25
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
    { name = H.node1 112 1 5 "Maybe.map3"
    , arguments =
        [ H.node1 112 6 10 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 112 11 13 (Elm.Syntax.Pattern.VarPattern "ma")
        , H.node1 112 14 16 (Elm.Syntax.Pattern.VarPattern "mb")
        , H.node1 112 17 19 (Elm.Syntax.Pattern.VarPattern "mc")
        ]
    , expression =
        H.node
            113
            3
            128
            32
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 113 8 10 (H.val "ma")
                , cases =
                    [ ( H.node1
                            114
                            5
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 115 7 14 (H.val "Nothing")
                      )
                    , ( H.node1
                            117
                            5
                            11
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    117
                                    10
                                    11
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , H.node
                            118
                            7
                            128
                            32
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 118 12 14 (H.val "mb")
                                , cases =
                                    [ ( H.node1
                                            119
                                            9
                                            16
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Nothing"
                                                }
                                                []
                                            )
                                      , H.node1 120 11 18 (H.val "Nothing")
                                      )
                                    , ( H.node1
                                            122
                                            9
                                            15
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Just"
                                                }
                                                [ H.node1
                                                    122
                                                    14
                                                    15
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , H.node
                                            123
                                            11
                                            128
                                            32
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        123
                                                        16
                                                        18
                                                        (H.val "mc")
                                                , cases =
                                                    [ ( H.node1
                                                            124
                                                            13
                                                            20
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "Nothing"
                                                                }
                                                                []
                                                            )
                                                      , H.node1
                                                            125
                                                            15
                                                            22
                                                            (H.val "Nothing")
                                                      )
                                                    , ( H.node1
                                                            127
                                                            13
                                                            19
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Just"
                                                                }
                                                                [ H.node1
                                                                    127
                                                                    18
                                                                    19
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "c"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            128
                                                            15
                                                            32
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    128
                                                                    15
                                                                    19
                                                                    (H.val
                                                                        "Just"
                                                                    )
                                                                , H.node1
                                                                    128
                                                                    20
                                                                    32
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            128
                                                                            21
                                                                            31
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    128
                                                                                    21
                                                                                    25
                                                                                    (H.val
                                                                                        "func"
                                                                                    )
                                                                                , H.node1
                                                                                    128
                                                                                    26
                                                                                    27
                                                                                    (H.val
                                                                                        "a"
                                                                                    )
                                                                                , H.node1
                                                                                    128
                                                                                    28
                                                                                    29
                                                                                    (H.val
                                                                                        "b"
                                                                                    )
                                                                                , H.node1
                                                                                    128
                                                                                    30
                                                                                    31
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
    { name = H.node1 133 1 5 "Maybe.map4"
    , arguments =
        [ H.node1 133 6 10 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 133 11 13 (Elm.Syntax.Pattern.VarPattern "ma")
        , H.node1 133 14 16 (Elm.Syntax.Pattern.VarPattern "mb")
        , H.node1 133 17 19 (Elm.Syntax.Pattern.VarPattern "mc")
        , H.node1 133 20 22 (Elm.Syntax.Pattern.VarPattern "md")
        ]
    , expression =
        H.node
            134
            3
            154
            38
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 134 8 10 (H.val "ma")
                , cases =
                    [ ( H.node1
                            135
                            5
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 136 7 14 (H.val "Nothing")
                      )
                    , ( H.node1
                            138
                            5
                            11
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    138
                                    10
                                    11
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , H.node
                            139
                            7
                            154
                            38
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 139 12 14 (H.val "mb")
                                , cases =
                                    [ ( H.node1
                                            140
                                            9
                                            16
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Nothing"
                                                }
                                                []
                                            )
                                      , H.node1 141 11 18 (H.val "Nothing")
                                      )
                                    , ( H.node1
                                            143
                                            9
                                            15
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Just"
                                                }
                                                [ H.node1
                                                    143
                                                    14
                                                    15
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , H.node
                                            144
                                            11
                                            154
                                            38
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        144
                                                        16
                                                        18
                                                        (H.val "mc")
                                                , cases =
                                                    [ ( H.node1
                                                            145
                                                            13
                                                            20
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "Nothing"
                                                                }
                                                                []
                                                            )
                                                      , H.node1
                                                            146
                                                            15
                                                            22
                                                            (H.val "Nothing")
                                                      )
                                                    , ( H.node1
                                                            148
                                                            13
                                                            19
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Just"
                                                                }
                                                                [ H.node1
                                                                    148
                                                                    18
                                                                    19
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "c"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node
                                                            149
                                                            15
                                                            154
                                                            38
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    H.node1
                                                                        149
                                                                        20
                                                                        22
                                                                        (H.val
                                                                            "md"
                                                                        )
                                                                , cases =
                                                                    [ ( H.node1
                                                                            150
                                                                            17
                                                                            24
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Nothing"
                                                                                }
                                                                                []
                                                                            )
                                                                      , H.node1
                                                                            151
                                                                            19
                                                                            26
                                                                            (H.val
                                                                                "Nothing"
                                                                            )
                                                                      )
                                                                    , ( H.node1
                                                                            153
                                                                            17
                                                                            23
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Just"
                                                                                }
                                                                                [ H.node1
                                                                                    153
                                                                                    22
                                                                                    23
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "d"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , H.node1
                                                                            154
                                                                            19
                                                                            38
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    154
                                                                                    19
                                                                                    23
                                                                                    (H.val
                                                                                        "Just"
                                                                                    )
                                                                                , H.node1
                                                                                    154
                                                                                    24
                                                                                    38
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (H.node1
                                                                                            154
                                                                                            25
                                                                                            37
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    154
                                                                                                    25
                                                                                                    29
                                                                                                    (H.val
                                                                                                        "func"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    154
                                                                                                    30
                                                                                                    31
                                                                                                    (H.val
                                                                                                        "a"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    154
                                                                                                    32
                                                                                                    33
                                                                                                    (H.val
                                                                                                        "b"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    154
                                                                                                    34
                                                                                                    35
                                                                                                    (H.val
                                                                                                        "c"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    154
                                                                                                    36
                                                                                                    37
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
    { name = H.node1 159 1 5 "Maybe.map5"
    , arguments =
        [ H.node1 159 6 10 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 159 11 13 (Elm.Syntax.Pattern.VarPattern "ma")
        , H.node1 159 14 16 (Elm.Syntax.Pattern.VarPattern "mb")
        , H.node1 159 17 19 (Elm.Syntax.Pattern.VarPattern "mc")
        , H.node1 159 20 22 (Elm.Syntax.Pattern.VarPattern "md")
        , H.node1 159 23 25 (Elm.Syntax.Pattern.VarPattern "me")
        ]
    , expression =
        H.node
            160
            3
            185
            44
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 160 8 10 (H.val "ma")
                , cases =
                    [ ( H.node1
                            161
                            5
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 162 7 14 (H.val "Nothing")
                      )
                    , ( H.node1
                            164
                            5
                            11
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    164
                                    10
                                    11
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , H.node
                            165
                            7
                            185
                            44
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 165 12 14 (H.val "mb")
                                , cases =
                                    [ ( H.node1
                                            166
                                            9
                                            16
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Nothing"
                                                }
                                                []
                                            )
                                      , H.node1 167 11 18 (H.val "Nothing")
                                      )
                                    , ( H.node1
                                            169
                                            9
                                            15
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Just"
                                                }
                                                [ H.node1
                                                    169
                                                    14
                                                    15
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , H.node
                                            170
                                            11
                                            185
                                            44
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        170
                                                        16
                                                        18
                                                        (H.val "mc")
                                                , cases =
                                                    [ ( H.node1
                                                            171
                                                            13
                                                            20
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "Nothing"
                                                                }
                                                                []
                                                            )
                                                      , H.node1
                                                            172
                                                            15
                                                            22
                                                            (H.val "Nothing")
                                                      )
                                                    , ( H.node1
                                                            174
                                                            13
                                                            19
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Just"
                                                                }
                                                                [ H.node1
                                                                    174
                                                                    18
                                                                    19
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "c"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node
                                                            175
                                                            15
                                                            185
                                                            44
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    H.node1
                                                                        175
                                                                        20
                                                                        22
                                                                        (H.val
                                                                            "md"
                                                                        )
                                                                , cases =
                                                                    [ ( H.node1
                                                                            176
                                                                            17
                                                                            24
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Nothing"
                                                                                }
                                                                                []
                                                                            )
                                                                      , H.node1
                                                                            177
                                                                            19
                                                                            26
                                                                            (H.val
                                                                                "Nothing"
                                                                            )
                                                                      )
                                                                    , ( H.node1
                                                                            179
                                                                            17
                                                                            23
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Just"
                                                                                }
                                                                                [ H.node1
                                                                                    179
                                                                                    22
                                                                                    23
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "d"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , H.node
                                                                            180
                                                                            19
                                                                            185
                                                                            44
                                                                            (Elm.Syntax.Expression.CaseExpression
                                                                                { expression =
                                                                                    H.node1
                                                                                        180
                                                                                        24
                                                                                        26
                                                                                        (H.val
                                                                                            "me"
                                                                                        )
                                                                                , cases =
                                                                                    [ ( H.node1
                                                                                            181
                                                                                            21
                                                                                            28
                                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                                { moduleName =
                                                                                                    []
                                                                                                , name =
                                                                                                    "Nothing"
                                                                                                }
                                                                                                []
                                                                                            )
                                                                                      , H.node1
                                                                                            182
                                                                                            23
                                                                                            30
                                                                                            (H.val
                                                                                                "Nothing"
                                                                                            )
                                                                                      )
                                                                                    , ( H.node1
                                                                                            184
                                                                                            21
                                                                                            27
                                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                                { moduleName =
                                                                                                    []
                                                                                                , name =
                                                                                                    "Just"
                                                                                                }
                                                                                                [ H.node1
                                                                                                    184
                                                                                                    26
                                                                                                    27
                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                        "e"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                      , H.node1
                                                                                            185
                                                                                            23
                                                                                            44
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    185
                                                                                                    23
                                                                                                    27
                                                                                                    (H.val
                                                                                                        "Just"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    185
                                                                                                    28
                                                                                                    44
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (H.node1
                                                                                                            185
                                                                                                            29
                                                                                                            43
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ H.node1
                                                                                                                    185
                                                                                                                    29
                                                                                                                    33
                                                                                                                    (H.val
                                                                                                                        "func"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    185
                                                                                                                    34
                                                                                                                    35
                                                                                                                    (H.val
                                                                                                                        "a"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    185
                                                                                                                    36
                                                                                                                    37
                                                                                                                    (H.val
                                                                                                                        "b"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    185
                                                                                                                    38
                                                                                                                    39
                                                                                                                    (H.val
                                                                                                                        "c"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    185
                                                                                                                    40
                                                                                                                    41
                                                                                                                    (H.val
                                                                                                                        "d"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    185
                                                                                                                    42
                                                                                                                    43
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
    { name = H.node1 221 1 8 "Maybe.andThen"
    , arguments =
        [ H.node1 221 9 17 (Elm.Syntax.Pattern.VarPattern "callback")
        , H.node1 221 18 28 (Elm.Syntax.Pattern.VarPattern "maybeValue")
        ]
    , expression =
        H.node
            222
            5
            227
            20
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 222 10 20 (H.val "maybeValue")
                , cases =
                    [ ( H.node1
                            223
                            9
                            19
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    223
                                    14
                                    19
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                ]
                            )
                      , H.node1
                            224
                            13
                            27
                            (Elm.Syntax.Expression.Application
                                [ H.node1 224 13 21 (H.val "callback")
                                , H.node1 224 22 27 (H.val "value")
                                ]
                            )
                      )
                    , ( H.node1
                            226
                            9
                            16
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 227 13 20 (H.val "Nothing")
                      )
                    ]
                }
            )
    }


isJust : Elm.Syntax.Expression.FunctionImplementation
isJust =
    { name = H.node1 237 1 7 "Maybe.isJust"
    , arguments = [ H.node1 237 8 13 (Elm.Syntax.Pattern.VarPattern "maybe") ]
    , expression =
        H.node
            238
            3
            243
            12
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 238 8 13 (H.val "maybe")
                , cases =
                    [ ( H.node1
                            239
                            5
                            11
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    239
                                    10
                                    11
                                    Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , H.node1 240 7 11 (H.val "True")
                      )
                    , ( H.node1
                            242
                            5
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 243 7 12 (H.val "False")
                      )
                    ]
                }
            )
    }


destruct : Elm.Syntax.Expression.FunctionImplementation
destruct =
    { name = H.node1 247 1 9 "Maybe.destruct"
    , arguments =
        [ H.node1 247 10 17 (Elm.Syntax.Pattern.VarPattern "default")
        , H.node1 247 18 22 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 247 23 28 (Elm.Syntax.Pattern.VarPattern "maybe")
        ]
    , expression =
        H.node
            248
            3
            253
            14
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 248 8 13 (H.val "maybe")
                , cases =
                    [ ( H.node1
                            249
                            5
                            11
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    249
                                    10
                                    11
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                ]
                            )
                      , H.node1
                            250
                            7
                            13
                            (Elm.Syntax.Expression.Application
                                [ H.node1 250 7 11 (H.val "func")
                                , H.node1 250 12 13 (H.val "a")
                                ]
                            )
                      )
                    , ( H.node1
                            252
                            5
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 253 7 14 (H.val "default")
                      )
                    ]
                }
            )
    }