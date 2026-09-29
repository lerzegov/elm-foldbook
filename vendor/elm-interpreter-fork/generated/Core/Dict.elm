module Core.Dict exposing (balance, diff, empty, filter, foldl, foldr, fromList, functions, get, getMin, insert, insertHelp, intersect, isEmpty, keys, map, member, merge, moveRedLeft, moveRedRight, partition, remove, removeHelp, removeHelpEQGT, removeHelpPrepEQGT, removeMin, singleton, size, sizeHelp, toList, union, update, values)

{-| 
@docs functions, empty, get, member, size, sizeHelp, isEmpty, insert, insertHelp, balance, remove, removeHelp, removeHelpPrepEQGT, removeHelpEQGT, getMin, removeMin, moveRedLeft, moveRedRight, update, singleton, union, intersect, diff, merge, map, foldl, foldr, filter, partition, keys, values, toList, fromList
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
        [ ( "empty", empty )
        , ( "get", get )
        , ( "member", member )
        , ( "size", size )
        , ( "sizeHelp", sizeHelp )
        , ( "isEmpty", isEmpty )
        , ( "insert", insert )
        , ( "insertHelp", insertHelp )
        , ( "balance", balance )
        , ( "remove", remove )
        , ( "removeHelp", removeHelp )
        , ( "removeHelpPrepEQGT", removeHelpPrepEQGT )
        , ( "removeHelpEQGT", removeHelpEQGT )
        , ( "getMin", getMin )
        , ( "removeMin", removeMin )
        , ( "moveRedLeft", moveRedLeft )
        , ( "moveRedRight", moveRedRight )
        , ( "update", update )
        , ( "singleton", singleton )
        , ( "union", union )
        , ( "intersect", intersect )
        , ( "diff", diff )
        , ( "merge", merge )
        , ( "map", map )
        , ( "foldl", foldl )
        , ( "foldr", foldr )
        , ( "filter", filter )
        , ( "partition", partition )
        , ( "keys", keys )
        , ( "values", values )
        , ( "toList", toList )
        , ( "fromList", fromList )
        ]


empty : Elm.Syntax.Expression.FunctionImplementation
empty =
    { name = H.node1 79 1 6 "Dict.empty"
    , arguments = []
    , expression = H.node1 80 3 22 (H.val "RBEmpty_elm_builtin")
    }


get : Elm.Syntax.Expression.FunctionImplementation
get =
    { name = H.node1 95 1 4 "Dict.get"
    , arguments =
        [ H.node1 95 5 14 (Elm.Syntax.Pattern.VarPattern "targetKey")
        , H.node1 95 15 19 (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        H.node
            96
            3
            109
            30
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 96 8 12 (H.val "dict")
                , cases =
                    [ ( H.node1
                            97
                            5
                            24
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , H.node1 98 7 14 (H.val "Nothing")
                      )
                    , ( H.node1
                            100
                            5
                            46
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    100
                                    24
                                    25
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    100
                                    26
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , H.node1
                                    100
                                    30
                                    35
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , H.node1
                                    100
                                    36
                                    40
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , H.node1
                                    100
                                    41
                                    46
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , H.node
                            101
                            7
                            109
                            30
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    H.node1
                                        101
                                        12
                                        33
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                101
                                                12
                                                19
                                                (H.val "compare")
                                            , H.node1
                                                101
                                                20
                                                29
                                                (H.val "targetKey")
                                            , H.node1 101 30 33 (H.val "key")
                                            ]
                                        )
                                , cases =
                                    [ ( H.node1
                                            102
                                            9
                                            11
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "LT" }
                                                []
                                            )
                                      , H.node1
                                            103
                                            11
                                            29
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    103
                                                    11
                                                    14
                                                    (H.val "get")
                                                , H.node1
                                                    103
                                                    15
                                                    24
                                                    (H.val "targetKey")
                                                , H.node1
                                                    103
                                                    25
                                                    29
                                                    (H.val "left")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            105
                                            9
                                            11
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "EQ" }
                                                []
                                            )
                                      , H.node1
                                            106
                                            11
                                            21
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    106
                                                    11
                                                    15
                                                    (H.val "Just")
                                                , H.node1
                                                    106
                                                    16
                                                    21
                                                    (H.val "value")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            108
                                            9
                                            11
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "GT" }
                                                []
                                            )
                                      , H.node1
                                            109
                                            11
                                            30
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    109
                                                    11
                                                    14
                                                    (H.val "get")
                                                , H.node1
                                                    109
                                                    15
                                                    24
                                                    (H.val "targetKey")
                                                , H.node1
                                                    109
                                                    25
                                                    30
                                                    (H.val "right")
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


member : Elm.Syntax.Expression.FunctionImplementation
member =
    { name = H.node1 114 1 7 "Dict.member"
    , arguments =
        [ H.node1 114 8 11 (Elm.Syntax.Pattern.VarPattern "key")
        , H.node1 114 12 16 (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        H.node
            115
            3
            120
            12
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        115
                        8
                        20
                        (Elm.Syntax.Expression.Application
                            [ H.node1 115 8 11 (H.val "get")
                            , H.node1 115 12 15 (H.val "key")
                            , H.node1 115 16 20 (H.val "dict")
                            ]
                        )
                , cases =
                    [ ( H.node1
                            116
                            5
                            11
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    116
                                    10
                                    11
                                    Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , H.node1 117 7 11 (H.val "True")
                      )
                    , ( H.node1
                            119
                            5
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 120 7 12 (H.val "False")
                      )
                    ]
                }
            )
    }


size : Elm.Syntax.Expression.FunctionImplementation
size =
    { name = H.node1 125 1 5 "Dict.size"
    , arguments = [ H.node1 125 6 10 (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        H.node1
            126
            3
            18
            (Elm.Syntax.Expression.Application
                [ H.node1 126 3 11 (H.val "sizeHelp")
                , H.node1 126 12 13 (Elm.Syntax.Expression.Integer 0)
                , H.node1 126 14 18 (H.val "dict")
                ]
            )
    }


sizeHelp : Elm.Syntax.Expression.FunctionImplementation
sizeHelp =
    { name = H.node1 130 1 9 "Dict.sizeHelp"
    , arguments =
        [ H.node1 130 10 11 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 130 12 16 (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        H.node
            131
            3
            136
            43
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 131 8 12 (H.val "dict")
                , cases =
                    [ ( H.node1
                            132
                            5
                            24
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , H.node1 133 7 8 (H.val "n")
                      )
                    , ( H.node1
                            135
                            5
                            40
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    135
                                    24
                                    25
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    135
                                    26
                                    27
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    135
                                    28
                                    29
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    135
                                    30
                                    34
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , H.node1
                                    135
                                    35
                                    40
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , H.node1
                            136
                            7
                            43
                            (Elm.Syntax.Expression.Application
                                [ H.node1 136 7 15 (H.val "sizeHelp")
                                , H.node1
                                    136
                                    16
                                    38
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            136
                                            17
                                            37
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    136
                                                    17
                                                    25
                                                    (H.val "sizeHelp")
                                                , H.node1
                                                    136
                                                    26
                                                    31
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            136
                                                            27
                                                            30
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "+"
                                                                Elm.Syntax.Infix.Left
                                                                (H.node1
                                                                    136
                                                                    27
                                                                    28
                                                                    (H.val "n")
                                                                )
                                                                (H.node1
                                                                    136
                                                                    29
                                                                    30
                                                                    (Elm.Syntax.Expression.Integer
                                                                        1
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    136
                                                    32
                                                    37
                                                    (H.val "right")
                                                ]
                                            )
                                        )
                                    )
                                , H.node1 136 39 43 (H.val "left")
                                ]
                            )
                      )
                    ]
                }
            )
    }


isEmpty : Elm.Syntax.Expression.FunctionImplementation
isEmpty =
    { name = H.node1 144 1 8 "Dict.isEmpty"
    , arguments = [ H.node1 144 9 13 (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        H.node
            145
            3
            150
            12
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 145 8 12 (H.val "dict")
                , cases =
                    [ ( H.node1
                            146
                            5
                            24
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , H.node1 147 7 11 (H.val "True")
                      )
                    , ( H.node1
                            149
                            5
                            33
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    149
                                    24
                                    25
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    149
                                    26
                                    27
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    149
                                    28
                                    29
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    149
                                    30
                                    31
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    149
                                    32
                                    33
                                    Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , H.node1 150 7 12 (H.val "False")
                      )
                    ]
                }
            )
    }


insert : Elm.Syntax.Expression.FunctionImplementation
insert =
    { name = H.node1 156 1 7 "Dict.insert"
    , arguments =
        [ H.node1 156 8 11 (Elm.Syntax.Pattern.VarPattern "key")
        , H.node1 156 12 17 (Elm.Syntax.Pattern.VarPattern "value")
        , H.node1 156 18 22 (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        H.node
            158
            3
            163
            8
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        158
                        8
                        33
                        (Elm.Syntax.Expression.Application
                            [ H.node1 158 8 18 (H.val "insertHelp")
                            , H.node1 158 19 22 (H.val "key")
                            , H.node1 158 23 28 (H.val "value")
                            , H.node1 158 29 33 (H.val "dict")
                            ]
                        )
                , cases =
                    [ ( H.node1
                            159
                            5
                            35
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    159
                                    24
                                    27
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = [], name = "Red" }
                                        []
                                    )
                                , H.node1
                                    159
                                    28
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "k")
                                , H.node1
                                    159
                                    30
                                    31
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                , H.node1
                                    159
                                    32
                                    33
                                    (Elm.Syntax.Pattern.VarPattern "l")
                                , H.node1
                                    159
                                    34
                                    35
                                    (Elm.Syntax.Pattern.VarPattern "r")
                                ]
                            )
                      , H.node1
                            160
                            7
                            39
                            (Elm.Syntax.Expression.Application
                                [ H.node1 160 7 25 (H.val "RBNode_elm_builtin")
                                , H.node1 160 26 31 (H.val "Black")
                                , H.node1 160 32 33 (H.val "k")
                                , H.node1 160 34 35 (H.val "v")
                                , H.node1 160 36 37 (H.val "l")
                                , H.node1 160 38 39 (H.val "r")
                                ]
                            )
                      )
                    , ( H.node1 162 5 6 (Elm.Syntax.Pattern.VarPattern "x")
                      , H.node1 163 7 8 (H.val "x")
                      )
                    ]
                }
            )
    }


insertHelp : Elm.Syntax.Expression.FunctionImplementation
insertHelp =
    { name = H.node1 167 1 11 "Dict.insertHelp"
    , arguments =
        [ H.node1 167 12 15 (Elm.Syntax.Pattern.VarPattern "key")
        , H.node1 167 16 21 (Elm.Syntax.Pattern.VarPattern "value")
        , H.node1 167 22 26 (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        H.node
            168
            3
            183
            73
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 168 8 12 (H.val "dict")
                , cases =
                    [ ( H.node1
                            169
                            5
                            24
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , H.node1
                            172
                            7
                            79
                            (Elm.Syntax.Expression.Application
                                [ H.node1 172 7 25 (H.val "RBNode_elm_builtin")
                                , H.node1 172 26 29 (H.val "Red")
                                , H.node1 172 30 33 (H.val "key")
                                , H.node1 172 34 39 (H.val "value")
                                , H.node1
                                    172
                                    40
                                    59
                                    (H.val "RBEmpty_elm_builtin")
                                , H.node1
                                    172
                                    60
                                    79
                                    (H.val "RBEmpty_elm_builtin")
                                ]
                            )
                      )
                    , ( H.node1
                            174
                            5
                            55
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    174
                                    24
                                    30
                                    (Elm.Syntax.Pattern.VarPattern "nColor")
                                , H.node1
                                    174
                                    31
                                    35
                                    (Elm.Syntax.Pattern.VarPattern "nKey")
                                , H.node1
                                    174
                                    36
                                    42
                                    (Elm.Syntax.Pattern.VarPattern "nValue")
                                , H.node1
                                    174
                                    43
                                    48
                                    (Elm.Syntax.Pattern.VarPattern "nLeft")
                                , H.node1
                                    174
                                    49
                                    55
                                    (Elm.Syntax.Pattern.VarPattern "nRight")
                                ]
                            )
                      , H.node
                            175
                            7
                            183
                            73
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    H.node1
                                        175
                                        12
                                        28
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                175
                                                12
                                                19
                                                (H.val "compare")
                                            , H.node1 175 20 23 (H.val "key")
                                            , H.node1 175 24 28 (H.val "nKey")
                                            ]
                                        )
                                , cases =
                                    [ ( H.node1
                                            176
                                            9
                                            11
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "LT" }
                                                []
                                            )
                                      , H.node1
                                            177
                                            11
                                            73
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    177
                                                    11
                                                    18
                                                    (H.val "balance")
                                                , H.node1
                                                    177
                                                    19
                                                    25
                                                    (H.val "nColor")
                                                , H.node1
                                                    177
                                                    26
                                                    30
                                                    (H.val "nKey")
                                                , H.node1
                                                    177
                                                    31
                                                    37
                                                    (H.val "nValue")
                                                , H.node1
                                                    177
                                                    38
                                                    66
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            177
                                                            39
                                                            65
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    177
                                                                    39
                                                                    49
                                                                    (H.val
                                                                        "insertHelp"
                                                                    )
                                                                , H.node1
                                                                    177
                                                                    50
                                                                    53
                                                                    (H.val "key"
                                                                    )
                                                                , H.node1
                                                                    177
                                                                    54
                                                                    59
                                                                    (H.val
                                                                        "value"
                                                                    )
                                                                , H.node1
                                                                    177
                                                                    60
                                                                    65
                                                                    (H.val
                                                                        "nLeft"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    177
                                                    67
                                                    73
                                                    (H.val "nRight")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            179
                                            9
                                            11
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "EQ" }
                                                []
                                            )
                                      , H.node1
                                            180
                                            11
                                            60
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    180
                                                    11
                                                    29
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    180
                                                    30
                                                    36
                                                    (H.val "nColor")
                                                , H.node1
                                                    180
                                                    37
                                                    41
                                                    (H.val "nKey")
                                                , H.node1
                                                    180
                                                    42
                                                    47
                                                    (H.val "value")
                                                , H.node1
                                                    180
                                                    48
                                                    53
                                                    (H.val "nLeft")
                                                , H.node1
                                                    180
                                                    54
                                                    60
                                                    (H.val "nRight")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            182
                                            9
                                            11
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = [], name = "GT" }
                                                []
                                            )
                                      , H.node1
                                            183
                                            11
                                            73
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    183
                                                    11
                                                    18
                                                    (H.val "balance")
                                                , H.node1
                                                    183
                                                    19
                                                    25
                                                    (H.val "nColor")
                                                , H.node1
                                                    183
                                                    26
                                                    30
                                                    (H.val "nKey")
                                                , H.node1
                                                    183
                                                    31
                                                    37
                                                    (H.val "nValue")
                                                , H.node1
                                                    183
                                                    38
                                                    43
                                                    (H.val "nLeft")
                                                , H.node1
                                                    183
                                                    44
                                                    73
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            183
                                                            45
                                                            72
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    183
                                                                    45
                                                                    55
                                                                    (H.val
                                                                        "insertHelp"
                                                                    )
                                                                , H.node1
                                                                    183
                                                                    56
                                                                    59
                                                                    (H.val "key"
                                                                    )
                                                                , H.node1
                                                                    183
                                                                    60
                                                                    65
                                                                    (H.val
                                                                        "value"
                                                                    )
                                                                , H.node1
                                                                    183
                                                                    66
                                                                    72
                                                                    (H.val
                                                                        "nRight"
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
    }


