module Core.String exposing (all, any, append, concat, cons, contains, dropLeft, dropRight, endsWith, filter, foldl, foldr, fromChar, fromFloat, fromInt, fromList, functions, indexes, indices, isEmpty, join, left, length, lines, map, pad, padLeft, padRight, repeat, repeatHelp, replace, reverse, right, slice, split, startsWith, toFloat, toInt, toList, toLower, toUpper, trim, trimLeft, trimRight, uncons, words)

{-| 
@docs functions, isEmpty, length, reverse, repeat, repeatHelp, replace, append, concat, split, join, words, lines, slice, left, right, dropLeft, dropRight, contains, startsWith, endsWith, indexes, indices, toUpper, toLower, pad, padLeft, padRight, trim, trimLeft, trimRight, toInt, fromInt, toFloat, fromFloat, toList, fromList, fromChar, cons, uncons, map, filter, foldl, foldr, any, all
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
        [ ( "isEmpty", isEmpty )
        , ( "length", length )
        , ( "reverse", reverse )
        , ( "repeat", repeat )
        , ( "repeatHelp", repeatHelp )
        , ( "replace", replace )
        , ( "append", append )
        , ( "concat", concat )
        , ( "split", split )
        , ( "join", join )
        , ( "words", words )
        , ( "lines", lines )
        , ( "slice", slice )
        , ( "left", left )
        , ( "right", right )
        , ( "dropLeft", dropLeft )
        , ( "dropRight", dropRight )
        , ( "contains", contains )
        , ( "startsWith", startsWith )
        , ( "endsWith", endsWith )
        , ( "indexes", indexes )
        , ( "indices", indices )
        , ( "toUpper", toUpper )
        , ( "toLower", toLower )
        , ( "pad", pad )
        , ( "padLeft", padLeft )
        , ( "padRight", padRight )
        , ( "trim", trim )
        , ( "trimLeft", trimLeft )
        , ( "trimRight", trimRight )
        , ( "toInt", toInt )
        , ( "fromInt", fromInt )
        , ( "toFloat", toFloat )
        , ( "fromFloat", fromFloat )
        , ( "toList", toList )
        , ( "fromList", fromList )
        , ( "fromChar", fromChar )
        , ( "cons", cons )
        , ( "uncons", uncons )
        , ( "map", map )
        , ( "filter", filter )
        , ( "foldl", foldl )
        , ( "foldr", foldr )
        , ( "any", any )
        , ( "all", all )
        ]


isEmpty : Elm.Syntax.Expression.FunctionImplementation
isEmpty =
    { name = H.node1 102 1 8 "String.isEmpty"
    , arguments = [ H.node1 102 9 15 (Elm.Syntax.Pattern.VarPattern "string") ]
    , expression =
        H.node1
            103
            3
            15
            (Elm.Syntax.Expression.OperatorApplication
                "=="
                Elm.Syntax.Infix.Non
                (H.node1 103 3 9 (H.val "string"))
                (H.node1 103 13 15 (Elm.Syntax.Expression.Literal ""))
            )
    }


length : Elm.Syntax.Expression.FunctionImplementation
length =
    { name = H.node1 113 1 7 "String.length"
    , arguments = []
    , expression =
        H.node1
            114
            3
            27
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "length"
            )
    }


reverse : Elm.Syntax.Expression.FunctionImplementation
reverse =
    { name = H.node1 122 1 8 "String.reverse"
    , arguments = []
    , expression =
        H.node1
            123
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "reverse"
            )
    }


repeat : Elm.Syntax.Expression.FunctionImplementation
repeat =
    { name = H.node1 131 1 7 "String.repeat"
    , arguments =
        [ H.node1 131 8 9 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 131 10 15 (Elm.Syntax.Pattern.VarPattern "chunk")
        ]
    , expression =
        H.node1
            132
            3
            24
            (Elm.Syntax.Expression.Application
                [ H.node1 132 3 13 (H.val "repeatHelp")
                , H.node1 132 14 15 (H.val "n")
                , H.node1 132 16 21 (H.val "chunk")
                , H.node1 132 22 24 (Elm.Syntax.Expression.Literal "")
                ]
            )
    }


