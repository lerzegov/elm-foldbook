module Core.Set exposing (diff, empty, filter, foldl, foldr, fromList, functions, insert, intersect, isEmpty, map, member, partition, remove, singleton, size, toList, union)

{-| 
@docs functions, empty, singleton, insert, remove, isEmpty, member, size, union, intersect, diff, toList, fromList, foldl, foldr, map, filter, partition
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
        , ( "singleton", singleton )
        , ( "insert", insert )
        , ( "remove", remove )
        , ( "isEmpty", isEmpty )
        , ( "member", member )
        , ( "size", size )
        , ( "union", union )
        , ( "intersect", intersect )
        , ( "diff", diff )
        , ( "toList", toList )
        , ( "fromList", fromList )
        , ( "foldl", foldl )
        , ( "foldr", foldr )
        , ( "map", map )
        , ( "filter", filter )
        , ( "partition", partition )
        ]


empty : Elm.Syntax.Expression.FunctionImplementation
empty =
    { name = H.node1 52 1 6 "Set.empty"
    , arguments = []
    , expression =
        H.node1
            53
            3
            29
            (Elm.Syntax.Expression.Application
                [ H.node1 53 3 18 (H.val "Set_elm_builtin")
                , H.node1
                    53
                    19
                    29
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "empty")
                ]
            )
    }


singleton : Elm.Syntax.Expression.FunctionImplementation
singleton =
    { name = H.node1 59 1 10 "Set.singleton"
    , arguments = [ H.node1 59 11 14 (Elm.Syntax.Pattern.VarPattern "key") ]
    , expression =
        H.node1
            60
            3
            42
            (Elm.Syntax.Expression.Application
                [ H.node1 60 3 18 (H.val "Set_elm_builtin")
                , H.node1
                    60
                    19
                    42
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            60
                            20
                            41
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    60
                                    20
                                    34
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "singleton"
                                    )
                                , H.node1 60 35 38 (H.val "key")
                                , H.node1
                                    60
                                    39
                                    41
                                    Elm.Syntax.Expression.UnitExpr
                                ]
                            )
                        )
                    )
                ]
            )
    }


insert : Elm.Syntax.Expression.FunctionImplementation
insert =
    { name = H.node1 66 1 7 "Set.insert"
    , arguments =
        [ H.node1 66 8 11 (Elm.Syntax.Pattern.VarPattern "key")
        , H.node1
            66
            12
            34
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    66
                    13
                    33
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            66
                            29
                            33
                            (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            67
            3
            44
            (Elm.Syntax.Expression.Application
                [ H.node1 67 3 18 (H.val "Set_elm_builtin")
                , H.node1
                    67
                    19
                    44
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            67
                            20
                            43
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    67
                                    20
                                    31
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "insert"
                                    )
                                , H.node1 67 32 35 (H.val "key")
                                , H.node1
                                    67
                                    36
                                    38
                                    Elm.Syntax.Expression.UnitExpr
                                , H.node1 67 39 43 (H.val "dict")
                                ]
                            )
                        )
                    )
                ]
            )
    }


remove : Elm.Syntax.Expression.FunctionImplementation
remove =
    { name = H.node1 73 1 7 "Set.remove"
    , arguments =
        [ H.node1 73 8 11 (Elm.Syntax.Pattern.VarPattern "key")
        , H.node1
            73
            12
            34
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    73
                    13
                    33
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            73
                            29
                            33
                            (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            74
            3
            41
            (Elm.Syntax.Expression.Application
                [ H.node1 74 3 18 (H.val "Set_elm_builtin")
                , H.node1
                    74
                    19
                    41
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            74
                            20
                            40
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    74
                                    20
                                    31
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "remove"
                                    )
                                , H.node1 74 32 35 (H.val "key")
                                , H.node1 74 36 40 (H.val "dict")
                                ]
                            )
                        )
                    )
                ]
            )
    }