balance : Elm.Syntax.Expression.FunctionImplementation
balance =
    { name = H.node1 187 1 8 "Dict.balance"
    , arguments =
        [ H.node1 187 9 14 (Elm.Syntax.Pattern.VarPattern "color")
        , H.node1 187 15 18 (Elm.Syntax.Pattern.VarPattern "key")
        , H.node1 187 19 24 (Elm.Syntax.Pattern.VarPattern "value")
        , H.node1 187 25 29 (Elm.Syntax.Pattern.VarPattern "left")
        , H.node1 187 30 35 (Elm.Syntax.Pattern.VarPattern "right")
        ]
    , expression =
        H.node
            188
            3
            213
            56
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 188 8 13 (H.val "right")
                , cases =
                    [ ( H.node1
                            189
                            5
                            46
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    189
                                    24
                                    27
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = [], name = "Red" }
                                        []
                                    )
                                , H.node1
                                    189
                                    28
                                    30
                                    (Elm.Syntax.Pattern.VarPattern "rK")
                                , H.node1
                                    189
                                    31
                                    33
                                    (Elm.Syntax.Pattern.VarPattern "rV")
                                , H.node1
                                    189
                                    34
                                    39
                                    (Elm.Syntax.Pattern.VarPattern "rLeft")
                                , H.node1
                                    189
                                    40
                                    46
                                    (Elm.Syntax.Pattern.VarPattern "rRight")
                                ]
                            )
                      , H.node
                            190
                            7
                            200
                            94
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 190 12 16 (H.val "left")
                                , cases =
                                    [ ( H.node1
                                            191
                                            9
                                            50
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ H.node1
                                                    191
                                                    28
                                                    31
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name = "Red"
                                                        }
                                                        []
                                                    )
                                                , H.node1
                                                    191
                                                    32
                                                    34
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lK"
                                                    )
                                                , H.node1
                                                    191
                                                    35
                                                    37
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lV"
                                                    )
                                                , H.node1
                                                    191
                                                    38
                                                    43
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lLeft"
                                                    )
                                                , H.node1
                                                    191
                                                    44
                                                    50
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lRight"
                                                    )
                                                ]
                                            )
                                      , H.node
                                            192
                                            11
                                            197
                                            58
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    192
                                                    11
                                                    29
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    193
                                                    13
                                                    16
                                                    (H.val "Red")
                                                , H.node1
                                                    194
                                                    13
                                                    16
                                                    (H.val "key")
                                                , H.node1
                                                    195
                                                    13
                                                    18
                                                    (H.val "value")
                                                , H.node1
                                                    196
                                                    13
                                                    58
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            196
                                                            14
                                                            57
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    196
                                                                    14
                                                                    32
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    196
                                                                    33
                                                                    38
                                                                    (H.val
                                                                        "Black"
                                                                    )
                                                                , H.node1
                                                                    196
                                                                    39
                                                                    41
                                                                    (H.val "lK")
                                                                , H.node1
                                                                    196
                                                                    42
                                                                    44
                                                                    (H.val "lV")
                                                                , H.node1
                                                                    196
                                                                    45
                                                                    50
                                                                    (H.val
                                                                        "lLeft"
                                                                    )
                                                                , H.node1
                                                                    196
                                                                    51
                                                                    57
                                                                    (H.val
                                                                        "lRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    197
                                                    13
                                                    58
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            197
                                                            14
                                                            57
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    197
                                                                    14
                                                                    32
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    197
                                                                    33
                                                                    38
                                                                    (H.val
                                                                        "Black"
                                                                    )
                                                                , H.node1
                                                                    197
                                                                    39
                                                                    41
                                                                    (H.val "rK")
                                                                , H.node1
                                                                    197
                                                                    42
                                                                    44
                                                                    (H.val "rV")
                                                                , H.node1
                                                                    197
                                                                    45
                                                                    50
                                                                    (H.val
                                                                        "rLeft"
                                                                    )
                                                                , H.node1
                                                                    197
                                                                    51
                                                                    57
                                                                    (H.val
                                                                        "rRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            199
                                            9
                                            10
                                            Elm.Syntax.Pattern.AllPattern
                                      , H.node1
                                            200
                                            11
                                            94
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    200
                                                    11
                                                    29
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    200
                                                    30
                                                    35
                                                    (H.val "color")
                                                , H.node1 200 36 38 (H.val "rK")
                                                , H.node1 200 39 41 (H.val "rV")
                                                , H.node1
                                                    200
                                                    42
                                                    87
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            200
                                                            43
                                                            86
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    200
                                                                    43
                                                                    61
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    200
                                                                    62
                                                                    65
                                                                    (H.val "Red"
                                                                    )
                                                                , H.node1
                                                                    200
                                                                    66
                                                                    69
                                                                    (H.val "key"
                                                                    )
                                                                , H.node1
                                                                    200
                                                                    70
                                                                    75
                                                                    (H.val
                                                                        "value"
                                                                    )
                                                                , H.node1
                                                                    200
                                                                    76
                                                                    80
                                                                    (H.val
                                                                        "left"
                                                                    )
                                                                , H.node1
                                                                    200
                                                                    81
                                                                    86
                                                                    (H.val
                                                                        "rLeft"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    200
                                                    88
                                                    94
                                                    (H.val "rRight")
                                                ]
                                            )
                                      )
                                    ]
                                }
                            )
                      )
                    , ( H.node1 202 5 6 Elm.Syntax.Pattern.AllPattern
                      , H.node
                            203
                            7
                            213
                            56
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 203 12 16 (H.val "left")
                                , cases =
                                    [ ( H.node1
                                            204
                                            9
                                            92
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ H.node1
                                                    204
                                                    28
                                                    31
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name = "Red"
                                                        }
                                                        []
                                                    )
                                                , H.node1
                                                    204
                                                    32
                                                    34
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lK"
                                                    )
                                                , H.node1
                                                    204
                                                    35
                                                    37
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lV"
                                                    )
                                                , H.node1
                                                    204
                                                    38
                                                    85
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (H.node1
                                                            204
                                                            39
                                                            84
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "RBNode_elm_builtin"
                                                                }
                                                                [ H.node1
                                                                    204
                                                                    58
                                                                    61
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "Red"
                                                                        }
                                                                        []
                                                                    )
                                                                , H.node1
                                                                    204
                                                                    62
                                                                    65
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llK"
                                                                    )
                                                                , H.node1
                                                                    204
                                                                    66
                                                                    69
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llV"
                                                                    )
                                                                , H.node1
                                                                    204
                                                                    70
                                                                    76
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llLeft"
                                                                    )
                                                                , H.node1
                                                                    204
                                                                    77
                                                                    84
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    204
                                                    86
                                                    92
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lRight"
                                                    )
                                                ]
                                            )
                                      , H.node
                                            205
                                            11
                                            210
                                            62
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    205
                                                    11
                                                    29
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    206
                                                    13
                                                    16
                                                    (H.val "Red")
                                                , H.node1 207 13 15 (H.val "lK")
                                                , H.node1 208 13 15 (H.val "lV")
                                                , H.node1
                                                    209
                                                    13
                                                    62
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            209
                                                            14
                                                            61
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    209
                                                                    14
                                                                    32
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    209
                                                                    33
                                                                    38
                                                                    (H.val
                                                                        "Black"
                                                                    )
                                                                , H.node1
                                                                    209
                                                                    39
                                                                    42
                                                                    (H.val "llK"
                                                                    )
                                                                , H.node1
                                                                    209
                                                                    43
                                                                    46
                                                                    (H.val "llV"
                                                                    )
                                                                , H.node1
                                                                    209
                                                                    47
                                                                    53
                                                                    (H.val
                                                                        "llLeft"
                                                                    )
                                                                , H.node1
                                                                    209
                                                                    54
                                                                    61
                                                                    (H.val
                                                                        "llRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    210
                                                    13
                                                    62
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            210
                                                            14
                                                            61
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    210
                                                                    14
                                                                    32
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    210
                                                                    33
                                                                    38
                                                                    (H.val
                                                                        "Black"
                                                                    )
                                                                , H.node1
                                                                    210
                                                                    39
                                                                    42
                                                                    (H.val "key"
                                                                    )
                                                                , H.node1
                                                                    210
                                                                    43
                                                                    48
                                                                    (H.val
                                                                        "value"
                                                                    )
                                                                , H.node1
                                                                    210
                                                                    49
                                                                    55
                                                                    (H.val
                                                                        "lRight"
                                                                    )
                                                                , H.node1
                                                                    210
                                                                    56
                                                                    61
                                                                    (H.val
                                                                        "right"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            212
                                            9
                                            10
                                            Elm.Syntax.Pattern.AllPattern
                                      , H.node1
                                            213
                                            11
                                            56
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    213
                                                    11
                                                    29
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    213
                                                    30
                                                    35
                                                    (H.val "color")
                                                , H.node1
                                                    213
                                                    36
                                                    39
                                                    (H.val "key")
                                                , H.node1
                                                    213
                                                    40
                                                    45
                                                    (H.val "value")
                                                , H.node1
                                                    213
                                                    46
                                                    50
                                                    (H.val "left")
                                                , H.node1
                                                    213
                                                    51
                                                    56
                                                    (H.val "right")
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


remove : Elm.Syntax.Expression.FunctionImplementation
remove =
    { name = H.node1 219 1 7 "Dict.remove"
    , arguments =
        [ H.node1 219 8 11 (Elm.Syntax.Pattern.VarPattern "key")
        , H.node1 219 12 16 (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        H.node
            221
            3
            226
            8
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        221
                        8
                        27
                        (Elm.Syntax.Expression.Application
                            [ H.node1 221 8 18 (H.val "removeHelp")
                            , H.node1 221 19 22 (H.val "key")
                            , H.node1 221 23 27 (H.val "dict")
                            ]
                        )
                , cases =
                    [ ( H.node1
                            222
                            5
                            35
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    222
                                    24
                                    27
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = [], name = "Red" }
                                        []
                                    )
                                , H.node1
                                    222
                                    28
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "k")
                                , H.node1
                                    222
                                    30
                                    31
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                , H.node1
                                    222
                                    32
                                    33
                                    (Elm.Syntax.Pattern.VarPattern "l")
                                , H.node1
                                    222
                                    34
                                    35
                                    (Elm.Syntax.Pattern.VarPattern "r")
                                ]
                            )
                      , H.node1
                            223
                            7
                            39
                            (Elm.Syntax.Expression.Application
                                [ H.node1 223 7 25 (H.val "RBNode_elm_builtin")
                                , H.node1 223 26 31 (H.val "Black")
                                , H.node1 223 32 33 (H.val "k")
                                , H.node1 223 34 35 (H.val "v")
                                , H.node1 223 36 37 (H.val "l")
                                , H.node1 223 38 39 (H.val "r")
                                ]
                            )
                      )
                    , ( H.node1 225 5 6 (Elm.Syntax.Pattern.VarPattern "x")
                      , H.node1 226 7 8 (H.val "x")
                      )
                    ]
                }
            )
    }


