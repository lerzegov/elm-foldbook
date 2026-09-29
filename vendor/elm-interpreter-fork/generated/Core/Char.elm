module Core.Char exposing (fromCode, functions, isAlpha, isAlphaNum, isDigit, isHexDigit, isLower, isOctDigit, isUpper, toCode, toLocaleLower, toLocaleUpper, toLower, toUpper)

{-| 
@docs functions, isUpper, isLower, isAlpha, isAlphaNum, isDigit, isOctDigit, isHexDigit, toUpper, toLower, toLocaleUpper, toLocaleLower, toCode, fromCode
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
        [ ( "isUpper", isUpper )
        , ( "isLower", isLower )
        , ( "isAlpha", isAlpha )
        , ( "isAlphaNum", isAlphaNum )
        , ( "isDigit", isDigit )
        , ( "isOctDigit", isOctDigit )
        , ( "isHexDigit", isHexDigit )
        , ( "toUpper", toUpper )
        , ( "toLower", toLower )
        , ( "toLocaleUpper", toLocaleUpper )
        , ( "toLocaleLower", toLocaleLower )
        , ( "toCode", toCode )
        , ( "fromCode", fromCode )
        ]


isUpper : Elm.Syntax.Expression.FunctionImplementation
isUpper =
    { name = H.node1 82 1 8 "Char.isUpper"
    , arguments = [ H.node1 82 9 13 (Elm.Syntax.Pattern.VarPattern "char") ]
    , expression =
        H.node
            83
            3
            87
            33
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        84
                        5
                        85
                        18
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    84
                                    5
                                    85
                                    18
                                    { name = H.node1 84 5 9 "code"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            85
                                            7
                                            18
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    85
                                                    7
                                                    13
                                                    (H.val "toCode")
                                                , H.node1
                                                    85
                                                    14
                                                    18
                                                    (H.val "char")
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        87
                        5
                        33
                        (Elm.Syntax.Expression.OperatorApplication
                            "&&"
                            Elm.Syntax.Infix.Right
                            (H.node1
                                87
                                5
                                17
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<="
                                    Elm.Syntax.Infix.Non
                                    (H.node1 87 5 9 (H.val "code"))
                                    (H.node1
                                        87
                                        13
                                        17
                                        (Elm.Syntax.Expression.Hex 0x5A)
                                    )
                                )
                            )
                            (H.node1
                                87
                                21
                                33
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<="
                                    Elm.Syntax.Infix.Non
                                    (H.node1
                                        87
                                        21
                                        25
                                        (Elm.Syntax.Expression.Hex 0x41)
                                    )
                                    (H.node1 87 29 33 (H.val "code"))
                                )
                            )
                        )
                }
            )
    }


isLower : Elm.Syntax.Expression.FunctionImplementation
isLower =
    { name = H.node1 103 1 8 "Char.isLower"
    , arguments = [ H.node1 103 9 13 (Elm.Syntax.Pattern.VarPattern "char") ]
    , expression =
        H.node
            104
            3
            108
            33
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        105
                        5
                        106
                        18
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    105
                                    5
                                    106
                                    18
                                    { name = H.node1 105 5 9 "code"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            106
                                            7
                                            18
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    106
                                                    7
                                                    13
                                                    (H.val "toCode")
                                                , H.node1
                                                    106
                                                    14
                                                    18
                                                    (H.val "char")
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        108
                        5
                        33
                        (Elm.Syntax.Expression.OperatorApplication
                            "&&"
                            Elm.Syntax.Infix.Right
                            (H.node1
                                108
                                5
                                17
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<="
                                    Elm.Syntax.Infix.Non
                                    (H.node1
                                        108
                                        5
                                        9
                                        (Elm.Syntax.Expression.Hex 0x61)
                                    )
                                    (H.node1 108 13 17 (H.val "code"))
                                )
                            )
                            (H.node1
                                108
                                21
                                33
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<="
                                    Elm.Syntax.Infix.Non
                                    (H.node1 108 21 25 (H.val "code"))
                                    (H.node1
                                        108
                                        29
                                        33
                                        (Elm.Syntax.Expression.Hex 0x7A)
                                    )
                                )
                            )
                        )
                }
            )
    }


isAlpha : Elm.Syntax.Expression.FunctionImplementation
isAlpha =
    { name = H.node1 123 1 8 "Char.isAlpha"
    , arguments = [ H.node1 123 9 13 (Elm.Syntax.Pattern.VarPattern "char") ]
    , expression =
        H.node1
            124
            3
            31
            (Elm.Syntax.Expression.OperatorApplication
                "||"
                Elm.Syntax.Infix.Right
                (H.node1
                    124
                    3
                    15
                    (Elm.Syntax.Expression.Application
                        [ H.node1 124 3 10 (H.val "isLower")
                        , H.node1 124 11 15 (H.val "char")
                        ]
                    )
                )
                (H.node1
                    124
                    19
                    31
                    (Elm.Syntax.Expression.Application
                        [ H.node1 124 19 26 (H.val "isUpper")
                        , H.node1 124 27 31 (H.val "char")
                        ]
                    )
                )
            )
    }