repeatHelp : Elm.Syntax.Expression.FunctionImplementation
repeatHelp =
    { name = H.node1 136 1 11 "String.repeatHelp"
    , arguments =
        [ H.node1 136 12 13 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 136 14 19 (Elm.Syntax.Pattern.VarPattern "chunk")
        , H.node1 136 20 26 (Elm.Syntax.Pattern.VarPattern "result")
        ]
    , expression =
        H.node
            137
            3
            141
            63
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    137
                    6
                    12
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Non
                        (H.node1 137 6 7 (H.val "n"))
                        (H.node1 137 11 12 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node1 138 5 11 (H.val "result"))
                (H.node
                    140
                    5
                    141
                    63
                    (Elm.Syntax.Expression.OperatorApplication
                        "<|"
                        Elm.Syntax.Infix.Right
                        (H.node1
                            140
                            5
                            59
                            (Elm.Syntax.Expression.Application
                                [ H.node1 140 5 15 (H.val "repeatHelp")
                                , H.node1
                                    140
                                    16
                                    42
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            140
                                            17
                                            41
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    140
                                                    17
                                                    37
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "Bitwise" ]
                                                        "shiftRightBy"
                                                    )
                                                , H.node1
                                                    140
                                                    38
                                                    39
                                                    (Elm.Syntax.Expression.Integer
                                                        1
                                                    )
                                                , H.node1 140 40 41 (H.val "n")
                                                ]
                                            )
                                        )
                                    )
                                , H.node1
                                    140
                                    43
                                    59
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            140
                                            44
                                            58
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "++"
                                                Elm.Syntax.Infix.Right
                                                (H.node1
                                                    140
                                                    44
                                                    49
                                                    (H.val "chunk")
                                                )
                                                (H.node1
                                                    140
                                                    53
                                                    58
                                                    (H.val "chunk")
                                                )
                                            )
                                        )
                                    )
                                ]
                            )
                        )
                        (H.node1
                            141
                            7
                            63
                            (Elm.Syntax.Expression.IfBlock
                                (H.node1
                                    141
                                    10
                                    30
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "=="
                                        Elm.Syntax.Infix.Non
                                        (H.node1
                                            141
                                            10
                                            25
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    141
                                                    10
                                                    21
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "Bitwise" ]
                                                        "and"
                                                    )
                                                , H.node1 141 22 23 (H.val "n")
                                                , H.node1
                                                    141
                                                    24
                                                    25
                                                    (Elm.Syntax.Expression.Integer
                                                        1
                                                    )
                                                ]
                                            )
                                        )
                                        (H.node1
                                            141
                                            29
                                            30
                                            (Elm.Syntax.Expression.Integer 0)
                                        )
                                    )
                                )
                                (H.node1 141 36 42 (H.val "result"))
                                (H.node1
                                    141
                                    48
                                    63
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "++"
                                        Elm.Syntax.Infix.Right
                                        (H.node1 141 48 54 (H.val "result"))
                                        (H.node1 141 58 63 (H.val "chunk"))
                                    )
                                )
                            )
                        )
                    )
                )
            )
    }


replace : Elm.Syntax.Expression.FunctionImplementation
replace =
    { name = H.node1 156 1 8 "String.replace"
    , arguments =
        [ H.node1 156 9 15 (Elm.Syntax.Pattern.VarPattern "before")
        , H.node1 156 16 21 (Elm.Syntax.Pattern.VarPattern "after")
        , H.node1 156 22 28 (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        H.node1
            157
            3
            35
            (Elm.Syntax.Expression.Application
                [ H.node1 157 3 7 (H.val "join")
                , H.node1 157 8 13 (H.val "after")
                , H.node1
                    157
                    14
                    35
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            157
                            15
                            34
                            (Elm.Syntax.Expression.Application
                                [ H.node1 157 15 20 (H.val "split")
                                , H.node1 157 21 27 (H.val "before")
                                , H.node1 157 28 34 (H.val "string")
                                ]
                            )
                        )
                    )
                ]
            )
    }