removeHelp : Elm.Syntax.Expression.FunctionImplementation
removeHelp =
    { name = H.node1 236 1 11 "Dict.removeHelp"
    , arguments =
        [ H.node1 236 12 21 (Elm.Syntax.Pattern.VarPattern "targetKey")
        , H.node1 236 22 26 (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        H.node
            237
            3
            260
            96
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 237 8 12 (H.val "dict")
                , cases =
                    [ ( H.node1
                            238
                            5
                            24
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , H.node1 239 7 26 (H.val "RBEmpty_elm_builtin")
                      )
                    , ( H.node1
                            241
                            5
                            50
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    241
                                    24
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "color")
                                , H.node1
                                    241
                                    30
                                    33
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , H.node1
                                    241
                                    34
                                    39
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , H.node1
                                    241
                                    40
                                    44
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , H.node1
                                    241
                                    45
                                    50
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , H.node
                            242
                            7
                            260
                            96
                            (Elm.Syntax.Expression.IfBlock
                                (H.node1
                                    242
                                    10
                                    25
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "<"
                                        Elm.Syntax.Infix.Non
                                        (H.node1 242 10 19 (H.val "targetKey"))
                                        (H.node1 242 22 25 (H.val "key"))
                                    )
                                )
                                (H.node
                                    243
                                    9
                                    258
                                    81
                                    (Elm.Syntax.Expression.CaseExpression
                                        { expression =
                                            H.node1 243 14 18 (H.val "left")
                                        , cases =
                                            [ ( H.node1
                                                    244
                                                    11
                                                    47
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name =
                                                            "RBNode_elm_builtin"
                                                        }
                                                        [ H.node1
                                                            244
                                                            30
                                                            35
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Black"
                                                                }
                                                                []
                                                            )
                                                        , H.node1
                                                            244
                                                            36
                                                            37
                                                            Elm.Syntax.Pattern.AllPattern
                                                        , H.node1
                                                            244
                                                            38
                                                            39
                                                            Elm.Syntax.Pattern.AllPattern
                                                        , H.node1
                                                            244
                                                            40
                                                            45
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "lLeft"
                                                            )
                                                        , H.node1
                                                            244
                                                            46
                                                            47
                                                            Elm.Syntax.Pattern.AllPattern
                                                        ]
                                                    )
                                              , H.node
                                                    245
                                                    13
                                                    255
                                                    40
                                                    (Elm.Syntax.Expression.CaseExpression
                                                        { expression =
                                                            H.node1
                                                                245
                                                                18
                                                                23
                                                                (H.val "lLeft")
                                                        , cases =
                                                            [ ( H.node1
                                                                    246
                                                                    15
                                                                    45
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "RBNode_elm_builtin"
                                                                        }
                                                                        [ H.node1
                                                                            246
                                                                            34
                                                                            37
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Red"
                                                                                }
                                                                                []
                                                                            )
                                                                        , H.node1
                                                                            246
                                                                            38
                                                                            39
                                                                            Elm.Syntax.Pattern.AllPattern
                                                                        , H.node1
                                                                            246
                                                                            40
                                                                            41
                                                                            Elm.Syntax.Pattern.AllPattern
                                                                        , H.node1
                                                                            246
                                                                            42
                                                                            43
                                                                            Elm.Syntax.Pattern.AllPattern
                                                                        , H.node1
                                                                            246
                                                                            44
                                                                            45
                                                                            Elm.Syntax.Pattern.AllPattern
                                                                        ]
                                                                    )
                                                              , H.node1
                                                                    247
                                                                    17
                                                                    85
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            247
                                                                            17
                                                                            35
                                                                            (H.val
                                                                                "RBNode_elm_builtin"
                                                                            )
                                                                        , H.node1
                                                                            247
                                                                            36
                                                                            41
                                                                            (H.val
                                                                                "color"
                                                                            )
                                                                        , H.node1
                                                                            247
                                                                            42
                                                                            45
                                                                            (H.val
                                                                                "key"
                                                                            )
                                                                        , H.node1
                                                                            247
                                                                            46
                                                                            51
                                                                            (H.val
                                                                                "value"
                                                                            )
                                                                        , H.node1
                                                                            247
                                                                            52
                                                                            79
                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                (H.node1
                                                                                    247
                                                                                    53
                                                                                    78
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ H.node1
                                                                                            247
                                                                                            53
                                                                                            63
                                                                                            (H.val
                                                                                                "removeHelp"
                                                                                            )
                                                                                        , H.node1
                                                                                            247
                                                                                            64
                                                                                            73
                                                                                            (H.val
                                                                                                "targetKey"
                                                                                            )
                                                                                        , H.node1
                                                                                            247
                                                                                            74
                                                                                            78
                                                                                            (H.val
                                                                                                "left"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                                )
                                                                            )
                                                                        , H.node1
                                                                            247
                                                                            80
                                                                            85
                                                                            (H.val
                                                                                "right"
                                                                            )
                                                                        ]
                                                                    )
                                                              )
                                                            , ( H.node1
                                                                    249
                                                                    15
                                                                    16
                                                                    Elm.Syntax.Pattern.AllPattern
                                                              , H.node
                                                                    250
                                                                    17
                                                                    255
                                                                    40
                                                                    (Elm.Syntax.Expression.CaseExpression
                                                                        { expression =
                                                                            H.node1
                                                                                250
                                                                                22
                                                                                38
                                                                                (Elm.Syntax.Expression.Application
                                                                                    [ H.node1
                                                                                        250
                                                                                        22
                                                                                        33
                                                                                        (H.val
                                                                                            "moveRedLeft"
                                                                                        )
                                                                                    , H.node1
                                                                                        250
                                                                                        34
                                                                                        38
                                                                                        (H.val
                                                                                            "dict"
                                                                                        )
                                                                                    ]
                                                                                )
                                                                        , cases =
                                                                            [ ( H.node1
                                                                                    251
                                                                                    19
                                                                                    69
                                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                                        { moduleName =
                                                                                            []
                                                                                        , name =
                                                                                            "RBNode_elm_builtin"
                                                                                        }
                                                                                        [ H.node1
                                                                                            251
                                                                                            38
                                                                                            44
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "nColor"
                                                                                            )
                                                                                        , H.node1
                                                                                            251
                                                                                            45
                                                                                            49
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "nKey"
                                                                                            )
                                                                                        , H.node1
                                                                                            251
                                                                                            50
                                                                                            56
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "nValue"
                                                                                            )
                                                                                        , H.node1
                                                                                            251
                                                                                            57
                                                                                            62
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "nLeft"
                                                                                            )
                                                                                        , H.node1
                                                                                            251
                                                                                            63
                                                                                            69
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "nRight"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                              , H.node1
                                                                                    252
                                                                                    21
                                                                                    83
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ H.node1
                                                                                            252
                                                                                            21
                                                                                            28
                                                                                            (H.val
                                                                                                "balance"
                                                                                            )
                                                                                        , H.node1
                                                                                            252
                                                                                            29
                                                                                            35
                                                                                            (H.val
                                                                                                "nColor"
                                                                                            )
                                                                                        , H.node1
                                                                                            252
                                                                                            36
                                                                                            40
                                                                                            (H.val
                                                                                                "nKey"
                                                                                            )
                                                                                        , H.node1
                                                                                            252
                                                                                            41
                                                                                            47
                                                                                            (H.val
                                                                                                "nValue"
                                                                                            )
                                                                                        , H.node1
                                                                                            252
                                                                                            48
                                                                                            76
                                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                (H.node1
                                                                                                    252
                                                                                                    49
                                                                                                    75
                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                        [ H.node1
                                                                                                            252
                                                                                                            49
                                                                                                            59
                                                                                                            (H.val
                                                                                                                "removeHelp"
                                                                                                            )
                                                                                                        , H.node1
                                                                                                            252
                                                                                                            60
                                                                                                            69
                                                                                                            (H.val
                                                                                                                "targetKey"
                                                                                                            )
                                                                                                        , H.node1
                                                                                                            252
                                                                                                            70
                                                                                                            75
                                                                                                            (H.val
                                                                                                                "nLeft"
                                                                                                            )
                                                                                                        ]
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                        , H.node1
                                                                                            252
                                                                                            77
                                                                                            83
                                                                                            (H.val
                                                                                                "nRight"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                              )
                                                                            , ( H.node1
                                                                                    254
                                                                                    19
                                                                                    38
                                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                                        { moduleName =
                                                                                            []
                                                                                        , name =
                                                                                            "RBEmpty_elm_builtin"
                                                                                        }
                                                                                        []
                                                                                    )
                                                                              , H.node1
                                                                                    255
                                                                                    21
                                                                                    40
                                                                                    (H.val
                                                                                        "RBEmpty_elm_builtin"
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
                                            , ( H.node1
                                                    257
                                                    11
                                                    12
                                                    Elm.Syntax.Pattern.AllPattern
                                              , H.node1
                                                    258
                                                    13
                                                    81
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            258
                                                            13
                                                            31
                                                            (H.val
                                                                "RBNode_elm_builtin"
                                                            )
                                                        , H.node1
                                                            258
                                                            32
                                                            37
                                                            (H.val "color")
                                                        , H.node1
                                                            258
                                                            38
                                                            41
                                                            (H.val "key")
                                                        , H.node1
                                                            258
                                                            42
                                                            47
                                                            (H.val "value")
                                                        , H.node1
                                                            258
                                                            48
                                                            75
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    258
                                                                    49
                                                                    74
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            258
                                                                            49
                                                                            59
                                                                            (H.val
                                                                                "removeHelp"
                                                                            )
                                                                        , H.node1
                                                                            258
                                                                            60
                                                                            69
                                                                            (H.val
                                                                                "targetKey"
                                                                            )
                                                                        , H.node1
                                                                            258
                                                                            70
                                                                            74
                                                                            (H.val
                                                                                "left"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        , H.node1
                                                            258
                                                            76
                                                            81
                                                            (H.val "right")
                                                        ]
                                                    )
                                              )
                                            ]
                                        }
                                    )
                                )
                                (H.node1
                                    260
                                    9
                                    96
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            260
                                            9
                                            23
                                            (H.val "removeHelpEQGT")
                                        , H.node1 260 24 33 (H.val "targetKey")
                                        , H.node1
                                            260
                                            34
                                            96
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    260
                                                    35
                                                    95
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            260
                                                            35
                                                            53
                                                            (H.val
                                                                "removeHelpPrepEQGT"
                                                            )
                                                        , H.node1
                                                            260
                                                            54
                                                            63
                                                            (H.val "targetKey")
                                                        , H.node1
                                                            260
                                                            64
                                                            68
                                                            (H.val "dict")
                                                        , H.node1
                                                            260
                                                            69
                                                            74
                                                            (H.val "color")
                                                        , H.node1
                                                            260
                                                            75
                                                            78
                                                            (H.val "key")
                                                        , H.node1
                                                            260
                                                            79
                                                            84
                                                            (H.val "value")
                                                        , H.node1
                                                            260
                                                            85
                                                            89
                                                            (H.val "left")
                                                        , H.node1
                                                            260
                                                            90
                                                            95
                                                            (H.val "right")
                                                        ]
                                                    )
                                                )
                                            )
                                        ]
                                    )
                                )
                            )
                      )
                    ]
                }
            )
    }


removeHelpPrepEQGT : Elm.Syntax.Expression.FunctionImplementation
removeHelpPrepEQGT =
    { name = H.node1 264 1 19 "Dict.removeHelpPrepEQGT"
    , arguments =
        [ H.node1 264 20 29 (Elm.Syntax.Pattern.VarPattern "targetKey")
        , H.node1 264 30 34 (Elm.Syntax.Pattern.VarPattern "dict")
        , H.node1 264 35 40 (Elm.Syntax.Pattern.VarPattern "color")
        , H.node1 264 41 44 (Elm.Syntax.Pattern.VarPattern "key")
        , H.node1 264 45 50 (Elm.Syntax.Pattern.VarPattern "value")
        , H.node1 264 51 55 (Elm.Syntax.Pattern.VarPattern "left")
        , H.node1 264 56 61 (Elm.Syntax.Pattern.VarPattern "right")
        ]
    , expression =
        H.node
            265
            3
            283
            15
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 265 8 12 (H.val "left")
                , cases =
                    [ ( H.node1
                            266
                            5
                            46
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    266
                                    24
                                    27
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = [], name = "Red" }
                                        []
                                    )
                                , H.node1
                                    266
                                    28
                                    30
                                    (Elm.Syntax.Pattern.VarPattern "lK")
                                , H.node1
                                    266
                                    31
                                    33
                                    (Elm.Syntax.Pattern.VarPattern "lV")
                                , H.node1
                                    266
                                    34
                                    39
                                    (Elm.Syntax.Pattern.VarPattern "lLeft")
                                , H.node1
                                    266
                                    40
                                    46
                                    (Elm.Syntax.Pattern.VarPattern "lRight")
                                ]
                            )
                      , H.node
                            267
                            7
                            272
                            56
                            (Elm.Syntax.Expression.Application
                                [ H.node1 267 7 25 (H.val "RBNode_elm_builtin")
                                , H.node1 268 9 14 (H.val "color")
                                , H.node1 269 9 11 (H.val "lK")
                                , H.node1 270 9 11 (H.val "lV")
                                , H.node1 271 9 14 (H.val "lLeft")
                                , H.node1
                                    272
                                    9
                                    56
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            272
                                            10
                                            55
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    272
                                                    10
                                                    28
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    272
                                                    29
                                                    32
                                                    (H.val "Red")
                                                , H.node1
                                                    272
                                                    33
                                                    36
                                                    (H.val "key")
                                                , H.node1
                                                    272
                                                    37
                                                    42
                                                    (H.val "value")
                                                , H.node1
                                                    272
                                                    43
                                                    49
                                                    (H.val "lRight")
                                                , H.node1
                                                    272
                                                    50
                                                    55
                                                    (H.val "right")
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      )
                    , ( H.node1 274 5 6 Elm.Syntax.Pattern.AllPattern
                      , H.node
                            275
                            7
                            283
                            15
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 275 12 17 (H.val "right")
                                , cases =
                                    [ ( H.node1
                                            276
                                            9
                                            74
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ H.node1
                                                    276
                                                    28
                                                    33
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name = "Black"
                                                        }
                                                        []
                                                    )
                                                , H.node1
                                                    276
                                                    34
                                                    35
                                                    Elm.Syntax.Pattern.AllPattern
                                                , H.node1
                                                    276
                                                    36
                                                    37
                                                    Elm.Syntax.Pattern.AllPattern
                                                , H.node1
                                                    276
                                                    38
                                                    72
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (H.node1
                                                            276
                                                            39
                                                            71
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "RBNode_elm_builtin"
                                                                }
                                                                [ H.node1
                                                                    276
                                                                    58
                                                                    63
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "Black"
                                                                        }
                                                                        []
                                                                    )
                                                                , H.node1
                                                                    276
                                                                    64
                                                                    65
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , H.node1
                                                                    276
                                                                    66
                                                                    67
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , H.node1
                                                                    276
                                                                    68
                                                                    69
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , H.node1
                                                                    276
                                                                    70
                                                                    71
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    276
                                                    73
                                                    74
                                                    Elm.Syntax.Pattern.AllPattern
                                                ]
                                            )
                                      , H.node1
                                            277
                                            11
                                            28
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    277
                                                    11
                                                    23
                                                    (H.val "moveRedRight")
                                                , H.node1
                                                    277
                                                    24
                                                    28
                                                    (H.val "dict")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            279
                                            9
                                            59
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ H.node1
                                                    279
                                                    28
                                                    33
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name = "Black"
                                                        }
                                                        []
                                                    )
                                                , H.node1
                                                    279
                                                    34
                                                    35
                                                    Elm.Syntax.Pattern.AllPattern
                                                , H.node1
                                                    279
                                                    36
                                                    37
                                                    Elm.Syntax.Pattern.AllPattern
                                                , H.node1
                                                    279
                                                    38
                                                    57
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name =
                                                            "RBEmpty_elm_builtin"
                                                        }
                                                        []
                                                    )
                                                , H.node1
                                                    279
                                                    58
                                                    59
                                                    Elm.Syntax.Pattern.AllPattern
                                                ]
                                            )
                                      , H.node1
                                            280
                                            11
                                            28
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    280
                                                    11
                                                    23
                                                    (H.val "moveRedRight")
                                                , H.node1
                                                    280
                                                    24
                                                    28
                                                    (H.val "dict")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            282
                                            9
                                            10
                                            Elm.Syntax.Pattern.AllPattern
                                      , H.node1 283 11 15 (H.val "dict")
                                      )
                                    ]
                                }
                            )
                      )
                    ]
                }
            )
    }


