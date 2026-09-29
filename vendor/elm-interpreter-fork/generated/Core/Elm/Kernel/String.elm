module Core.Elm.Kernel.String exposing (all, any, foldl, foldr, functions, map)

{-| 
@docs functions, any, all, map, foldl, foldr
-}


import Elm.Syntax.Expression
import Elm.Syntax.Node
import Elm.Syntax.Pattern
import FastDict
import H


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "any", any )
        , ( "all", all )
        , ( "map", map )
        , ( "foldl", foldl )
        , ( "foldr", foldr )
        ]


any : Elm.Syntax.Expression.FunctionImplementation
any =
    { name = H.node1 5 1 4 "Elm.Kernel.String.any"
    , arguments =
        [ H.node1 5 5 6 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 5 7 8 (Elm.Syntax.Pattern.VarPattern "s")
        ]
    , expression =
        H.node1
            6
            5
            33
            (Elm.Syntax.Expression.Application
                [ H.node1
                    6
                    5
                    13
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "any")
                , H.node1 6 14 15 (H.val "f")
                , H.node1
                    6
                    16
                    33
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            6
                            17
                            32
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    6
                                    17
                                    30
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "String" ]
                                        "toList"
                                    )
                                , H.node1 6 31 32 (H.val "s")
                                ]
                            )
                        )
                    )
                ]
            )
    }


all : Elm.Syntax.Expression.FunctionImplementation
all =
    { name = H.node1 10 1 4 "Elm.Kernel.String.all"
    , arguments =
        [ H.node1 10 5 6 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 10 7 8 (Elm.Syntax.Pattern.VarPattern "s")
        ]
    , expression =
        H.node1
            11
            5
            33
            (Elm.Syntax.Expression.Application
                [ H.node1
                    11
                    5
                    13
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "all")
                , H.node1 11 14 15 (H.val "f")
                , H.node1
                    11
                    16
                    33
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            11
                            17
                            32
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    11
                                    17
                                    30
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "String" ]
                                        "toList"
                                    )
                                , H.node1 11 31 32 (H.val "s")
                                ]
                            )
                        )
                    )
                ]
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = H.node1 15 1 4 "Elm.Kernel.String.map"
    , arguments =
        [ H.node1 15 5 6 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 15 7 8 (Elm.Syntax.Pattern.VarPattern "s")
        ]
    , expression =
        H.node1
            16
            5
            51
            (Elm.Syntax.Expression.Application
                [ H.node1
                    16
                    5
                    20
                    (Elm.Syntax.Expression.FunctionOrValue
                        [ "String" ]
                        "fromList"
                    )
                , H.node1
                    16
                    21
                    51
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            16
                            22
                            50
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    16
                                    22
                                    30
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "List" ]
                                        "map"
                                    )
                                , H.node1 16 31 32 (H.val "f")
                                , H.node1
                                    16
                                    33
                                    50
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            16
                                            34
                                            49
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    16
                                                    34
                                                    47
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "String" ]
                                                        "toList"
                                                    )
                                                , H.node1 16 48 49 (H.val "s")
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


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = H.node1 20 1 6 "Elm.Kernel.String.foldl"
    , arguments =
        [ H.node1 20 7 8 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 20 9 10 (Elm.Syntax.Pattern.VarPattern "i")
        , H.node1 20 11 12 (Elm.Syntax.Pattern.VarPattern "s")
        ]
    , expression =
        H.node
            21
            5
            26
            30
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        21
                        10
                        25
                        (Elm.Syntax.Expression.Application
                            [ H.node1
                                21
                                10
                                23
                                (Elm.Syntax.Expression.FunctionOrValue
                                    [ "String" ]
                                    "uncons"
                                )
                            , H.node1 21 24 25 (H.val "s")
                            ]
                        )
                , cases =
                    [ ( H.node1
                            22
                            9
                            16
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 23 13 14 (H.val "i")
                      )
                    , ( H.node1
                            25
                            9
                            22
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    25
                                    14
                                    22
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ H.node1
                                            25
                                            16
                                            17
                                            (Elm.Syntax.Pattern.VarPattern "c")
                                        , H.node1
                                            25
                                            19
                                            20
                                            (Elm.Syntax.Pattern.VarPattern "t")
                                        ]
                                    )
                                ]
                            )
                      , H.node1
                            26
                            13
                            30
                            (Elm.Syntax.Expression.Application
                                [ H.node1 26 13 18 (H.val "foldl")
                                , H.node1 26 19 20 (H.val "f")
                                , H.node1
                                    26
                                    21
                                    28
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            26
                                            22
                                            27
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1 26 22 23 (H.val "f")
                                                , H.node1 26 24 25 (H.val "c")
                                                , H.node1 26 26 27 (H.val "i")
                                                ]
                                            )
                                        )
                                    )
                                , H.node1 26 29 30 (H.val "t")
                                ]
                            )
                      )
                    ]
                }
            )
    }


foldr : Elm.Syntax.Expression.FunctionImplementation
foldr =
    { name = H.node1 30 1 6 "Elm.Kernel.String.foldr"
    , arguments =
        [ H.node1 30 7 8 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 30 9 10 (Elm.Syntax.Pattern.VarPattern "i")
        , H.node1 30 11 12 (Elm.Syntax.Pattern.VarPattern "s")
        ]
    , expression =
        H.node
            31
            5
            36
            51
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        31
                        10
                        42
                        (Elm.Syntax.Expression.Application
                            [ H.node1
                                31
                                10
                                23
                                (Elm.Syntax.Expression.FunctionOrValue
                                    [ "String" ]
                                    "uncons"
                                )
                            , H.node1
                                31
                                24
                                42
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        31
                                        25
                                        41
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                31
                                                25
                                                37
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "String" ]
                                                    "right"
                                                )
                                            , H.node1
                                                31
                                                38
                                                39
                                                (Elm.Syntax.Expression.Integer 1
                                                )
                                            , H.node1 31 40 41 (H.val "s")
                                            ]
                                        )
                                    )
                                )
                            ]
                        )
                , cases =
                    [ ( H.node1
                            32
                            9
                            16
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 33 13 14 (H.val "i")
                      )
                    , ( H.node1
                            35
                            9
                            22
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    35
                                    14
                                    22
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ H.node1
                                            35
                                            16
                                            17
                                            (Elm.Syntax.Pattern.VarPattern "c")
                                        , H.node1
                                            35
                                            19
                                            20
                                            Elm.Syntax.Pattern.AllPattern
                                        ]
                                    )
                                ]
                            )
                      , H.node1
                            36
                            13
                            51
                            (Elm.Syntax.Expression.Application
                                [ H.node1 36 13 18 (H.val "foldr")
                                , H.node1 36 19 20 (H.val "f")
                                , H.node1
                                    36
                                    21
                                    28
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            36
                                            22
                                            27
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1 36 22 23 (H.val "f")
                                                , H.node1 36 24 25 (H.val "c")
                                                , H.node1 36 26 27 (H.val "i")
                                                ]
                                            )
                                        )
                                    )
                                , H.node1
                                    36
                                    29
                                    51
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            36
                                            30
                                            50
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    36
                                                    30
                                                    46
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "String" ]
                                                        "dropRight"
                                                    )
                                                , H.node1
                                                    36
                                                    47
                                                    48
                                                    (Elm.Syntax.Expression.Integer
                                                        1
                                                    )
                                                , H.node1 36 49 50 (H.val "s")
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