isAlphaNum : Elm.Syntax.Expression.FunctionImplementation
isAlphaNum =
    { name = H.node1 140 1 11 "Char.isAlphaNum"
    , arguments = [ H.node1 140 12 16 (Elm.Syntax.Pattern.VarPattern "char") ]
    , expression =
        H.node1
            141
            3
            47
            (Elm.Syntax.Expression.OperatorApplication
                "||"
                Elm.Syntax.Infix.Right
                (H.node1
                    141
                    3
                    15
                    (Elm.Syntax.Expression.Application
                        [ H.node1 141 3 10 (H.val "isLower")
                        , H.node1 141 11 15 (H.val "char")
                        ]
                    )
                )
                (H.node1
                    141
                    19
                    47
                    (Elm.Syntax.Expression.OperatorApplication
                        "||"
                        Elm.Syntax.Infix.Right
                        (H.node1
                            141
                            19
                            31
                            (Elm.Syntax.Expression.Application
                                [ H.node1 141 19 26 (H.val "isUpper")
                                , H.node1 141 27 31 (H.val "char")
                                ]
                            )
                        )
                        (H.node1
                            141
                            35
                            47
                            (Elm.Syntax.Expression.Application
                                [ H.node1 141 35 42 (H.val "isDigit")
                                , H.node1 141 43 47 (H.val "char")
                                ]
                            )
                        )
                    )
                )
            )
    }


isDigit : Elm.Syntax.Expression.FunctionImplementation
isDigit =
    { name = H.node1 156 1 8 "Char.isDigit"
    , arguments = [ H.node1 156 9 13 (Elm.Syntax.Pattern.VarPattern "char") ]
    , expression =
        H.node
            157
            3
            161
            33
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        158
                        5
                        159
                        18
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    158
                                    5
                                    159
                                    18
                                    { name = H.node1 158 5 9 "code"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            159
                                            7
                                            18
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    159
                                                    7
                                                    13
                                                    (H.val "toCode")
                                                , H.node1
                                                    159
                                                    14
                                                    18
                                                    (H.val "char")
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        161
                        5
                        33
                        (Elm.Syntax.Expression.OperatorApplication
                            "&&"
                            Elm.Syntax.Infix.Right
                            (H.node1
                                161
                                5
                                17
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<="
                                    Elm.Syntax.Infix.Non
                                    (H.node1 161 5 9 (H.val "code"))
                                    (H.node1
                                        161
                                        13
                                        17
                                        (Elm.Syntax.Expression.Hex 0x39)
                                    )
                                )
                            )
                            (H.node1
                                161
                                21
                                33
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<="
                                    Elm.Syntax.Infix.Non
                                    (H.node1
                                        161
                                        21
                                        25
                                        (Elm.Syntax.Expression.Hex 0x30)
                                    )
                                    (H.node1 161 29 33 (H.val "code"))
                                )
                            )
                        )
                }
            )
    }


isOctDigit : Elm.Syntax.Expression.FunctionImplementation
isOctDigit =
    { name = H.node1 176 1 11 "Char.isOctDigit"
    , arguments = [ H.node1 176 12 16 (Elm.Syntax.Pattern.VarPattern "char") ]
    , expression =
        H.node
            177
            3
            181
            33
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        178
                        5
                        179
                        18
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    178
                                    5
                                    179
                                    18
                                    { name = H.node1 178 5 9 "code"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            179
                                            7
                                            18
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    179
                                                    7
                                                    13
                                                    (H.val "toCode")
                                                , H.node1
                                                    179
                                                    14
                                                    18
                                                    (H.val "char")
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        181
                        5
                        33
                        (Elm.Syntax.Expression.OperatorApplication
                            "&&"
                            Elm.Syntax.Infix.Right
                            (H.node1
                                181
                                5
                                17
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<="
                                    Elm.Syntax.Infix.Non
                                    (H.node1 181 5 9 (H.val "code"))
                                    (H.node1
                                        181
                                        13
                                        17
                                        (Elm.Syntax.Expression.Hex 0x37)
                                    )
                                )
                            )
                            (H.node1
                                181
                                21
                                33
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<="
                                    Elm.Syntax.Infix.Non
                                    (H.node1
                                        181
                                        21
                                        25
                                        (Elm.Syntax.Expression.Hex 0x30)
                                    )
                                    (H.node1 181 29 33 (H.val "code"))
                                )
                            )
                        )
                }
            )
    }