removeHelpEQGT : Elm.Syntax.Expression.FunctionImplementation
removeHelpEQGT =
    { name = H.node1 290 1 15 "Dict.removeHelpEQGT"
    , arguments =
        [ H.node1 290 16 25 (Elm.Syntax.Pattern.VarPattern "targetKey")
        , H.node1 290 26 30 (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        H.node
            291
            3
            304
            26
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 291 8 12 (H.val "dict")
                , cases =
                    [ ( H.node1
                            292
                            5
                            50
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    292
                                    24
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "color")
                                , H.node1
                                    292
                                    30
                                    33
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , H.node1
                                    292
                                    34
                                    39
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , H.node1
                                    292
                                    40
                                    44
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , H.node1
                                    292
                                    45
                                    50
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , H.node
                            293
                            7
                            301
                            66
                            (Elm.Syntax.Expression.IfBlock
                                (H.node1
                                    293
                                    10
                                    26
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "=="
                                        Elm.Syntax.Infix.Non
                                        (H.node1 293 10 19 (H.val "targetKey"))
                                        (H.node1 293 23 26 (H.val "key"))
                                    )
                                )
                                (H.node
                                    294
                                    9
                                    299
                                    32
                                    (Elm.Syntax.Expression.CaseExpression
                                        { expression =
                                            H.node1
                                                294
                                                14
                                                26
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        294
                                                        14
                                                        20
                                                        (H.val "getMin")
                                                    , H.node1
                                                        294
                                                        21
                                                        26
                                                        (H.val "right")
                                                    ]
                                                )
                                        , cases =
                                            [ ( H.node1
                                                    295
                                                    11
                                                    51
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name =
                                                            "RBNode_elm_builtin"
                                                        }
                                                        [ H.node1
                                                            295
                                                            30
                                                            31
                                                            Elm.Syntax.Pattern.AllPattern
                                                        , H.node1
                                                            295
                                                            32
                                                            38
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "minKey"
                                                            )
                                                        , H.node1
                                                            295
                                                            39
                                                            47
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "minValue"
                                                            )
                                                        , H.node1
                                                            295
                                                            48
                                                            49
                                                            Elm.Syntax.Pattern.AllPattern
                                                        , H.node1
                                                            295
                                                            50
                                                            51
                                                            Elm.Syntax.Pattern.AllPattern
                                                        ]
                                                    )
                                              , H.node1
                                                    296
                                                    13
                                                    65
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            296
                                                            13
                                                            20
                                                            (H.val "balance")
                                                        , H.node1
                                                            296
                                                            21
                                                            26
                                                            (H.val "color")
                                                        , H.node1
                                                            296
                                                            27
                                                            33
                                                            (H.val "minKey")
                                                        , H.node1
                                                            296
                                                            34
                                                            42
                                                            (H.val "minValue")
                                                        , H.node1
                                                            296
                                                            43
                                                            47
                                                            (H.val "left")
                                                        , H.node1
                                                            296
                                                            48
                                                            65
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    296
                                                                    49
                                                                    64
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            296
                                                                            49
                                                                            58
                                                                            (H.val
                                                                                "removeMin"
                                                                            )
                                                                        , H.node1
                                                                            296
                                                                            59
                                                                            64
                                                                            (H.val
                                                                                "right"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        ]
                                                    )
                                              )
                                            , ( H.node1
                                                    298
                                                    11
                                                    30
                                                    (Elm.Syntax.Pattern.NamedPattern
                                                        { moduleName = []
                                                        , name =
                                                            "RBEmpty_elm_builtin"
                                                        }
                                                        []
                                                    )
                                              , H.node1
                                                    299
                                                    13
                                                    32
                                                    (H.val "RBEmpty_elm_builtin"
                                                    )
                                              )
                                            ]
                                        }
                                    )
                                )
                                (H.node1
                                    301
                                    9
                                    66
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 301 9 16 (H.val "balance")
                                        , H.node1 301 17 22 (H.val "color")
                                        , H.node1 301 23 26 (H.val "key")
                                        , H.node1 301 27 32 (H.val "value")
                                        , H.node1 301 33 37 (H.val "left")
                                        , H.node1
                                            301
                                            38
                                            66
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    301
                                                    39
                                                    65
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            301
                                                            39
                                                            49
                                                            (H.val "removeHelp")
                                                        , H.node1
                                                            301
                                                            50
                                                            59
                                                            (H.val "targetKey")
                                                        , H.node1
                                                            301
                                                            60
                                                            65
                                                            (H.val "right")
                                                        ]
                                                    )
                                                )
                                            )
                                        ]
                                    )
                                )
                            )
                      )
                    , ( H.node1
                            303
                            5
                            24
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , H.node1 304 7 26 (H.val "RBEmpty_elm_builtin")
                      )
                    ]
                }
            )
    }


getMin : Elm.Syntax.Expression.FunctionImplementation
getMin =
    { name = H.node1 308 1 7 "Dict.getMin"
    , arguments = [ H.node1 308 8 12 (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        H.node
            309
            3
            314
            11
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 309 8 12 (H.val "dict")
                , cases =
                    [ ( H.node1
                            310
                            5
                            72
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    310
                                    24
                                    25
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    310
                                    26
                                    27
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    310
                                    28
                                    29
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    310
                                    30
                                    70
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (H.node1
                                            310
                                            31
                                            69
                                            (Elm.Syntax.Pattern.AsPattern
                                                (H.node1
                                                    310
                                                    31
                                                    61
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (H.node1
                                                            310
                                                            32
                                                            60
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "RBNode_elm_builtin"
                                                                }
                                                                [ H.node1
                                                                    310
                                                                    51
                                                                    52
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , H.node1
                                                                    310
                                                                    53
                                                                    54
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , H.node1
                                                                    310
                                                                    55
                                                                    56
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , H.node1
                                                                    310
                                                                    57
                                                                    58
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , H.node1
                                                                    310
                                                                    59
                                                                    60
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                ]
                                                            )
                                                        )
                                                    )
                                                )
                                                (H.node1 310 65 69 "left")
                                            )
                                        )
                                    )
                                , H.node1
                                    310
                                    71
                                    72
                                    Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , H.node1
                            311
                            7
                            18
                            (Elm.Syntax.Expression.Application
                                [ H.node1 311 7 13 (H.val "getMin")
                                , H.node1 311 14 18 (H.val "left")
                                ]
                            )
                      )
                    , ( H.node1 313 5 6 Elm.Syntax.Pattern.AllPattern
                      , H.node1 314 7 11 (H.val "dict")
                      )
                    ]
                }
            )
    }


removeMin : Elm.Syntax.Expression.FunctionImplementation
removeMin =
    { name = H.node1 318 1 10 "Dict.removeMin"
    , arguments = [ H.node1 318 11 15 (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        H.node
            319
            3
            339
            26
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 319 8 12 (H.val "dict")
                , cases =
                    [ ( H.node1
                            320
                            5
                            95
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    320
                                    24
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "color")
                                , H.node1
                                    320
                                    30
                                    33
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , H.node1
                                    320
                                    34
                                    39
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , H.node1
                                    320
                                    40
                                    89
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (H.node1
                                            320
                                            41
                                            88
                                            (Elm.Syntax.Pattern.AsPattern
                                                (H.node1
                                                    320
                                                    41
                                                    80
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (H.node1
                                                            320
                                                            42
                                                            79
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "RBNode_elm_builtin"
                                                                }
                                                                [ H.node1
                                                                    320
                                                                    61
                                                                    67
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "lColor"
                                                                    )
                                                                , H.node1
                                                                    320
                                                                    68
                                                                    69
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , H.node1
                                                                    320
                                                                    70
                                                                    71
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , H.node1
                                                                    320
                                                                    72
                                                                    77
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "lLeft"
                                                                    )
                                                                , H.node1
                                                                    320
                                                                    78
                                                                    79
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                ]
                                                            )
                                                        )
                                                    )
                                                )
                                                (H.node1 320 84 88 "left")
                                            )
                                        )
                                    )
                                , H.node1
                                    320
                                    90
                                    95
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , H.node
                            321
                            7
                            336
                            68
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    H.node1 321 12 18 (H.val "lColor")
                                , cases =
                                    [ ( H.node1
                                            322
                                            9
                                            14
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Black"
                                                }
                                                []
                                            )
                                      , H.node
                                            323
                                            11
                                            333
                                            38
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        323
                                                        16
                                                        21
                                                        (H.val "lLeft")
                                                , cases =
                                                    [ ( H.node1
                                                            324
                                                            13
                                                            43
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "RBNode_elm_builtin"
                                                                }
                                                                [ H.node1
                                                                    324
                                                                    32
                                                                    35
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "Red"
                                                                        }
                                                                        []
                                                                    )
                                                                , H.node1
                                                                    324
                                                                    36
                                                                    37
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , H.node1
                                                                    324
                                                                    38
                                                                    39
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , H.node1
                                                                    324
                                                                    40
                                                                    41
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                , H.node1
                                                                    324
                                                                    42
                                                                    43
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                ]
                                                            )
                                                      , H.node1
                                                            325
                                                            15
                                                            72
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    325
                                                                    15
                                                                    33
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    325
                                                                    34
                                                                    39
                                                                    (H.val
                                                                        "color"
                                                                    )
                                                                , H.node1
                                                                    325
                                                                    40
                                                                    43
                                                                    (H.val "key"
                                                                    )
                                                                , H.node1
                                                                    325
                                                                    44
                                                                    49
                                                                    (H.val
                                                                        "value"
                                                                    )
                                                                , H.node1
                                                                    325
                                                                    50
                                                                    66
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            325
                                                                            51
                                                                            65
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    325
                                                                                    51
                                                                                    60
                                                                                    (H.val
                                                                                        "removeMin"
                                                                                    )
                                                                                , H.node1
                                                                                    325
                                                                                    61
                                                                                    65
                                                                                    (H.val
                                                                                        "left"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                , H.node1
                                                                    325
                                                                    67
                                                                    72
                                                                    (H.val
                                                                        "right"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            327
                                                            13
                                                            14
                                                            Elm.Syntax.Pattern.AllPattern
                                                      , H.node
                                                            328
                                                            15
                                                            333
                                                            38
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    H.node1
                                                                        328
                                                                        20
                                                                        36
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                328
                                                                                20
                                                                                31
                                                                                (H.val
                                                                                    "moveRedLeft"
                                                                                )
                                                                            , H.node1
                                                                                328
                                                                                32
                                                                                36
                                                                                (H.val
                                                                                    "dict"
                                                                                )
                                                                            ]
                                                                        )
                                                                , cases =
                                                                    [ ( H.node1
                                                                            329
                                                                            17
                                                                            67
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "RBNode_elm_builtin"
                                                                                }
                                                                                [ H.node1
                                                                                    329
                                                                                    36
                                                                                    42
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "nColor"
                                                                                    )
                                                                                , H.node1
                                                                                    329
                                                                                    43
                                                                                    47
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "nKey"
                                                                                    )
                                                                                , H.node1
                                                                                    329
                                                                                    48
                                                                                    54
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "nValue"
                                                                                    )
                                                                                , H.node1
                                                                                    329
                                                                                    55
                                                                                    60
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "nLeft"
                                                                                    )
                                                                                , H.node1
                                                                                    329
                                                                                    61
                                                                                    67
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "nRight"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , H.node1
                                                                            330
                                                                            19
                                                                            70
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    330
                                                                                    19
                                                                                    26
                                                                                    (H.val
                                                                                        "balance"
                                                                                    )
                                                                                , H.node1
                                                                                    330
                                                                                    27
                                                                                    33
                                                                                    (H.val
                                                                                        "nColor"
                                                                                    )
                                                                                , H.node1
                                                                                    330
                                                                                    34
                                                                                    38
                                                                                    (H.val
                                                                                        "nKey"
                                                                                    )
                                                                                , H.node1
                                                                                    330
                                                                                    39
                                                                                    45
                                                                                    (H.val
                                                                                        "nValue"
                                                                                    )
                                                                                , H.node1
                                                                                    330
                                                                                    46
                                                                                    63
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (H.node1
                                                                                            330
                                                                                            47
                                                                                            62
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    330
                                                                                                    47
                                                                                                    56
                                                                                                    (H.val
                                                                                                        "removeMin"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    330
                                                                                                    57
                                                                                                    62
                                                                                                    (H.val
                                                                                                        "nLeft"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                , H.node1
                                                                                    330
                                                                                    64
                                                                                    70
                                                                                    (H.val
                                                                                        "nRight"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( H.node1
                                                                            332
                                                                            17
                                                                            36
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "RBEmpty_elm_builtin"
                                                                                }
                                                                                []
                                                                            )
                                                                      , H.node1
                                                                            333
                                                                            19
                                                                            38
                                                                            (H.val
                                                                                "RBEmpty_elm_builtin"
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
                                    , ( H.node1
                                            335
                                            9
                                            10
                                            Elm.Syntax.Pattern.AllPattern
                                      , H.node1
                                            336
                                            11
                                            68
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    336
                                                    11
                                                    29
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    336
                                                    30
                                                    35
                                                    (H.val "color")
                                                , H.node1
                                                    336
                                                    36
                                                    39
                                                    (H.val "key")
                                                , H.node1
                                                    336
                                                    40
                                                    45
                                                    (H.val "value")
                                                , H.node1
                                                    336
                                                    46
                                                    62
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            336
                                                            47
                                                            61
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    336
                                                                    47
                                                                    56
                                                                    (H.val
                                                                        "removeMin"
                                                                    )
                                                                , H.node1
                                                                    336
                                                                    57
                                                                    61
                                                                    (H.val
                                                                        "left"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    336
                                                    63
                                                    68
                                                    (H.val "right")
                                                ]
                                            )
                                      )
                                    ]
                                }
                            )
                      )
                    , ( H.node1 338 5 6 Elm.Syntax.Pattern.AllPattern
                      , H.node1 339 7 26 (H.val "RBEmpty_elm_builtin")
                      )
                    ]
                }
            )
    }