append : Elm.Syntax.Expression.FunctionImplementation
append =
    { name = H.node1 170 1 7 "String.append"
    , arguments = []
    , expression =
        H.node1
            171
            3
            27
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "append"
            )
    }


concat : Elm.Syntax.Expression.FunctionImplementation
concat =
    { name = H.node1 179 1 7 "String.concat"
    , arguments = [ H.node1 179 8 15 (Elm.Syntax.Pattern.VarPattern "strings") ]
    , expression =
        H.node1
            180
            3
            18
            (Elm.Syntax.Expression.Application
                [ H.node1 180 3 7 (H.val "join")
                , H.node1 180 8 10 (Elm.Syntax.Expression.Literal "")
                , H.node1 180 11 18 (H.val "strings")
                ]
            )
    }


split : Elm.Syntax.Expression.FunctionImplementation
split =
    { name = H.node1 190 1 6 "String.split"
    , arguments =
        [ H.node1 190 7 10 (Elm.Syntax.Pattern.VarPattern "sep")
        , H.node1 190 11 17 (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        H.node1
            191
            3
            65
            (Elm.Syntax.Expression.Application
                [ H.node1
                    191
                    3
                    28
                    (Elm.Syntax.Expression.FunctionOrValue
                        [ "Elm", "Kernel", "List" ]
                        "fromArray"
                    )
                , H.node1
                    191
                    29
                    65
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            191
                            30
                            64
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    191
                                    30
                                    53
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Elm", "Kernel", "String" ]
                                        "split"
                                    )
                                , H.node1 191 54 57 (H.val "sep")
                                , H.node1 191 58 64 (H.val "string")
                                ]
                            )
                        )
                    )
                ]
            )
    }


join : Elm.Syntax.Expression.FunctionImplementation
join =
    { name = H.node1 201 1 5 "String.join"
    , arguments =
        [ H.node1 201 6 9 (Elm.Syntax.Pattern.VarPattern "sep")
        , H.node1 201 10 16 (Elm.Syntax.Pattern.VarPattern "chunks")
        ]
    , expression =
        H.node1
            202
            3
            62
            (Elm.Syntax.Expression.Application
                [ H.node1
                    202
                    3
                    25
                    (Elm.Syntax.Expression.FunctionOrValue
                        [ "Elm", "Kernel", "String" ]
                        "join"
                    )
                , H.node1 202 26 29 (H.val "sep")
                , H.node1
                    202
                    30
                    62
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            202
                            31
                            61
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    202
                                    31
                                    54
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Elm", "Kernel", "List" ]
                                        "toArray"
                                    )
                                , H.node1 202 55 61 (H.val "chunks")
                                ]
                            )
                        )
                    )
                ]
            )
    }


words : Elm.Syntax.Expression.FunctionImplementation
words =
    { name = H.node1 210 1 6 "String.words"
    , arguments = []
    , expression =
        H.node1
            211
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "words"
            )
    }


lines : Elm.Syntax.Expression.FunctionImplementation
lines =
    { name = H.node1 219 1 6 "String.lines"
    , arguments = []
    , expression =
        H.node1
            220
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "lines"
            )
    }


slice : Elm.Syntax.Expression.FunctionImplementation
slice =
    { name = H.node1 236 1 6 "String.slice"
    , arguments = []
    , expression =
        H.node1
            237
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "slice"
            )
    }


left : Elm.Syntax.Expression.FunctionImplementation
left =
    { name = H.node1 245 1 5 "String.left"
    , arguments =
        [ H.node1 245 6 7 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 245 8 14 (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        H.node
            246
            3
            249
            21
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    246
                    6
                    11
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Non
                        (H.node1 246 6 7 (H.val "n"))
                        (H.node1 246 10 11 (Elm.Syntax.Expression.Integer 1))
                    )
                )
                (H.node1 247 5 7 (Elm.Syntax.Expression.Literal ""))
                (H.node1
                    249
                    5
                    21
                    (Elm.Syntax.Expression.Application
                        [ H.node1 249 5 10 (H.val "slice")
                        , H.node1 249 11 12 (Elm.Syntax.Expression.Integer 0)
                        , H.node1 249 13 14 (H.val "n")
                        , H.node1 249 15 21 (H.val "string")
                        ]
                    )
                )
            )
    }