isEmpty : Elm.Syntax.Expression.FunctionImplementation
isEmpty =
    { name = H.node1 80 1 8 "Set.isEmpty"
    , arguments =
        [ H.node1
            80
            9
            31
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    80
                    10
                    30
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            80
                            26
                            30
                            (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            81
            3
            20
            (Elm.Syntax.Expression.Application
                [ H.node1
                    81
                    3
                    15
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "isEmpty")
                , H.node1 81 16 20 (H.val "dict")
                ]
            )
    }


member : Elm.Syntax.Expression.FunctionImplementation
member =
    { name = H.node1 87 1 7 "Set.member"
    , arguments =
        [ H.node1 87 8 11 (Elm.Syntax.Pattern.VarPattern "key")
        , H.node1
            87
            12
            34
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    87
                    13
                    33
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            87
                            29
                            33
                            (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            88
            3
            23
            (Elm.Syntax.Expression.Application
                [ H.node1
                    88
                    3
                    14
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "member")
                , H.node1 88 15 18 (H.val "key")
                , H.node1 88 19 23 (H.val "dict")
                ]
            )
    }


size : Elm.Syntax.Expression.FunctionImplementation
size =
    { name = H.node1 94 1 5 "Set.size"
    , arguments =
        [ H.node1
            94
            6
            28
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    94
                    7
                    27
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            94
                            23
                            27
                            (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            95
            3
            17
            (Elm.Syntax.Expression.Application
                [ H.node1
                    95
                    3
                    12
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "size")
                , H.node1 95 13 17 (H.val "dict")
                ]
            )
    }


union : Elm.Syntax.Expression.FunctionImplementation
union =
    { name = H.node1 101 1 6 "Set.union"
    , arguments =
        [ H.node1
            101
            7
            30
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    101
                    8
                    29
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            101
                            24
                            29
                            (Elm.Syntax.Pattern.VarPattern "dict1")
                        ]
                    )
                )
            )
        , H.node1
            101
            31
            54
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    101
                    32
                    53
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            101
                            48
                            53
                            (Elm.Syntax.Pattern.VarPattern "dict2")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            102
            3
            43
            (Elm.Syntax.Expression.Application
                [ H.node1 102 3 18 (H.val "Set_elm_builtin")
                , H.node1
                    102
                    19
                    43
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            102
                            20
                            42
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    102
                                    20
                                    30
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "union"
                                    )
                                , H.node1 102 31 36 (H.val "dict1")
                                , H.node1 102 37 42 (H.val "dict2")
                                ]
                            )
                        )
                    )
                ]
            )
    }


intersect : Elm.Syntax.Expression.FunctionImplementation
intersect =
    { name = H.node1 108 1 10 "Set.intersect"
    , arguments =
        [ H.node1
            108
            11
            34
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    108
                    12
                    33
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            108
                            28
                            33
                            (Elm.Syntax.Pattern.VarPattern "dict1")
                        ]
                    )
                )
            )
        , H.node1
            108
            35
            58
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    108
                    36
                    57
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            108
                            52
                            57
                            (Elm.Syntax.Pattern.VarPattern "dict2")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            109
            3
            47
            (Elm.Syntax.Expression.Application
                [ H.node1 109 3 18 (H.val "Set_elm_builtin")
                , H.node1
                    109
                    19
                    47
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            109
                            20
                            46
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    109
                                    20
                                    34
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "intersect"
                                    )
                                , H.node1 109 35 40 (H.val "dict1")
                                , H.node1 109 41 46 (H.val "dict2")
                                ]
                            )
                        )
                    )
                ]
            )
    }


diff : Elm.Syntax.Expression.FunctionImplementation
diff =
    { name = H.node1 116 1 5 "Set.diff"
    , arguments =
        [ H.node1
            116
            6
            29
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    116
                    7
                    28
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            116
                            23
                            28
                            (Elm.Syntax.Pattern.VarPattern "dict1")
                        ]
                    )
                )
            )
        , H.node1
            116
            30
            53
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    116
                    31
                    52
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            116
                            47
                            52
                            (Elm.Syntax.Pattern.VarPattern "dict2")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            117
            3
            42
            (Elm.Syntax.Expression.Application
                [ H.node1 117 3 18 (H.val "Set_elm_builtin")
                , H.node1
                    117
                    19
                    42
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            117
                            20
                            41
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    117
                                    20
                                    29
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "diff"
                                    )
                                , H.node1 117 30 35 (H.val "dict1")
                                , H.node1 117 36 41 (H.val "dict2")
                                ]
                            )
                        )
                    )
                ]
            )
    }