moveRedLeft : Elm.Syntax.Expression.FunctionImplementation
moveRedLeft =
    { name = H.node1 343 1 12 "Dict.moveRedLeft"
    , arguments = [ H.node1 343 13 17 (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        H.node
            344
            3
            372
            11
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 344 8 12 (H.val "dict")
                , cases =
                    [ ( H.node1
                            345
                            5
                            167
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    345
                                    24
                                    27
                                    (Elm.Syntax.Pattern.VarPattern "clr")
                                , H.node1
                                    345
                                    28
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "k")
                                , H.node1
                                    345
                                    30
                                    31
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                , H.node1
                                    345
                                    32
                                    76
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (H.node1
                                            345
                                            33
                                            75
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ H.node1
                                                    345
                                                    52
                                                    56
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lClr"
                                                    )
                                                , H.node1
                                                    345
                                                    57
                                                    59
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lK"
                                                    )
                                                , H.node1
                                                    345
                                                    60
                                                    62
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lV"
                                                    )
                                                , H.node1
                                                    345
                                                    63
                                                    68
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lLeft"
                                                    )
                                                , H.node1
                                                    345
                                                    69
                                                    75
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , H.node1
                                    345
                                    77
                                    167
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (H.node1
                                            345
                                            78
                                            166
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ H.node1
                                                    345
                                                    97
                                                    101
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rClr"
                                                    )
                                                , H.node1
                                                    345
                                                    102
                                                    104
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rK"
                                                    )
                                                , H.node1
                                                    345
                                                    105
                                                    107
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rV"
                                                    )
                                                , H.node1
                                                    345
                                                    108
                                                    159
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (H.node1
                                                            345
                                                            109
                                                            158
                                                            (Elm.Syntax.Pattern.AsPattern
                                                                (H.node1
                                                                    345
                                                                    109
                                                                    149
                                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                                        (H.node1
                                                                            345
                                                                            110
                                                                            148
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "RBNode_elm_builtin"
                                                                                }
                                                                                [ H.node1
                                                                                    345
                                                                                    129
                                                                                    132
                                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                                        { moduleName =
                                                                                            []
                                                                                        , name =
                                                                                            "Red"
                                                                                        }
                                                                                        []
                                                                                    )
                                                                                , H.node1
                                                                                    345
                                                                                    133
                                                                                    136
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "rlK"
                                                                                    )
                                                                                , H.node1
                                                                                    345
                                                                                    137
                                                                                    140
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "rlV"
                                                                                    )
                                                                                , H.node1
                                                                                    345
                                                                                    141
                                                                                    144
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "rlL"
                                                                                    )
                                                                                , H.node1
                                                                                    345
                                                                                    145
                                                                                    148
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "rlR"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                (H.node1
                                                                    345
                                                                    153
                                                                    158
                                                                    "rLeft"
                                                                )
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    345
                                                    160
                                                    166
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      , H.node
                            346
                            7
                            351
                            52
                            (Elm.Syntax.Expression.Application
                                [ H.node1 346 7 25 (H.val "RBNode_elm_builtin")
                                , H.node1 347 9 12 (H.val "Red")
                                , H.node1 348 9 12 (H.val "rlK")
                                , H.node1 349 9 12 (H.val "rlV")
                                , H.node1
                                    350
                                    9
                                    87
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            350
                                            10
                                            86
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    350
                                                    10
                                                    28
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    350
                                                    29
                                                    34
                                                    (H.val "Black")
                                                , H.node1 350 35 36 (H.val "k")
                                                , H.node1 350 37 38 (H.val "v")
                                                , H.node1
                                                    350
                                                    39
                                                    82
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            350
                                                            40
                                                            81
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    350
                                                                    40
                                                                    58
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    350
                                                                    59
                                                                    62
                                                                    (H.val "Red"
                                                                    )
                                                                , H.node1
                                                                    350
                                                                    63
                                                                    65
                                                                    (H.val "lK")
                                                                , H.node1
                                                                    350
                                                                    66
                                                                    68
                                                                    (H.val "lV")
                                                                , H.node1
                                                                    350
                                                                    69
                                                                    74
                                                                    (H.val
                                                                        "lLeft"
                                                                    )
                                                                , H.node1
                                                                    350
                                                                    75
                                                                    81
                                                                    (H.val
                                                                        "lRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    350
                                                    83
                                                    86
                                                    (H.val "rlL")
                                                ]
                                            )
                                        )
                                    )
                                , H.node1
                                    351
                                    9
                                    52
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            351
                                            10
                                            51
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    351
                                                    10
                                                    28
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    351
                                                    29
                                                    34
                                                    (H.val "Black")
                                                , H.node1 351 35 37 (H.val "rK")
                                                , H.node1 351 38 40 (H.val "rV")
                                                , H.node1
                                                    351
                                                    41
                                                    44
                                                    (H.val "rlR")
                                                , H.node1
                                                    351
                                                    45
                                                    51
                                                    (H.val "rRight")
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      )
                    , ( H.node1
                            353
                            5
                            121
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    353
                                    24
                                    27
                                    (Elm.Syntax.Pattern.VarPattern "clr")
                                , H.node1
                                    353
                                    28
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "k")
                                , H.node1
                                    353
                                    30
                                    31
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                , H.node1
                                    353
                                    32
                                    76
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (H.node1
                                            353
                                            33
                                            75
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ H.node1
                                                    353
                                                    52
                                                    56
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lClr"
                                                    )
                                                , H.node1
                                                    353
                                                    57
                                                    59
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lK"
                                                    )
                                                , H.node1
                                                    353
                                                    60
                                                    62
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lV"
                                                    )
                                                , H.node1
                                                    353
                                                    63
                                                    68
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lLeft"
                                                    )
                                                , H.node1
                                                    353
                                                    69
                                                    75
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , H.node1
                                    353
                                    77
                                    121
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (H.node1
                                            353
                                            78
                                            120
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ H.node1
                                                    353
                                                    97
                                                    101
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rClr"
                                                    )
                                                , H.node1
                                                    353
                                                    102
                                                    104
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rK"
                                                    )
                                                , H.node1
                                                    353
                                                    105
                                                    107
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rV"
                                                    )
                                                , H.node1
                                                    353
                                                    108
                                                    113
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rLeft"
                                                    )
                                                , H.node1
                                                    353
                                                    114
                                                    120
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      , H.node
                            354
                            7
                            369
                            56
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 354 12 15 (H.val "clr")
                                , cases =
                                    [ ( H.node1
                                            355
                                            9
                                            14
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Black"
                                                }
                                                []
                                            )
                                      , H.node
                                            356
                                            11
                                            361
                                            56
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    356
                                                    11
                                                    29
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    357
                                                    13
                                                    18
                                                    (H.val "Black")
                                                , H.node1 358 13 14 (H.val "k")
                                                , H.node1 359 13 14 (H.val "v")
                                                , H.node1
                                                    360
                                                    13
                                                    56
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            360
                                                            14
                                                            55
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    360
                                                                    14
                                                                    32
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    360
                                                                    33
                                                                    36
                                                                    (H.val "Red"
                                                                    )
                                                                , H.node1
                                                                    360
                                                                    37
                                                                    39
                                                                    (H.val "lK")
                                                                , H.node1
                                                                    360
                                                                    40
                                                                    42
                                                                    (H.val "lV")
                                                                , H.node1
                                                                    360
                                                                    43
                                                                    48
                                                                    (H.val
                                                                        "lLeft"
                                                                    )
                                                                , H.node1
                                                                    360
                                                                    49
                                                                    55
                                                                    (H.val
                                                                        "lRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    361
                                                    13
                                                    56
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            361
                                                            14
                                                            55
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    361
                                                                    14
                                                                    32
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    361
                                                                    33
                                                                    36
                                                                    (H.val "Red"
                                                                    )
                                                                , H.node1
                                                                    361
                                                                    37
                                                                    39
                                                                    (H.val "rK")
                                                                , H.node1
                                                                    361
                                                                    40
                                                                    42
                                                                    (H.val "rV")
                                                                , H.node1
                                                                    361
                                                                    43
                                                                    48
                                                                    (H.val
                                                                        "rLeft"
                                                                    )
                                                                , H.node1
                                                                    361
                                                                    49
                                                                    55
                                                                    (H.val
                                                                        "rRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            363
                                            9
                                            12
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Red"
                                                }
                                                []
                                            )
                                      , H.node
                                            364
                                            11
                                            369
                                            56
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    364
                                                    11
                                                    29
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    365
                                                    13
                                                    18
                                                    (H.val "Black")
                                                , H.node1 366 13 14 (H.val "k")
                                                , H.node1 367 13 14 (H.val "v")
                                                , H.node1
                                                    368
                                                    13
                                                    56
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            368
                                                            14
                                                            55
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    368
                                                                    14
                                                                    32
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    368
                                                                    33
                                                                    36
                                                                    (H.val "Red"
                                                                    )
                                                                , H.node1
                                                                    368
                                                                    37
                                                                    39
                                                                    (H.val "lK")
                                                                , H.node1
                                                                    368
                                                                    40
                                                                    42
                                                                    (H.val "lV")
                                                                , H.node1
                                                                    368
                                                                    43
                                                                    48
                                                                    (H.val
                                                                        "lLeft"
                                                                    )
                                                                , H.node1
                                                                    368
                                                                    49
                                                                    55
                                                                    (H.val
                                                                        "lRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    369
                                                    13
                                                    56
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            369
                                                            14
                                                            55
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    369
                                                                    14
                                                                    32
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    369
                                                                    33
                                                                    36
                                                                    (H.val "Red"
                                                                    )
                                                                , H.node1
                                                                    369
                                                                    37
                                                                    39
                                                                    (H.val "rK")
                                                                , H.node1
                                                                    369
                                                                    40
                                                                    42
                                                                    (H.val "rV")
                                                                , H.node1
                                                                    369
                                                                    43
                                                                    48
                                                                    (H.val
                                                                        "rLeft"
                                                                    )
                                                                , H.node1
                                                                    369
                                                                    49
                                                                    55
                                                                    (H.val
                                                                        "rRight"
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
                    , ( H.node1 371 5 6 Elm.Syntax.Pattern.AllPattern
                      , H.node1 372 7 11 (H.val "dict")
                      )
                    ]
                }
            )
    }