right : Elm.Syntax.Expression.FunctionImplementation
right =
    { name = H.node1 257 1 6 "String.right"
    , arguments =
        [ H.node1 257 7 8 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 257 9 15 (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        H.node
            258
            3
            261
            36
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    258
                    6
                    11
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Non
                        (H.node1 258 6 7 (H.val "n"))
                        (H.node1 258 10 11 (Elm.Syntax.Expression.Integer 1))
                    )
                )
                (H.node1 259 5 7 (Elm.Syntax.Expression.Literal ""))
                (H.node1
                    261
                    5
                    36
                    (Elm.Syntax.Expression.Application
                        [ H.node1 261 5 10 (H.val "slice")
                        , H.node1
                            261
                            11
                            13
                            (Elm.Syntax.Expression.Negation
                                (H.node1 261 12 13 (H.val "n"))
                            )
                        , H.node1
                            261
                            14
                            29
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    261
                                    15
                                    28
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 261 15 21 (H.val "length")
                                        , H.node1 261 22 28 (H.val "string")
                                        ]
                                    )
                                )
                            )
                        , H.node1 261 30 36 (H.val "string")
                        ]
                    )
                )
            )
    }


dropLeft : Elm.Syntax.Expression.FunctionImplementation
dropLeft =
    { name = H.node1 269 1 9 "String.dropLeft"
    , arguments =
        [ H.node1 269 10 11 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 269 12 18 (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        H.node
            270
            3
            273
            35
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    270
                    6
                    11
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Non
                        (H.node1 270 6 7 (H.val "n"))
                        (H.node1 270 10 11 (Elm.Syntax.Expression.Integer 1))
                    )
                )
                (H.node1 271 5 11 (H.val "string"))
                (H.node1
                    273
                    5
                    35
                    (Elm.Syntax.Expression.Application
                        [ H.node1 273 5 10 (H.val "slice")
                        , H.node1 273 11 12 (H.val "n")
                        , H.node1
                            273
                            13
                            28
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    273
                                    14
                                    27
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 273 14 20 (H.val "length")
                                        , H.node1 273 21 27 (H.val "string")
                                        ]
                                    )
                                )
                            )
                        , H.node1 273 29 35 (H.val "string")
                        ]
                    )
                )
            )
    }


dropRight : Elm.Syntax.Expression.FunctionImplementation
dropRight =
    { name = H.node1 281 1 10 "String.dropRight"
    , arguments =
        [ H.node1 281 11 12 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 281 13 19 (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        H.node
            282
            3
            285
            22
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    282
                    6
                    11
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Non
                        (H.node1 282 6 7 (H.val "n"))
                        (H.node1 282 10 11 (Elm.Syntax.Expression.Integer 1))
                    )
                )
                (H.node1 283 5 11 (H.val "string"))
                (H.node1
                    285
                    5
                    22
                    (Elm.Syntax.Expression.Application
                        [ H.node1 285 5 10 (H.val "slice")
                        , H.node1 285 11 12 (Elm.Syntax.Expression.Integer 0)
                        , H.node1
                            285
                            13
                            15
                            (Elm.Syntax.Expression.Negation
                                (H.node1 285 14 15 (H.val "n"))
                            )
                        , H.node1 285 16 22 (H.val "string")
                        ]
                    )
                )
            )
    }


contains : Elm.Syntax.Expression.FunctionImplementation
contains =
    { name = H.node1 300 1 9 "String.contains"
    , arguments = []
    , expression =
        H.node1
            301
            3
            29
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "contains"
            )
    }


startsWith : Elm.Syntax.Expression.FunctionImplementation
startsWith =
    { name = H.node1 310 1 11 "String.startsWith"
    , arguments = []
    , expression =
        H.node1
            311
            3
            31
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "startsWith"
            )
    }