isHexDigit : Elm.Syntax.Expression.FunctionImplementation
isHexDigit =
    { name = H.node1 187 1 11 "Char.isHexDigit"
    , arguments = [ H.node1 187 12 16 (Elm.Syntax.Pattern.VarPattern "char") ]
    , expression =
        H.node
            188
            3
            194
            38
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        189
                        5
                        190
                        18
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    189
                                    5
                                    190
                                    18
                                    { name = H.node1 189 5 9 "code"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            190
                                            7
                                            18
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    190
                                                    7
                                                    13
                                                    (H.val "toCode")
                                                , H.node1
                                                    190
                                                    14
                                                    18
                                                    (H.val "char")
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        192
                        5
                        194
                        38
                        (Elm.Syntax.Expression.OperatorApplication
                            "||"
                            Elm.Syntax.Infix.Right
                            (H.node1
                                192
                                5
                                35
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        192
                                        6
                                        34
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "&&"
                                            Elm.Syntax.Infix.Right
                                            (H.node1
                                                192
                                                6
                                                18
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "<="
                                                    Elm.Syntax.Infix.Non
                                                    (H.node1
                                                        192
                                                        6
                                                        10
                                                        (Elm.Syntax.Expression.Hex
                                                            0x30
                                                        )
                                                    )
                                                    (H.node1
                                                        192
                                                        14
                                                        18
                                                        (H.val "code")
                                                    )
                                                )
                                            )
                                            (H.node1
                                                192
                                                22
                                                34
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "<="
                                                    Elm.Syntax.Infix.Non
                                                    (H.node1
                                                        192
                                                        22
                                                        26
                                                        (H.val "code")
                                                    )
                                                    (H.node1
                                                        192
                                                        30
                                                        34
                                                        (Elm.Syntax.Expression.Hex
                                                            0x39
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                            (H.node
                                193
                                8
                                194
                                38
                                (Elm.Syntax.Expression.OperatorApplication
                                    "||"
                                    Elm.Syntax.Infix.Right
                                    (H.node1
                                        193
                                        8
                                        38
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node1
                                                193
                                                9
                                                37
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "&&"
                                                    Elm.Syntax.Infix.Right
                                                    (H.node1
                                                        193
                                                        9
                                                        21
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "<="
                                                            Elm.Syntax.Infix.Non
                                                            (H.node1
                                                                193
                                                                9
                                                                13
                                                                (Elm.Syntax.Expression.Hex
                                                                    0x41
                                                                )
                                                            )
                                                            (H.node1
                                                                193
                                                                17
                                                                21
                                                                (H.val "code")
                                                            )
                                                        )
                                                    )
                                                    (H.node1
                                                        193
                                                        25
                                                        37
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "<="
                                                            Elm.Syntax.Infix.Non
                                                            (H.node1
                                                                193
                                                                25
                                                                29
                                                                (H.val "code")
                                                            )
                                                            (H.node1
                                                                193
                                                                33
                                                                37
                                                                (Elm.Syntax.Expression.Hex
                                                                    0x46
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                    (H.node1
                                        194
                                        8
                                        38
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node1
                                                194
                                                9
                                                37
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "&&"
                                                    Elm.Syntax.Infix.Right
                                                    (H.node1
                                                        194
                                                        9
                                                        21
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "<="
                                                            Elm.Syntax.Infix.Non
                                                            (H.node1
                                                                194
                                                                9
                                                                13
                                                                (Elm.Syntax.Expression.Hex
                                                                    0x61
                                                                )
                                                            )
                                                            (H.node1
                                                                194
                                                                17
                                                                21
                                                                (H.val "code")
                                                            )
                                                        )
                                                    )
                                                    (H.node1
                                                        194
                                                        25
                                                        37
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "<="
                                                            Elm.Syntax.Infix.Non
                                                            (H.node1
                                                                194
                                                                25
                                                                29
                                                                (H.val "code")
                                                            )
                                                            (H.node1
                                                                194
                                                                33
                                                                37
                                                                (Elm.Syntax.Expression.Hex
                                                                    0x66
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        )
                }
            )
    }


toUpper : Elm.Syntax.Expression.FunctionImplementation
toUpper =
    { name = H.node1 203 1 8 "Char.toUpper"
    , arguments = []
    , expression =
        H.node1
            204
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Char" ]
                "toUpper"
            )
    }


toLower : Elm.Syntax.Expression.FunctionImplementation
toLower =
    { name = H.node1 209 1 8 "Char.toLower"
    , arguments = []
    , expression =
        H.node1
            210
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Char" ]
                "toLower"
            )
    }


toLocaleUpper : Elm.Syntax.Expression.FunctionImplementation
toLocaleUpper =
    { name = H.node1 215 1 14 "Char.toLocaleUpper"
    , arguments = []
    , expression =
        H.node1
            216
            3
            32
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Char" ]
                "toLocaleUpper"
            )
    }


toLocaleLower : Elm.Syntax.Expression.FunctionImplementation
toLocaleLower =
    { name = H.node1 221 1 14 "Char.toLocaleLower"
    , arguments = []
    , expression =
        H.node1
            222
            3
            32
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Char" ]
                "toLocaleLower"
            )
    }


toCode : Elm.Syntax.Expression.FunctionImplementation
toCode =
    { name = H.node1 236 1 7 "Char.toCode"
    , arguments = []
    , expression =
        H.node1
            237
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Char" ]
                "toCode"
            )
    }


fromCode : Elm.Syntax.Expression.FunctionImplementation
fromCode =
    { name = H.node1 256 1 9 "Char.fromCode"
    , arguments = []
    , expression =
        H.node1
            257
            3
            27
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Char" ]
                "fromCode"
            )
    }