moveRedRight : Elm.Syntax.Expression.FunctionImplementation
moveRedRight =
    { name = H.node1 376 1 13 "Dict.moveRedRight"
    , arguments = [ H.node1 376 14 18 (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        H.node
            377
            3
            405
            11
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 377 8 12 (H.val "dict")
                , cases =
                    [ ( H.node1
                            378
                            5
                            163
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    378
                                    24
                                    27
                                    (Elm.Syntax.Pattern.VarPattern "clr")
                                , H.node1
                                    378
                                    28
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "k")
                                , H.node1
                                    378
                                    30
                                    31
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                , H.node1
                                    378
                                    32
                                    118
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (H.node1
                                            378
                                            33
                                            117
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ H.node1
                                                    378
                                                    52
                                                    56
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lClr"
                                                    )
                                                , H.node1
                                                    378
                                                    57
                                                    59
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lK"
                                                    )
                                                , H.node1
                                                    378
                                                    60
                                                    62
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lV"
                                                    )
                                                , H.node1
                                                    378
                                                    63
                                                    110
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (H.node1
                                                            378
                                                            64
                                                            109
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "RBNode_elm_builtin"
                                                                }
                                                                [ H.node1
                                                                    378
                                                                    83
                                                                    86
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "Red"
                                                                        }
                                                                        []
                                                                    )
                                                                , H.node1
                                                                    378
                                                                    87
                                                                    90
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llK"
                                                                    )
                                                                , H.node1
                                                                    378
                                                                    91
                                                                    94
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llV"
                                                                    )
                                                                , H.node1
                                                                    378
                                                                    95
                                                                    101
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llLeft"
                                                                    )
                                                                , H.node1
                                                                    378
                                                                    102
                                                                    109
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "llRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    378
                                                    111
                                                    117
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , H.node1
                                    378
                                    119
                                    163
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (H.node1
                                            378
                                            120
                                            162
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ H.node1
                                                    378
                                                    139
                                                    143
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rClr"
                                                    )
                                                , H.node1
                                                    378
                                                    144
                                                    146
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rK"
                                                    )
                                                , H.node1
                                                    378
                                                    147
                                                    149
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rV"
                                                    )
                                                , H.node1
                                                    378
                                                    150
                                                    155
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rLeft"
                                                    )
                                                , H.node1
                                                    378
                                                    156
                                                    162
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      , H.node
                            379
                            7
                            384
                            90
                            (Elm.Syntax.Expression.Application
                                [ H.node1 379 7 25 (H.val "RBNode_elm_builtin")
                                , H.node1 380 9 12 (H.val "Red")
                                , H.node1 381 9 11 (H.val "lK")
                                , H.node1 382 9 11 (H.val "lV")
                                , H.node1
                                    383
                                    9
                                    58
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            383
                                            10
                                            57
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    383
                                                    10
                                                    28
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    383
                                                    29
                                                    34
                                                    (H.val "Black")
                                                , H.node1
                                                    383
                                                    35
                                                    38
                                                    (H.val "llK")
                                                , H.node1
                                                    383
                                                    39
                                                    42
                                                    (H.val "llV")
                                                , H.node1
                                                    383
                                                    43
                                                    49
                                                    (H.val "llLeft")
                                                , H.node1
                                                    383
                                                    50
                                                    57
                                                    (H.val "llRight")
                                                ]
                                            )
                                        )
                                    )
                                , H.node1
                                    384
                                    9
                                    90
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            384
                                            10
                                            89
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    384
                                                    10
                                                    28
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    384
                                                    29
                                                    34
                                                    (H.val "Black")
                                                , H.node1 384 35 36 (H.val "k")
                                                , H.node1 384 37 38 (H.val "v")
                                                , H.node1
                                                    384
                                                    39
                                                    45
                                                    (H.val "lRight")
                                                , H.node1
                                                    384
                                                    46
                                                    89
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            384
                                                            47
                                                            88
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    384
                                                                    47
                                                                    65
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    384
                                                                    66
                                                                    69
                                                                    (H.val "Red"
                                                                    )
                                                                , H.node1
                                                                    384
                                                                    70
                                                                    72
                                                                    (H.val "rK")
                                                                , H.node1
                                                                    384
                                                                    73
                                                                    75
                                                                    (H.val "rV")
                                                                , H.node1
                                                                    384
                                                                    76
                                                                    81
                                                                    (H.val
                                                                        "rLeft"
                                                                    )
                                                                , H.node1
                                                                    384
                                                                    82
                                                                    88
                                                                    (H.val
                                                                        "rRight"
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
                            386
                            5
                            121
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    386
                                    24
                                    27
                                    (Elm.Syntax.Pattern.VarPattern "clr")
                                , H.node1
                                    386
                                    28
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "k")
                                , H.node1
                                    386
                                    30
                                    31
                                    (Elm.Syntax.Pattern.VarPattern "v")
                                , H.node1
                                    386
                                    32
                                    76
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (H.node1
                                            386
                                            33
                                            75
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ H.node1
                                                    386
                                                    52
                                                    56
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lClr"
                                                    )
                                                , H.node1
                                                    386
                                                    57
                                                    59
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lK"
                                                    )
                                                , H.node1
                                                    386
                                                    60
                                                    62
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lV"
                                                    )
                                                , H.node1
                                                    386
                                                    63
                                                    68
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lLeft"
                                                    )
                                                , H.node1
                                                    386
                                                    69
                                                    75
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "lRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , H.node1
                                    386
                                    77
                                    121
                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                        (H.node1
                                            386
                                            78
                                            120
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "RBNode_elm_builtin"
                                                }
                                                [ H.node1
                                                    386
                                                    97
                                                    101
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rClr"
                                                    )
                                                , H.node1
                                                    386
                                                    102
                                                    104
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rK"
                                                    )
                                                , H.node1
                                                    386
                                                    105
                                                    107
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rV"
                                                    )
                                                , H.node1
                                                    386
                                                    108
                                                    113
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rLeft"
                                                    )
                                                , H.node1
                                                    386
                                                    114
                                                    120
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "rRight"
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                      , H.node
                            387
                            7
                            402
                            56
                            (Elm.Syntax.Expression.CaseExpression
                                { expression = H.node1 387 12 15 (H.val "clr")
                                , cases =
                                    [ ( H.node1
                                            388
                                            9
                                            14
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Black"
                                                }
                                                []
                                            )
                                      , H.node
                                            389
                                            11
                                            394
                                            56
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    389
                                                    11
                                                    29
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    390
                                                    13
                                                    18
                                                    (H.val "Black")
                                                , H.node1 391 13 14 (H.val "k")
                                                , H.node1 392 13 14 (H.val "v")
                                                , H.node1
                                                    393
                                                    13
                                                    56
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            393
                                                            14
                                                            55
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    393
                                                                    14
                                                                    32
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    393
                                                                    33
                                                                    36
                                                                    (H.val "Red"
                                                                    )
                                                                , H.node1
                                                                    393
                                                                    37
                                                                    39
                                                                    (H.val "lK")
                                                                , H.node1
                                                                    393
                                                                    40
                                                                    42
                                                                    (H.val "lV")
                                                                , H.node1
                                                                    393
                                                                    43
                                                                    48
                                                                    (H.val
                                                                        "lLeft"
                                                                    )
                                                                , H.node1
                                                                    393
                                                                    49
                                                                    55
                                                                    (H.val
                                                                        "lRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    394
                                                    13
                                                    56
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            394
                                                            14
                                                            55
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    394
                                                                    14
                                                                    32
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    394
                                                                    33
                                                                    36
                                                                    (H.val "Red"
                                                                    )
                                                                , H.node1
                                                                    394
                                                                    37
                                                                    39
                                                                    (H.val "rK")
                                                                , H.node1
                                                                    394
                                                                    40
                                                                    42
                                                                    (H.val "rV")
                                                                , H.node1
                                                                    394
                                                                    43
                                                                    48
                                                                    (H.val
                                                                        "rLeft"
                                                                    )
                                                                , H.node1
                                                                    394
                                                                    49
                                                                    55
                                                                    (H.val
                                                                        "rRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            396
                                            9
                                            12
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Red"
                                                }
                                                []
                                            )
                                      , H.node
                                            397
                                            11
                                            402
                                            56
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    397
                                                    11
                                                    29
                                                    (H.val "RBNode_elm_builtin")
                                                , H.node1
                                                    398
                                                    13
                                                    18
                                                    (H.val "Black")
                                                , H.node1 399 13 14 (H.val "k")
                                                , H.node1 400 13 14 (H.val "v")
                                                , H.node1
                                                    401
                                                    13
                                                    56
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            401
                                                            14
                                                            55
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    401
                                                                    14
                                                                    32
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    401
                                                                    33
                                                                    36
                                                                    (H.val "Red"
                                                                    )
                                                                , H.node1
                                                                    401
                                                                    37
                                                                    39
                                                                    (H.val "lK")
                                                                , H.node1
                                                                    401
                                                                    40
                                                                    42
                                                                    (H.val "lV")
                                                                , H.node1
                                                                    401
                                                                    43
                                                                    48
                                                                    (H.val
                                                                        "lLeft"
                                                                    )
                                                                , H.node1
                                                                    401
                                                                    49
                                                                    55
                                                                    (H.val
                                                                        "lRight"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    402
                                                    13
                                                    56
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            402
                                                            14
                                                            55
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    402
                                                                    14
                                                                    32
                                                                    (H.val
                                                                        "RBNode_elm_builtin"
                                                                    )
                                                                , H.node1
                                                                    402
                                                                    33
                                                                    36
                                                                    (H.val "Red"
                                                                    )
                                                                , H.node1
                                                                    402
                                                                    37
                                                                    39
                                                                    (H.val "rK")
                                                                , H.node1
                                                                    402
                                                                    40
                                                                    42
                                                                    (H.val "rV")
                                                                , H.node1
                                                                    402
                                                                    43
                                                                    48
                                                                    (H.val
                                                                        "rLeft"
                                                                    )
                                                                , H.node1
                                                                    402
                                                                    49
                                                                    55
                                                                    (H.val
                                                                        "rRight"
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
                    , ( H.node1 404 5 6 Elm.Syntax.Pattern.AllPattern
                      , H.node1 405 7 11 (H.val "dict")
                      )
                    ]
                }
            )
    }


update : Elm.Syntax.Expression.FunctionImplementation
update =
    { name = H.node1 410 1 7 "Dict.update"
    , arguments =
        [ H.node1 410 8 17 (Elm.Syntax.Pattern.VarPattern "targetKey")
        , H.node1 410 18 23 (Elm.Syntax.Pattern.VarPattern "alter")
        , H.node1 410 24 34 (Elm.Syntax.Pattern.VarPattern "dictionary")
        ]
    , expression =
        H.node
            411
            3
            416
            34
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        411
                        8
                        40
                        (Elm.Syntax.Expression.Application
                            [ H.node1 411 8 13 (H.val "alter")
                            , H.node1
                                411
                                14
                                40
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        411
                                        15
                                        39
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 411 15 18 (H.val "get")
                                            , H.node1
                                                411
                                                19
                                                28
                                                (H.val "targetKey")
                                            , H.node1
                                                411
                                                29
                                                39
                                                (H.val "dictionary")
                                            ]
                                        )
                                    )
                                )
                            ]
                        )
                , cases =
                    [ ( H.node1
                            412
                            5
                            15
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    412
                                    10
                                    15
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                ]
                            )
                      , H.node1
                            413
                            7
                            40
                            (Elm.Syntax.Expression.Application
                                [ H.node1 413 7 13 (H.val "insert")
                                , H.node1 413 14 23 (H.val "targetKey")
                                , H.node1 413 24 29 (H.val "value")
                                , H.node1 413 30 40 (H.val "dictionary")
                                ]
                            )
                      )
                    , ( H.node1
                            415
                            5
                            12
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1
                            416
                            7
                            34
                            (Elm.Syntax.Expression.Application
                                [ H.node1 416 7 13 (H.val "remove")
                                , H.node1 416 14 23 (H.val "targetKey")
                                , H.node1 416 24 34 (H.val "dictionary")
                                ]
                            )
                      )
                    ]
                }
            )
    }


singleton : Elm.Syntax.Expression.FunctionImplementation
singleton =
    { name = H.node1 421 1 10 "Dict.singleton"
    , arguments =
        [ H.node1 421 11 14 (Elm.Syntax.Pattern.VarPattern "key")
        , H.node1 421 15 20 (Elm.Syntax.Pattern.VarPattern "value")
        ]
    , expression =
        H.node1
            423
            3
            77
            (Elm.Syntax.Expression.Application
                [ H.node1 423 3 21 (H.val "RBNode_elm_builtin")
                , H.node1 423 22 27 (H.val "Black")
                , H.node1 423 28 31 (H.val "key")
                , H.node1 423 32 37 (H.val "value")
                , H.node1 423 38 57 (H.val "RBEmpty_elm_builtin")
                , H.node1 423 58 77 (H.val "RBEmpty_elm_builtin")
                ]
            )
    }


union : Elm.Syntax.Expression.FunctionImplementation
union =
    { name = H.node1 433 1 6 "Dict.union"
    , arguments =
        [ H.node1 433 7 9 (Elm.Syntax.Pattern.VarPattern "t1")
        , H.node1 433 10 12 (Elm.Syntax.Pattern.VarPattern "t2")
        ]
    , expression =
        H.node1
            434
            3
            21
            (Elm.Syntax.Expression.Application
                [ H.node1 434 3 8 (H.val "foldl")
                , H.node1 434 9 15 (H.val "insert")
                , H.node1 434 16 18 (H.val "t2")
                , H.node1 434 19 21 (H.val "t1")
                ]
            )
    }


intersect : Elm.Syntax.Expression.FunctionImplementation
intersect =
    { name = H.node1 441 1 10 "Dict.intersect"
    , arguments =
        [ H.node1 441 11 13 (Elm.Syntax.Pattern.VarPattern "t1")
        , H.node1 441 14 16 (Elm.Syntax.Pattern.VarPattern "t2")
        ]
    , expression =
        H.node1
            442
            3
            34
            (Elm.Syntax.Expression.Application
                [ H.node1 442 3 9 (H.val "filter")
                , H.node1
                    442
                    10
                    31
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            442
                            11
                            30
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        442
                                        12
                                        13
                                        (Elm.Syntax.Pattern.VarPattern "k")
                                    , H.node1
                                        442
                                        14
                                        15
                                        Elm.Syntax.Pattern.AllPattern
                                    ]
                                , expression =
                                    H.node1
                                        442
                                        19
                                        30
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 442 19 25 (H.val "member")
                                            , H.node1 442 26 27 (H.val "k")
                                            , H.node1 442 28 30 (H.val "t2")
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , H.node1 442 32 34 (H.val "t1")
                ]
            )
    }


diff : Elm.Syntax.Expression.FunctionImplementation
diff =
    { name = H.node1 448 1 5 "Dict.diff"
    , arguments =
        [ H.node1 448 6 8 (Elm.Syntax.Pattern.VarPattern "t1")
        , H.node1 448 9 11 (Elm.Syntax.Pattern.VarPattern "t2")
        ]
    , expression =
        H.node1
            449
            3
            37
            (Elm.Syntax.Expression.Application
                [ H.node1 449 3 8 (H.val "foldl")
                , H.node1
                    449
                    9
                    31
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            449
                            10
                            30
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        449
                                        11
                                        12
                                        (Elm.Syntax.Pattern.VarPattern "k")
                                    , H.node1
                                        449
                                        13
                                        14
                                        (Elm.Syntax.Pattern.VarPattern "v")
                                    , H.node1
                                        449
                                        15
                                        16
                                        (Elm.Syntax.Pattern.VarPattern "t")
                                    ]
                                , expression =
                                    H.node1
                                        449
                                        20
                                        30
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 449 20 26 (H.val "remove")
                                            , H.node1 449 27 28 (H.val "k")
                                            , H.node1 449 29 30 (H.val "t")
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , H.node1 449 32 34 (H.val "t1")
                , H.node1 449 35 37 (H.val "t2")
                ]
            )
    }