endsWith : Elm.Syntax.Expression.FunctionImplementation
endsWith =
    { name = H.node1 320 1 9 "String.endsWith"
    , arguments = []
    , expression =
        H.node1
            321
            3
            29
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "endsWith"
            )
    }


indexes : Elm.Syntax.Expression.FunctionImplementation
indexes =
    { name = H.node1 331 1 8 "String.indexes"
    , arguments = []
    , expression =
        H.node1
            332
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "indexes"
            )
    }


indices : Elm.Syntax.Expression.FunctionImplementation
indices =
    { name = H.node1 337 1 8 "String.indices"
    , arguments = []
    , expression =
        H.node1
            338
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "indexes"
            )
    }


toUpper : Elm.Syntax.Expression.FunctionImplementation
toUpper =
    { name = H.node1 351 1 8 "String.toUpper"
    , arguments = []
    , expression =
        H.node1
            352
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "toUpper"
            )
    }


toLower : Elm.Syntax.Expression.FunctionImplementation
toLower =
    { name = H.node1 360 1 8 "String.toLower"
    , arguments = []
    , expression =
        H.node1
            361
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "toLower"
            )
    }


pad : Elm.Syntax.Expression.FunctionImplementation
pad =
    { name = H.node1 371 1 4 "String.pad"
    , arguments =
        [ H.node1 371 5 6 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 371 7 11 (Elm.Syntax.Pattern.VarPattern "char")
        , H.node1 371 12 18 (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        H.node
            372
            3
            376
            91
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        373
                        5
                        374
                        45
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    373
                                    5
                                    374
                                    45
                                    { name = H.node1 373 5 9 "half"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            374
                                            7
                                            45
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "/"
                                                Elm.Syntax.Infix.Left
                                                (H.node1
                                                    374
                                                    7
                                                    41
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            374
                                                            7
                                                            21
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Basics" ]
                                                                "toFloat"
                                                            )
                                                        , H.node1
                                                            374
                                                            22
                                                            41
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    374
                                                                    23
                                                                    40
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "-"
                                                                        Elm.Syntax.Infix.Left
                                                                        (H.node1
                                                                            374
                                                                            23
                                                                            24
                                                                            (H.val
                                                                                "n"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            374
                                                                            27
                                                                            40
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    374
                                                                                    27
                                                                                    33
                                                                                    (H.val
                                                                                        "length"
                                                                                    )
                                                                                , H.node1
                                                                                    374
                                                                                    34
                                                                                    40
                                                                                    (H.val
                                                                                        "string"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    374
                                                    44
                                                    45
                                                    (Elm.Syntax.Expression.Integer
                                                        2
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        376
                        5
                        91
                        (Elm.Syntax.Expression.OperatorApplication
                            "++"
                            Elm.Syntax.Infix.Right
                            (H.node1
                                376
                                5
                                42
                                (Elm.Syntax.Expression.Application
                                    [ H.node1 376 5 11 (H.val "repeat")
                                    , H.node1
                                        376
                                        12
                                        26
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node1
                                                376
                                                13
                                                25
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        376
                                                        13
                                                        20
                                                        (H.val "ceiling")
                                                    , H.node1
                                                        376
                                                        21
                                                        25
                                                        (H.val "half")
                                                    ]
                                                )
                                            )
                                        )
                                    , H.node1
                                        376
                                        27
                                        42
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node1
                                                376
                                                28
                                                41
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        376
                                                        28
                                                        36
                                                        (H.val "fromChar")
                                                    , H.node1
                                                        376
                                                        37
                                                        41
                                                        (H.val "char")
                                                    ]
                                                )
                                            )
                                        )
                                    ]
                                )
                            )
                            (H.node1
                                376
                                46
                                91
                                (Elm.Syntax.Expression.OperatorApplication
                                    "++"
                                    Elm.Syntax.Infix.Right
                                    (H.node1 376 46 52 (H.val "string"))
                                    (H.node1
                                        376
                                        56
                                        91
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 376 56 62 (H.val "repeat")
                                            , H.node1
                                                376
                                                63
                                                75
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        376
                                                        64
                                                        74
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                376
                                                                64
                                                                69
                                                                (H.val "floor")
                                                            , H.node1
                                                                376
                                                                70
                                                                74
                                                                (H.val "half")
                                                            ]
                                                        )
                                                    )
                                                )
                                            , H.node1
                                                376
                                                76
                                                91
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        376
                                                        77
                                                        90
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                376
                                                                77
                                                                85
                                                                (H.val
                                                                    "fromChar"
                                                                )
                                                            , H.node1
                                                                376
                                                                86
                                                                90
                                                                (H.val "char")
                                                            ]
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                    )
                                )
                            )
                        )
                }
            )
    }