toList : Elm.Syntax.Expression.FunctionImplementation
toList =
    { name = H.node1 123 1 7 "Set.toList"
    , arguments =
        [ H.node1
            123
            8
            30
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    123
                    9
                    29
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            123
                            25
                            29
                            (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            124
            3
            17
            (Elm.Syntax.Expression.Application
                [ H.node1
                    124
                    3
                    12
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "keys")
                , H.node1 124 13 17 (H.val "dict")
                ]
            )
    }


fromList : Elm.Syntax.Expression.FunctionImplementation
fromList =
    { name = H.node1 130 1 9 "Set.fromList"
    , arguments = [ H.node1 130 10 14 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node1
            131
            3
            31
            (Elm.Syntax.Expression.Application
                [ H.node1
                    131
                    3
                    13
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "foldl")
                , H.node1 131 14 20 (H.val "insert")
                , H.node1 131 21 26 (H.val "empty")
                , H.node1 131 27 31 (H.val "list")
                ]
            )
    }


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = H.node1 137 1 6 "Set.foldl"
    , arguments =
        [ H.node1 137 7 11 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 137 12 24 (Elm.Syntax.Pattern.VarPattern "initialState")
        , H.node1
            137
            25
            47
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    137
                    26
                    46
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            137
                            42
                            46
                            (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            138
            3
            64
            (Elm.Syntax.Expression.Application
                [ H.node1
                    138
                    3
                    13
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "foldl")
                , H.node1
                    138
                    14
                    46
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            138
                            15
                            45
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        138
                                        16
                                        19
                                        (Elm.Syntax.Pattern.VarPattern "key")
                                    , H.node1
                                        138
                                        20
                                        21
                                        Elm.Syntax.Pattern.AllPattern
                                    , H.node1
                                        138
                                        22
                                        27
                                        (Elm.Syntax.Pattern.VarPattern "state")
                                    ]
                                , expression =
                                    H.node1
                                        138
                                        31
                                        45
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 138 31 35 (H.val "func")
                                            , H.node1 138 36 39 (H.val "key")
                                            , H.node1 138 40 45 (H.val "state")
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , H.node1 138 47 59 (H.val "initialState")
                , H.node1 138 60 64 (H.val "dict")
                ]
            )
    }


foldr : Elm.Syntax.Expression.FunctionImplementation
foldr =
    { name = H.node1 144 1 6 "Set.foldr"
    , arguments =
        [ H.node1 144 7 11 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 144 12 24 (Elm.Syntax.Pattern.VarPattern "initialState")
        , H.node1
            144
            25
            47
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    144
                    26
                    46
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            144
                            42
                            46
                            (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            145
            3
            64
            (Elm.Syntax.Expression.Application
                [ H.node1
                    145
                    3
                    13
                    (Elm.Syntax.Expression.FunctionOrValue [ "Dict" ] "foldr")
                , H.node1
                    145
                    14
                    46
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            145
                            15
                            45
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        145
                                        16
                                        19
                                        (Elm.Syntax.Pattern.VarPattern "key")
                                    , H.node1
                                        145
                                        20
                                        21
                                        Elm.Syntax.Pattern.AllPattern
                                    , H.node1
                                        145
                                        22
                                        27
                                        (Elm.Syntax.Pattern.VarPattern "state")
                                    ]
                                , expression =
                                    H.node1
                                        145
                                        31
                                        45
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 145 31 35 (H.val "func")
                                            , H.node1 145 36 39 (H.val "key")
                                            , H.node1 145 40 45 (H.val "state")
                                            ]
                                        )
                                }
                            )
                        )
                    )
                , H.node1 145 47 59 (H.val "initialState")
                , H.node1 145 60 64 (H.val "dict")
                ]
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = H.node1 151 1 4 "Set.map"
    , arguments =
        [ H.node1 151 5 9 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 151 10 13 (Elm.Syntax.Pattern.VarPattern "set")
        ]
    , expression =
        H.node1
            152
            3
            50
            (Elm.Syntax.Expression.Application
                [ H.node1 152 3 11 (H.val "fromList")
                , H.node1
                    152
                    12
                    50
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            152
                            13
                            49
                            (Elm.Syntax.Expression.Application
                                [ H.node1 152 13 18 (H.val "foldl")
                                , H.node1
                                    152
                                    19
                                    42
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            152
                                            20
                                            41
                                            (Elm.Syntax.Expression.LambdaExpression
                                                { args =
                                                    [ H.node1
                                                        152
                                                        21
                                                        22
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "x"
                                                        )
                                                    , H.node1
                                                        152
                                                        23
                                                        25
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "xs"
                                                        )
                                                    ]
                                                , expression =
                                                    H.node1
                                                        152
                                                        29
                                                        41
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "::"
                                                            Elm.Syntax.Infix.Right
                                                            (H.node1
                                                                152
                                                                29
                                                                35
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        152
                                                                        29
                                                                        33
                                                                        (H.val
                                                                            "func"
                                                                        )
                                                                    , H.node1
                                                                        152
                                                                        34
                                                                        35
                                                                        (H.val
                                                                            "x"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                            (H.node1
                                                                152
                                                                39
                                                                41
                                                                (H.val "xs")
                                                            )
                                                        )
                                                }
                                            )
                                        )
                                    )
                                , H.node1
                                    152
                                    43
                                    45
                                    (Elm.Syntax.Expression.ListExpr [])
                                , H.node1 152 46 49 (H.val "set")
                                ]
                            )
                        )
                    )
                ]
            )
    }