merge : Elm.Syntax.Expression.FunctionImplementation
merge =
    { name = H.node1 470 1 6 "Dict.merge"
    , arguments =
        [ H.node1 470 7 15 (Elm.Syntax.Pattern.VarPattern "leftStep")
        , H.node1 470 16 24 (Elm.Syntax.Pattern.VarPattern "bothStep")
        , H.node1 470 25 34 (Elm.Syntax.Pattern.VarPattern "rightStep")
        , H.node1 470 35 43 (Elm.Syntax.Pattern.VarPattern "leftDict")
        , H.node1 470 44 53 (Elm.Syntax.Pattern.VarPattern "rightDict")
        , H.node1 470 54 67 (Elm.Syntax.Pattern.VarPattern "initialResult")
        ]
    , expression =
        H.node
            471
            3
            490
            83
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        472
                        5
                        485
                        55
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    472
                                    5
                                    485
                                    55
                                    { name = H.node1 472 5 14 "stepState"
                                    , arguments =
                                        [ H.node1
                                            472
                                            15
                                            19
                                            (Elm.Syntax.Pattern.VarPattern
                                                "rKey"
                                            )
                                        , H.node1
                                            472
                                            20
                                            26
                                            (Elm.Syntax.Pattern.VarPattern
                                                "rValue"
                                            )
                                        , H.node1
                                            472
                                            27
                                            41
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    472
                                                    28
                                                    32
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "list"
                                                    )
                                                , H.node1
                                                    472
                                                    34
                                                    40
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "result"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            473
                                            7
                                            485
                                            55
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        473
                                                        12
                                                        16
                                                        (H.val "list")
                                                , cases =
                                                    [ ( H.node1
                                                            474
                                                            9
                                                            11
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , H.node1
                                                            475
                                                            11
                                                            47
                                                            (Elm.Syntax.Expression.TupledExpression
                                                                [ H.node1
                                                                    475
                                                                    12
                                                                    16
                                                                    (H.val
                                                                        "list"
                                                                    )
                                                                , H.node1
                                                                    475
                                                                    18
                                                                    46
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            475
                                                                            18
                                                                            27
                                                                            (H.val
                                                                                "rightStep"
                                                                            )
                                                                        , H.node1
                                                                            475
                                                                            28
                                                                            32
                                                                            (H.val
                                                                                "rKey"
                                                                            )
                                                                        , H.node1
                                                                            475
                                                                            33
                                                                            39
                                                                            (H.val
                                                                                "rValue"
                                                                            )
                                                                        , H.node1
                                                                            475
                                                                            40
                                                                            46
                                                                            (H.val
                                                                                "result"
                                                                            )
                                                                        ]
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            477
                                                            9
                                                            31
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    477
                                                                    9
                                                                    23
                                                                    (Elm.Syntax.Pattern.TuplePattern
                                                                        [ H.node1
                                                                            477
                                                                            10
                                                                            14
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "lKey"
                                                                            )
                                                                        , H.node1
                                                                            477
                                                                            16
                                                                            22
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "lValue"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                                (H.node1
                                                                    477
                                                                    27
                                                                    31
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "rest"
                                                                    )
                                                                )
                                                            )
                                                      , H.node
                                                            478
                                                            11
                                                            485
                                                            55
                                                            (Elm.Syntax.Expression.IfBlock
                                                                (H.node1
                                                                    478
                                                                    14
                                                                    25
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "<"
                                                                        Elm.Syntax.Infix.Non
                                                                        (H.node1
                                                                            478
                                                                            14
                                                                            18
                                                                            (H.val
                                                                                "lKey"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            478
                                                                            21
                                                                            25
                                                                            (H.val
                                                                                "rKey"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                (H.node1
                                                                    479
                                                                    13
                                                                    70
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            479
                                                                            13
                                                                            22
                                                                            (H.val
                                                                                "stepState"
                                                                            )
                                                                        , H.node1
                                                                            479
                                                                            23
                                                                            27
                                                                            (H.val
                                                                                "rKey"
                                                                            )
                                                                        , H.node1
                                                                            479
                                                                            28
                                                                            34
                                                                            (H.val
                                                                                "rValue"
                                                                            )
                                                                        , H.node1
                                                                            479
                                                                            35
                                                                            70
                                                                            (Elm.Syntax.Expression.TupledExpression
                                                                                [ H.node1
                                                                                    479
                                                                                    36
                                                                                    40
                                                                                    (H.val
                                                                                        "rest"
                                                                                    )
                                                                                , H.node1
                                                                                    479
                                                                                    42
                                                                                    69
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ H.node1
                                                                                            479
                                                                                            42
                                                                                            50
                                                                                            (H.val
                                                                                                "leftStep"
                                                                                            )
                                                                                        , H.node1
                                                                                            479
                                                                                            51
                                                                                            55
                                                                                            (H.val
                                                                                                "lKey"
                                                                                            )
                                                                                        , H.node1
                                                                                            479
                                                                                            56
                                                                                            62
                                                                                            (H.val
                                                                                                "lValue"
                                                                                            )
                                                                                        , H.node1
                                                                                            479
                                                                                            63
                                                                                            69
                                                                                            (H.val
                                                                                                "result"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                                ]
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                                (H.node
                                                                    481
                                                                    16
                                                                    485
                                                                    55
                                                                    (Elm.Syntax.Expression.IfBlock
                                                                        (H.node1
                                                                            481
                                                                            19
                                                                            30
                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                ">"
                                                                                Elm.Syntax.Infix.Non
                                                                                (H.node1
                                                                                    481
                                                                                    19
                                                                                    23
                                                                                    (H.val
                                                                                        "lKey"
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    481
                                                                                    26
                                                                                    30
                                                                                    (H.val
                                                                                        "rKey"
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            482
                                                                            13
                                                                            49
                                                                            (Elm.Syntax.Expression.TupledExpression
                                                                                [ H.node1
                                                                                    482
                                                                                    14
                                                                                    18
                                                                                    (H.val
                                                                                        "list"
                                                                                    )
                                                                                , H.node1
                                                                                    482
                                                                                    20
                                                                                    48
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ H.node1
                                                                                            482
                                                                                            20
                                                                                            29
                                                                                            (H.val
                                                                                                "rightStep"
                                                                                            )
                                                                                        , H.node1
                                                                                            482
                                                                                            30
                                                                                            34
                                                                                            (H.val
                                                                                                "rKey"
                                                                                            )
                                                                                        , H.node1
                                                                                            482
                                                                                            35
                                                                                            41
                                                                                            (H.val
                                                                                                "rValue"
                                                                                            )
                                                                                        , H.node1
                                                                                            482
                                                                                            42
                                                                                            48
                                                                                            (H.val
                                                                                                "result"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            485
                                                                            13
                                                                            55
                                                                            (Elm.Syntax.Expression.TupledExpression
                                                                                [ H.node1
                                                                                    485
                                                                                    14
                                                                                    18
                                                                                    (H.val
                                                                                        "rest"
                                                                                    )
                                                                                , H.node1
                                                                                    485
                                                                                    20
                                                                                    54
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ H.node1
                                                                                            485
                                                                                            20
                                                                                            28
                                                                                            (H.val
                                                                                                "bothStep"
                                                                                            )
                                                                                        , H.node1
                                                                                            485
                                                                                            29
                                                                                            33
                                                                                            (H.val
                                                                                                "lKey"
                                                                                            )
                                                                                        , H.node1
                                                                                            485
                                                                                            34
                                                                                            40
                                                                                            (H.val
                                                                                                "lValue"
                                                                                            )
                                                                                        , H.node1
                                                                                            485
                                                                                            41
                                                                                            47
                                                                                            (H.val
                                                                                                "rValue"
                                                                                            )
                                                                                        , H.node1
                                                                                            485
                                                                                            48
                                                                                            54
                                                                                            (H.val
                                                                                                "result"
                                                                                            )
                                                                                        ]
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
                                    }
                            }
                        )
                    , H.node
                        487
                        5
                        488
                        65
                        (Elm.Syntax.Expression.LetDestructuring
                            (H.node1
                                487
                                5
                                36
                                (Elm.Syntax.Pattern.TuplePattern
                                    [ H.node1
                                        487
                                        6
                                        15
                                        (Elm.Syntax.Pattern.VarPattern
                                            "leftovers"
                                        )
                                    , H.node1
                                        487
                                        17
                                        35
                                        (Elm.Syntax.Pattern.VarPattern
                                            "intermediateResult"
                                        )
                                    ]
                                )
                            )
                            (H.node1
                                488
                                7
                                65
                                (Elm.Syntax.Expression.Application
                                    [ H.node1 488 7 12 (H.val "foldl")
                                    , H.node1 488 13 22 (H.val "stepState")
                                    , H.node1
                                        488
                                        23
                                        55
                                        (Elm.Syntax.Expression.TupledExpression
                                            [ H.node1
                                                488
                                                24
                                                39
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        488
                                                        24
                                                        30
                                                        (H.val "toList")
                                                    , H.node1
                                                        488
                                                        31
                                                        39
                                                        (H.val "leftDict")
                                                    ]
                                                )
                                            , H.node1
                                                488
                                                41
                                                54
                                                (H.val "initialResult")
                                            ]
                                        )
                                    , H.node1 488 56 65 (H.val "rightDict")
                                    ]
                                )
                            )
                        )
                    ]
                , expression =
                    H.node1
                        490
                        5
                        83
                        (Elm.Syntax.Expression.Application
                            [ H.node1
                                490
                                5
                                15
                                (Elm.Syntax.Expression.FunctionOrValue
                                    [ "List" ]
                                    "foldl"
                                )
                            , H.node1
                                490
                                16
                                54
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        490
                                        17
                                        53
                                        (Elm.Syntax.Expression.LambdaExpression
                                            { args =
                                                [ H.node1
                                                    490
                                                    18
                                                    23
                                                    (Elm.Syntax.Pattern.TuplePattern
                                                        [ H.node1
                                                            490
                                                            19
                                                            20
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "k"
                                                            )
                                                        , H.node1
                                                            490
                                                            21
                                                            22
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "v"
                                                            )
                                                        ]
                                                    )
                                                , H.node1
                                                    490
                                                    24
                                                    30
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "result"
                                                    )
                                                ]
                                            , expression =
                                                H.node1
                                                    490
                                                    34
                                                    53
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            490
                                                            34
                                                            42
                                                            (H.val "leftStep")
                                                        , H.node1
                                                            490
                                                            43
                                                            44
                                                            (H.val "k")
                                                        , H.node1
                                                            490
                                                            45
                                                            46
                                                            (H.val "v")
                                                        , H.node1
                                                            490
                                                            47
                                                            53
                                                            (H.val "result")
                                                        ]
                                                    )
                                            }
                                        )
                                    )
                                )
                            , H.node1 490 55 73 (H.val "intermediateResult")
                            , H.node1 490 74 83 (H.val "leftovers")
                            ]
                        )
                }
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = H.node1 500 1 4 "Dict.map"
    , arguments =
        [ H.node1 500 5 9 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 500 10 14 (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        H.node
            501
            3
            506
            85
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 501 8 12 (H.val "dict")
                , cases =
                    [ ( H.node1
                            502
                            5
                            24
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , H.node1 503 7 26 (H.val "RBEmpty_elm_builtin")
                      )
                    , ( H.node1
                            505
                            5
                            50
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    505
                                    24
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "color")
                                , H.node1
                                    505
                                    30
                                    33
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , H.node1
                                    505
                                    34
                                    39
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , H.node1
                                    505
                                    40
                                    44
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , H.node1
                                    505
                                    45
                                    50
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , H.node1
                            506
                            7
                            85
                            (Elm.Syntax.Expression.Application
                                [ H.node1 506 7 25 (H.val "RBNode_elm_builtin")
                                , H.node1 506 26 31 (H.val "color")
                                , H.node1 506 32 35 (H.val "key")
                                , H.node1
                                    506
                                    36
                                    52
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            506
                                            37
                                            51
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    506
                                                    37
                                                    41
                                                    (H.val "func")
                                                , H.node1
                                                    506
                                                    42
                                                    45
                                                    (H.val "key")
                                                , H.node1
                                                    506
                                                    46
                                                    51
                                                    (H.val "value")
                                                ]
                                            )
                                        )
                                    )
                                , H.node1
                                    506
                                    53
                                    68
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            506
                                            54
                                            67
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    506
                                                    54
                                                    57
                                                    (H.val "map")
                                                , H.node1
                                                    506
                                                    58
                                                    62
                                                    (H.val "func")
                                                , H.node1
                                                    506
                                                    63
                                                    67
                                                    (H.val "left")
                                                ]
                                            )
                                        )
                                    )
                                , H.node1
                                    506
                                    69
                                    85
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            506
                                            70
                                            84
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    506
                                                    70
                                                    73
                                                    (H.val "map")
                                                , H.node1
                                                    506
                                                    74
                                                    78
                                                    (H.val "func")
                                                , H.node1
                                                    506
                                                    79
                                                    84
                                                    (H.val "right")
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


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = H.node1 524 1 6 "Dict.foldl"
    , arguments =
        [ H.node1 524 7 11 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 524 12 15 (Elm.Syntax.Pattern.VarPattern "acc")
        , H.node1 524 16 20 (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        H.node
            525
            3
            530
            62
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 525 8 12 (H.val "dict")
                , cases =
                    [ ( H.node1
                            526
                            5
                            24
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , H.node1 527 7 10 (H.val "acc")
                      )
                    , ( H.node1
                            529
                            5
                            46
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    529
                                    24
                                    25
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    529
                                    26
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , H.node1
                                    529
                                    30
                                    35
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , H.node1
                                    529
                                    36
                                    40
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , H.node1
                                    529
                                    41
                                    46
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , H.node1
                            530
                            7
                            62
                            (Elm.Syntax.Expression.Application
                                [ H.node1 530 7 12 (H.val "foldl")
                                , H.node1 530 13 17 (H.val "func")
                                , H.node1
                                    530
                                    18
                                    56
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            530
                                            19
                                            55
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    530
                                                    19
                                                    23
                                                    (H.val "func")
                                                , H.node1
                                                    530
                                                    24
                                                    27
                                                    (H.val "key")
                                                , H.node1
                                                    530
                                                    28
                                                    33
                                                    (H.val "value")
                                                , H.node1
                                                    530
                                                    34
                                                    55
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            530
                                                            35
                                                            54
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    530
                                                                    35
                                                                    40
                                                                    (H.val
                                                                        "foldl"
                                                                    )
                                                                , H.node1
                                                                    530
                                                                    41
                                                                    45
                                                                    (H.val
                                                                        "func"
                                                                    )
                                                                , H.node1
                                                                    530
                                                                    46
                                                                    49
                                                                    (H.val "acc"
                                                                    )
                                                                , H.node1
                                                                    530
                                                                    50
                                                                    54
                                                                    (H.val
                                                                        "left"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , H.node1 530 57 62 (H.val "right")
                                ]
                            )
                      )
                    ]
                }
            )
    }


foldr : Elm.Syntax.Expression.FunctionImplementation
foldr =
    { name = H.node1 548 1 6 "Dict.foldr"
    , arguments =
        [ H.node1 548 7 11 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 548 12 15 (Elm.Syntax.Pattern.VarPattern "acc")
        , H.node1 548 16 17 (Elm.Syntax.Pattern.VarPattern "t")
        ]
    , expression =
        H.node
            549
            3
            554
            62
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 549 8 9 (H.val "t")
                , cases =
                    [ ( H.node1
                            550
                            5
                            24
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = []
                                , name = "RBEmpty_elm_builtin"
                                }
                                []
                            )
                      , H.node1 551 7 10 (H.val "acc")
                      )
                    , ( H.node1
                            553
                            5
                            46
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "RBNode_elm_builtin" }
                                [ H.node1
                                    553
                                    24
                                    25
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    553
                                    26
                                    29
                                    (Elm.Syntax.Pattern.VarPattern "key")
                                , H.node1
                                    553
                                    30
                                    35
                                    (Elm.Syntax.Pattern.VarPattern "value")
                                , H.node1
                                    553
                                    36
                                    40
                                    (Elm.Syntax.Pattern.VarPattern "left")
                                , H.node1
                                    553
                                    41
                                    46
                                    (Elm.Syntax.Pattern.VarPattern "right")
                                ]
                            )
                      , H.node1
                            554
                            7
                            62
                            (Elm.Syntax.Expression.Application
                                [ H.node1 554 7 12 (H.val "foldr")
                                , H.node1 554 13 17 (H.val "func")
                                , H.node1
                                    554
                                    18
                                    57
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            554
                                            19
                                            56
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    554
                                                    19
                                                    23
                                                    (H.val "func")
                                                , H.node1
                                                    554
                                                    24
                                                    27
                                                    (H.val "key")
                                                , H.node1
                                                    554
                                                    28
                                                    33
                                                    (H.val "value")
                                                , H.node1
                                                    554
                                                    34
                                                    56
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            554
                                                            35
                                                            55
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    554
                                                                    35
                                                                    40
                                                                    (H.val
                                                                        "foldr"
                                                                    )
                                                                , H.node1
                                                                    554
                                                                    41
                                                                    45
                                                                    (H.val
                                                                        "func"
                                                                    )
                                                                , H.node1
                                                                    554
                                                                    46
                                                                    49
                                                                    (H.val "acc"
                                                                    )
                                                                , H.node1
                                                                    554
                                                                    50
                                                                    55
                                                                    (H.val
                                                                        "right"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                , H.node1 554 58 62 (H.val "left")
                                ]
                            )
                      )
                    ]
                }
            )
    }