padLeft : Elm.Syntax.Expression.FunctionImplementation
padLeft =
    { name = H.node1 386 1 8 "String.padLeft"
    , arguments =
        [ H.node1 386 9 10 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 386 11 15 (Elm.Syntax.Pattern.VarPattern "char")
        , H.node1 386 16 22 (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        H.node1
            387
            3
            55
            (Elm.Syntax.Expression.OperatorApplication
                "++"
                Elm.Syntax.Infix.Right
                (H.node1
                    387
                    3
                    45
                    (Elm.Syntax.Expression.Application
                        [ H.node1 387 3 9 (H.val "repeat")
                        , H.node1
                            387
                            10
                            29
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    387
                                    11
                                    28
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "-"
                                        Elm.Syntax.Infix.Left
                                        (H.node1 387 11 12 (H.val "n"))
                                        (H.node1
                                            387
                                            15
                                            28
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    387
                                                    15
                                                    21
                                                    (H.val "length")
                                                , H.node1
                                                    387
                                                    22
                                                    28
                                                    (H.val "string")
                                                ]
                                            )
                                        )
                                    )
                                )
                            )
                        , H.node1
                            387
                            30
                            45
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    387
                                    31
                                    44
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 387 31 39 (H.val "fromChar")
                                        , H.node1 387 40 44 (H.val "char")
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                )
                (H.node1 387 49 55 (H.val "string"))
            )
    }


padRight : Elm.Syntax.Expression.FunctionImplementation
padRight =
    { name = H.node1 397 1 9 "String.padRight"
    , arguments =
        [ H.node1 397 10 11 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 397 12 16 (Elm.Syntax.Pattern.VarPattern "char")
        , H.node1 397 17 23 (Elm.Syntax.Pattern.VarPattern "string")
        ]
    , expression =
        H.node1
            398
            3
            55
            (Elm.Syntax.Expression.OperatorApplication
                "++"
                Elm.Syntax.Infix.Right
                (H.node1 398 3 9 (H.val "string"))
                (H.node1
                    398
                    13
                    55
                    (Elm.Syntax.Expression.Application
                        [ H.node1 398 13 19 (H.val "repeat")
                        , H.node1
                            398
                            20
                            39
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    398
                                    21
                                    38
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "-"
                                        Elm.Syntax.Infix.Left
                                        (H.node1 398 21 22 (H.val "n"))
                                        (H.node1
                                            398
                                            25
                                            38
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    398
                                                    25
                                                    31
                                                    (H.val "length")
                                                , H.node1
                                                    398
                                                    32
                                                    38
                                                    (H.val "string")
                                                ]
                                            )
                                        )
                                    )
                                )
                            )
                        , H.node1
                            398
                            40
                            55
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    398
                                    41
                                    54
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 398 41 49 (H.val "fromChar")
                                        , H.node1 398 50 54 (H.val "char")
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                )
            )
    }


trim : Elm.Syntax.Expression.FunctionImplementation
trim =
    { name = H.node1 406 1 5 "String.trim"
    , arguments = []
    , expression =
        H.node1
            407
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "trim"
            )
    }


trimLeft : Elm.Syntax.Expression.FunctionImplementation
trimLeft =
    { name = H.node1 415 1 9 "String.trimLeft"
    , arguments = []
    , expression =
        H.node1
            416
            3
            29
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "trimLeft"
            )
    }


trimRight : Elm.Syntax.Expression.FunctionImplementation
trimRight =
    { name = H.node1 424 1 10 "String.trimRight"
    , arguments = []
    , expression =
        H.node1
            425
            3
            30
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "trimRight"
            )
    }