filter : Elm.Syntax.Expression.FunctionImplementation
filter =
    { name = H.node1 170 1 7 "Set.filter"
    , arguments =
        [ H.node1 170 8 14 (Elm.Syntax.Pattern.VarPattern "isGood")
        , H.node1
            170
            15
            37
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    170
                    16
                    36
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            170
                            32
                            36
                            (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            171
            3
            60
            (Elm.Syntax.Expression.Application
                [ H.node1 171 3 18 (H.val "Set_elm_builtin")
                , H.node1
                    171
                    19
                    60
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            171
                            20
                            59
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    171
                                    20
                                    31
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Dict" ]
                                        "filter"
                                    )
                                , H.node1
                                    171
                                    32
                                    54
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            171
                                            33
                                            53
                                            (Elm.Syntax.Expression.LambdaExpression
                                                { args =
                                                    [ H.node1
                                                        171
                                                        34
                                                        37
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "key"
                                                        )
                                                    , H.node1
                                                        171
                                                        38
                                                        39
                                                        Elm.Syntax.Pattern.AllPattern
                                                    ]
                                                , expression =
                                                    H.node1
                                                        171
                                                        43
                                                        53
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                171
                                                                43
                                                                49
                                                                (H.val "isGood")
                                                            , H.node1
                                                                171
                                                                50
                                                                53
                                                                (H.val "key")
                                                            ]
                                                        )
                                                }
                                            )
                                        )
                                    )
                                , H.node1 171 55 59 (H.val "dict")
                                ]
                            )
                        )
                    )
                ]
            )
    }


partition : Elm.Syntax.Expression.FunctionImplementation
partition =
    { name = H.node1 178 1 10 "Set.partition"
    , arguments =
        [ H.node1 178 11 17 (Elm.Syntax.Pattern.VarPattern "isGood")
        , H.node1
            178
            18
            40
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    178
                    19
                    39
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Set_elm_builtin" }
                        [ H.node1
                            178
                            35
                            39
                            (Elm.Syntax.Pattern.VarPattern "dict")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node
            179
            3
            183
            51
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        180
                        5
                        181
                        49
                        (Elm.Syntax.Expression.LetDestructuring
                            (H.node1
                                180
                                5
                                19
                                (Elm.Syntax.Pattern.TuplePattern
                                    [ H.node1
                                        180
                                        6
                                        11
                                        (Elm.Syntax.Pattern.VarPattern "dict1")
                                    , H.node1
                                        180
                                        13
                                        18
                                        (Elm.Syntax.Pattern.VarPattern "dict2")
                                    ]
                                )
                            )
                            (H.node1
                                181
                                7
                                49
                                (Elm.Syntax.Expression.Application
                                    [ H.node1
                                        181
                                        7
                                        21
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "Dict" ]
                                            "partition"
                                        )
                                    , H.node1
                                        181
                                        22
                                        44
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node1
                                                181
                                                23
                                                43
                                                (Elm.Syntax.Expression.LambdaExpression
                                                    { args =
                                                        [ H.node1
                                                            181
                                                            24
                                                            27
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "key"
                                                            )
                                                        , H.node1
                                                            181
                                                            28
                                                            29
                                                            Elm.Syntax.Pattern.AllPattern
                                                        ]
                                                    , expression =
                                                        H.node1
                                                            181
                                                            33
                                                            43
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    181
                                                                    33
                                                                    39
                                                                    (H.val
                                                                        "isGood"
                                                                    )
                                                                , H.node1
                                                                    181
                                                                    40
                                                                    43
                                                                    (H.val "key"
                                                                    )
                                                                ]
                                                            )
                                                    }
                                                )
                                            )
                                        )
                                    , H.node1 181 45 49 (H.val "dict")
                                    ]
                                )
                            )
                        )
                    ]
                , expression =
                    H.node1
                        183
                        5
                        51
                        (Elm.Syntax.Expression.TupledExpression
                            [ H.node1
                                183
                                6
                                27
                                (Elm.Syntax.Expression.Application
                                    [ H.node1 183 6 21 (H.val "Set_elm_builtin")
                                    , H.node1 183 22 27 (H.val "dict1")
                                    ]
                                )
                            , H.node1
                                183
                                29
                                50
                                (Elm.Syntax.Expression.Application
                                    [ H.node1
                                        183
                                        29
                                        44
                                        (H.val "Set_elm_builtin")
                                    , H.node1 183 45 50 (H.val "dict2")
                                    ]
                                )
                            ]
                        )
                }
            )
    }