filter : Elm.Syntax.Expression.FunctionImplementation
filter =
    { name = H.node1 559 1 7 "Dict.filter"
    , arguments =
        [ H.node1 559 8 14 (Elm.Syntax.Pattern.VarPattern "isGood")
        , H.node1 559 15 19 (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        H.node1
            560
            3
            70
            (Elm.Syntax.Expression.Application
                [ H.node1 560 3 8 (H.val "foldl")
                , H.node1
                    560
                    9
                    59
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            560
                            10
                            58
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        560
                                        11
                                        12
                                        (Elm.Syntax.Pattern.VarPattern "k")
                                    , H.node1
                                        560
                                        13
                                        14
                                        (Elm.Syntax.Pattern.VarPattern "v")
                                    , H.node1
                                        560
                                        15
                                        16
                                        (Elm.Syntax.Pattern.VarPattern "d")
                                    ]
                                , expression =
                                    H.node1
                                        560
                                        20
                                        58
                                        (Elm.Syntax.Expression.IfBlock
                                            (H.node1
                                                560
                                                23
                                                33
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        560
                                                        23
                                                        29
                                                        (H.val "isGood")
                                                    , H.node1
                                                        560
                                                        30
                                                        31
                                                        (H.val "k")
                                                    , H.node1
                                                        560
                                                        32
                                                        33
                                                        (H.val "v")
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                560
                                                39
                                                51
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        560
                                                        39
                                                        45
                                                        (H.val "insert")
                                                    , H.node1
                                                        560
                                                        46
                                                        47
                                                        (H.val "k")
                                                    , H.node1
                                                        560
                                                        48
                                                        49
                                                        (H.val "v")
                                                    , H.node1
                                                        560
                                                        50
                                                        51
                                                        (H.val "d")
                                                    ]
                                                )
                                            )
                                            (H.node1 560 57 58 (H.val "d"))
                                        )
                                }
                            )
                        )
                    )
                , H.node1 560 60 65 (H.val "empty")
                , H.node1 560 66 70 (H.val "dict")
                ]
            )
    }


partition : Elm.Syntax.Expression.FunctionImplementation
partition =
    { name = H.node1 568 1 10 "Dict.partition"
    , arguments =
        [ H.node1 568 11 17 (Elm.Syntax.Pattern.VarPattern "isGood")
        , H.node1 568 18 22 (Elm.Syntax.Pattern.VarPattern "dict")
        ]
    , expression =
        H.node
            569
            3
            577
            34
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        570
                        5
                        575
                        34
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    570
                                    5
                                    575
                                    34
                                    { name = H.node1 570 5 8 "add"
                                    , arguments =
                                        [ H.node1
                                            570
                                            9
                                            12
                                            (Elm.Syntax.Pattern.VarPattern "key"
                                            )
                                        , H.node1
                                            570
                                            13
                                            18
                                            (Elm.Syntax.Pattern.VarPattern
                                                "value"
                                            )
                                        , H.node1
                                            570
                                            19
                                            27
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    570
                                                    20
                                                    22
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "t1"
                                                    )
                                                , H.node1
                                                    570
                                                    24
                                                    26
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "t2"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            571
                                            7
                                            575
                                            34
                                            (Elm.Syntax.Expression.IfBlock
                                                (H.node1
                                                    571
                                                    10
                                                    26
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            571
                                                            10
                                                            16
                                                            (H.val "isGood")
                                                        , H.node1
                                                            571
                                                            17
                                                            20
                                                            (H.val "key")
                                                        , H.node1
                                                            571
                                                            21
                                                            26
                                                            (H.val "value")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    572
                                                    9
                                                    34
                                                    (Elm.Syntax.Expression.TupledExpression
                                                        [ H.node1
                                                            572
                                                            10
                                                            29
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    572
                                                                    10
                                                                    16
                                                                    (H.val
                                                                        "insert"
                                                                    )
                                                                , H.node1
                                                                    572
                                                                    17
                                                                    20
                                                                    (H.val "key"
                                                                    )
                                                                , H.node1
                                                                    572
                                                                    21
                                                                    26
                                                                    (H.val
                                                                        "value"
                                                                    )
                                                                , H.node1
                                                                    572
                                                                    27
                                                                    29
                                                                    (H.val "t1")
                                                                ]
                                                            )
                                                        , H.node1
                                                            572
                                                            31
                                                            33
                                                            (H.val "t2")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    575
                                                    9
                                                    34
                                                    (Elm.Syntax.Expression.TupledExpression
                                                        [ H.node1
                                                            575
                                                            10
                                                            12
                                                            (H.val "t1")
                                                        , H.node1
                                                            575
                                                            14
                                                            33
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    575
                                                                    14
                                                                    20
                                                                    (H.val
                                                                        "insert"
                                                                    )
                                                                , H.node1
                                                                    575
                                                                    21
                                                                    24
                                                                    (H.val "key"
                                                                    )
                                                                , H.node1
                                                                    575
                                                                    25
                                                                    30
                                                                    (H.val
                                                                        "value"
                                                                    )
                                                                , H.node1
                                                                    575
                                                                    31
                                                                    33
                                                                    (H.val "t2")
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
                        577
                        5
                        34
                        (Elm.Syntax.Expression.Application
                            [ H.node1 577 5 10 (H.val "foldl")
                            , H.node1 577 11 14 (H.val "add")
                            , H.node1
                                577
                                15
                                29
                                (Elm.Syntax.Expression.TupledExpression
                                    [ H.node1 577 16 21 (H.val "empty")
                                    , H.node1 577 23 28 (H.val "empty")
                                    ]
                                )
                            , H.node1 577 30 34 (H.val "dict")
                            ]
                        )
                }
            )
    }


keys : Elm.Syntax.Expression.FunctionImplementation
keys =
    { name = H.node1 588 1 5 "Dict.keys"
    , arguments = [ H.node1 588 6 10 (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        H.node1
            589
            3
            55
            (Elm.Syntax.Expression.Application
                [ H.node1 589 3 8 (H.val "foldr")
                , H.node1
                    589
                    9
                    47
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            589
                            10
                            46
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        589
                                        11
                                        14
                                        (Elm.Syntax.Pattern.VarPattern "key")
                                    , H.node1
                                        589
                                        15
                                        20
                                        (Elm.Syntax.Pattern.VarPattern "value")
                                    , H.node1
                                        589
                                        21
                                        28
                                        (Elm.Syntax.Pattern.VarPattern "keyList"
                                        )
                                    ]
                                , expression =
                                    H.node1
                                        589
                                        32
                                        46
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "::"
                                            Elm.Syntax.Infix.Right
                                            (H.node1 589 32 35 (H.val "key"))
                                            (H.node1 589 39 46 (H.val "keyList")
                                            )
                                        )
                                }
                            )
                        )
                    )
                , H.node1 589 48 50 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 589 51 55 (H.val "dict")
                ]
            )
    }


values : Elm.Syntax.Expression.FunctionImplementation
values =
    { name = H.node1 597 1 7 "Dict.values"
    , arguments = [ H.node1 597 8 12 (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        H.node1
            598
            3
            61
            (Elm.Syntax.Expression.Application
                [ H.node1 598 3 8 (H.val "foldr")
                , H.node1
                    598
                    9
                    53
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            598
                            10
                            52
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        598
                                        11
                                        14
                                        (Elm.Syntax.Pattern.VarPattern "key")
                                    , H.node1
                                        598
                                        15
                                        20
                                        (Elm.Syntax.Pattern.VarPattern "value")
                                    , H.node1
                                        598
                                        21
                                        30
                                        (Elm.Syntax.Pattern.VarPattern
                                            "valueList"
                                        )
                                    ]
                                , expression =
                                    H.node1
                                        598
                                        34
                                        52
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "::"
                                            Elm.Syntax.Infix.Right
                                            (H.node1 598 34 39 (H.val "value"))
                                            (H.node1
                                                598
                                                43
                                                52
                                                (H.val "valueList")
                                            )
                                        )
                                }
                            )
                        )
                    )
                , H.node1 598 54 56 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 598 57 61 (H.val "dict")
                ]
            )
    }


toList : Elm.Syntax.Expression.FunctionImplementation
toList =
    { name = H.node1 603 1 7 "Dict.toList"
    , arguments = [ H.node1 603 8 12 (Elm.Syntax.Pattern.VarPattern "dict") ]
    , expression =
        H.node1
            604
            3
            57
            (Elm.Syntax.Expression.Application
                [ H.node1 604 3 8 (H.val "foldr")
                , H.node1
                    604
                    9
                    49
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            604
                            10
                            48
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        604
                                        11
                                        14
                                        (Elm.Syntax.Pattern.VarPattern "key")
                                    , H.node1
                                        604
                                        15
                                        20
                                        (Elm.Syntax.Pattern.VarPattern "value")
                                    , H.node1
                                        604
                                        21
                                        25
                                        (Elm.Syntax.Pattern.VarPattern "list")
                                    ]
                                , expression =
                                    H.node1
                                        604
                                        29
                                        48
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "::"
                                            Elm.Syntax.Infix.Right
                                            (H.node1
                                                604
                                                29
                                                40
                                                (Elm.Syntax.Expression.TupledExpression
                                                    [ H.node1
                                                        604
                                                        30
                                                        33
                                                        (H.val "key")
                                                    , H.node1
                                                        604
                                                        34
                                                        39
                                                        (H.val "value")
                                                    ]
                                                )
                                            )
                                            (H.node1 604 44 48 (H.val "list"))
                                        )
                                }
                            )
                        )
                    )
                , H.node1 604 50 52 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 604 53 57 (H.val "dict")
                ]
            )
    }


fromList : Elm.Syntax.Expression.FunctionImplementation
fromList =
    { name = H.node1 609 1 9 "Dict.fromList"
    , arguments = [ H.node1 609 10 16 (Elm.Syntax.Pattern.VarPattern "assocs") ]
    , expression =
        H.node1
            610
            3
            71
            (Elm.Syntax.Expression.Application
                [ H.node1
                    610
                    3
                    13
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "foldl")
                , H.node1
                    610
                    14
                    58
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            610
                            15
                            57
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        610
                                        16
                                        27
                                        (Elm.Syntax.Pattern.TuplePattern
                                            [ H.node1
                                                610
                                                17
                                                20
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "key"
                                                )
                                            , H.node1
                                                610
                                                21
                                                26
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "value"
                                                )
                                            ]
                                        )
                                    , H.node1
                                        610
                                        28
                                        32
                                        (Elm.Syntax.Pattern.VarPattern "dict")
                                    ]
                                , expression =
                                    H.node1
                                        610
                                        36
                                        57
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 610 36 42 (H.val "insert")
                                            , H.node1 610 43 46 (H.val "key")
                                            , H.node1 610 47 52 (H.val "value")
                                            , H.node1 610 53 57 (H.val "dict")
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , H.node1 610 59 64 (H.val "empty")
                , H.node1 610 65 71 (H.val "assocs")
                ]
            )
    }