toInt : Elm.Syntax.Expression.FunctionImplementation
toInt =
    { name = H.node1 446 1 6 "String.toInt"
    , arguments = []
    , expression =
        H.node1
            447
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "toInt"
            )
    }


fromInt : Elm.Syntax.Expression.FunctionImplementation
fromInt =
    { name = H.node1 459 1 8 "String.fromInt"
    , arguments = []
    , expression =
        H.node1
            460
            3
            31
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "fromNumber"
            )
    }


toFloat : Elm.Syntax.Expression.FunctionImplementation
toFloat =
    { name = H.node1 481 1 8 "String.toFloat"
    , arguments = []
    , expression =
        H.node1
            482
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "toFloat"
            )
    }


fromFloat : Elm.Syntax.Expression.FunctionImplementation
fromFloat =
    { name = H.node1 495 1 10 "String.fromFloat"
    , arguments = []
    , expression =
        H.node1
            496
            3
            31
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "fromNumber"
            )
    }


toList : Elm.Syntax.Expression.FunctionImplementation
toList =
    { name = H.node1 509 1 7 "String.toList"
    , arguments = [ H.node1 509 8 14 (Elm.Syntax.Pattern.VarPattern "string") ]
    , expression =
        H.node1
            510
            3
            23
            (Elm.Syntax.Expression.Application
                [ H.node1 510 3 8 (H.val "foldr")
                , H.node1 510 9 13 (Elm.Syntax.Expression.PrefixOperator "::")
                , H.node1 510 14 16 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 510 17 23 (H.val "string")
                ]
            )
    }


fromList : Elm.Syntax.Expression.FunctionImplementation
fromList =
    { name = H.node1 521 1 9 "String.fromList"
    , arguments = []
    , expression =
        H.node1
            522
            3
            29
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "fromList"
            )
    }


fromChar : Elm.Syntax.Expression.FunctionImplementation
fromChar =
    { name = H.node1 534 1 9 "String.fromChar"
    , arguments = [ H.node1 534 10 14 (Elm.Syntax.Pattern.VarPattern "char") ]
    , expression =
        H.node1
            535
            3
            15
            (Elm.Syntax.Expression.Application
                [ H.node1 535 3 7 (H.val "cons")
                , H.node1 535 8 12 (H.val "char")
                , H.node1 535 13 15 (Elm.Syntax.Expression.Literal "")
                ]
            )
    }


cons : Elm.Syntax.Expression.FunctionImplementation
cons =
    { name = H.node1 543 1 5 "String.cons"
    , arguments = []
    , expression =
        H.node1
            544
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "cons"
            )
    }


uncons : Elm.Syntax.Expression.FunctionImplementation
uncons =
    { name = H.node1 554 1 7 "String.uncons"
    , arguments = []
    , expression =
        H.node1
            555
            3
            27
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "uncons"
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = H.node1 567 1 4 "String.map"
    , arguments = []
    , expression =
        H.node1
            568
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "map"
            )
    }


filter : Elm.Syntax.Expression.FunctionImplementation
filter =
    { name = H.node1 576 1 7 "String.filter"
    , arguments = []
    , expression =
        H.node1
            577
            3
            27
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "filter"
            )
    }


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = H.node1 585 1 6 "String.foldl"
    , arguments = []
    , expression =
        H.node1
            586
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "foldl"
            )
    }


foldr : Elm.Syntax.Expression.FunctionImplementation
foldr =
    { name = H.node1 594 1 6 "String.foldr"
    , arguments = []
    , expression =
        H.node1
            595
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "foldr"
            )
    }


any : Elm.Syntax.Expression.FunctionImplementation
any =
    { name = H.node1 605 1 4 "String.any"
    , arguments = []
    , expression =
        H.node1
            606
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "any"
            )
    }


all : Elm.Syntax.Expression.FunctionImplementation
all =
    { name = H.node1 616 1 4 "String.all"
    , arguments = []
    , expression =
        H.node1
            617
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "String" ]
                "all"
            )
    }