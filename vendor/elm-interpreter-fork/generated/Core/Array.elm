module Core.Array exposing (append, appendHelpBuilder, appendHelpTree, bitMask, branchFactor, builderFromArray, builderToArray, compressNodes, empty, emptyBuilder, fetchNewTail, filter, foldl, foldr, fromList, fromListHelp, functions, get, getHelp, hoistTree, indexedMap, initialize, initializeHelp, insertTailInTree, isEmpty, length, map, push, repeat, set, setHelp, shiftStep, slice, sliceLeft, sliceRight, sliceTree, tailIndex, toIndexedList, toList, translateIndex, treeFromBuilder, unsafeReplaceTail)

{-| 
@docs functions, branchFactor, shiftStep, bitMask, empty, isEmpty, length, initialize, initializeHelp, repeat, fromList, fromListHelp, get, getHelp, tailIndex, set, setHelp, push, unsafeReplaceTail, insertTailInTree, toList, toIndexedList, foldr, foldl, filter, map, indexedMap, append, appendHelpTree, appendHelpBuilder, slice, translateIndex, sliceRight, fetchNewTail, sliceTree, hoistTree, sliceLeft, emptyBuilder, builderFromArray, builderToArray, treeFromBuilder, compressNodes
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
        [ ( "branchFactor", branchFactor )
        , ( "shiftStep", shiftStep )
        , ( "bitMask", bitMask )
        , ( "empty", empty )
        , ( "isEmpty", isEmpty )
        , ( "length", length )
        , ( "initialize", initialize )
        , ( "initializeHelp", initializeHelp )
        , ( "repeat", repeat )
        , ( "fromList", fromList )
        , ( "fromListHelp", fromListHelp )
        , ( "get", get )
        , ( "getHelp", getHelp )
        , ( "tailIndex", tailIndex )
        , ( "set", set )
        , ( "setHelp", setHelp )
        , ( "push", push )
        , ( "unsafeReplaceTail", unsafeReplaceTail )
        , ( "insertTailInTree", insertTailInTree )
        , ( "toList", toList )
        , ( "toIndexedList", toIndexedList )
        , ( "foldr", foldr )
        , ( "foldl", foldl )
        , ( "filter", filter )
        , ( "map", map )
        , ( "indexedMap", indexedMap )
        , ( "append", append )
        , ( "appendHelpTree", appendHelpTree )
        , ( "appendHelpBuilder", appendHelpBuilder )
        , ( "slice", slice )
        , ( "translateIndex", translateIndex )
        , ( "sliceRight", sliceRight )
        , ( "fetchNewTail", fetchNewTail )
        , ( "sliceTree", sliceTree )
        , ( "hoistTree", hoistTree )
        , ( "sliceLeft", sliceLeft )
        , ( "emptyBuilder", emptyBuilder )
        , ( "builderFromArray", builderFromArray )
        , ( "builderToArray", builderToArray )
        , ( "treeFromBuilder", treeFromBuilder )
        , ( "compressNodes", compressNodes )
        ]


branchFactor : Elm.Syntax.Expression.FunctionImplementation
branchFactor =
    { name = H.node1 70 1 13 "Array.branchFactor"
    , arguments = []
    , expression = H.node1 71 5 7 (Elm.Syntax.Expression.Integer 32)
    }


shiftStep : Elm.Syntax.Expression.FunctionImplementation
shiftStep =
    { name = H.node1 93 1 10 "Array.shiftStep"
    , arguments = []
    , expression =
        H.node1
            94
            5
            47
            (Elm.Syntax.Expression.Application
                [ H.node1 94 5 12 (H.val "ceiling")
                , H.node1
                    94
                    13
                    47
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            94
                            14
                            46
                            (Elm.Syntax.Expression.Application
                                [ H.node1 94 14 21 (H.val "logBase")
                                , H.node1
                                    94
                                    22
                                    23
                                    (Elm.Syntax.Expression.Integer 2)
                                , H.node1
                                    94
                                    24
                                    46
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            94
                                            25
                                            45
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    94
                                                    25
                                                    32
                                                    (H.val "toFloat")
                                                , H.node1
                                                    94
                                                    33
                                                    45
                                                    (H.val "branchFactor")
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


bitMask : Elm.Syntax.Expression.FunctionImplementation
bitMask =
    { name = H.node1 101 1 8 "Array.bitMask"
    , arguments = []
    , expression =
        H.node1
            102
            5
            55
            (Elm.Syntax.Expression.Application
                [ H.node1
                    102
                    5
                    27
                    (Elm.Syntax.Expression.FunctionOrValue
                        [ "Bitwise" ]
                        "shiftRightZfBy"
                    )
                , H.node1
                    102
                    28
                    44
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            102
                            29
                            43
                            (Elm.Syntax.Expression.OperatorApplication
                                "-"
                                Elm.Syntax.Infix.Left
                                (H.node1
                                    102
                                    29
                                    31
                                    (Elm.Syntax.Expression.Integer 32)
                                )
                                (H.node1 102 34 43 (H.val "shiftStep"))
                            )
                        )
                    )
                , H.node1 102 45 55 (Elm.Syntax.Expression.Hex 0xFFFFFFFF)
                ]
            )
    }


empty : Elm.Syntax.Expression.FunctionImplementation
empty =
    { name = H.node1 141 1 6 "Array.empty"
    , arguments = []
    , expression =
        H.node1
            146
            5
            62
            (Elm.Syntax.Expression.Application
                [ H.node1 146 5 22 (H.val "Array_elm_builtin")
                , H.node1 146 23 24 (Elm.Syntax.Expression.Integer 0)
                , H.node1 146 25 34 (H.val "shiftStep")
                , H.node1
                    146
                    35
                    48
                    (Elm.Syntax.Expression.FunctionOrValue [ "JsArray" ] "empty"
                    )
                , H.node1
                    146
                    49
                    62
                    (Elm.Syntax.Expression.FunctionOrValue [ "JsArray" ] "empty"
                    )
                ]
            )
    }


isEmpty : Elm.Syntax.Expression.FunctionImplementation
isEmpty =
    { name = H.node1 154 1 8 "Array.isEmpty"
    , arguments =
        [ H.node1
            154
            9
            38
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    154
                    10
                    37
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ H.node1
                            154
                            28
                            31
                            (Elm.Syntax.Pattern.VarPattern "len")
                        , H.node1 154 32 33 Elm.Syntax.Pattern.AllPattern
                        , H.node1 154 34 35 Elm.Syntax.Pattern.AllPattern
                        , H.node1 154 36 37 Elm.Syntax.Pattern.AllPattern
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            155
            5
            13
            (Elm.Syntax.Expression.OperatorApplication
                "=="
                Elm.Syntax.Infix.Non
                (H.node1 155 5 8 (H.val "len"))
                (H.node1 155 12 13 (Elm.Syntax.Expression.Integer 0))
            )
    }


length : Elm.Syntax.Expression.FunctionImplementation
length =
    { name = H.node1 163 1 7 "Array.length"
    , arguments =
        [ H.node1
            163
            8
            37
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    163
                    9
                    36
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ H.node1
                            163
                            27
                            30
                            (Elm.Syntax.Pattern.VarPattern "len")
                        , H.node1 163 31 32 Elm.Syntax.Pattern.AllPattern
                        , H.node1 163 33 34 Elm.Syntax.Pattern.AllPattern
                        , H.node1 163 35 36 Elm.Syntax.Pattern.AllPattern
                        ]
                    )
                )
            )
        ]
    , expression = H.node1 164 5 8 (H.val "len")
    }


initialize : Elm.Syntax.Expression.FunctionImplementation
initialize =
    { name = H.node1 175 1 11 "Array.initialize"
    , arguments =
        [ H.node1 175 12 15 (Elm.Syntax.Pattern.VarPattern "len")
        , H.node1 175 16 18 (Elm.Syntax.Pattern.VarPattern "fn")
        ]
    , expression =
        H.node
            176
            5
            189
            59
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    176
                    8
                    16
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Non
                        (H.node1 176 8 11 (H.val "len"))
                        (H.node1 176 15 16 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node1 177 9 14 (H.val "empty"))
                (H.node
                    179
                    9
                    189
                    59
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ H.node
                                180
                                13
                                181
                                45
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            180
                                            13
                                            181
                                            45
                                            { name = H.node1 180 13 20 "tailLen"
                                            , arguments = []
                                            , expression =
                                                H.node1
                                                    181
                                                    17
                                                    45
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            181
                                                            17
                                                            28
                                                            (H.val "remainderBy"
                                                            )
                                                        , H.node1
                                                            181
                                                            29
                                                            41
                                                            (H.val
                                                                "branchFactor"
                                                            )
                                                        , H.node1
                                                            181
                                                            42
                                                            45
                                                            (H.val "len")
                                                        ]
                                                    )
                                            }
                                    }
                                )
                            , H.node
                                183
                                13
                                184
                                62
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            183
                                            13
                                            184
                                            62
                                            { name = H.node1 183 13 17 "tail"
                                            , arguments = []
                                            , expression =
                                                H.node1
                                                    184
                                                    17
                                                    62
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            184
                                                            17
                                                            35
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "JsArray" ]
                                                                "initialize"
                                                            )
                                                        , H.node1
                                                            184
                                                            36
                                                            43
                                                            (H.val "tailLen")
                                                        , H.node1
                                                            184
                                                            44
                                                            59
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    184
                                                                    45
                                                                    58
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "-"
                                                                        Elm.Syntax.Infix.Left
                                                                        (H.node1
                                                                            184
                                                                            45
                                                                            48
                                                                            (H.val
                                                                                "len"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            184
                                                                            51
                                                                            58
                                                                            (H.val
                                                                                "tailLen"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        , H.node1
                                                            184
                                                            60
                                                            62
                                                            (H.val "fn")
                                                        ]
                                                    )
                                            }
                                    }
                                )
                            , H.node
                                186
                                13
                                187
                                45
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            186
                                            13
                                            187
                                            45
                                            { name =
                                                H.node1
                                                    186
                                                    13
                                                    29
                                                    "initialFromIndex"
                                            , arguments = []
                                            , expression =
                                                H.node1
                                                    187
                                                    17
                                                    45
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            187
                                                            17
                                                            30
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "-"
                                                                Elm.Syntax.Infix.Left
                                                                (H.node1
                                                                    187
                                                                    17
                                                                    20
                                                                    (H.val "len"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    187
                                                                    23
                                                                    30
                                                                    (H.val
                                                                        "tailLen"
                                                                    )
                                                                )
                                                            )
                                                        )
                                                        (H.node1
                                                            187
                                                            33
                                                            45
                                                            (H.val
                                                                "branchFactor"
                                                            )
                                                        )
                                                    )
                                            }
                                    }
                                )
                            ]
                        , expression =
                            H.node1
                                189
                                13
                                59
                                (Elm.Syntax.Expression.Application
                                    [ H.node1 189 13 27 (H.val "initializeHelp")
                                    , H.node1 189 28 30 (H.val "fn")
                                    , H.node1
                                        189
                                        31
                                        47
                                        (H.val "initialFromIndex")
                                    , H.node1 189 48 51 (H.val "len")
                                    , H.node1
                                        189
                                        52
                                        54
                                        (Elm.Syntax.Expression.ListExpr [])
                                    , H.node1 189 55 59 (H.val "tail")
                                    ]
                                )
                        }
                    )
                )
            )
    }


initializeHelp : Elm.Syntax.Expression.FunctionImplementation
initializeHelp =
    { name = H.node1 193 1 15 "Array.initializeHelp"
    , arguments =
        [ H.node1 193 16 18 (Elm.Syntax.Pattern.VarPattern "fn")
        , H.node1 193 19 28 (Elm.Syntax.Pattern.VarPattern "fromIndex")
        , H.node1 193 29 32 (Elm.Syntax.Pattern.VarPattern "len")
        , H.node1 193 33 41 (Elm.Syntax.Pattern.VarPattern "nodeList")
        , H.node1 193 42 46 (Elm.Syntax.Pattern.VarPattern "tail")
        ]
    , expression =
        H.node
            194
            5
            210
            21
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    194
                    8
                    21
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Non
                        (H.node1 194 8 17 (H.val "fromIndex"))
                        (H.node1 194 20 21 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node
                    195
                    9
                    199
                    14
                    (Elm.Syntax.Expression.Application
                        [ H.node1 195 9 23 (H.val "builderToArray")
                        , H.node1 195 24 29 (H.val "False")
                        , H.node
                            196
                            13
                            199
                            14
                            (Elm.Syntax.Expression.RecordExpr
                                [ H.node1
                                    196
                                    15
                                    26
                                    ( H.node1 196 15 19 "tail"
                                    , H.node1 196 22 26 (H.val "tail")
                                    )
                                , H.node
                                    197
                                    15
                                    198
                                    13
                                    ( H.node1 197 15 23 "nodeList"
                                    , H.node1 197 26 34 (H.val "nodeList")
                                    )
                                , H.node
                                    198
                                    15
                                    199
                                    13
                                    ( H.node1 198 15 27 "nodeListSize"
                                    , H.node1
                                        198
                                        30
                                        49
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "//"
                                            Elm.Syntax.Infix.Left
                                            (H.node1 198 30 33 (H.val "len"))
                                            (H.node1
                                                198
                                                37
                                                49
                                                (H.val "branchFactor")
                                            )
                                        )
                                    )
                                ]
                            )
                        ]
                    )
                )
                (H.node
                    201
                    9
                    210
                    21
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ H.node
                                202
                                13
                                203
                                69
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            202
                                            13
                                            203
                                            69
                                            { name = H.node1 202 13 17 "leaf"
                                            , arguments = []
                                            , expression =
                                                H.node1
                                                    203
                                                    17
                                                    69
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "<|"
                                                        Elm.Syntax.Infix.Right
                                                        (H.node1
                                                            203
                                                            17
                                                            21
                                                            (H.val "Leaf")
                                                        )
                                                        (H.node1
                                                            203
                                                            25
                                                            69
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    203
                                                                    25
                                                                    43
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "initialize"
                                                                    )
                                                                , H.node1
                                                                    203
                                                                    44
                                                                    56
                                                                    (H.val
                                                                        "branchFactor"
                                                                    )
                                                                , H.node1
                                                                    203
                                                                    57
                                                                    66
                                                                    (H.val
                                                                        "fromIndex"
                                                                    )
                                                                , H.node1
                                                                    203
                                                                    67
                                                                    69
                                                                    (H.val "fn")
                                                                ]
                                                            )
                                                        )
                                                    )
                                            }
                                    }
                                )
                            ]
                        , expression =
                            H.node
                                205
                                13
                                210
                                21
                                (Elm.Syntax.Expression.Application
                                    [ H.node1 205 13 27 (H.val "initializeHelp")
                                    , H.node1 206 17 19 (H.val "fn")
                                    , H.node1
                                        207
                                        17
                                        43
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node1
                                                207
                                                18
                                                42
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "-"
                                                    Elm.Syntax.Infix.Left
                                                    (H.node1
                                                        207
                                                        18
                                                        27
                                                        (H.val "fromIndex")
                                                    )
                                                    (H.node1
                                                        207
                                                        30
                                                        42
                                                        (H.val "branchFactor")
                                                    )
                                                )
                                            )
                                        )
                                    , H.node1 208 17 20 (H.val "len")
                                    , H.node1
                                        209
                                        17
                                        35
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node1
                                                209
                                                18
                                                34
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "::"
                                                    Elm.Syntax.Infix.Right
                                                    (H.node1
                                                        209
                                                        18
                                                        22
                                                        (H.val "leaf")
                                                    )
                                                    (H.node1
                                                        209
                                                        26
                                                        34
                                                        (H.val "nodeList")
                                                    )
                                                )
                                            )
                                        )
                                    , H.node1 210 17 21 (H.val "tail")
                                    ]
                                )
                        }
                    )
                )
            )
    }


repeat : Elm.Syntax.Expression.FunctionImplementation
repeat =
    { name = H.node1 221 1 7 "Array.repeat"
    , arguments =
        [ H.node1 221 8 9 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 221 10 11 (Elm.Syntax.Pattern.VarPattern "e")
        ]
    , expression =
        H.node1
            222
            5
            27
            (Elm.Syntax.Expression.Application
                [ H.node1 222 5 15 (H.val "initialize")
                , H.node1 222 16 17 (H.val "n")
                , H.node1
                    222
                    18
                    27
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            222
                            19
                            26
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        222
                                        20
                                        21
                                        Elm.Syntax.Pattern.AllPattern
                                    ]
                                , expression = H.node1 222 25 26 (H.val "e")
                                }
                            )
                        )
                    )
                ]
            )
    }


fromList : Elm.Syntax.Expression.FunctionImplementation
fromList =
    { name = H.node1 228 1 9 "Array.fromList"
    , arguments = [ H.node1 228 10 14 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node
            229
            5
            234
            35
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 229 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 230 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 231 13 18 (H.val "empty")
                      )
                    , ( H.node1 233 9 10 Elm.Syntax.Pattern.AllPattern
                      , H.node1
                            234
                            13
                            35
                            (Elm.Syntax.Expression.Application
                                [ H.node1 234 13 25 (H.val "fromListHelp")
                                , H.node1 234 26 30 (H.val "list")
                                , H.node1
                                    234
                                    31
                                    33
                                    (Elm.Syntax.Expression.ListExpr [])
                                , H.node1
                                    234
                                    34
                                    35
                                    (Elm.Syntax.Expression.Integer 0)
                                ]
                            )
                      )
                    ]
                }
            )
    }


fromListHelp : Elm.Syntax.Expression.FunctionImplementation
fromListHelp =
    { name = H.node1 238 1 13 "Array.fromListHelp"
    , arguments =
        [ H.node1 238 14 18 (Elm.Syntax.Pattern.VarPattern "list")
        , H.node1 238 19 27 (Elm.Syntax.Pattern.VarPattern "nodeList")
        , H.node1 238 28 40 (Elm.Syntax.Pattern.VarPattern "nodeListSize")
        ]
    , expression =
        H.node
            239
            5
            253
            35
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        240
                        9
                        241
                        57
                        (Elm.Syntax.Expression.LetDestructuring
                            (H.node1
                                240
                                9
                                36
                                (Elm.Syntax.Pattern.TuplePattern
                                    [ H.node1
                                        240
                                        11
                                        18
                                        (Elm.Syntax.Pattern.VarPattern "jsArray"
                                        )
                                    , H.node1
                                        240
                                        20
                                        34
                                        (Elm.Syntax.Pattern.VarPattern
                                            "remainingItems"
                                        )
                                    ]
                                )
                            )
                            (H.node1
                                241
                                13
                                57
                                (Elm.Syntax.Expression.Application
                                    [ H.node1
                                        241
                                        13
                                        39
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "JsArray" ]
                                            "initializeFromList"
                                        )
                                    , H.node1 241 40 52 (H.val "branchFactor")
                                    , H.node1 241 53 57 (H.val "list")
                                    ]
                                )
                            )
                        )
                    ]
                , expression =
                    H.node
                        243
                        9
                        253
                        35
                        (Elm.Syntax.Expression.IfBlock
                            (H.node1
                                243
                                12
                                49
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<"
                                    Elm.Syntax.Infix.Non
                                    (H.node1
                                        243
                                        12
                                        34
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                243
                                                12
                                                26
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "length"
                                                )
                                            , H.node1
                                                243
                                                27
                                                34
                                                (H.val "jsArray")
                                            ]
                                        )
                                    )
                                    (H.node1 243 37 49 (H.val "branchFactor"))
                                )
                            )
                            (H.node
                                244
                                13
                                248
                                18
                                (Elm.Syntax.Expression.Application
                                    [ H.node1 244 13 27 (H.val "builderToArray")
                                    , H.node1 244 28 32 (H.val "True")
                                    , H.node
                                        245
                                        17
                                        248
                                        18
                                        (Elm.Syntax.Expression.RecordExpr
                                            [ H.node1
                                                245
                                                19
                                                33
                                                ( H.node1 245 19 23 "tail"
                                                , H.node1
                                                    245
                                                    26
                                                    33
                                                    (H.val "jsArray")
                                                )
                                            , H.node
                                                246
                                                19
                                                247
                                                17
                                                ( H.node1 246 19 27 "nodeList"
                                                , H.node1
                                                    246
                                                    30
                                                    38
                                                    (H.val "nodeList")
                                                )
                                            , H.node
                                                247
                                                19
                                                248
                                                17
                                                ( H.node1
                                                    247
                                                    19
                                                    31
                                                    "nodeListSize"
                                                , H.node1
                                                    247
                                                    34
                                                    46
                                                    (H.val "nodeListSize")
                                                )
                                            ]
                                        )
                                    ]
                                )
                            )
                            (H.node
                                250
                                13
                                253
                                35
                                (Elm.Syntax.Expression.Application
                                    [ H.node1 250 13 25 (H.val "fromListHelp")
                                    , H.node1 251 17 31 (H.val "remainingItems")
                                    , H.node1
                                        252
                                        17
                                        43
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node1
                                                252
                                                18
                                                42
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "::"
                                                    Elm.Syntax.Infix.Right
                                                    (H.node1
                                                        252
                                                        18
                                                        30
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                252
                                                                18
                                                                22
                                                                (H.val "Leaf")
                                                            , H.node1
                                                                252
                                                                23
                                                                30
                                                                (H.val "jsArray"
                                                                )
                                                            ]
                                                        )
                                                    )
                                                    (H.node1
                                                        252
                                                        34
                                                        42
                                                        (H.val "nodeList")
                                                    )
                                                )
                                            )
                                        )
                                    , H.node1
                                        253
                                        17
                                        35
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node1
                                                253
                                                18
                                                34
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "+"
                                                    Elm.Syntax.Infix.Left
                                                    (H.node1
                                                        253
                                                        18
                                                        30
                                                        (H.val "nodeListSize")
                                                    )
                                                    (H.node1
                                                        253
                                                        33
                                                        34
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
                }
            )
    }


get : Elm.Syntax.Expression.FunctionImplementation
get =
    { name = H.node1 265 1 4 "Array.get"
    , arguments =
        [ H.node1 265 5 10 (Elm.Syntax.Pattern.VarPattern "index")
        , H.node1
            265
            11
            55
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    265
                    12
                    54
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ H.node1
                            265
                            30
                            33
                            (Elm.Syntax.Pattern.VarPattern "len")
                        , H.node1
                            265
                            34
                            44
                            (Elm.Syntax.Pattern.VarPattern "startShift")
                        , H.node1
                            265
                            45
                            49
                            (Elm.Syntax.Pattern.VarPattern "tree")
                        , H.node1
                            265
                            50
                            54
                            (Elm.Syntax.Pattern.VarPattern "tail")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node
            266
            5
            271
            46
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    266
                    8
                    33
                    (Elm.Syntax.Expression.OperatorApplication
                        "||"
                        Elm.Syntax.Infix.Right
                        (H.node1
                            266
                            8
                            17
                            (Elm.Syntax.Expression.OperatorApplication
                                "<"
                                Elm.Syntax.Infix.Non
                                (H.node1 266 8 13 (H.val "index"))
                                (H.node1
                                    266
                                    16
                                    17
                                    (Elm.Syntax.Expression.Integer 0)
                                )
                            )
                        )
                        (H.node1
                            266
                            21
                            33
                            (Elm.Syntax.Expression.OperatorApplication
                                ">="
                                Elm.Syntax.Infix.Non
                                (H.node1 266 21 26 (H.val "index"))
                                (H.node1 266 30 33 (H.val "len"))
                            )
                        )
                    )
                )
                (H.node1 267 9 16 (H.val "Nothing"))
                (H.node
                    268
                    10
                    271
                    46
                    (Elm.Syntax.Expression.IfBlock
                        (H.node1
                            268
                            13
                            35
                            (Elm.Syntax.Expression.OperatorApplication
                                ">="
                                Elm.Syntax.Infix.Non
                                (H.node1 268 13 18 (H.val "index"))
                                (H.node1
                                    268
                                    22
                                    35
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 268 22 31 (H.val "tailIndex")
                                        , H.node1 268 32 35 (H.val "len")
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node1
                            269
                            9
                            67
                            (Elm.Syntax.Expression.OperatorApplication
                                "<|"
                                Elm.Syntax.Infix.Right
                                (H.node1 269 9 13 (H.val "Just"))
                                (H.node1
                                    269
                                    17
                                    67
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            269
                                            17
                                            34
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "unsafeGet"
                                            )
                                        , H.node1
                                            269
                                            35
                                            62
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    269
                                                    36
                                                    61
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            269
                                                            36
                                                            47
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , H.node1
                                                            269
                                                            48
                                                            55
                                                            (H.val "bitMask")
                                                        , H.node1
                                                            269
                                                            56
                                                            61
                                                            (H.val "index")
                                                        ]
                                                    )
                                                )
                                            )
                                        , H.node1 269 63 67 (H.val "tail")
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node1
                            271
                            9
                            46
                            (Elm.Syntax.Expression.OperatorApplication
                                "<|"
                                Elm.Syntax.Infix.Right
                                (H.node1 271 9 13 (H.val "Just"))
                                (H.node1
                                    271
                                    17
                                    46
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 271 17 24 (H.val "getHelp")
                                        , H.node1 271 25 35 (H.val "startShift")
                                        , H.node1 271 36 41 (H.val "index")
                                        , H.node1 271 42 46 (H.val "tree")
                                        ]
                                    )
                                )
                            )
                        )
                    )
                )
            )
    }


getHelp : Elm.Syntax.Expression.FunctionImplementation
getHelp =
    { name = H.node1 275 1 8 "Array.getHelp"
    , arguments =
        [ H.node1 275 9 14 (Elm.Syntax.Pattern.VarPattern "shift")
        , H.node1 275 15 20 (Elm.Syntax.Pattern.VarPattern "index")
        , H.node1 275 21 25 (Elm.Syntax.Pattern.VarPattern "tree")
        ]
    , expression =
        H.node
            276
            5
            285
            69
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        277
                        9
                        278
                        70
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    277
                                    9
                                    278
                                    70
                                    { name = H.node1 277 9 12 "pos"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            278
                                            13
                                            70
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "<|"
                                                Elm.Syntax.Infix.Right
                                                (H.node1
                                                    278
                                                    13
                                                    32
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            278
                                                            13
                                                            24
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , H.node1
                                                            278
                                                            25
                                                            32
                                                            (H.val "bitMask")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    278
                                                    36
                                                    70
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            278
                                                            36
                                                            58
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "shiftRightZfBy"
                                                            )
                                                        , H.node1
                                                            278
                                                            59
                                                            64
                                                            (H.val "shift")
                                                        , H.node1
                                                            278
                                                            65
                                                            70
                                                            (H.val "index")
                                                        ]
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        280
                        9
                        285
                        69
                        (Elm.Syntax.Expression.CaseExpression
                            { expression =
                                H.node1
                                    280
                                    14
                                    40
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            280
                                            14
                                            31
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "unsafeGet"
                                            )
                                        , H.node1 280 32 35 (H.val "pos")
                                        , H.node1 280 36 40 (H.val "tree")
                                        ]
                                    )
                            , cases =
                                [ ( H.node1
                                        281
                                        13
                                        28
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = []
                                            , name = "SubTree"
                                            }
                                            [ H.node1
                                                281
                                                21
                                                28
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "subTree"
                                                )
                                            ]
                                        )
                                  , H.node1
                                        282
                                        17
                                        58
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                282
                                                17
                                                24
                                                (H.val "getHelp")
                                            , H.node1
                                                282
                                                25
                                                44
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        282
                                                        26
                                                        43
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "-"
                                                            Elm.Syntax.Infix.Left
                                                            (H.node1
                                                                282
                                                                26
                                                                31
                                                                (H.val "shift")
                                                            )
                                                            (H.node1
                                                                282
                                                                34
                                                                43
                                                                (H.val
                                                                    "shiftStep"
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            , H.node1 282 45 50 (H.val "index")
                                            , H.node1
                                                282
                                                51
                                                58
                                                (H.val "subTree")
                                            ]
                                        )
                                  )
                                , ( H.node1
                                        284
                                        13
                                        24
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = [], name = "Leaf" }
                                            [ H.node1
                                                284
                                                18
                                                24
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "values"
                                                )
                                            ]
                                        )
                                  , H.node1
                                        285
                                        17
                                        69
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                285
                                                17
                                                34
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "unsafeGet"
                                                )
                                            , H.node1
                                                285
                                                35
                                                62
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        285
                                                        36
                                                        61
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                285
                                                                36
                                                                47
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    [ "Bitwise"
                                                                    ]
                                                                    "and"
                                                                )
                                                            , H.node1
                                                                285
                                                                48
                                                                55
                                                                (H.val "bitMask"
                                                                )
                                                            , H.node1
                                                                285
                                                                56
                                                                61
                                                                (H.val "index")
                                                            ]
                                                        )
                                                    )
                                                )
                                            , H.node1 285 63 69 (H.val "values")
                                            ]
                                        )
                                  )
                                ]
                            }
                        )
                }
            )
    }


tailIndex : Elm.Syntax.Expression.FunctionImplementation
tailIndex =
    { name = H.node1 292 1 10 "Array.tailIndex"
    , arguments = [ H.node1 292 11 14 (Elm.Syntax.Pattern.VarPattern "len") ]
    , expression =
        H.node
            293
            5
            295
            33
            (Elm.Syntax.Expression.OperatorApplication
                "|>"
                Elm.Syntax.Infix.Left
                (H.node
                    293
                    5
                    294
                    36
                    (Elm.Syntax.Expression.OperatorApplication
                        "|>"
                        Elm.Syntax.Infix.Left
                        (H.node1 293 5 8 (H.val "len"))
                        (H.node1
                            294
                            12
                            36
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    294
                                    12
                                    34
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Bitwise" ]
                                        "shiftRightZfBy"
                                    )
                                , H.node1
                                    294
                                    35
                                    36
                                    (Elm.Syntax.Expression.Integer 5)
                                ]
                            )
                        )
                    )
                )
                (H.node1
                    295
                    12
                    33
                    (Elm.Syntax.Expression.Application
                        [ H.node1
                            295
                            12
                            31
                            (Elm.Syntax.Expression.FunctionOrValue
                                [ "Bitwise" ]
                                "shiftLeftBy"
                            )
                        , H.node1 295 32 33 (Elm.Syntax.Expression.Integer 5)
                        ]
                    )
                )
            )
    }


set : Elm.Syntax.Expression.FunctionImplementation
set =
    { name = H.node1 304 1 4 "Array.set"
    , arguments =
        [ H.node1 304 5 10 (Elm.Syntax.Pattern.VarPattern "index")
        , H.node1 304 11 16 (Elm.Syntax.Pattern.VarPattern "value")
        , H.node1
            304
            17
            72
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    304
                    18
                    71
                    (Elm.Syntax.Pattern.AsPattern
                        (H.node1
                            304
                            18
                            62
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (H.node1
                                    304
                                    19
                                    61
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ H.node1
                                            304
                                            37
                                            40
                                            (Elm.Syntax.Pattern.VarPattern "len"
                                            )
                                        , H.node1
                                            304
                                            41
                                            51
                                            (Elm.Syntax.Pattern.VarPattern
                                                "startShift"
                                            )
                                        , H.node1
                                            304
                                            52
                                            56
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tree"
                                            )
                                        , H.node1
                                            304
                                            57
                                            61
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node1 304 66 71 "array")
                    )
                )
            )
        ]
    , expression =
        H.node
            305
            5
            315
            17
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    305
                    8
                    33
                    (Elm.Syntax.Expression.OperatorApplication
                        "||"
                        Elm.Syntax.Infix.Right
                        (H.node1
                            305
                            8
                            17
                            (Elm.Syntax.Expression.OperatorApplication
                                "<"
                                Elm.Syntax.Infix.Non
                                (H.node1 305 8 13 (H.val "index"))
                                (H.node1
                                    305
                                    16
                                    17
                                    (Elm.Syntax.Expression.Integer 0)
                                )
                            )
                        )
                        (H.node1
                            305
                            21
                            33
                            (Elm.Syntax.Expression.OperatorApplication
                                ">="
                                Elm.Syntax.Infix.Non
                                (H.node1 305 21 26 (H.val "index"))
                                (H.node1 305 30 33 (H.val "len"))
                            )
                        )
                    )
                )
                (H.node1 306 9 14 (H.val "array"))
                (H.node
                    307
                    10
                    315
                    17
                    (Elm.Syntax.Expression.IfBlock
                        (H.node1
                            307
                            13
                            35
                            (Elm.Syntax.Expression.OperatorApplication
                                ">="
                                Elm.Syntax.Infix.Non
                                (H.node1 307 13 18 (H.val "index"))
                                (H.node1
                                    307
                                    22
                                    35
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 307 22 31 (H.val "tailIndex")
                                        , H.node1 307 32 35 (H.val "len")
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node
                            308
                            9
                            309
                            69
                            (Elm.Syntax.Expression.OperatorApplication
                                "<|"
                                Elm.Syntax.Infix.Right
                                (H.node1
                                    308
                                    9
                                    46
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            308
                                            9
                                            26
                                            (H.val "Array_elm_builtin")
                                        , H.node1 308 27 30 (H.val "len")
                                        , H.node1 308 31 41 (H.val "startShift")
                                        , H.node1 308 42 46 (H.val "tree")
                                        ]
                                    )
                                )
                                (H.node1
                                    309
                                    13
                                    69
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            309
                                            13
                                            30
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "unsafeSet"
                                            )
                                        , H.node1
                                            309
                                            31
                                            58
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    309
                                                    32
                                                    57
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            309
                                                            32
                                                            43
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , H.node1
                                                            309
                                                            44
                                                            51
                                                            (H.val "bitMask")
                                                        , H.node1
                                                            309
                                                            52
                                                            57
                                                            (H.val "index")
                                                        ]
                                                    )
                                                )
                                            )
                                        , H.node1 309 59 64 (H.val "value")
                                        , H.node1 309 65 69 (H.val "tail")
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node
                            311
                            9
                            315
                            17
                            (Elm.Syntax.Expression.Application
                                [ H.node1 311 9 26 (H.val "Array_elm_builtin")
                                , H.node1 312 13 16 (H.val "len")
                                , H.node1 313 13 23 (H.val "startShift")
                                , H.node1
                                    314
                                    13
                                    50
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            314
                                            14
                                            49
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    314
                                                    14
                                                    21
                                                    (H.val "setHelp")
                                                , H.node1
                                                    314
                                                    22
                                                    32
                                                    (H.val "startShift")
                                                , H.node1
                                                    314
                                                    33
                                                    38
                                                    (H.val "index")
                                                , H.node1
                                                    314
                                                    39
                                                    44
                                                    (H.val "value")
                                                , H.node1
                                                    314
                                                    45
                                                    49
                                                    (H.val "tree")
                                                ]
                                            )
                                        )
                                    )
                                , H.node1 315 13 17 (H.val "tail")
                                ]
                            )
                        )
                    )
                )
            )
    }


setHelp : Elm.Syntax.Expression.FunctionImplementation
setHelp =
    { name = H.node1 319 1 8 "Array.setHelp"
    , arguments =
        [ H.node1 319 9 14 (Elm.Syntax.Pattern.VarPattern "shift")
        , H.node1 319 15 20 (Elm.Syntax.Pattern.VarPattern "index")
        , H.node1 319 21 26 (Elm.Syntax.Pattern.VarPattern "value")
        , H.node1 319 27 31 (Elm.Syntax.Pattern.VarPattern "tree")
        ]
    , expression =
        H.node
            320
            5
            337
            62
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        321
                        9
                        322
                        70
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    321
                                    9
                                    322
                                    70
                                    { name = H.node1 321 9 12 "pos"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            322
                                            13
                                            70
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "<|"
                                                Elm.Syntax.Infix.Right
                                                (H.node1
                                                    322
                                                    13
                                                    32
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            322
                                                            13
                                                            24
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , H.node1
                                                            322
                                                            25
                                                            32
                                                            (H.val "bitMask")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    322
                                                    36
                                                    70
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            322
                                                            36
                                                            58
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "shiftRightZfBy"
                                                            )
                                                        , H.node1
                                                            322
                                                            59
                                                            64
                                                            (H.val "shift")
                                                        , H.node1
                                                            322
                                                            65
                                                            70
                                                            (H.val "index")
                                                        ]
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        324
                        9
                        337
                        62
                        (Elm.Syntax.Expression.CaseExpression
                            { expression =
                                H.node1
                                    324
                                    14
                                    40
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            324
                                            14
                                            31
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "unsafeGet"
                                            )
                                        , H.node1 324 32 35 (H.val "pos")
                                        , H.node1 324 36 40 (H.val "tree")
                                        ]
                                    )
                            , cases =
                                [ ( H.node1
                                        325
                                        13
                                        28
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = []
                                            , name = "SubTree"
                                            }
                                            [ H.node1
                                                325
                                                21
                                                28
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "subTree"
                                                )
                                            ]
                                        )
                                  , H.node
                                        326
                                        17
                                        330
                                        64
                                        (Elm.Syntax.Expression.LetExpression
                                            { declarations =
                                                [ H.node
                                                    327
                                                    21
                                                    328
                                                    72
                                                    (Elm.Syntax.Expression.LetFunction
                                                        { documentation =
                                                            Nothing
                                                        , signature = Nothing
                                                        , declaration =
                                                            H.node
                                                                327
                                                                21
                                                                328
                                                                72
                                                                { name =
                                                                    H.node1
                                                                        327
                                                                        21
                                                                        27
                                                                        "newSub"
                                                                , arguments = []
                                                                , expression =
                                                                    H.node1
                                                                        328
                                                                        25
                                                                        72
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                328
                                                                                25
                                                                                32
                                                                                (H.val
                                                                                    "setHelp"
                                                                                )
                                                                            , H.node1
                                                                                328
                                                                                33
                                                                                52
                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                    (H.node1
                                                                                        328
                                                                                        34
                                                                                        51
                                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                                            "-"
                                                                                            Elm.Syntax.Infix.Left
                                                                                            (H.node1
                                                                                                328
                                                                                                34
                                                                                                39
                                                                                                (H.val
                                                                                                    "shift"
                                                                                                )
                                                                                            )
                                                                                            (H.node1
                                                                                                328
                                                                                                42
                                                                                                51
                                                                                                (H.val
                                                                                                    "shiftStep"
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                            , H.node1
                                                                                328
                                                                                53
                                                                                58
                                                                                (H.val
                                                                                    "index"
                                                                                )
                                                                            , H.node1
                                                                                328
                                                                                59
                                                                                64
                                                                                (H.val
                                                                                    "value"
                                                                                )
                                                                            , H.node1
                                                                                328
                                                                                65
                                                                                72
                                                                                (H.val
                                                                                    "subTree"
                                                                                )
                                                                            ]
                                                                        )
                                                                }
                                                        }
                                                    )
                                                ]
                                            , expression =
                                                H.node1
                                                    330
                                                    21
                                                    64
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            330
                                                            21
                                                            38
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "JsArray" ]
                                                                "unsafeSet"
                                                            )
                                                        , H.node1
                                                            330
                                                            39
                                                            42
                                                            (H.val "pos")
                                                        , H.node1
                                                            330
                                                            43
                                                            59
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    330
                                                                    44
                                                                    58
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            330
                                                                            44
                                                                            51
                                                                            (H.val
                                                                                "SubTree"
                                                                            )
                                                                        , H.node1
                                                                            330
                                                                            52
                                                                            58
                                                                            (H.val
                                                                                "newSub"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        , H.node1
                                                            330
                                                            60
                                                            64
                                                            (H.val "tree")
                                                        ]
                                                    )
                                            }
                                        )
                                  )
                                , ( H.node1
                                        332
                                        13
                                        24
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = [], name = "Leaf" }
                                            [ H.node1
                                                332
                                                18
                                                24
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "values"
                                                )
                                            ]
                                        )
                                  , H.node
                                        333
                                        17
                                        337
                                        62
                                        (Elm.Syntax.Expression.LetExpression
                                            { declarations =
                                                [ H.node
                                                    334
                                                    21
                                                    335
                                                    83
                                                    (Elm.Syntax.Expression.LetFunction
                                                        { documentation =
                                                            Nothing
                                                        , signature = Nothing
                                                        , declaration =
                                                            H.node
                                                                334
                                                                21
                                                                335
                                                                83
                                                                { name =
                                                                    H.node1
                                                                        334
                                                                        21
                                                                        28
                                                                        "newLeaf"
                                                                , arguments = []
                                                                , expression =
                                                                    H.node1
                                                                        335
                                                                        25
                                                                        83
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                335
                                                                                25
                                                                                42
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    [ "JsArray"
                                                                                    ]
                                                                                    "unsafeSet"
                                                                                )
                                                                            , H.node1
                                                                                335
                                                                                43
                                                                                70
                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                    (H.node1
                                                                                        335
                                                                                        44
                                                                                        69
                                                                                        (Elm.Syntax.Expression.Application
                                                                                            [ H.node1
                                                                                                335
                                                                                                44
                                                                                                55
                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                    [ "Bitwise"
                                                                                                    ]
                                                                                                    "and"
                                                                                                )
                                                                                            , H.node1
                                                                                                335
                                                                                                56
                                                                                                63
                                                                                                (H.val
                                                                                                    "bitMask"
                                                                                                )
                                                                                            , H.node1
                                                                                                335
                                                                                                64
                                                                                                69
                                                                                                (H.val
                                                                                                    "index"
                                                                                                )
                                                                                            ]
                                                                                        )
                                                                                    )
                                                                                )
                                                                            , H.node1
                                                                                335
                                                                                71
                                                                                76
                                                                                (H.val
                                                                                    "value"
                                                                                )
                                                                            , H.node1
                                                                                335
                                                                                77
                                                                                83
                                                                                (H.val
                                                                                    "values"
                                                                                )
                                                                            ]
                                                                        )
                                                                }
                                                        }
                                                    )
                                                ]
                                            , expression =
                                                H.node1
                                                    337
                                                    21
                                                    62
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            337
                                                            21
                                                            38
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "JsArray" ]
                                                                "unsafeSet"
                                                            )
                                                        , H.node1
                                                            337
                                                            39
                                                            42
                                                            (H.val "pos")
                                                        , H.node1
                                                            337
                                                            43
                                                            57
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    337
                                                                    44
                                                                    56
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            337
                                                                            44
                                                                            48
                                                                            (H.val
                                                                                "Leaf"
                                                                            )
                                                                        , H.node1
                                                                            337
                                                                            49
                                                                            56
                                                                            (H.val
                                                                                "newLeaf"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        , H.node1
                                                            337
                                                            58
                                                            62
                                                            (H.val "tree")
                                                        ]
                                                    )
                                            }
                                        )
                                  )
                                ]
                            }
                        )
                }
            )
    }


push : Elm.Syntax.Expression.FunctionImplementation
push =
    { name = H.node1 345 1 5 "Array.push"
    , arguments =
        [ H.node1 345 6 7 (Elm.Syntax.Pattern.VarPattern "a")
        , H.node1
            345
            8
            49
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    345
                    9
                    48
                    (Elm.Syntax.Pattern.AsPattern
                        (H.node1
                            345
                            9
                            39
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (H.node1
                                    345
                                    10
                                    38
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ H.node1
                                            345
                                            28
                                            29
                                            Elm.Syntax.Pattern.AllPattern
                                        , H.node1
                                            345
                                            30
                                            31
                                            Elm.Syntax.Pattern.AllPattern
                                        , H.node1
                                            345
                                            32
                                            33
                                            Elm.Syntax.Pattern.AllPattern
                                        , H.node1
                                            345
                                            34
                                            38
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node1 345 43 48 "array")
                    )
                )
            )
        ]
    , expression =
        H.node1
            346
            5
            50
            (Elm.Syntax.Expression.Application
                [ H.node1 346 5 22 (H.val "unsafeReplaceTail")
                , H.node1
                    346
                    23
                    44
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            346
                            24
                            43
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    346
                                    24
                                    36
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "JsArray" ]
                                        "push"
                                    )
                                , H.node1 346 37 38 (H.val "a")
                                , H.node1 346 39 43 (H.val "tail")
                                ]
                            )
                        )
                    )
                , H.node1 346 45 50 (H.val "array")
                ]
            )
    }


unsafeReplaceTail : Elm.Syntax.Expression.FunctionImplementation
unsafeReplaceTail =
    { name = H.node1 357 1 18 "Array.unsafeReplaceTail"
    , arguments =
        [ H.node1 357 19 26 (Elm.Syntax.Pattern.VarPattern "newTail")
        , H.node1
            357
            27
            71
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    357
                    28
                    70
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ H.node1
                            357
                            46
                            49
                            (Elm.Syntax.Pattern.VarPattern "len")
                        , H.node1
                            357
                            50
                            60
                            (Elm.Syntax.Pattern.VarPattern "startShift")
                        , H.node1
                            357
                            61
                            65
                            (Elm.Syntax.Pattern.VarPattern "tree")
                        , H.node1
                            357
                            66
                            70
                            (Elm.Syntax.Pattern.VarPattern "tail")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node
            358
            5
            398
            24
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        359
                        9
                        360
                        32
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    359
                                    9
                                    360
                                    32
                                    { name = H.node1 359 9 24 "originalTailLen"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            360
                                            13
                                            32
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    360
                                                    13
                                                    27
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "length"
                                                    )
                                                , H.node1
                                                    360
                                                    28
                                                    32
                                                    (H.val "tail")
                                                ]
                                            )
                                    }
                            }
                        )
                    , H.node
                        362
                        9
                        363
                        35
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    362
                                    9
                                    363
                                    35
                                    { name = H.node1 362 9 19 "newTailLen"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            363
                                            13
                                            35
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    363
                                                    13
                                                    27
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "length"
                                                    )
                                                , H.node1
                                                    363
                                                    28
                                                    35
                                                    (H.val "newTail")
                                                ]
                                            )
                                    }
                            }
                        )
                    , H.node
                        365
                        9
                        366
                        49
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    365
                                    9
                                    366
                                    49
                                    { name = H.node1 365 9 20 "newArrayLen"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            366
                                            13
                                            49
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "+"
                                                Elm.Syntax.Infix.Left
                                                (H.node1 366 13 16 (H.val "len")
                                                )
                                                (H.node1
                                                    366
                                                    19
                                                    49
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            366
                                                            20
                                                            48
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "-"
                                                                Elm.Syntax.Infix.Left
                                                                (H.node1
                                                                    366
                                                                    20
                                                                    30
                                                                    (H.val
                                                                        "newTailLen"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    366
                                                                    33
                                                                    48
                                                                    (H.val
                                                                        "originalTailLen"
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        368
                        9
                        398
                        24
                        (Elm.Syntax.Expression.IfBlock
                            (H.node1
                                368
                                12
                                38
                                (Elm.Syntax.Expression.OperatorApplication
                                    "=="
                                    Elm.Syntax.Infix.Non
                                    (H.node1 368 12 22 (H.val "newTailLen"))
                                    (H.node1 368 26 38 (H.val "branchFactor"))
                                )
                            )
                            (H.node
                                369
                                13
                                392
                                38
                                (Elm.Syntax.Expression.LetExpression
                                    { declarations =
                                        [ H.node
                                            370
                                            17
                                            371
                                            100
                                            (Elm.Syntax.Expression.LetFunction
                                                { documentation = Nothing
                                                , signature = Nothing
                                                , declaration =
                                                    H.node
                                                        370
                                                        17
                                                        371
                                                        100
                                                        { name =
                                                            H.node1
                                                                370
                                                                17
                                                                25
                                                                "overflow"
                                                        , arguments = []
                                                        , expression =
                                                            H.node1
                                                                371
                                                                21
                                                                100
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    ">"
                                                                    Elm.Syntax.Infix.Non
                                                                    (H.node1
                                                                        371
                                                                        21
                                                                        65
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                371
                                                                                21
                                                                                43
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    [ "Bitwise"
                                                                                    ]
                                                                                    "shiftRightZfBy"
                                                                                )
                                                                            , H.node1
                                                                                371
                                                                                44
                                                                                53
                                                                                (H.val
                                                                                    "shiftStep"
                                                                                )
                                                                            , H.node1
                                                                                371
                                                                                54
                                                                                65
                                                                                (H.val
                                                                                    "newArrayLen"
                                                                                )
                                                                            ]
                                                                        )
                                                                    )
                                                                    (H.node1
                                                                        371
                                                                        68
                                                                        100
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                371
                                                                                68
                                                                                87
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    [ "Bitwise"
                                                                                    ]
                                                                                    "shiftLeftBy"
                                                                                )
                                                                            , H.node1
                                                                                371
                                                                                88
                                                                                98
                                                                                (H.val
                                                                                    "startShift"
                                                                                )
                                                                            , H.node1
                                                                                371
                                                                                99
                                                                                100
                                                                                (Elm.Syntax.Expression.Integer
                                                                                    1
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
                                        H.node
                                            373
                                            17
                                            392
                                            38
                                            (Elm.Syntax.Expression.IfBlock
                                                (H.node1
                                                    373
                                                    20
                                                    28
                                                    (H.val "overflow")
                                                )
                                                (H.node
                                                    374
                                                    21
                                                    386
                                                    42
                                                    (Elm.Syntax.Expression.LetExpression
                                                        { declarations =
                                                            [ H.node
                                                                375
                                                                25
                                                                376
                                                                51
                                                                (Elm.Syntax.Expression.LetFunction
                                                                    { documentation =
                                                                        Nothing
                                                                    , signature =
                                                                        Nothing
                                                                    , declaration =
                                                                        H.node
                                                                            375
                                                                            25
                                                                            376
                                                                            51
                                                                            { name =
                                                                                H.node1
                                                                                    375
                                                                                    25
                                                                                    33
                                                                                    "newShift"
                                                                            , arguments =
                                                                                []
                                                                            , expression =
                                                                                H.node1
                                                                                    376
                                                                                    29
                                                                                    51
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "+"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (H.node1
                                                                                            376
                                                                                            29
                                                                                            39
                                                                                            (H.val
                                                                                                "startShift"
                                                                                            )
                                                                                        )
                                                                                        (H.node1
                                                                                            376
                                                                                            42
                                                                                            51
                                                                                            (H.val
                                                                                                "shiftStep"
                                                                                            )
                                                                                        )
                                                                                    )
                                                                            }
                                                                    }
                                                                )
                                                            , H.node
                                                                378
                                                                25
                                                                380
                                                                73
                                                                (Elm.Syntax.Expression.LetFunction
                                                                    { documentation =
                                                                        Nothing
                                                                    , signature =
                                                                        Nothing
                                                                    , declaration =
                                                                        H.node
                                                                            378
                                                                            25
                                                                            380
                                                                            73
                                                                            { name =
                                                                                H.node1
                                                                                    378
                                                                                    25
                                                                                    32
                                                                                    "newTree"
                                                                            , arguments =
                                                                                []
                                                                            , expression =
                                                                                H.node
                                                                                    379
                                                                                    29
                                                                                    380
                                                                                    73
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "|>"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (H.node1
                                                                                            379
                                                                                            29
                                                                                            61
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    379
                                                                                                    29
                                                                                                    46
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        [ "JsArray"
                                                                                                        ]
                                                                                                        "singleton"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    379
                                                                                                    47
                                                                                                    61
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (H.node1
                                                                                                            379
                                                                                                            48
                                                                                                            60
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ H.node1
                                                                                                                    379
                                                                                                                    48
                                                                                                                    55
                                                                                                                    (H.val
                                                                                                                        "SubTree"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    379
                                                                                                                    56
                                                                                                                    60
                                                                                                                    (H.val
                                                                                                                        "tree"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                        )
                                                                                        (H.node1
                                                                                            380
                                                                                            36
                                                                                            73
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    380
                                                                                                    36
                                                                                                    52
                                                                                                    (H.val
                                                                                                        "insertTailInTree"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    380
                                                                                                    53
                                                                                                    61
                                                                                                    (H.val
                                                                                                        "newShift"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    380
                                                                                                    62
                                                                                                    65
                                                                                                    (H.val
                                                                                                        "len"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    380
                                                                                                    66
                                                                                                    73
                                                                                                    (H.val
                                                                                                        "newTail"
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
                                                            H.node
                                                                382
                                                                25
                                                                386
                                                                42
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        382
                                                                        25
                                                                        42
                                                                        (H.val
                                                                            "Array_elm_builtin"
                                                                        )
                                                                    , H.node1
                                                                        383
                                                                        29
                                                                        40
                                                                        (H.val
                                                                            "newArrayLen"
                                                                        )
                                                                    , H.node1
                                                                        384
                                                                        29
                                                                        37
                                                                        (H.val
                                                                            "newShift"
                                                                        )
                                                                    , H.node1
                                                                        385
                                                                        29
                                                                        36
                                                                        (H.val
                                                                            "newTree"
                                                                        )
                                                                    , H.node1
                                                                        386
                                                                        29
                                                                        42
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            [ "JsArray"
                                                                            ]
                                                                            "empty"
                                                                        )
                                                                    ]
                                                                )
                                                        }
                                                    )
                                                )
                                                (H.node
                                                    388
                                                    21
                                                    392
                                                    38
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            388
                                                            21
                                                            38
                                                            (H.val
                                                                "Array_elm_builtin"
                                                            )
                                                        , H.node1
                                                            389
                                                            25
                                                            36
                                                            (H.val "newArrayLen"
                                                            )
                                                        , H.node1
                                                            390
                                                            25
                                                            35
                                                            (H.val "startShift")
                                                        , H.node1
                                                            391
                                                            25
                                                            71
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    391
                                                                    26
                                                                    70
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            391
                                                                            26
                                                                            42
                                                                            (H.val
                                                                                "insertTailInTree"
                                                                            )
                                                                        , H.node1
                                                                            391
                                                                            43
                                                                            53
                                                                            (H.val
                                                                                "startShift"
                                                                            )
                                                                        , H.node1
                                                                            391
                                                                            54
                                                                            57
                                                                            (H.val
                                                                                "len"
                                                                            )
                                                                        , H.node1
                                                                            391
                                                                            58
                                                                            65
                                                                            (H.val
                                                                                "newTail"
                                                                            )
                                                                        , H.node1
                                                                            391
                                                                            66
                                                                            70
                                                                            (H.val
                                                                                "tree"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        , H.node1
                                                            392
                                                            25
                                                            38
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "JsArray" ]
                                                                "empty"
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                    }
                                )
                            )
                            (H.node
                                394
                                13
                                398
                                24
                                (Elm.Syntax.Expression.Application
                                    [ H.node1
                                        394
                                        13
                                        30
                                        (H.val "Array_elm_builtin")
                                    , H.node1 395 17 28 (H.val "newArrayLen")
                                    , H.node1 396 17 27 (H.val "startShift")
                                    , H.node1 397 17 21 (H.val "tree")
                                    , H.node1 398 17 24 (H.val "newTail")
                                    ]
                                )
                            )
                        )
                }
            )
    }


insertTailInTree : Elm.Syntax.Expression.FunctionImplementation
insertTailInTree =
    { name = H.node1 402 1 17 "Array.insertTailInTree"
    , arguments =
        [ H.node1 402 18 23 (Elm.Syntax.Pattern.VarPattern "shift")
        , H.node1 402 24 29 (Elm.Syntax.Pattern.VarPattern "index")
        , H.node1 402 30 34 (Elm.Syntax.Pattern.VarPattern "tail")
        , H.node1 402 35 39 (Elm.Syntax.Pattern.VarPattern "tree")
        ]
    , expression =
        H.node
            403
            5
            440
            62
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        404
                        9
                        405
                        70
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    404
                                    9
                                    405
                                    70
                                    { name = H.node1 404 9 12 "pos"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            405
                                            13
                                            70
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "<|"
                                                Elm.Syntax.Infix.Right
                                                (H.node1
                                                    405
                                                    13
                                                    32
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            405
                                                            13
                                                            24
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , H.node1
                                                            405
                                                            25
                                                            32
                                                            (H.val "bitMask")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    405
                                                    36
                                                    70
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            405
                                                            36
                                                            58
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "shiftRightZfBy"
                                                            )
                                                        , H.node1
                                                            405
                                                            59
                                                            64
                                                            (H.val "shift")
                                                        , H.node1
                                                            405
                                                            65
                                                            70
                                                            (H.val "index")
                                                        ]
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        407
                        9
                        440
                        62
                        (Elm.Syntax.Expression.IfBlock
                            (H.node1
                                407
                                12
                                38
                                (Elm.Syntax.Expression.OperatorApplication
                                    ">="
                                    Elm.Syntax.Infix.Non
                                    (H.node1 407 12 15 (H.val "pos"))
                                    (H.node1
                                        407
                                        19
                                        38
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                407
                                                19
                                                33
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "length"
                                                )
                                            , H.node1 407 34 38 (H.val "tree")
                                            ]
                                        )
                                    )
                                )
                            )
                            (H.node
                                408
                                13
                                417
                                45
                                (Elm.Syntax.Expression.IfBlock
                                    (H.node1
                                        408
                                        16
                                        26
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "=="
                                            Elm.Syntax.Infix.Non
                                            (H.node1 408 16 21 (H.val "shift"))
                                            (H.node1
                                                408
                                                25
                                                26
                                                (Elm.Syntax.Expression.Integer 5
                                                )
                                            )
                                        )
                                    )
                                    (H.node1
                                        409
                                        17
                                        46
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                409
                                                17
                                                29
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "push"
                                                )
                                            , H.node1
                                                409
                                                30
                                                41
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        409
                                                        31
                                                        40
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                409
                                                                31
                                                                35
                                                                (H.val "Leaf")
                                                            , H.node1
                                                                409
                                                                36
                                                                40
                                                                (H.val "tail")
                                                            ]
                                                        )
                                                    )
                                                )
                                            , H.node1 409 42 46 (H.val "tree")
                                            ]
                                        )
                                    )
                                    (H.node
                                        411
                                        17
                                        417
                                        45
                                        (Elm.Syntax.Expression.LetExpression
                                            { declarations =
                                                [ H.node
                                                    412
                                                    21
                                                    415
                                                    39
                                                    (Elm.Syntax.Expression.LetFunction
                                                        { documentation =
                                                            Nothing
                                                        , signature = Nothing
                                                        , declaration =
                                                            H.node
                                                                412
                                                                21
                                                                415
                                                                39
                                                                { name =
                                                                    H.node1
                                                                        412
                                                                        21
                                                                        27
                                                                        "newSub"
                                                                , arguments = []
                                                                , expression =
                                                                    H.node
                                                                        413
                                                                        25
                                                                        415
                                                                        39
                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                            "|>"
                                                                            Elm.Syntax.Infix.Left
                                                                            (H.node
                                                                                413
                                                                                25
                                                                                414
                                                                                79
                                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                                    "|>"
                                                                                    Elm.Syntax.Infix.Left
                                                                                    (H.node1
                                                                                        413
                                                                                        25
                                                                                        38
                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                            [ "JsArray"
                                                                                            ]
                                                                                            "empty"
                                                                                        )
                                                                                    )
                                                                                    (H.node1
                                                                                        414
                                                                                        32
                                                                                        79
                                                                                        (Elm.Syntax.Expression.Application
                                                                                            [ H.node1
                                                                                                414
                                                                                                32
                                                                                                48
                                                                                                (H.val
                                                                                                    "insertTailInTree"
                                                                                                )
                                                                                            , H.node1
                                                                                                414
                                                                                                49
                                                                                                68
                                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                    (H.node1
                                                                                                        414
                                                                                                        50
                                                                                                        67
                                                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                                                            "-"
                                                                                                            Elm.Syntax.Infix.Left
                                                                                                            (H.node1
                                                                                                                414
                                                                                                                50
                                                                                                                55
                                                                                                                (H.val
                                                                                                                    "shift"
                                                                                                                )
                                                                                                            )
                                                                                                            (H.node1
                                                                                                                414
                                                                                                                58
                                                                                                                67
                                                                                                                (H.val
                                                                                                                    "shiftStep"
                                                                                                                )
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                            , H.node1
                                                                                                414
                                                                                                69
                                                                                                74
                                                                                                (H.val
                                                                                                    "index"
                                                                                                )
                                                                                            , H.node1
                                                                                                414
                                                                                                75
                                                                                                79
                                                                                                (H.val
                                                                                                    "tail"
                                                                                                )
                                                                                            ]
                                                                                        )
                                                                                    )
                                                                                )
                                                                            )
                                                                            (H.node1
                                                                                415
                                                                                32
                                                                                39
                                                                                (H.val
                                                                                    "SubTree"
                                                                                )
                                                                            )
                                                                        )
                                                                }
                                                        }
                                                    )
                                                ]
                                            , expression =
                                                H.node1
                                                    417
                                                    21
                                                    45
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            417
                                                            21
                                                            33
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "JsArray" ]
                                                                "push"
                                                            )
                                                        , H.node1
                                                            417
                                                            34
                                                            40
                                                            (H.val "newSub")
                                                        , H.node1
                                                            417
                                                            41
                                                            45
                                                            (H.val "tree")
                                                        ]
                                                    )
                                            }
                                        )
                                    )
                                )
                            )
                            (H.node
                                419
                                13
                                440
                                62
                                (Elm.Syntax.Expression.LetExpression
                                    { declarations =
                                        [ H.node
                                            420
                                            17
                                            421
                                            47
                                            (Elm.Syntax.Expression.LetFunction
                                                { documentation = Nothing
                                                , signature = Nothing
                                                , declaration =
                                                    H.node
                                                        420
                                                        17
                                                        421
                                                        47
                                                        { name =
                                                            H.node1
                                                                420
                                                                17
                                                                22
                                                                "value"
                                                        , arguments = []
                                                        , expression =
                                                            H.node1
                                                                421
                                                                21
                                                                47
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        421
                                                                        21
                                                                        38
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            [ "JsArray"
                                                                            ]
                                                                            "unsafeGet"
                                                                        )
                                                                    , H.node1
                                                                        421
                                                                        39
                                                                        42
                                                                        (H.val
                                                                            "pos"
                                                                        )
                                                                    , H.node1
                                                                        421
                                                                        43
                                                                        47
                                                                        (H.val
                                                                            "tree"
                                                                        )
                                                                    ]
                                                                )
                                                        }
                                                }
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            423
                                            17
                                            440
                                            62
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        423
                                                        22
                                                        27
                                                        (H.val "value")
                                                , cases =
                                                    [ ( H.node1
                                                            424
                                                            21
                                                            36
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "SubTree"
                                                                }
                                                                [ H.node1
                                                                    424
                                                                    29
                                                                    36
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node
                                                            425
                                                            25
                                                            431
                                                            62
                                                            (Elm.Syntax.Expression.LetExpression
                                                                { declarations =
                                                                    [ H.node
                                                                        426
                                                                        29
                                                                        429
                                                                        47
                                                                        (Elm.Syntax.Expression.LetFunction
                                                                            { documentation =
                                                                                Nothing
                                                                            , signature =
                                                                                Nothing
                                                                            , declaration =
                                                                                H.node
                                                                                    426
                                                                                    29
                                                                                    429
                                                                                    47
                                                                                    { name =
                                                                                        H.node1
                                                                                            426
                                                                                            29
                                                                                            35
                                                                                            "newSub"
                                                                                    , arguments =
                                                                                        []
                                                                                    , expression =
                                                                                        H.node
                                                                                            427
                                                                                            33
                                                                                            429
                                                                                            47
                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                "|>"
                                                                                                Elm.Syntax.Infix.Left
                                                                                                (H.node
                                                                                                    427
                                                                                                    33
                                                                                                    428
                                                                                                    87
                                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                                        "|>"
                                                                                                        Elm.Syntax.Infix.Left
                                                                                                        (H.node1
                                                                                                            427
                                                                                                            33
                                                                                                            40
                                                                                                            (H.val
                                                                                                                "subTree"
                                                                                                            )
                                                                                                        )
                                                                                                        (H.node1
                                                                                                            428
                                                                                                            40
                                                                                                            87
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ H.node1
                                                                                                                    428
                                                                                                                    40
                                                                                                                    56
                                                                                                                    (H.val
                                                                                                                        "insertTailInTree"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    428
                                                                                                                    57
                                                                                                                    76
                                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                        (H.node1
                                                                                                                            428
                                                                                                                            58
                                                                                                                            75
                                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                "-"
                                                                                                                                Elm.Syntax.Infix.Left
                                                                                                                                (H.node1
                                                                                                                                    428
                                                                                                                                    58
                                                                                                                                    63
                                                                                                                                    (H.val
                                                                                                                                        "shift"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (H.node1
                                                                                                                                    428
                                                                                                                                    66
                                                                                                                                    75
                                                                                                                                    (H.val
                                                                                                                                        "shiftStep"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    428
                                                                                                                    77
                                                                                                                    82
                                                                                                                    (H.val
                                                                                                                        "index"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    428
                                                                                                                    83
                                                                                                                    87
                                                                                                                    (H.val
                                                                                                                        "tail"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                                (H.node1
                                                                                                    429
                                                                                                    40
                                                                                                    47
                                                                                                    (H.val
                                                                                                        "SubTree"
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                    }
                                                                            }
                                                                        )
                                                                    ]
                                                                , expression =
                                                                    H.node1
                                                                        431
                                                                        29
                                                                        62
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                431
                                                                                29
                                                                                46
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    [ "JsArray"
                                                                                    ]
                                                                                    "unsafeSet"
                                                                                )
                                                                            , H.node1
                                                                                431
                                                                                47
                                                                                50
                                                                                (H.val
                                                                                    "pos"
                                                                                )
                                                                            , H.node1
                                                                                431
                                                                                51
                                                                                57
                                                                                (H.val
                                                                                    "newSub"
                                                                                )
                                                                            , H.node1
                                                                                431
                                                                                58
                                                                                62
                                                                                (H.val
                                                                                    "tree"
                                                                                )
                                                                            ]
                                                                        )
                                                                }
                                                            )
                                                      )
                                                    , ( H.node1
                                                            433
                                                            21
                                                            27
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Leaf"
                                                                }
                                                                [ H.node1
                                                                    433
                                                                    26
                                                                    27
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                ]
                                                            )
                                                      , H.node
                                                            434
                                                            25
                                                            440
                                                            62
                                                            (Elm.Syntax.Expression.LetExpression
                                                                { declarations =
                                                                    [ H.node
                                                                        435
                                                                        29
                                                                        438
                                                                        47
                                                                        (Elm.Syntax.Expression.LetFunction
                                                                            { documentation =
                                                                                Nothing
                                                                            , signature =
                                                                                Nothing
                                                                            , declaration =
                                                                                H.node
                                                                                    435
                                                                                    29
                                                                                    438
                                                                                    47
                                                                                    { name =
                                                                                        H.node1
                                                                                            435
                                                                                            29
                                                                                            35
                                                                                            "newSub"
                                                                                    , arguments =
                                                                                        []
                                                                                    , expression =
                                                                                        H.node
                                                                                            436
                                                                                            33
                                                                                            438
                                                                                            47
                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                "|>"
                                                                                                Elm.Syntax.Infix.Left
                                                                                                (H.node
                                                                                                    436
                                                                                                    33
                                                                                                    437
                                                                                                    87
                                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                                        "|>"
                                                                                                        Elm.Syntax.Infix.Left
                                                                                                        (H.node1
                                                                                                            436
                                                                                                            33
                                                                                                            56
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ H.node1
                                                                                                                    436
                                                                                                                    33
                                                                                                                    50
                                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                        [ "JsArray"
                                                                                                                        ]
                                                                                                                        "singleton"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    436
                                                                                                                    51
                                                                                                                    56
                                                                                                                    (H.val
                                                                                                                        "value"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                        )
                                                                                                        (H.node1
                                                                                                            437
                                                                                                            40
                                                                                                            87
                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                [ H.node1
                                                                                                                    437
                                                                                                                    40
                                                                                                                    56
                                                                                                                    (H.val
                                                                                                                        "insertTailInTree"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    437
                                                                                                                    57
                                                                                                                    76
                                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                        (H.node1
                                                                                                                            437
                                                                                                                            58
                                                                                                                            75
                                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                "-"
                                                                                                                                Elm.Syntax.Infix.Left
                                                                                                                                (H.node1
                                                                                                                                    437
                                                                                                                                    58
                                                                                                                                    63
                                                                                                                                    (H.val
                                                                                                                                        "shift"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                                (H.node1
                                                                                                                                    437
                                                                                                                                    66
                                                                                                                                    75
                                                                                                                                    (H.val
                                                                                                                                        "shiftStep"
                                                                                                                                    )
                                                                                                                                )
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    437
                                                                                                                    77
                                                                                                                    82
                                                                                                                    (H.val
                                                                                                                        "index"
                                                                                                                    )
                                                                                                                , H.node1
                                                                                                                    437
                                                                                                                    83
                                                                                                                    87
                                                                                                                    (H.val
                                                                                                                        "tail"
                                                                                                                    )
                                                                                                                ]
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                                (H.node1
                                                                                                    438
                                                                                                    40
                                                                                                    47
                                                                                                    (H.val
                                                                                                        "SubTree"
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                    }
                                                                            }
                                                                        )
                                                                    ]
                                                                , expression =
                                                                    H.node1
                                                                        440
                                                                        29
                                                                        62
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                440
                                                                                29
                                                                                46
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    [ "JsArray"
                                                                                    ]
                                                                                    "unsafeSet"
                                                                                )
                                                                            , H.node1
                                                                                440
                                                                                47
                                                                                50
                                                                                (H.val
                                                                                    "pos"
                                                                                )
                                                                            , H.node1
                                                                                440
                                                                                51
                                                                                57
                                                                                (H.val
                                                                                    "newSub"
                                                                                )
                                                                            , H.node1
                                                                                440
                                                                                58
                                                                                62
                                                                                (H.val
                                                                                    "tree"
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
                                )
                            )
                        )
                }
            )
    }


toList : Elm.Syntax.Expression.FunctionImplementation
toList =
    { name = H.node1 448 1 7 "Array.toList"
    , arguments = [ H.node1 448 8 13 (Elm.Syntax.Pattern.VarPattern "array") ]
    , expression =
        H.node1
            449
            5
            24
            (Elm.Syntax.Expression.Application
                [ H.node1 449 5 10 (H.val "foldr")
                , H.node1 449 11 15 (Elm.Syntax.Expression.PrefixOperator "::")
                , H.node1 449 16 18 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 449 19 24 (H.val "array")
                ]
            )
    }


toIndexedList : Elm.Syntax.Expression.FunctionImplementation
toIndexedList =
    { name = H.node1 458 1 14 "Array.toIndexedList"
    , arguments =
        [ H.node1
            458
            15
            55
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    458
                    16
                    54
                    (Elm.Syntax.Pattern.AsPattern
                        (H.node1
                            458
                            16
                            45
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (H.node1
                                    458
                                    17
                                    44
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ H.node1
                                            458
                                            35
                                            38
                                            (Elm.Syntax.Pattern.VarPattern "len"
                                            )
                                        , H.node1
                                            458
                                            39
                                            40
                                            Elm.Syntax.Pattern.AllPattern
                                        , H.node1
                                            458
                                            41
                                            42
                                            Elm.Syntax.Pattern.AllPattern
                                        , H.node1
                                            458
                                            43
                                            44
                                            Elm.Syntax.Pattern.AllPattern
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node1 458 49 54 "array")
                    )
                )
            )
        ]
    , expression =
        H.node
            459
            5
            463
            58
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        460
                        9
                        461
                        49
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    460
                                    9
                                    461
                                    49
                                    { name = H.node1 460 9 15 "helper"
                                    , arguments =
                                        [ H.node1
                                            460
                                            16
                                            21
                                            (Elm.Syntax.Pattern.VarPattern
                                                "entry"
                                            )
                                        , H.node1
                                            460
                                            22
                                            37
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    460
                                                    24
                                                    29
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "index"
                                                    )
                                                , H.node1
                                                    460
                                                    31
                                                    35
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "list"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        H.node1
                                            461
                                            13
                                            49
                                            (Elm.Syntax.Expression.TupledExpression
                                                [ H.node1
                                                    461
                                                    15
                                                    24
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            461
                                                            15
                                                            20
                                                            (H.val "index")
                                                        )
                                                        (H.node1
                                                            461
                                                            23
                                                            24
                                                            (Elm.Syntax.Expression.Integer
                                                                1
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    461
                                                    26
                                                    47
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "::"
                                                        Elm.Syntax.Infix.Right
                                                        (H.node1
                                                            461
                                                            26
                                                            39
                                                            (Elm.Syntax.Expression.TupledExpression
                                                                [ H.node1
                                                                    461
                                                                    27
                                                                    32
                                                                    (H.val
                                                                        "index"
                                                                    )
                                                                , H.node1
                                                                    461
                                                                    33
                                                                    38
                                                                    (H.val
                                                                        "entry"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                        (H.node1
                                                            461
                                                            43
                                                            47
                                                            (H.val "list")
                                                        )
                                                    )
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        463
                        9
                        58
                        (Elm.Syntax.Expression.Application
                            [ H.node1
                                463
                                9
                                21
                                (Elm.Syntax.Expression.FunctionOrValue
                                    [ "Tuple" ]
                                    "second"
                                )
                            , H.node1
                                463
                                22
                                58
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        463
                                        23
                                        57
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 463 23 28 (H.val "foldr")
                                            , H.node1 463 29 35 (H.val "helper")
                                            , H.node1
                                                463
                                                36
                                                51
                                                (Elm.Syntax.Expression.TupledExpression
                                                    [ H.node1
                                                        463
                                                        38
                                                        45
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "-"
                                                            Elm.Syntax.Infix.Left
                                                            (H.node1
                                                                463
                                                                38
                                                                41
                                                                (H.val "len")
                                                            )
                                                            (H.node1
                                                                463
                                                                44
                                                                45
                                                                (Elm.Syntax.Expression.Integer
                                                                    1
                                                                )
                                                            )
                                                        )
                                                    , H.node1
                                                        463
                                                        47
                                                        49
                                                        (Elm.Syntax.Expression.ListExpr
                                                            []
                                                        )
                                                    ]
                                                )
                                            , H.node1 463 52 57 (H.val "array")
                                            ]
                                        )
                                    )
                                )
                            ]
                        )
                }
            )
    }


foldr : Elm.Syntax.Expression.FunctionImplementation
foldr =
    { name = H.node1 471 1 6 "Array.foldr"
    , arguments =
        [ H.node1 471 7 11 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 471 12 20 (Elm.Syntax.Pattern.VarPattern "baseCase")
        , H.node1
            471
            21
            54
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    471
                    22
                    53
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ H.node1 471 40 41 Elm.Syntax.Pattern.AllPattern
                        , H.node1 471 42 43 Elm.Syntax.Pattern.AllPattern
                        , H.node1
                            471
                            44
                            48
                            (Elm.Syntax.Pattern.VarPattern "tree")
                        , H.node1
                            471
                            49
                            53
                            (Elm.Syntax.Pattern.VarPattern "tail")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node
            472
            5
            481
            69
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        473
                        9
                        479
                        50
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    473
                                    9
                                    479
                                    50
                                    { name = H.node1 473 9 15 "helper"
                                    , arguments =
                                        [ H.node1
                                            473
                                            16
                                            20
                                            (Elm.Syntax.Pattern.VarPattern
                                                "node"
                                            )
                                        , H.node1
                                            473
                                            21
                                            24
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            474
                                            13
                                            479
                                            50
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        474
                                                        18
                                                        22
                                                        (H.val "node")
                                                , cases =
                                                    [ ( H.node1
                                                            475
                                                            17
                                                            32
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "SubTree"
                                                                }
                                                                [ H.node1
                                                                    475
                                                                    25
                                                                    32
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            476
                                                            21
                                                            53
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    476
                                                                    21
                                                                    34
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "foldr"
                                                                    )
                                                                , H.node1
                                                                    476
                                                                    35
                                                                    41
                                                                    (H.val
                                                                        "helper"
                                                                    )
                                                                , H.node1
                                                                    476
                                                                    42
                                                                    45
                                                                    (H.val "acc"
                                                                    )
                                                                , H.node1
                                                                    476
                                                                    46
                                                                    53
                                                                    (H.val
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            478
                                                            17
                                                            28
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Leaf"
                                                                }
                                                                [ H.node1
                                                                    478
                                                                    22
                                                                    28
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "values"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            479
                                                            21
                                                            50
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    479
                                                                    21
                                                                    34
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "foldr"
                                                                    )
                                                                , H.node1
                                                                    479
                                                                    35
                                                                    39
                                                                    (H.val
                                                                        "func"
                                                                    )
                                                                , H.node1
                                                                    479
                                                                    40
                                                                    43
                                                                    (H.val "acc"
                                                                    )
                                                                , H.node1
                                                                    479
                                                                    44
                                                                    50
                                                                    (H.val
                                                                        "values"
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
                        481
                        9
                        69
                        (Elm.Syntax.Expression.Application
                            [ H.node1
                                481
                                9
                                22
                                (Elm.Syntax.Expression.FunctionOrValue
                                    [ "JsArray" ]
                                    "foldr"
                                )
                            , H.node1 481 23 29 (H.val "helper")
                            , H.node1
                                481
                                30
                                64
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        481
                                        31
                                        63
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                481
                                                31
                                                44
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "foldr"
                                                )
                                            , H.node1 481 45 49 (H.val "func")
                                            , H.node1
                                                481
                                                50
                                                58
                                                (H.val "baseCase")
                                            , H.node1 481 59 63 (H.val "tail")
                                            ]
                                        )
                                    )
                                )
                            , H.node1 481 65 69 (H.val "tree")
                            ]
                        )
                }
            )
    }


foldl : Elm.Syntax.Expression.FunctionImplementation
foldl =
    { name = H.node1 489 1 6 "Array.foldl"
    , arguments =
        [ H.node1 489 7 11 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 489 12 20 (Elm.Syntax.Pattern.VarPattern "baseCase")
        , H.node1
            489
            21
            54
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    489
                    22
                    53
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ H.node1 489 40 41 Elm.Syntax.Pattern.AllPattern
                        , H.node1 489 42 43 Elm.Syntax.Pattern.AllPattern
                        , H.node1
                            489
                            44
                            48
                            (Elm.Syntax.Pattern.VarPattern "tree")
                        , H.node1
                            489
                            49
                            53
                            (Elm.Syntax.Pattern.VarPattern "tail")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node
            490
            5
            499
            69
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        491
                        9
                        497
                        50
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    491
                                    9
                                    497
                                    50
                                    { name = H.node1 491 9 15 "helper"
                                    , arguments =
                                        [ H.node1
                                            491
                                            16
                                            20
                                            (Elm.Syntax.Pattern.VarPattern
                                                "node"
                                            )
                                        , H.node1
                                            491
                                            21
                                            24
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            492
                                            13
                                            497
                                            50
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        492
                                                        18
                                                        22
                                                        (H.val "node")
                                                , cases =
                                                    [ ( H.node1
                                                            493
                                                            17
                                                            32
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "SubTree"
                                                                }
                                                                [ H.node1
                                                                    493
                                                                    25
                                                                    32
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            494
                                                            21
                                                            53
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    494
                                                                    21
                                                                    34
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "foldl"
                                                                    )
                                                                , H.node1
                                                                    494
                                                                    35
                                                                    41
                                                                    (H.val
                                                                        "helper"
                                                                    )
                                                                , H.node1
                                                                    494
                                                                    42
                                                                    45
                                                                    (H.val "acc"
                                                                    )
                                                                , H.node1
                                                                    494
                                                                    46
                                                                    53
                                                                    (H.val
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            496
                                                            17
                                                            28
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Leaf"
                                                                }
                                                                [ H.node1
                                                                    496
                                                                    22
                                                                    28
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "values"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            497
                                                            21
                                                            50
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    497
                                                                    21
                                                                    34
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "foldl"
                                                                    )
                                                                , H.node1
                                                                    497
                                                                    35
                                                                    39
                                                                    (H.val
                                                                        "func"
                                                                    )
                                                                , H.node1
                                                                    497
                                                                    40
                                                                    43
                                                                    (H.val "acc"
                                                                    )
                                                                , H.node1
                                                                    497
                                                                    44
                                                                    50
                                                                    (H.val
                                                                        "values"
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
                        499
                        9
                        69
                        (Elm.Syntax.Expression.Application
                            [ H.node1
                                499
                                9
                                22
                                (Elm.Syntax.Expression.FunctionOrValue
                                    [ "JsArray" ]
                                    "foldl"
                                )
                            , H.node1 499 23 27 (H.val "func")
                            , H.node1
                                499
                                28
                                64
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        499
                                        29
                                        63
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                499
                                                29
                                                42
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "foldl"
                                                )
                                            , H.node1 499 43 49 (H.val "helper")
                                            , H.node1
                                                499
                                                50
                                                58
                                                (H.val "baseCase")
                                            , H.node1 499 59 63 (H.val "tree")
                                            ]
                                        )
                                    )
                                )
                            , H.node1 499 65 69 (H.val "tail")
                            ]
                        )
                }
            )
    }


filter : Elm.Syntax.Expression.FunctionImplementation
filter =
    { name = H.node1 507 1 7 "Array.filter"
    , arguments =
        [ H.node1 507 8 14 (Elm.Syntax.Pattern.VarPattern "isGood")
        , H.node1 507 15 20 (Elm.Syntax.Pattern.VarPattern "array")
        ]
    , expression =
        H.node1
            508
            5
            74
            (Elm.Syntax.Expression.Application
                [ H.node1 508 5 13 (H.val "fromList")
                , H.node1
                    508
                    14
                    74
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            508
                            15
                            73
                            (Elm.Syntax.Expression.Application
                                [ H.node1 508 15 20 (H.val "foldr")
                                , H.node1
                                    508
                                    21
                                    64
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            508
                                            22
                                            63
                                            (Elm.Syntax.Expression.LambdaExpression
                                                { args =
                                                    [ H.node1
                                                        508
                                                        23
                                                        24
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "x"
                                                        )
                                                    , H.node1
                                                        508
                                                        25
                                                        27
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "xs"
                                                        )
                                                    ]
                                                , expression =
                                                    H.node1
                                                        508
                                                        31
                                                        63
                                                        (Elm.Syntax.Expression.IfBlock
                                                            (H.node1
                                                                508
                                                                34
                                                                42
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        508
                                                                        34
                                                                        40
                                                                        (H.val
                                                                            "isGood"
                                                                        )
                                                                    , H.node1
                                                                        508
                                                                        41
                                                                        42
                                                                        (H.val
                                                                            "x"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                            (H.node1
                                                                508
                                                                48
                                                                55
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    "::"
                                                                    Elm.Syntax.Infix.Right
                                                                    (H.node1
                                                                        508
                                                                        48
                                                                        49
                                                                        (H.val
                                                                            "x"
                                                                        )
                                                                    )
                                                                    (H.node1
                                                                        508
                                                                        53
                                                                        55
                                                                        (H.val
                                                                            "xs"
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                            (H.node1
                                                                508
                                                                61
                                                                63
                                                                (H.val "xs")
                                                            )
                                                        )
                                                }
                                            )
                                        )
                                    )
                                , H.node1
                                    508
                                    65
                                    67
                                    (Elm.Syntax.Expression.ListExpr [])
                                , H.node1 508 68 73 (H.val "array")
                                ]
                            )
                        )
                    )
                ]
            )
    }


map : Elm.Syntax.Expression.FunctionImplementation
map =
    { name = H.node1 516 1 4 "Array.map"
    , arguments =
        [ H.node1 516 5 9 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1
            516
            10
            54
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    516
                    11
                    53
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ H.node1
                            516
                            29
                            32
                            (Elm.Syntax.Pattern.VarPattern "len")
                        , H.node1
                            516
                            33
                            43
                            (Elm.Syntax.Pattern.VarPattern "startShift")
                        , H.node1
                            516
                            44
                            48
                            (Elm.Syntax.Pattern.VarPattern "tree")
                        , H.node1
                            516
                            49
                            53
                            (Elm.Syntax.Pattern.VarPattern "tail")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node
            517
            5
            530
            36
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        518
                        9
                        524
                        52
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    518
                                    9
                                    524
                                    52
                                    { name = H.node1 518 9 15 "helper"
                                    , arguments =
                                        [ H.node1
                                            518
                                            16
                                            20
                                            (Elm.Syntax.Pattern.VarPattern
                                                "node"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            519
                                            13
                                            524
                                            52
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        519
                                                        18
                                                        22
                                                        (H.val "node")
                                                , cases =
                                                    [ ( H.node1
                                                            520
                                                            17
                                                            32
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "SubTree"
                                                                }
                                                                [ H.node1
                                                                    520
                                                                    25
                                                                    32
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            521
                                                            21
                                                            58
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "<|"
                                                                Elm.Syntax.Infix.Right
                                                                (H.node1
                                                                    521
                                                                    21
                                                                    28
                                                                    (H.val
                                                                        "SubTree"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    521
                                                                    32
                                                                    58
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            521
                                                                            32
                                                                            43
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "map"
                                                                            )
                                                                        , H.node1
                                                                            521
                                                                            44
                                                                            50
                                                                            (H.val
                                                                                "helper"
                                                                            )
                                                                        , H.node1
                                                                            521
                                                                            51
                                                                            58
                                                                            (H.val
                                                                                "subTree"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                      )
                                                    , ( H.node1
                                                            523
                                                            17
                                                            28
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Leaf"
                                                                }
                                                                [ H.node1
                                                                    523
                                                                    22
                                                                    28
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "values"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            524
                                                            21
                                                            52
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "<|"
                                                                Elm.Syntax.Infix.Right
                                                                (H.node1
                                                                    524
                                                                    21
                                                                    25
                                                                    (H.val
                                                                        "Leaf"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    524
                                                                    29
                                                                    52
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            524
                                                                            29
                                                                            40
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "map"
                                                                            )
                                                                        , H.node1
                                                                            524
                                                                            41
                                                                            45
                                                                            (H.val
                                                                                "func"
                                                                            )
                                                                        , H.node1
                                                                            524
                                                                            46
                                                                            52
                                                                            (H.val
                                                                                "values"
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
                            }
                        )
                    ]
                , expression =
                    H.node
                        526
                        9
                        530
                        36
                        (Elm.Syntax.Expression.Application
                            [ H.node1 526 9 26 (H.val "Array_elm_builtin")
                            , H.node1 527 13 16 (H.val "len")
                            , H.node1 528 13 23 (H.val "startShift")
                            , H.node1
                                529
                                13
                                38
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        529
                                        14
                                        37
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                529
                                                14
                                                25
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "map"
                                                )
                                            , H.node1 529 26 32 (H.val "helper")
                                            , H.node1 529 33 37 (H.val "tree")
                                            ]
                                        )
                                    )
                                )
                            , H.node1
                                530
                                13
                                36
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        530
                                        14
                                        35
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                530
                                                14
                                                25
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "map"
                                                )
                                            , H.node1 530 26 30 (H.val "func")
                                            , H.node1 530 31 35 (H.val "tail")
                                            ]
                                        )
                                    )
                                )
                            ]
                        )
                }
            )
    }


indexedMap : Elm.Syntax.Expression.FunctionImplementation
indexedMap =
    { name = H.node1 538 1 11 "Array.indexedMap"
    , arguments =
        [ H.node1 538 12 16 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1
            538
            17
            52
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    538
                    18
                    51
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ H.node1
                            538
                            36
                            39
                            (Elm.Syntax.Pattern.VarPattern "len")
                        , H.node1 538 40 41 Elm.Syntax.Pattern.AllPattern
                        , H.node1
                            538
                            42
                            46
                            (Elm.Syntax.Pattern.VarPattern "tree")
                        , H.node1
                            538
                            47
                            51
                            (Elm.Syntax.Pattern.VarPattern "tail")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node
            539
            5
            564
            71
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        540
                        9
                        556
                        26
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    540
                                    9
                                    556
                                    26
                                    { name = H.node1 540 9 15 "helper"
                                    , arguments =
                                        [ H.node1
                                            540
                                            16
                                            20
                                            (Elm.Syntax.Pattern.VarPattern
                                                "node"
                                            )
                                        , H.node1
                                            540
                                            21
                                            28
                                            (Elm.Syntax.Pattern.VarPattern
                                                "builder"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            541
                                            13
                                            556
                                            26
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        541
                                                        18
                                                        22
                                                        (H.val "node")
                                                , cases =
                                                    [ ( H.node1
                                                            542
                                                            17
                                                            32
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "SubTree"
                                                                }
                                                                [ H.node1
                                                                    542
                                                                    25
                                                                    32
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            543
                                                            21
                                                            57
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    543
                                                                    21
                                                                    34
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "foldl"
                                                                    )
                                                                , H.node1
                                                                    543
                                                                    35
                                                                    41
                                                                    (H.val
                                                                        "helper"
                                                                    )
                                                                , H.node1
                                                                    543
                                                                    42
                                                                    49
                                                                    (H.val
                                                                        "builder"
                                                                    )
                                                                , H.node1
                                                                    543
                                                                    50
                                                                    57
                                                                    (H.val
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            545
                                                            17
                                                            26
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Leaf"
                                                                }
                                                                [ H.node1
                                                                    545
                                                                    22
                                                                    26
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "leaf"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node
                                                            546
                                                            21
                                                            556
                                                            26
                                                            (Elm.Syntax.Expression.LetExpression
                                                                { declarations =
                                                                    [ H.node
                                                                        547
                                                                        25
                                                                        548
                                                                        64
                                                                        (Elm.Syntax.Expression.LetFunction
                                                                            { documentation =
                                                                                Nothing
                                                                            , signature =
                                                                                Nothing
                                                                            , declaration =
                                                                                H.node
                                                                                    547
                                                                                    25
                                                                                    548
                                                                                    64
                                                                                    { name =
                                                                                        H.node1
                                                                                            547
                                                                                            25
                                                                                            31
                                                                                            "offset"
                                                                                    , arguments =
                                                                                        []
                                                                                    , expression =
                                                                                        H.node1
                                                                                            548
                                                                                            29
                                                                                            64
                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                "*"
                                                                                                Elm.Syntax.Infix.Left
                                                                                                (H.node1
                                                                                                    548
                                                                                                    29
                                                                                                    49
                                                                                                    (Elm.Syntax.Expression.RecordAccess
                                                                                                        (H.node1
                                                                                                            548
                                                                                                            29
                                                                                                            36
                                                                                                            (H.val
                                                                                                                "builder"
                                                                                                            )
                                                                                                        )
                                                                                                        (H.node1
                                                                                                            548
                                                                                                            37
                                                                                                            49
                                                                                                            "nodeListSize"
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                                (H.node1
                                                                                                    548
                                                                                                    52
                                                                                                    64
                                                                                                    (H.val
                                                                                                        "branchFactor"
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                    }
                                                                            }
                                                                        )
                                                                    , H.node
                                                                        550
                                                                        25
                                                                        551
                                                                        72
                                                                        (Elm.Syntax.Expression.LetFunction
                                                                            { documentation =
                                                                                Nothing
                                                                            , signature =
                                                                                Nothing
                                                                            , declaration =
                                                                                H.node
                                                                                    550
                                                                                    25
                                                                                    551
                                                                                    72
                                                                                    { name =
                                                                                        H.node1
                                                                                            550
                                                                                            25
                                                                                            35
                                                                                            "mappedLeaf"
                                                                                    , arguments =
                                                                                        []
                                                                                    , expression =
                                                                                        H.node1
                                                                                            551
                                                                                            29
                                                                                            72
                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                "<|"
                                                                                                Elm.Syntax.Infix.Right
                                                                                                (H.node1
                                                                                                    551
                                                                                                    29
                                                                                                    33
                                                                                                    (H.val
                                                                                                        "Leaf"
                                                                                                    )
                                                                                                )
                                                                                                (H.node1
                                                                                                    551
                                                                                                    37
                                                                                                    72
                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                        [ H.node1
                                                                                                            551
                                                                                                            37
                                                                                                            55
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                [ "JsArray"
                                                                                                                ]
                                                                                                                "indexedMap"
                                                                                                            )
                                                                                                        , H.node1
                                                                                                            551
                                                                                                            56
                                                                                                            60
                                                                                                            (H.val
                                                                                                                "func"
                                                                                                            )
                                                                                                        , H.node1
                                                                                                            551
                                                                                                            61
                                                                                                            67
                                                                                                            (H.val
                                                                                                                "offset"
                                                                                                            )
                                                                                                        , H.node1
                                                                                                            551
                                                                                                            68
                                                                                                            72
                                                                                                            (H.val
                                                                                                                "leaf"
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
                                                                    H.node
                                                                        553
                                                                        25
                                                                        556
                                                                        26
                                                                        (Elm.Syntax.Expression.RecordExpr
                                                                            [ H.node1
                                                                                553
                                                                                27
                                                                                46
                                                                                ( H.node1
                                                                                    553
                                                                                    27
                                                                                    31
                                                                                    "tail"
                                                                                , H.node1
                                                                                    553
                                                                                    34
                                                                                    46
                                                                                    (Elm.Syntax.Expression.RecordAccess
                                                                                        (H.node1
                                                                                            553
                                                                                            34
                                                                                            41
                                                                                            (H.val
                                                                                                "builder"
                                                                                            )
                                                                                        )
                                                                                        (H.node1
                                                                                            553
                                                                                            42
                                                                                            46
                                                                                            "tail"
                                                                                        )
                                                                                    )
                                                                                )
                                                                            , H.node
                                                                                554
                                                                                27
                                                                                555
                                                                                25
                                                                                ( H.node1
                                                                                    554
                                                                                    27
                                                                                    35
                                                                                    "nodeList"
                                                                                , H.node1
                                                                                    554
                                                                                    38
                                                                                    68
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "::"
                                                                                        Elm.Syntax.Infix.Right
                                                                                        (H.node1
                                                                                            554
                                                                                            38
                                                                                            48
                                                                                            (H.val
                                                                                                "mappedLeaf"
                                                                                            )
                                                                                        )
                                                                                        (H.node1
                                                                                            554
                                                                                            52
                                                                                            68
                                                                                            (Elm.Syntax.Expression.RecordAccess
                                                                                                (H.node1
                                                                                                    554
                                                                                                    52
                                                                                                    59
                                                                                                    (H.val
                                                                                                        "builder"
                                                                                                    )
                                                                                                )
                                                                                                (H.node1
                                                                                                    554
                                                                                                    60
                                                                                                    68
                                                                                                    "nodeList"
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                            , H.node
                                                                                555
                                                                                27
                                                                                556
                                                                                25
                                                                                ( H.node1
                                                                                    555
                                                                                    27
                                                                                    39
                                                                                    "nodeListSize"
                                                                                , H.node1
                                                                                    555
                                                                                    42
                                                                                    66
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "+"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (H.node1
                                                                                            555
                                                                                            42
                                                                                            62
                                                                                            (Elm.Syntax.Expression.RecordAccess
                                                                                                (H.node1
                                                                                                    555
                                                                                                    42
                                                                                                    49
                                                                                                    (H.val
                                                                                                        "builder"
                                                                                                    )
                                                                                                )
                                                                                                (H.node1
                                                                                                    555
                                                                                                    50
                                                                                                    62
                                                                                                    "nodeListSize"
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                        (H.node1
                                                                                            555
                                                                                            65
                                                                                            66
                                                                                            (Elm.Syntax.Expression.Integer
                                                                                                1
                                                                                            )
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
                            }
                        )
                    , H.node
                        558
                        9
                        562
                        14
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    558
                                    9
                                    562
                                    14
                                    { name = H.node1 558 9 23 "initialBuilder"
                                    , arguments = []
                                    , expression =
                                        H.node
                                            559
                                            13
                                            562
                                            14
                                            (Elm.Syntax.Expression.RecordExpr
                                                [ H.node1
                                                    559
                                                    15
                                                    66
                                                    ( H.node1 559 15 19 "tail"
                                                    , H.node1
                                                        559
                                                        22
                                                        66
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                559
                                                                22
                                                                40
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    [ "JsArray"
                                                                    ]
                                                                    "indexedMap"
                                                                )
                                                            , H.node1
                                                                559
                                                                41
                                                                45
                                                                (H.val "func")
                                                            , H.node1
                                                                559
                                                                46
                                                                61
                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                    (H.node1
                                                                        559
                                                                        47
                                                                        60
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                559
                                                                                47
                                                                                56
                                                                                (H.val
                                                                                    "tailIndex"
                                                                                )
                                                                            , H.node1
                                                                                559
                                                                                57
                                                                                60
                                                                                (H.val
                                                                                    "len"
                                                                                )
                                                                            ]
                                                                        )
                                                                    )
                                                                )
                                                            , H.node1
                                                                559
                                                                62
                                                                66
                                                                (H.val "tail")
                                                            ]
                                                        )
                                                    )
                                                , H.node
                                                    560
                                                    15
                                                    561
                                                    13
                                                    ( H.node1
                                                        560
                                                        15
                                                        23
                                                        "nodeList"
                                                    , H.node1
                                                        560
                                                        26
                                                        28
                                                        (Elm.Syntax.Expression.ListExpr
                                                            []
                                                        )
                                                    )
                                                , H.node
                                                    561
                                                    15
                                                    562
                                                    13
                                                    ( H.node1
                                                        561
                                                        15
                                                        27
                                                        "nodeListSize"
                                                    , H.node1
                                                        561
                                                        30
                                                        31
                                                        (Elm.Syntax.Expression.Integer
                                                            0
                                                        )
                                                    )
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        564
                        9
                        71
                        (Elm.Syntax.Expression.Application
                            [ H.node1 564 9 23 (H.val "builderToArray")
                            , H.node1 564 24 28 (H.val "True")
                            , H.node1
                                564
                                29
                                71
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        564
                                        30
                                        70
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                564
                                                30
                                                43
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "foldl"
                                                )
                                            , H.node1 564 44 50 (H.val "helper")
                                            , H.node1
                                                564
                                                51
                                                65
                                                (H.val "initialBuilder")
                                            , H.node1 564 66 70 (H.val "tree")
                                            ]
                                        )
                                    )
                                )
                            ]
                        )
                }
            )
    }


append : Elm.Syntax.Expression.FunctionImplementation
append =
    { name = H.node1 572 1 7 "Array.append"
    , arguments =
        [ H.node1
            572
            8
            46
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    572
                    9
                    45
                    (Elm.Syntax.Pattern.AsPattern
                        (H.node1
                            572
                            9
                            40
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (H.node1
                                    572
                                    10
                                    39
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ H.node1
                                            572
                                            28
                                            29
                                            Elm.Syntax.Pattern.AllPattern
                                        , H.node1
                                            572
                                            30
                                            31
                                            Elm.Syntax.Pattern.AllPattern
                                        , H.node1
                                            572
                                            32
                                            33
                                            Elm.Syntax.Pattern.AllPattern
                                        , H.node1
                                            572
                                            34
                                            39
                                            (Elm.Syntax.Pattern.VarPattern
                                                "aTail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node1 572 44 45 "a")
                    )
                )
            )
        , H.node1
            572
            47
            85
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    572
                    48
                    84
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ H.node1
                            572
                            66
                            70
                            (Elm.Syntax.Pattern.VarPattern "bLen")
                        , H.node1 572 71 72 Elm.Syntax.Pattern.AllPattern
                        , H.node1
                            572
                            73
                            78
                            (Elm.Syntax.Pattern.VarPattern "bTree")
                        , H.node1
                            572
                            79
                            84
                            (Elm.Syntax.Pattern.VarPattern "bTail")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node
            574
            5
            598
            39
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    574
                    8
                    34
                    (Elm.Syntax.Expression.OperatorApplication
                        "<="
                        Elm.Syntax.Infix.Non
                        (H.node1 574 8 12 (H.val "bLen"))
                        (H.node1
                            574
                            16
                            34
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    574
                                    17
                                    33
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "*"
                                        Elm.Syntax.Infix.Left
                                        (H.node1
                                            574
                                            17
                                            29
                                            (H.val "branchFactor")
                                        )
                                        (H.node1
                                            574
                                            32
                                            33
                                            (Elm.Syntax.Expression.Integer 4)
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
                (H.node
                    575
                    9
                    585
                    40
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ H.node
                                576
                                13
                                582
                                50
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            576
                                            13
                                            582
                                            50
                                            { name =
                                                H.node1 576 13 23 "foldHelper"
                                            , arguments =
                                                [ H.node1
                                                    576
                                                    24
                                                    28
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "node"
                                                    )
                                                , H.node1
                                                    576
                                                    29
                                                    34
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "array"
                                                    )
                                                ]
                                            , expression =
                                                H.node
                                                    577
                                                    17
                                                    582
                                                    50
                                                    (Elm.Syntax.Expression.CaseExpression
                                                        { expression =
                                                            H.node1
                                                                577
                                                                22
                                                                26
                                                                (H.val "node")
                                                        , cases =
                                                            [ ( H.node1
                                                                    578
                                                                    21
                                                                    33
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "SubTree"
                                                                        }
                                                                        [ H.node1
                                                                            578
                                                                            29
                                                                            33
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "tree"
                                                                            )
                                                                        ]
                                                                    )
                                                              , H.node1
                                                                    579
                                                                    25
                                                                    60
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            579
                                                                            25
                                                                            38
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "foldl"
                                                                            )
                                                                        , H.node1
                                                                            579
                                                                            39
                                                                            49
                                                                            (H.val
                                                                                "foldHelper"
                                                                            )
                                                                        , H.node1
                                                                            579
                                                                            50
                                                                            55
                                                                            (H.val
                                                                                "array"
                                                                            )
                                                                        , H.node1
                                                                            579
                                                                            56
                                                                            60
                                                                            (H.val
                                                                                "tree"
                                                                            )
                                                                        ]
                                                                    )
                                                              )
                                                            , ( H.node1
                                                                    581
                                                                    21
                                                                    30
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "Leaf"
                                                                        }
                                                                        [ H.node1
                                                                            581
                                                                            26
                                                                            30
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "leaf"
                                                                            )
                                                                        ]
                                                                    )
                                                              , H.node1
                                                                    582
                                                                    25
                                                                    50
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            582
                                                                            25
                                                                            39
                                                                            (H.val
                                                                                "appendHelpTree"
                                                                            )
                                                                        , H.node1
                                                                            582
                                                                            40
                                                                            44
                                                                            (H.val
                                                                                "leaf"
                                                                            )
                                                                        , H.node1
                                                                            582
                                                                            45
                                                                            50
                                                                            (H.val
                                                                                "array"
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
                            H.node
                                584
                                13
                                585
                                40
                                (Elm.Syntax.Expression.OperatorApplication
                                    "|>"
                                    Elm.Syntax.Infix.Left
                                    (H.node1
                                        584
                                        13
                                        45
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                584
                                                13
                                                26
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "foldl"
                                                )
                                            , H.node1
                                                584
                                                27
                                                37
                                                (H.val "foldHelper")
                                            , H.node1 584 38 39 (H.val "a")
                                            , H.node1 584 40 45 (H.val "bTree")
                                            ]
                                        )
                                    )
                                    (H.node1
                                        585
                                        20
                                        40
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                585
                                                20
                                                34
                                                (H.val "appendHelpTree")
                                            , H.node1 585 35 40 (H.val "bTail")
                                            ]
                                        )
                                    )
                                )
                        }
                    )
                )
                (H.node
                    587
                    9
                    598
                    39
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ H.node
                                588
                                13
                                594
                                55
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            588
                                            13
                                            594
                                            55
                                            { name =
                                                H.node1 588 13 23 "foldHelper"
                                            , arguments =
                                                [ H.node1
                                                    588
                                                    24
                                                    28
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "node"
                                                    )
                                                , H.node1
                                                    588
                                                    29
                                                    36
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "builder"
                                                    )
                                                ]
                                            , expression =
                                                H.node
                                                    589
                                                    17
                                                    594
                                                    55
                                                    (Elm.Syntax.Expression.CaseExpression
                                                        { expression =
                                                            H.node1
                                                                589
                                                                22
                                                                26
                                                                (H.val "node")
                                                        , cases =
                                                            [ ( H.node1
                                                                    590
                                                                    21
                                                                    33
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "SubTree"
                                                                        }
                                                                        [ H.node1
                                                                            590
                                                                            29
                                                                            33
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "tree"
                                                                            )
                                                                        ]
                                                                    )
                                                              , H.node1
                                                                    591
                                                                    25
                                                                    62
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            591
                                                                            25
                                                                            38
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "foldl"
                                                                            )
                                                                        , H.node1
                                                                            591
                                                                            39
                                                                            49
                                                                            (H.val
                                                                                "foldHelper"
                                                                            )
                                                                        , H.node1
                                                                            591
                                                                            50
                                                                            57
                                                                            (H.val
                                                                                "builder"
                                                                            )
                                                                        , H.node1
                                                                            591
                                                                            58
                                                                            62
                                                                            (H.val
                                                                                "tree"
                                                                            )
                                                                        ]
                                                                    )
                                                              )
                                                            , ( H.node1
                                                                    593
                                                                    21
                                                                    30
                                                                    (Elm.Syntax.Pattern.NamedPattern
                                                                        { moduleName =
                                                                            []
                                                                        , name =
                                                                            "Leaf"
                                                                        }
                                                                        [ H.node1
                                                                            593
                                                                            26
                                                                            30
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "leaf"
                                                                            )
                                                                        ]
                                                                    )
                                                              , H.node1
                                                                    594
                                                                    25
                                                                    55
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            594
                                                                            25
                                                                            42
                                                                            (H.val
                                                                                "appendHelpBuilder"
                                                                            )
                                                                        , H.node1
                                                                            594
                                                                            43
                                                                            47
                                                                            (H.val
                                                                                "leaf"
                                                                            )
                                                                        , H.node1
                                                                            594
                                                                            48
                                                                            55
                                                                            (H.val
                                                                                "builder"
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
                            H.node
                                596
                                13
                                598
                                39
                                (Elm.Syntax.Expression.OperatorApplication
                                    "|>"
                                    Elm.Syntax.Infix.Left
                                    (H.node
                                        596
                                        13
                                        597
                                        43
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "|>"
                                            Elm.Syntax.Infix.Left
                                            (H.node1
                                                596
                                                13
                                                64
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        596
                                                        13
                                                        26
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            [ "JsArray" ]
                                                            "foldl"
                                                        )
                                                    , H.node1
                                                        596
                                                        27
                                                        37
                                                        (H.val "foldHelper")
                                                    , H.node1
                                                        596
                                                        38
                                                        58
                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                            (H.node1
                                                                596
                                                                39
                                                                57
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        596
                                                                        39
                                                                        55
                                                                        (H.val
                                                                            "builderFromArray"
                                                                        )
                                                                    , H.node1
                                                                        596
                                                                        56
                                                                        57
                                                                        (H.val
                                                                            "a"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                        )
                                                    , H.node1
                                                        596
                                                        59
                                                        64
                                                        (H.val "bTree")
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                597
                                                20
                                                43
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        597
                                                        20
                                                        37
                                                        (H.val
                                                            "appendHelpBuilder"
                                                        )
                                                    , H.node1
                                                        597
                                                        38
                                                        43
                                                        (H.val "bTail")
                                                    ]
                                                )
                                            )
                                        )
                                    )
                                    (H.node1
                                        598
                                        20
                                        39
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                598
                                                20
                                                34
                                                (H.val "builderToArray")
                                            , H.node1 598 35 39 (H.val "True")
                                            ]
                                        )
                                    )
                                )
                        }
                    )
                )
            )
    }


appendHelpTree : Elm.Syntax.Expression.FunctionImplementation
appendHelpTree =
    { name = H.node1 602 1 15 "Array.appendHelpTree"
    , arguments =
        [ H.node1 602 16 24 (Elm.Syntax.Pattern.VarPattern "toAppend")
        , H.node1
            602
            25
            71
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    602
                    26
                    70
                    (Elm.Syntax.Pattern.AsPattern
                        (H.node1
                            602
                            26
                            61
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (H.node1
                                    602
                                    27
                                    60
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ H.node1
                                            602
                                            45
                                            48
                                            (Elm.Syntax.Pattern.VarPattern "len"
                                            )
                                        , H.node1
                                            602
                                            49
                                            50
                                            Elm.Syntax.Pattern.AllPattern
                                        , H.node1
                                            602
                                            51
                                            55
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tree"
                                            )
                                        , H.node1
                                            602
                                            56
                                            60
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node1 602 65 70 "array")
                    )
                )
            )
        ]
    , expression =
        H.node
            603
            5
            623
            21
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        604
                        9
                        605
                        55
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    604
                                    9
                                    605
                                    55
                                    { name = H.node1 604 9 17 "appended"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            605
                                            13
                                            55
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    605
                                                    13
                                                    28
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "appendN"
                                                    )
                                                , H.node1
                                                    605
                                                    29
                                                    41
                                                    (H.val "branchFactor")
                                                , H.node1
                                                    605
                                                    42
                                                    46
                                                    (H.val "tail")
                                                , H.node1
                                                    605
                                                    47
                                                    55
                                                    (H.val "toAppend")
                                                ]
                                            )
                                    }
                            }
                        )
                    , H.node
                        607
                        9
                        608
                        36
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    607
                                    9
                                    608
                                    36
                                    { name = H.node1 607 9 22 "itemsToAppend"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            608
                                            13
                                            36
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    608
                                                    13
                                                    27
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "length"
                                                    )
                                                , H.node1
                                                    608
                                                    28
                                                    36
                                                    (H.val "toAppend")
                                                ]
                                            )
                                    }
                            }
                        )
                    , H.node
                        610
                        9
                        611
                        65
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    610
                                    9
                                    611
                                    65
                                    { name = H.node1 610 9 20 "notAppended"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            611
                                            13
                                            65
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "-"
                                                Elm.Syntax.Infix.Left
                                                (H.node1
                                                    611
                                                    13
                                                    49
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            611
                                                            13
                                                            25
                                                            (H.val
                                                                "branchFactor"
                                                            )
                                                        )
                                                        (H.node1
                                                            611
                                                            28
                                                            49
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    611
                                                                    29
                                                                    48
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            611
                                                                            29
                                                                            43
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "length"
                                                                            )
                                                                        , H.node1
                                                                            611
                                                                            44
                                                                            48
                                                                            (H.val
                                                                                "tail"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                                (H.node1
                                                    611
                                                    52
                                                    65
                                                    (H.val "itemsToAppend")
                                                )
                                            )
                                    }
                            }
                        )
                    , H.node
                        613
                        9
                        614
                        45
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    613
                                    9
                                    614
                                    45
                                    { name = H.node1 613 9 17 "newArray"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            614
                                            13
                                            45
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    614
                                                    13
                                                    30
                                                    (H.val "unsafeReplaceTail")
                                                , H.node1
                                                    614
                                                    31
                                                    39
                                                    (H.val "appended")
                                                , H.node1
                                                    614
                                                    40
                                                    45
                                                    (H.val "array")
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        616
                        9
                        623
                        21
                        (Elm.Syntax.Expression.IfBlock
                            (H.node1
                                616
                                12
                                27
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<"
                                    Elm.Syntax.Infix.Non
                                    (H.node1 616 12 23 (H.val "notAppended"))
                                    (H.node1
                                        616
                                        26
                                        27
                                        (Elm.Syntax.Expression.Integer 0)
                                    )
                                )
                            )
                            (H.node
                                617
                                13
                                621
                                52
                                (Elm.Syntax.Expression.LetExpression
                                    { declarations =
                                        [ H.node
                                            618
                                            17
                                            619
                                            69
                                            (Elm.Syntax.Expression.LetFunction
                                                { documentation = Nothing
                                                , signature = Nothing
                                                , declaration =
                                                    H.node
                                                        618
                                                        17
                                                        619
                                                        69
                                                        { name =
                                                            H.node1
                                                                618
                                                                17
                                                                25
                                                                "nextTail"
                                                        , arguments = []
                                                        , expression =
                                                            H.node1
                                                                619
                                                                21
                                                                69
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        619
                                                                        21
                                                                        34
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            [ "JsArray"
                                                                            ]
                                                                            "slice"
                                                                        )
                                                                    , H.node1
                                                                        619
                                                                        35
                                                                        46
                                                                        (H.val
                                                                            "notAppended"
                                                                        )
                                                                    , H.node1
                                                                        619
                                                                        47
                                                                        60
                                                                        (H.val
                                                                            "itemsToAppend"
                                                                        )
                                                                    , H.node1
                                                                        619
                                                                        61
                                                                        69
                                                                        (H.val
                                                                            "toAppend"
                                                                        )
                                                                    ]
                                                                )
                                                        }
                                                }
                                            )
                                        ]
                                    , expression =
                                        H.node1
                                            621
                                            17
                                            52
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    621
                                                    17
                                                    34
                                                    (H.val "unsafeReplaceTail")
                                                , H.node1
                                                    621
                                                    35
                                                    43
                                                    (H.val "nextTail")
                                                , H.node1
                                                    621
                                                    44
                                                    52
                                                    (H.val "newArray")
                                                ]
                                            )
                                    }
                                )
                            )
                            (H.node1 623 13 21 (H.val "newArray"))
                        )
                }
            )
    }


appendHelpBuilder : Elm.Syntax.Expression.FunctionImplementation
appendHelpBuilder =
    { name = H.node1 627 1 18 "Array.appendHelpBuilder"
    , arguments =
        [ H.node1 627 19 23 (Elm.Syntax.Pattern.VarPattern "tail")
        , H.node1 627 24 31 (Elm.Syntax.Pattern.VarPattern "builder")
        ]
    , expression =
        H.node
            628
            5
            652
            14
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        629
                        9
                        630
                        59
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    629
                                    9
                                    630
                                    59
                                    { name = H.node1 629 9 17 "appended"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            630
                                            13
                                            59
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    630
                                                    13
                                                    28
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "appendN"
                                                    )
                                                , H.node1
                                                    630
                                                    29
                                                    41
                                                    (H.val "branchFactor")
                                                , H.node1
                                                    630
                                                    42
                                                    54
                                                    (Elm.Syntax.Expression.RecordAccess
                                                        (H.node1
                                                            630
                                                            42
                                                            49
                                                            (H.val "builder")
                                                        )
                                                        (H.node1
                                                            630
                                                            50
                                                            54
                                                            "tail"
                                                        )
                                                    )
                                                , H.node1
                                                    630
                                                    55
                                                    59
                                                    (H.val "tail")
                                                ]
                                            )
                                    }
                            }
                        )
                    , H.node
                        632
                        9
                        633
                        32
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    632
                                    9
                                    633
                                    32
                                    { name = H.node1 632 9 16 "tailLen"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            633
                                            13
                                            32
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    633
                                                    13
                                                    27
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "length"
                                                    )
                                                , H.node1
                                                    633
                                                    28
                                                    32
                                                    (H.val "tail")
                                                ]
                                            )
                                    }
                            }
                        )
                    , H.node
                        635
                        9
                        636
                        67
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    635
                                    9
                                    636
                                    67
                                    { name = H.node1 635 9 20 "notAppended"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            636
                                            13
                                            67
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "-"
                                                Elm.Syntax.Infix.Left
                                                (H.node1
                                                    636
                                                    13
                                                    57
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            636
                                                            13
                                                            25
                                                            (H.val
                                                                "branchFactor"
                                                            )
                                                        )
                                                        (H.node1
                                                            636
                                                            28
                                                            57
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    636
                                                                    29
                                                                    56
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            636
                                                                            29
                                                                            43
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "length"
                                                                            )
                                                                        , H.node1
                                                                            636
                                                                            44
                                                                            56
                                                                            (Elm.Syntax.Expression.RecordAccess
                                                                                (H.node1
                                                                                    636
                                                                                    44
                                                                                    51
                                                                                    (H.val
                                                                                        "builder"
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    636
                                                                                    52
                                                                                    56
                                                                                    "tail"
                                                                                )
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                                (H.node1
                                                    636
                                                    60
                                                    67
                                                    (H.val "tailLen")
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        638
                        9
                        652
                        14
                        (Elm.Syntax.Expression.IfBlock
                            (H.node1
                                638
                                12
                                27
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<"
                                    Elm.Syntax.Infix.Non
                                    (H.node1 638 12 23 (H.val "notAppended"))
                                    (H.node1
                                        638
                                        26
                                        27
                                        (Elm.Syntax.Expression.Integer 0)
                                    )
                                )
                            )
                            (H.node
                                639
                                13
                                642
                                14
                                (Elm.Syntax.Expression.RecordExpr
                                    [ H.node1
                                        639
                                        15
                                        60
                                        ( H.node1 639 15 19 "tail"
                                        , H.node1
                                            639
                                            22
                                            60
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    639
                                                    22
                                                    35
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "slice"
                                                    )
                                                , H.node1
                                                    639
                                                    36
                                                    47
                                                    (H.val "notAppended")
                                                , H.node1
                                                    639
                                                    48
                                                    55
                                                    (H.val "tailLen")
                                                , H.node1
                                                    639
                                                    56
                                                    60
                                                    (H.val "tail")
                                                ]
                                            )
                                        )
                                    , H.node
                                        640
                                        15
                                        641
                                        13
                                        ( H.node1 640 15 23 "nodeList"
                                        , H.node1
                                            640
                                            26
                                            59
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "::"
                                                Elm.Syntax.Infix.Right
                                                (H.node1
                                                    640
                                                    26
                                                    39
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            640
                                                            26
                                                            30
                                                            (H.val "Leaf")
                                                        , H.node1
                                                            640
                                                            31
                                                            39
                                                            (H.val "appended")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    640
                                                    43
                                                    59
                                                    (Elm.Syntax.Expression.RecordAccess
                                                        (H.node1
                                                            640
                                                            43
                                                            50
                                                            (H.val "builder")
                                                        )
                                                        (H.node1
                                                            640
                                                            51
                                                            59
                                                            "nodeList"
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    , H.node
                                        641
                                        15
                                        642
                                        13
                                        ( H.node1 641 15 27 "nodeListSize"
                                        , H.node1
                                            641
                                            30
                                            54
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "+"
                                                Elm.Syntax.Infix.Left
                                                (H.node1
                                                    641
                                                    30
                                                    50
                                                    (Elm.Syntax.Expression.RecordAccess
                                                        (H.node1
                                                            641
                                                            30
                                                            37
                                                            (H.val "builder")
                                                        )
                                                        (H.node1
                                                            641
                                                            38
                                                            50
                                                            "nodeListSize"
                                                        )
                                                    )
                                                )
                                                (H.node1
                                                    641
                                                    53
                                                    54
                                                    (Elm.Syntax.Expression.Integer
                                                        1
                                                    )
                                                )
                                            )
                                        )
                                    ]
                                )
                            )
                            (H.node
                                643
                                14
                                652
                                14
                                (Elm.Syntax.Expression.IfBlock
                                    (H.node1
                                        643
                                        17
                                        33
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "=="
                                            Elm.Syntax.Infix.Non
                                            (H.node1
                                                643
                                                17
                                                28
                                                (H.val "notAppended")
                                            )
                                            (H.node1
                                                643
                                                32
                                                33
                                                (Elm.Syntax.Expression.Integer 0
                                                )
                                            )
                                        )
                                    )
                                    (H.node
                                        644
                                        13
                                        647
                                        14
                                        (Elm.Syntax.Expression.RecordExpr
                                            [ H.node1
                                                644
                                                15
                                                35
                                                ( H.node1 644 15 19 "tail"
                                                , H.node1
                                                    644
                                                    22
                                                    35
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "JsArray" ]
                                                        "empty"
                                                    )
                                                )
                                            , H.node
                                                645
                                                15
                                                646
                                                13
                                                ( H.node1 645 15 23 "nodeList"
                                                , H.node1
                                                    645
                                                    26
                                                    59
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "::"
                                                        Elm.Syntax.Infix.Right
                                                        (H.node1
                                                            645
                                                            26
                                                            39
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    645
                                                                    26
                                                                    30
                                                                    (H.val
                                                                        "Leaf"
                                                                    )
                                                                , H.node1
                                                                    645
                                                                    31
                                                                    39
                                                                    (H.val
                                                                        "appended"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                        (H.node1
                                                            645
                                                            43
                                                            59
                                                            (Elm.Syntax.Expression.RecordAccess
                                                                (H.node1
                                                                    645
                                                                    43
                                                                    50
                                                                    (H.val
                                                                        "builder"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    645
                                                                    51
                                                                    59
                                                                    "nodeList"
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            , H.node
                                                646
                                                15
                                                647
                                                13
                                                ( H.node1
                                                    646
                                                    15
                                                    27
                                                    "nodeListSize"
                                                , H.node1
                                                    646
                                                    30
                                                    54
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "+"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            646
                                                            30
                                                            50
                                                            (Elm.Syntax.Expression.RecordAccess
                                                                (H.node1
                                                                    646
                                                                    30
                                                                    37
                                                                    (H.val
                                                                        "builder"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    646
                                                                    38
                                                                    50
                                                                    "nodeListSize"
                                                                )
                                                            )
                                                        )
                                                        (H.node1
                                                            646
                                                            53
                                                            54
                                                            (Elm.Syntax.Expression.Integer
                                                                1
                                                            )
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                    )
                                    (H.node
                                        649
                                        13
                                        652
                                        14
                                        (Elm.Syntax.Expression.RecordExpr
                                            [ H.node1
                                                649
                                                15
                                                30
                                                ( H.node1 649 15 19 "tail"
                                                , H.node1
                                                    649
                                                    22
                                                    30
                                                    (H.val "appended")
                                                )
                                            , H.node
                                                650
                                                15
                                                651
                                                13
                                                ( H.node1 650 15 23 "nodeList"
                                                , H.node1
                                                    650
                                                    26
                                                    42
                                                    (Elm.Syntax.Expression.RecordAccess
                                                        (H.node1
                                                            650
                                                            26
                                                            33
                                                            (H.val "builder")
                                                        )
                                                        (H.node1
                                                            650
                                                            34
                                                            42
                                                            "nodeList"
                                                        )
                                                    )
                                                )
                                            , H.node
                                                651
                                                15
                                                652
                                                13
                                                ( H.node1
                                                    651
                                                    15
                                                    27
                                                    "nodeListSize"
                                                , H.node1
                                                    651
                                                    30
                                                    50
                                                    (Elm.Syntax.Expression.RecordAccess
                                                        (H.node1
                                                            651
                                                            30
                                                            37
                                                            (H.val "builder")
                                                        )
                                                        (H.node1
                                                            651
                                                            38
                                                            50
                                                            "nodeListSize"
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


slice : Elm.Syntax.Expression.FunctionImplementation
slice =
    { name = H.node1 673 1 6 "Array.slice"
    , arguments =
        [ H.node1 673 7 11 (Elm.Syntax.Pattern.VarPattern "from")
        , H.node1 673 12 14 (Elm.Syntax.Pattern.VarPattern "to")
        , H.node1 673 15 20 (Elm.Syntax.Pattern.VarPattern "array")
        ]
    , expression =
        H.node
            674
            5
            686
            41
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        675
                        9
                        676
                        38
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    675
                                    9
                                    676
                                    38
                                    { name = H.node1 675 9 20 "correctFrom"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            676
                                            13
                                            38
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    676
                                                    13
                                                    27
                                                    (H.val "translateIndex")
                                                , H.node1
                                                    676
                                                    28
                                                    32
                                                    (H.val "from")
                                                , H.node1
                                                    676
                                                    33
                                                    38
                                                    (H.val "array")
                                                ]
                                            )
                                    }
                            }
                        )
                    , H.node
                        678
                        9
                        679
                        36
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    678
                                    9
                                    679
                                    36
                                    { name = H.node1 678 9 18 "correctTo"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            679
                                            13
                                            36
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    679
                                                    13
                                                    27
                                                    (H.val "translateIndex")
                                                , H.node1 679 28 30 (H.val "to")
                                                , H.node1
                                                    679
                                                    31
                                                    36
                                                    (H.val "array")
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        681
                        9
                        686
                        41
                        (Elm.Syntax.Expression.IfBlock
                            (H.node1
                                681
                                12
                                35
                                (Elm.Syntax.Expression.OperatorApplication
                                    ">"
                                    Elm.Syntax.Infix.Non
                                    (H.node1 681 12 23 (H.val "correctFrom"))
                                    (H.node1 681 26 35 (H.val "correctTo"))
                                )
                            )
                            (H.node1 682 13 18 (H.val "empty"))
                            (H.node
                                684
                                13
                                686
                                41
                                (Elm.Syntax.Expression.OperatorApplication
                                    "|>"
                                    Elm.Syntax.Infix.Left
                                    (H.node
                                        684
                                        13
                                        685
                                        40
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "|>"
                                            Elm.Syntax.Infix.Left
                                            (H.node1 684 13 18 (H.val "array"))
                                            (H.node1
                                                685
                                                20
                                                40
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        685
                                                        20
                                                        30
                                                        (H.val "sliceRight")
                                                    , H.node1
                                                        685
                                                        31
                                                        40
                                                        (H.val "correctTo")
                                                    ]
                                                )
                                            )
                                        )
                                    )
                                    (H.node1
                                        686
                                        20
                                        41
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                686
                                                20
                                                29
                                                (H.val "sliceLeft")
                                            , H.node1
                                                686
                                                30
                                                41
                                                (H.val "correctFrom")
                                            ]
                                        )
                                    )
                                )
                            )
                        )
                }
            )
    }


translateIndex : Elm.Syntax.Expression.FunctionImplementation
translateIndex =
    { name = H.node1 696 1 15 "Array.translateIndex"
    , arguments =
        [ H.node1 696 16 21 (Elm.Syntax.Pattern.VarPattern "index")
        , H.node1
            696
            22
            51
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    696
                    23
                    50
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ H.node1
                            696
                            41
                            44
                            (Elm.Syntax.Pattern.VarPattern "len")
                        , H.node1 696 45 46 Elm.Syntax.Pattern.AllPattern
                        , H.node1 696 47 48 Elm.Syntax.Pattern.AllPattern
                        , H.node1 696 49 50 Elm.Syntax.Pattern.AllPattern
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node
            697
            5
            709
            21
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        698
                        9
                        702
                        22
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    698
                                    9
                                    702
                                    22
                                    { name = H.node1 698 9 17 "posIndex"
                                    , arguments = []
                                    , expression =
                                        H.node
                                            699
                                            13
                                            702
                                            22
                                            (Elm.Syntax.Expression.IfBlock
                                                (H.node1
                                                    699
                                                    16
                                                    25
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "<"
                                                        Elm.Syntax.Infix.Non
                                                        (H.node1
                                                            699
                                                            16
                                                            21
                                                            (H.val "index")
                                                        )
                                                        (H.node1
                                                            699
                                                            24
                                                            25
                                                            (Elm.Syntax.Expression.Integer
                                                                0
                                                            )
                                                        )
                                                    )
                                                )
                                                (H.node1
                                                    700
                                                    17
                                                    28
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "+"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            700
                                                            17
                                                            20
                                                            (H.val "len")
                                                        )
                                                        (H.node1
                                                            700
                                                            23
                                                            28
                                                            (H.val "index")
                                                        )
                                                    )
                                                )
                                                (H.node1
                                                    702
                                                    17
                                                    22
                                                    (H.val "index")
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        704
                        9
                        709
                        21
                        (Elm.Syntax.Expression.IfBlock
                            (H.node1
                                704
                                12
                                24
                                (Elm.Syntax.Expression.OperatorApplication
                                    "<"
                                    Elm.Syntax.Infix.Non
                                    (H.node1 704 12 20 (H.val "posIndex"))
                                    (H.node1
                                        704
                                        23
                                        24
                                        (Elm.Syntax.Expression.Integer 0)
                                    )
                                )
                            )
                            (H.node1 705 13 14 (Elm.Syntax.Expression.Integer 0)
                            )
                            (H.node
                                706
                                14
                                709
                                21
                                (Elm.Syntax.Expression.IfBlock
                                    (H.node1
                                        706
                                        17
                                        31
                                        (Elm.Syntax.Expression.OperatorApplication
                                            ">"
                                            Elm.Syntax.Infix.Non
                                            (H.node1
                                                706
                                                17
                                                25
                                                (H.val "posIndex")
                                            )
                                            (H.node1 706 28 31 (H.val "len"))
                                        )
                                    )
                                    (H.node1 707 13 16 (H.val "len"))
                                    (H.node1 709 13 21 (H.val "posIndex"))
                                )
                            )
                        )
                }
            )
    }


sliceRight : Elm.Syntax.Expression.FunctionImplementation
sliceRight =
    { name = H.node1 725 1 11 "Array.sliceRight"
    , arguments =
        [ H.node1 725 12 15 (Elm.Syntax.Pattern.VarPattern "end")
        , H.node1
            725
            16
            71
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    725
                    17
                    70
                    (Elm.Syntax.Pattern.AsPattern
                        (H.node1
                            725
                            17
                            61
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (H.node1
                                    725
                                    18
                                    60
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ H.node1
                                            725
                                            36
                                            39
                                            (Elm.Syntax.Pattern.VarPattern "len"
                                            )
                                        , H.node1
                                            725
                                            40
                                            50
                                            (Elm.Syntax.Pattern.VarPattern
                                                "startShift"
                                            )
                                        , H.node1
                                            725
                                            51
                                            55
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tree"
                                            )
                                        , H.node1
                                            725
                                            56
                                            60
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node1 725 65 70 "array")
                    )
                )
            )
        ]
    , expression =
        H.node
            726
            5
            753
            58
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    726
                    8
                    18
                    (Elm.Syntax.Expression.OperatorApplication
                        "=="
                        Elm.Syntax.Infix.Non
                        (H.node1 726 8 11 (H.val "end"))
                        (H.node1 726 15 18 (H.val "len"))
                    )
                )
                (H.node1 727 9 14 (H.val "array"))
                (H.node
                    728
                    10
                    753
                    58
                    (Elm.Syntax.Expression.IfBlock
                        (H.node1
                            728
                            13
                            33
                            (Elm.Syntax.Expression.OperatorApplication
                                ">="
                                Elm.Syntax.Infix.Non
                                (H.node1 728 13 16 (H.val "end"))
                                (H.node1
                                    728
                                    20
                                    33
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 728 20 29 (H.val "tailIndex")
                                        , H.node1 728 30 33 (H.val "len")
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node
                            729
                            9
                            730
                            59
                            (Elm.Syntax.Expression.OperatorApplication
                                "<|"
                                Elm.Syntax.Infix.Right
                                (H.node1
                                    729
                                    9
                                    46
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            729
                                            9
                                            26
                                            (H.val "Array_elm_builtin")
                                        , H.node1 729 27 30 (H.val "end")
                                        , H.node1 729 31 41 (H.val "startShift")
                                        , H.node1 729 42 46 (H.val "tree")
                                        ]
                                    )
                                )
                                (H.node1
                                    730
                                    13
                                    59
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            730
                                            13
                                            26
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "slice"
                                            )
                                        , H.node1
                                            730
                                            27
                                            28
                                            (Elm.Syntax.Expression.Integer 0)
                                        , H.node1
                                            730
                                            29
                                            54
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    730
                                                    30
                                                    53
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            730
                                                            30
                                                            41
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , H.node1
                                                            730
                                                            42
                                                            49
                                                            (H.val "bitMask")
                                                        , H.node1
                                                            730
                                                            50
                                                            53
                                                            (H.val "end")
                                                        ]
                                                    )
                                                )
                                            )
                                        , H.node1 730 55 59 (H.val "tail")
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node
                            732
                            9
                            753
                            58
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ H.node
                                        733
                                        13
                                        734
                                        30
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    733
                                                    13
                                                    734
                                                    30
                                                    { name =
                                                        H.node1
                                                            733
                                                            13
                                                            19
                                                            "endIdx"
                                                    , arguments = []
                                                    , expression =
                                                        H.node1
                                                            734
                                                            17
                                                            30
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    734
                                                                    17
                                                                    26
                                                                    (H.val
                                                                        "tailIndex"
                                                                    )
                                                                , H.node1
                                                                    734
                                                                    27
                                                                    30
                                                                    (H.val "end"
                                                                    )
                                                                ]
                                                            )
                                                    }
                                            }
                                        )
                                    , H.node
                                        736
                                        13
                                        741
                                        29
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    736
                                                    13
                                                    741
                                                    29
                                                    { name =
                                                        H.node1
                                                            736
                                                            13
                                                            18
                                                            "depth"
                                                    , arguments = []
                                                    , expression =
                                                        H.node
                                                            737
                                                            17
                                                            741
                                                            29
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "|>"
                                                                Elm.Syntax.Infix.Left
                                                                (H.node
                                                                    737
                                                                    17
                                                                    740
                                                                    54
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "|>"
                                                                        Elm.Syntax.Infix.Left
                                                                        (H.node
                                                                            737
                                                                            17
                                                                            739
                                                                            31
                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                "|>"
                                                                                Elm.Syntax.Infix.Left
                                                                                (H.node
                                                                                    737
                                                                                    17
                                                                                    738
                                                                                    29
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "|>"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (H.node1
                                                                                            737
                                                                                            17
                                                                                            29
                                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                (H.node1
                                                                                                    737
                                                                                                    18
                                                                                                    28
                                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                                        "-"
                                                                                                        Elm.Syntax.Infix.Left
                                                                                                        (H.node1
                                                                                                            737
                                                                                                            18
                                                                                                            24
                                                                                                            (H.val
                                                                                                                "endIdx"
                                                                                                            )
                                                                                                        )
                                                                                                        (H.node1
                                                                                                            737
                                                                                                            27
                                                                                                            28
                                                                                                            (Elm.Syntax.Expression.Integer
                                                                                                                1
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                        (H.node1
                                                                                            738
                                                                                            24
                                                                                            29
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    738
                                                                                                    24
                                                                                                    27
                                                                                                    (H.val
                                                                                                        "max"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    738
                                                                                                    28
                                                                                                    29
                                                                                                    (Elm.Syntax.Expression.Integer
                                                                                                        1
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    739
                                                                                    24
                                                                                    31
                                                                                    (H.val
                                                                                        "toFloat"
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            740
                                                                            24
                                                                            54
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    740
                                                                                    24
                                                                                    31
                                                                                    (H.val
                                                                                        "logBase"
                                                                                    )
                                                                                , H.node1
                                                                                    740
                                                                                    32
                                                                                    54
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (H.node1
                                                                                            740
                                                                                            33
                                                                                            53
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    740
                                                                                                    33
                                                                                                    40
                                                                                                    (H.val
                                                                                                        "toFloat"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    740
                                                                                                    41
                                                                                                    53
                                                                                                    (H.val
                                                                                                        "branchFactor"
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
                                                                (H.node1
                                                                    741
                                                                    24
                                                                    29
                                                                    (H.val
                                                                        "floor"
                                                                    )
                                                                )
                                                            )
                                                    }
                                            }
                                        )
                                    , H.node
                                        743
                                        13
                                        744
                                        43
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    743
                                                    13
                                                    744
                                                    43
                                                    { name =
                                                        H.node1
                                                            743
                                                            13
                                                            21
                                                            "newShift"
                                                    , arguments = []
                                                    , expression =
                                                        H.node1
                                                            744
                                                            17
                                                            43
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "<|"
                                                                Elm.Syntax.Infix.Right
                                                                (H.node1
                                                                    744
                                                                    17
                                                                    22
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            744
                                                                            17
                                                                            20
                                                                            (H.val
                                                                                "max"
                                                                            )
                                                                        , H.node1
                                                                            744
                                                                            21
                                                                            22
                                                                            (Elm.Syntax.Expression.Integer
                                                                                5
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                                (H.node1
                                                                    744
                                                                    26
                                                                    43
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "*"
                                                                        Elm.Syntax.Infix.Left
                                                                        (H.node1
                                                                            744
                                                                            26
                                                                            31
                                                                            (H.val
                                                                                "depth"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            744
                                                                            34
                                                                            43
                                                                            (H.val
                                                                                "shiftStep"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                    }
                                            }
                                        )
                                    ]
                                , expression =
                                    H.node
                                        746
                                        13
                                        753
                                        58
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                746
                                                13
                                                30
                                                (H.val "Array_elm_builtin")
                                            , H.node1 747 17 20 (H.val "end")
                                            , H.node1
                                                748
                                                17
                                                25
                                                (H.val "newShift")
                                            , H.node
                                                749
                                                17
                                                752
                                                18
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node
                                                        749
                                                        18
                                                        751
                                                        53
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "|>"
                                                            Elm.Syntax.Infix.Left
                                                            (H.node
                                                                749
                                                                18
                                                                750
                                                                51
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    "|>"
                                                                    Elm.Syntax.Infix.Left
                                                                    (H.node1
                                                                        749
                                                                        18
                                                                        22
                                                                        (H.val
                                                                            "tree"
                                                                        )
                                                                    )
                                                                    (H.node1
                                                                        750
                                                                        24
                                                                        51
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                750
                                                                                24
                                                                                33
                                                                                (H.val
                                                                                    "sliceTree"
                                                                                )
                                                                            , H.node1
                                                                                750
                                                                                34
                                                                                44
                                                                                (H.val
                                                                                    "startShift"
                                                                                )
                                                                            , H.node1
                                                                                750
                                                                                45
                                                                                51
                                                                                (H.val
                                                                                    "endIdx"
                                                                                )
                                                                            ]
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                            (H.node1
                                                                751
                                                                24
                                                                53
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        751
                                                                        24
                                                                        33
                                                                        (H.val
                                                                            "hoistTree"
                                                                        )
                                                                    , H.node1
                                                                        751
                                                                        34
                                                                        44
                                                                        (H.val
                                                                            "startShift"
                                                                        )
                                                                    , H.node1
                                                                        751
                                                                        45
                                                                        53
                                                                        (H.val
                                                                            "newShift"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            , H.node1
                                                753
                                                17
                                                58
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        753
                                                        18
                                                        57
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                753
                                                                18
                                                                30
                                                                (H.val
                                                                    "fetchNewTail"
                                                                )
                                                            , H.node1
                                                                753
                                                                31
                                                                41
                                                                (H.val
                                                                    "startShift"
                                                                )
                                                            , H.node1
                                                                753
                                                                42
                                                                45
                                                                (H.val "end")
                                                            , H.node1
                                                                753
                                                                46
                                                                52
                                                                (H.val "endIdx")
                                                            , H.node1
                                                                753
                                                                53
                                                                57
                                                                (H.val "tree")
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
                )
            )
    }


fetchNewTail : Elm.Syntax.Expression.FunctionImplementation
fetchNewTail =
    { name = H.node1 760 1 13 "Array.fetchNewTail"
    , arguments =
        [ H.node1 760 14 19 (Elm.Syntax.Pattern.VarPattern "shift")
        , H.node1 760 20 23 (Elm.Syntax.Pattern.VarPattern "end")
        , H.node1 760 24 31 (Elm.Syntax.Pattern.VarPattern "treeEnd")
        , H.node1 760 32 36 (Elm.Syntax.Pattern.VarPattern "tree")
        ]
    , expression =
        H.node
            761
            5
            770
            65
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        762
                        9
                        763
                        72
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    762
                                    9
                                    763
                                    72
                                    { name = H.node1 762 9 12 "pos"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            763
                                            13
                                            72
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "<|"
                                                Elm.Syntax.Infix.Right
                                                (H.node1
                                                    763
                                                    13
                                                    32
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            763
                                                            13
                                                            24
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , H.node1
                                                            763
                                                            25
                                                            32
                                                            (H.val "bitMask")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    763
                                                    36
                                                    72
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            763
                                                            36
                                                            58
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "shiftRightZfBy"
                                                            )
                                                        , H.node1
                                                            763
                                                            59
                                                            64
                                                            (H.val "shift")
                                                        , H.node1
                                                            763
                                                            65
                                                            72
                                                            (H.val "treeEnd")
                                                        ]
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        765
                        9
                        770
                        65
                        (Elm.Syntax.Expression.CaseExpression
                            { expression =
                                H.node1
                                    765
                                    14
                                    40
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            765
                                            14
                                            31
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "unsafeGet"
                                            )
                                        , H.node1 765 32 35 (H.val "pos")
                                        , H.node1 765 36 40 (H.val "tree")
                                        ]
                                    )
                            , cases =
                                [ ( H.node1
                                        766
                                        13
                                        24
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = []
                                            , name = "SubTree"
                                            }
                                            [ H.node1
                                                766
                                                21
                                                24
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "sub"
                                                )
                                            ]
                                        )
                                  , H.node1
                                        767
                                        17
                                        65
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                767
                                                17
                                                29
                                                (H.val "fetchNewTail")
                                            , H.node1
                                                767
                                                30
                                                49
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        767
                                                        31
                                                        48
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "-"
                                                            Elm.Syntax.Infix.Left
                                                            (H.node1
                                                                767
                                                                31
                                                                36
                                                                (H.val "shift")
                                                            )
                                                            (H.node1
                                                                767
                                                                39
                                                                48
                                                                (H.val
                                                                    "shiftStep"
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            , H.node1 767 50 53 (H.val "end")
                                            , H.node1
                                                767
                                                54
                                                61
                                                (H.val "treeEnd")
                                            , H.node1 767 62 65 (H.val "sub")
                                            ]
                                        )
                                  )
                                , ( H.node1
                                        769
                                        13
                                        24
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = [], name = "Leaf" }
                                            [ H.node1
                                                769
                                                18
                                                24
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "values"
                                                )
                                            ]
                                        )
                                  , H.node1
                                        770
                                        17
                                        65
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                770
                                                17
                                                30
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "slice"
                                                )
                                            , H.node1
                                                770
                                                31
                                                32
                                                (Elm.Syntax.Expression.Integer 0
                                                )
                                            , H.node1
                                                770
                                                33
                                                58
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        770
                                                        34
                                                        57
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                770
                                                                34
                                                                45
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    [ "Bitwise"
                                                                    ]
                                                                    "and"
                                                                )
                                                            , H.node1
                                                                770
                                                                46
                                                                53
                                                                (H.val "bitMask"
                                                                )
                                                            , H.node1
                                                                770
                                                                54
                                                                57
                                                                (H.val "end")
                                                            ]
                                                        )
                                                    )
                                                )
                                            , H.node1 770 59 65 (H.val "values")
                                            ]
                                        )
                                  )
                                ]
                            }
                        )
                }
            )
    }


sliceTree : Elm.Syntax.Expression.FunctionImplementation
sliceTree =
    { name = H.node1 778 1 10 "Array.sliceTree"
    , arguments =
        [ H.node1 778 11 16 (Elm.Syntax.Pattern.VarPattern "shift")
        , H.node1 778 17 23 (Elm.Syntax.Pattern.VarPattern "endIdx")
        , H.node1 778 24 28 (Elm.Syntax.Pattern.VarPattern "tree")
        ]
    , expression =
        H.node
            779
            5
            800
            45
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        780
                        9
                        781
                        71
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    780
                                    9
                                    781
                                    71
                                    { name = H.node1 780 9 16 "lastPos"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            781
                                            13
                                            71
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "<|"
                                                Elm.Syntax.Infix.Right
                                                (H.node1
                                                    781
                                                    13
                                                    32
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            781
                                                            13
                                                            24
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "and"
                                                            )
                                                        , H.node1
                                                            781
                                                            25
                                                            32
                                                            (H.val "bitMask")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    781
                                                    36
                                                    71
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            781
                                                            36
                                                            58
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Bitwise" ]
                                                                "shiftRightZfBy"
                                                            )
                                                        , H.node1
                                                            781
                                                            59
                                                            64
                                                            (H.val "shift")
                                                        , H.node1
                                                            781
                                                            65
                                                            71
                                                            (H.val "endIdx")
                                                        ]
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        783
                        9
                        800
                        45
                        (Elm.Syntax.Expression.CaseExpression
                            { expression =
                                H.node1
                                    783
                                    14
                                    44
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            783
                                            14
                                            31
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "unsafeGet"
                                            )
                                        , H.node1 783 32 39 (H.val "lastPos")
                                        , H.node1 783 40 44 (H.val "tree")
                                        ]
                                    )
                            , cases =
                                [ ( H.node1
                                        784
                                        13
                                        24
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = []
                                            , name = "SubTree"
                                            }
                                            [ H.node1
                                                784
                                                21
                                                24
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "sub"
                                                )
                                            ]
                                        )
                                  , H.node
                                        785
                                        17
                                        795
                                        74
                                        (Elm.Syntax.Expression.LetExpression
                                            { declarations =
                                                [ H.node
                                                    786
                                                    21
                                                    787
                                                    65
                                                    (Elm.Syntax.Expression.LetFunction
                                                        { documentation =
                                                            Nothing
                                                        , signature = Nothing
                                                        , declaration =
                                                            H.node
                                                                786
                                                                21
                                                                787
                                                                65
                                                                { name =
                                                                    H.node1
                                                                        786
                                                                        21
                                                                        27
                                                                        "newSub"
                                                                , arguments = []
                                                                , expression =
                                                                    H.node1
                                                                        787
                                                                        25
                                                                        65
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                787
                                                                                25
                                                                                34
                                                                                (H.val
                                                                                    "sliceTree"
                                                                                )
                                                                            , H.node1
                                                                                787
                                                                                35
                                                                                54
                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                    (H.node1
                                                                                        787
                                                                                        36
                                                                                        53
                                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                                            "-"
                                                                                            Elm.Syntax.Infix.Left
                                                                                            (H.node1
                                                                                                787
                                                                                                36
                                                                                                41
                                                                                                (H.val
                                                                                                    "shift"
                                                                                                )
                                                                                            )
                                                                                            (H.node1
                                                                                                787
                                                                                                44
                                                                                                53
                                                                                                (H.val
                                                                                                    "shiftStep"
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                            , H.node1
                                                                                787
                                                                                55
                                                                                61
                                                                                (H.val
                                                                                    "endIdx"
                                                                                )
                                                                            , H.node1
                                                                                787
                                                                                62
                                                                                65
                                                                                (H.val
                                                                                    "sub"
                                                                                )
                                                                            ]
                                                                        )
                                                                }
                                                        }
                                                    )
                                                ]
                                            , expression =
                                                H.node
                                                    789
                                                    21
                                                    795
                                                    74
                                                    (Elm.Syntax.Expression.IfBlock
                                                        (H.node1
                                                            789
                                                            24
                                                            50
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "=="
                                                                Elm.Syntax.Infix.Non
                                                                (H.node1
                                                                    789
                                                                    24
                                                                    45
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            789
                                                                            24
                                                                            38
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "length"
                                                                            )
                                                                        , H.node1
                                                                            789
                                                                            39
                                                                            45
                                                                            (H.val
                                                                                "newSub"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                                (H.node1
                                                                    789
                                                                    49
                                                                    50
                                                                    (Elm.Syntax.Expression.Integer
                                                                        0
                                                                    )
                                                                )
                                                            )
                                                        )
                                                        (H.node1
                                                            791
                                                            25
                                                            53
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    791
                                                                    25
                                                                    38
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "slice"
                                                                    )
                                                                , H.node1
                                                                    791
                                                                    39
                                                                    40
                                                                    (Elm.Syntax.Expression.Integer
                                                                        0
                                                                    )
                                                                , H.node1
                                                                    791
                                                                    41
                                                                    48
                                                                    (H.val
                                                                        "lastPos"
                                                                    )
                                                                , H.node1
                                                                    791
                                                                    49
                                                                    53
                                                                    (H.val
                                                                        "tree"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                        (H.node
                                                            793
                                                            25
                                                            795
                                                            74
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "|>"
                                                                Elm.Syntax.Infix.Left
                                                                (H.node
                                                                    793
                                                                    25
                                                                    794
                                                                    61
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "|>"
                                                                        Elm.Syntax.Infix.Left
                                                                        (H.node1
                                                                            793
                                                                            25
                                                                            29
                                                                            (H.val
                                                                                "tree"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            794
                                                                            32
                                                                            61
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    794
                                                                                    32
                                                                                    45
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "JsArray"
                                                                                        ]
                                                                                        "slice"
                                                                                    )
                                                                                , H.node1
                                                                                    794
                                                                                    46
                                                                                    47
                                                                                    (Elm.Syntax.Expression.Integer
                                                                                        0
                                                                                    )
                                                                                , H.node1
                                                                                    794
                                                                                    48
                                                                                    61
                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                        (H.node1
                                                                                            794
                                                                                            49
                                                                                            60
                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                "+"
                                                                                                Elm.Syntax.Infix.Left
                                                                                                (H.node1
                                                                                                    794
                                                                                                    49
                                                                                                    56
                                                                                                    (H.val
                                                                                                        "lastPos"
                                                                                                    )
                                                                                                )
                                                                                                (H.node1
                                                                                                    794
                                                                                                    59
                                                                                                    60
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
                                                                )
                                                                (H.node1
                                                                    795
                                                                    32
                                                                    74
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            795
                                                                            32
                                                                            49
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "JsArray"
                                                                                ]
                                                                                "unsafeSet"
                                                                            )
                                                                        , H.node1
                                                                            795
                                                                            50
                                                                            57
                                                                            (H.val
                                                                                "lastPos"
                                                                            )
                                                                        , H.node1
                                                                            795
                                                                            58
                                                                            74
                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                (H.node1
                                                                                    795
                                                                                    59
                                                                                    73
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ H.node1
                                                                                            795
                                                                                            59
                                                                                            66
                                                                                            (H.val
                                                                                                "SubTree"
                                                                                            )
                                                                                        , H.node1
                                                                                            795
                                                                                            67
                                                                                            73
                                                                                            (H.val
                                                                                                "newSub"
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
                                                    )
                                            }
                                        )
                                  )
                                , ( H.node1
                                        799
                                        13
                                        19
                                        (Elm.Syntax.Pattern.NamedPattern
                                            { moduleName = [], name = "Leaf" }
                                            [ H.node1
                                                799
                                                18
                                                19
                                                Elm.Syntax.Pattern.AllPattern
                                            ]
                                        )
                                  , H.node1
                                        800
                                        17
                                        45
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                800
                                                17
                                                30
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "slice"
                                                )
                                            , H.node1
                                                800
                                                31
                                                32
                                                (Elm.Syntax.Expression.Integer 0
                                                )
                                            , H.node1
                                                800
                                                33
                                                40
                                                (H.val "lastPos")
                                            , H.node1 800 41 45 (H.val "tree")
                                            ]
                                        )
                                  )
                                ]
                            }
                        )
                }
            )
    }


hoistTree : Elm.Syntax.Expression.FunctionImplementation
hoistTree =
    { name = H.node1 809 1 10 "Array.hoistTree"
    , arguments =
        [ H.node1 809 11 19 (Elm.Syntax.Pattern.VarPattern "oldShift")
        , H.node1 809 20 28 (Elm.Syntax.Pattern.VarPattern "newShift")
        , H.node1 809 29 33 (Elm.Syntax.Pattern.VarPattern "tree")
        ]
    , expression =
        H.node
            810
            5
            818
            21
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    810
                    8
                    56
                    (Elm.Syntax.Expression.OperatorApplication
                        "||"
                        Elm.Syntax.Infix.Right
                        (H.node1
                            810
                            8
                            28
                            (Elm.Syntax.Expression.OperatorApplication
                                "<="
                                Elm.Syntax.Infix.Non
                                (H.node1 810 8 16 (H.val "oldShift"))
                                (H.node1 810 20 28 (H.val "newShift"))
                            )
                        )
                        (H.node1
                            810
                            32
                            56
                            (Elm.Syntax.Expression.OperatorApplication
                                "=="
                                Elm.Syntax.Infix.Non
                                (H.node1
                                    810
                                    32
                                    51
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            810
                                            32
                                            46
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "length"
                                            )
                                        , H.node1 810 47 51 (H.val "tree")
                                        ]
                                    )
                                )
                                (H.node1
                                    810
                                    55
                                    56
                                    (Elm.Syntax.Expression.Integer 0)
                                )
                            )
                        )
                    )
                )
                (H.node1 811 9 13 (H.val "tree"))
                (H.node
                    813
                    9
                    818
                    21
                    (Elm.Syntax.Expression.CaseExpression
                        { expression =
                            H.node1
                                813
                                14
                                38
                                (Elm.Syntax.Expression.Application
                                    [ H.node1
                                        813
                                        14
                                        31
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "JsArray" ]
                                            "unsafeGet"
                                        )
                                    , H.node1
                                        813
                                        32
                                        33
                                        (Elm.Syntax.Expression.Integer 0)
                                    , H.node1 813 34 38 (H.val "tree")
                                    ]
                                )
                        , cases =
                            [ ( H.node1
                                    814
                                    13
                                    24
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = [], name = "SubTree" }
                                        [ H.node1
                                            814
                                            21
                                            24
                                            (Elm.Syntax.Pattern.VarPattern "sub"
                                            )
                                        ]
                                    )
                              , H.node1
                                    815
                                    17
                                    62
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 815 17 26 (H.val "hoistTree")
                                        , H.node1
                                            815
                                            27
                                            49
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    815
                                                    28
                                                    48
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            815
                                                            28
                                                            36
                                                            (H.val "oldShift")
                                                        )
                                                        (H.node1
                                                            815
                                                            39
                                                            48
                                                            (H.val "shiftStep")
                                                        )
                                                    )
                                                )
                                            )
                                        , H.node1 815 50 58 (H.val "newShift")
                                        , H.node1 815 59 62 (H.val "sub")
                                        ]
                                    )
                              )
                            , ( H.node1
                                    817
                                    13
                                    19
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = [], name = "Leaf" }
                                        [ H.node1
                                            817
                                            18
                                            19
                                            Elm.Syntax.Pattern.AllPattern
                                        ]
                                    )
                              , H.node1 818 17 21 (H.val "tree")
                              )
                            ]
                        }
                    )
                )
            )
    }


sliceLeft : Elm.Syntax.Expression.FunctionImplementation
sliceLeft =
    { name = H.node1 838 1 10 "Array.sliceLeft"
    , arguments =
        [ H.node1 838 11 15 (Elm.Syntax.Pattern.VarPattern "from")
        , H.node1
            838
            16
            62
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    838
                    17
                    61
                    (Elm.Syntax.Pattern.AsPattern
                        (H.node1
                            838
                            17
                            52
                            (Elm.Syntax.Pattern.ParenthesizedPattern
                                (H.node1
                                    838
                                    18
                                    51
                                    (Elm.Syntax.Pattern.NamedPattern
                                        { moduleName = []
                                        , name = "Array_elm_builtin"
                                        }
                                        [ H.node1
                                            838
                                            36
                                            39
                                            (Elm.Syntax.Pattern.VarPattern "len"
                                            )
                                        , H.node1
                                            838
                                            40
                                            41
                                            Elm.Syntax.Pattern.AllPattern
                                        , H.node1
                                            838
                                            42
                                            46
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tree"
                                            )
                                        , H.node1
                                            838
                                            47
                                            51
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tail"
                                            )
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node1 838 56 61 "array")
                    )
                )
            )
        ]
    , expression =
        H.node
            839
            5
            883
            51
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    839
                    8
                    17
                    (Elm.Syntax.Expression.OperatorApplication
                        "=="
                        Elm.Syntax.Infix.Non
                        (H.node1 839 8 12 (H.val "from"))
                        (H.node1 839 16 17 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node1 840 9 14 (H.val "array"))
                (H.node
                    841
                    10
                    883
                    51
                    (Elm.Syntax.Expression.IfBlock
                        (H.node1
                            841
                            13
                            34
                            (Elm.Syntax.Expression.OperatorApplication
                                ">="
                                Elm.Syntax.Infix.Non
                                (H.node1 841 13 17 (H.val "from"))
                                (H.node1
                                    841
                                    21
                                    34
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 841 21 30 (H.val "tailIndex")
                                        , H.node1 841 31 34 (H.val "len")
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node
                            842
                            9
                            843
                            76
                            (Elm.Syntax.Expression.OperatorApplication
                                "<|"
                                Elm.Syntax.Infix.Right
                                (H.node1
                                    842
                                    9
                                    63
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            842
                                            9
                                            26
                                            (H.val "Array_elm_builtin")
                                        , H.node1
                                            842
                                            27
                                            39
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    842
                                                    28
                                                    38
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            842
                                                            28
                                                            31
                                                            (H.val "len")
                                                        )
                                                        (H.node1
                                                            842
                                                            34
                                                            38
                                                            (H.val "from")
                                                        )
                                                    )
                                                )
                                            )
                                        , H.node1 842 40 49 (H.val "shiftStep")
                                        , H.node1
                                            842
                                            50
                                            63
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "empty"
                                            )
                                        ]
                                    )
                                )
                                (H.node1
                                    843
                                    13
                                    76
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            843
                                            13
                                            26
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "slice"
                                            )
                                        , H.node1
                                            843
                                            27
                                            49
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    843
                                                    28
                                                    48
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            843
                                                            28
                                                            32
                                                            (H.val "from")
                                                        )
                                                        (H.node1
                                                            843
                                                            35
                                                            48
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    843
                                                                    35
                                                                    44
                                                                    (H.val
                                                                        "tailIndex"
                                                                    )
                                                                , H.node1
                                                                    843
                                                                    45
                                                                    48
                                                                    (H.val "len"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        , H.node1
                                            843
                                            50
                                            71
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    843
                                                    51
                                                    70
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            843
                                                            51
                                                            65
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "JsArray" ]
                                                                "length"
                                                            )
                                                        , H.node1
                                                            843
                                                            66
                                                            70
                                                            (H.val "tail")
                                                        ]
                                                    )
                                                )
                                            )
                                        , H.node1 843 72 76 (H.val "tail")
                                        ]
                                    )
                                )
                            )
                        )
                        (H.node
                            845
                            9
                            883
                            51
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ H.node
                                        846
                                        13
                                        852
                                        36
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    846
                                                    13
                                                    852
                                                    36
                                                    { name =
                                                        H.node1
                                                            846
                                                            13
                                                            19
                                                            "helper"
                                                    , arguments =
                                                        [ H.node1
                                                            846
                                                            20
                                                            24
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "node"
                                                            )
                                                        , H.node1
                                                            846
                                                            25
                                                            28
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "acc"
                                                            )
                                                        ]
                                                    , expression =
                                                        H.node
                                                            847
                                                            17
                                                            852
                                                            36
                                                            (Elm.Syntax.Expression.CaseExpression
                                                                { expression =
                                                                    H.node1
                                                                        847
                                                                        22
                                                                        26
                                                                        (H.val
                                                                            "node"
                                                                        )
                                                                , cases =
                                                                    [ ( H.node1
                                                                            848
                                                                            21
                                                                            36
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "SubTree"
                                                                                }
                                                                                [ H.node1
                                                                                    848
                                                                                    29
                                                                                    36
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "subTree"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , H.node1
                                                                            849
                                                                            25
                                                                            57
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    849
                                                                                    25
                                                                                    38
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "JsArray"
                                                                                        ]
                                                                                        "foldr"
                                                                                    )
                                                                                , H.node1
                                                                                    849
                                                                                    39
                                                                                    45
                                                                                    (H.val
                                                                                        "helper"
                                                                                    )
                                                                                , H.node1
                                                                                    849
                                                                                    46
                                                                                    49
                                                                                    (H.val
                                                                                        "acc"
                                                                                    )
                                                                                , H.node1
                                                                                    849
                                                                                    50
                                                                                    57
                                                                                    (H.val
                                                                                        "subTree"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      )
                                                                    , ( H.node1
                                                                            851
                                                                            21
                                                                            30
                                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                                { moduleName =
                                                                                    []
                                                                                , name =
                                                                                    "Leaf"
                                                                                }
                                                                                [ H.node1
                                                                                    851
                                                                                    26
                                                                                    30
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "leaf"
                                                                                    )
                                                                                ]
                                                                            )
                                                                      , H.node1
                                                                            852
                                                                            25
                                                                            36
                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                "::"
                                                                                Elm.Syntax.Infix.Right
                                                                                (H.node1
                                                                                    852
                                                                                    25
                                                                                    29
                                                                                    (H.val
                                                                                        "leaf"
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    852
                                                                                    33
                                                                                    36
                                                                                    (H.val
                                                                                        "acc"
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
                                        854
                                        13
                                        855
                                        51
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    854
                                                    13
                                                    855
                                                    51
                                                    { name =
                                                        H.node1
                                                            854
                                                            13
                                                            22
                                                            "leafNodes"
                                                    , arguments = []
                                                    , expression =
                                                        H.node1
                                                            855
                                                            17
                                                            51
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    855
                                                                    17
                                                                    30
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "foldr"
                                                                    )
                                                                , H.node1
                                                                    855
                                                                    31
                                                                    37
                                                                    (H.val
                                                                        "helper"
                                                                    )
                                                                , H.node1
                                                                    855
                                                                    38
                                                                    46
                                                                    (Elm.Syntax.Expression.ListExpr
                                                                        [ H.node1
                                                                            855
                                                                            40
                                                                            44
                                                                            (H.val
                                                                                "tail"
                                                                            )
                                                                        ]
                                                                    )
                                                                , H.node1
                                                                    855
                                                                    47
                                                                    51
                                                                    (H.val
                                                                        "tree"
                                                                    )
                                                                ]
                                                            )
                                                    }
                                            }
                                        )
                                    , H.node
                                        857
                                        13
                                        858
                                        37
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    857
                                                    13
                                                    858
                                                    37
                                                    { name =
                                                        H.node1
                                                            857
                                                            13
                                                            22
                                                            "skipNodes"
                                                    , arguments = []
                                                    , expression =
                                                        H.node1
                                                            858
                                                            17
                                                            37
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "//"
                                                                Elm.Syntax.Infix.Left
                                                                (H.node1
                                                                    858
                                                                    17
                                                                    21
                                                                    (H.val
                                                                        "from"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    858
                                                                    25
                                                                    37
                                                                    (H.val
                                                                        "branchFactor"
                                                                    )
                                                                )
                                                            )
                                                    }
                                            }
                                        )
                                    , H.node
                                        860
                                        13
                                        861
                                        46
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    860
                                                    13
                                                    861
                                                    46
                                                    { name =
                                                        H.node1
                                                            860
                                                            13
                                                            26
                                                            "nodesToInsert"
                                                    , arguments = []
                                                    , expression =
                                                        H.node1
                                                            861
                                                            17
                                                            46
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    861
                                                                    17
                                                                    26
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "drop"
                                                                    )
                                                                , H.node1
                                                                    861
                                                                    27
                                                                    36
                                                                    (H.val
                                                                        "skipNodes"
                                                                    )
                                                                , H.node1
                                                                    861
                                                                    37
                                                                    46
                                                                    (H.val
                                                                        "leafNodes"
                                                                    )
                                                                ]
                                                            )
                                                    }
                                            }
                                        )
                                    ]
                                , expression =
                                    H.node
                                        863
                                        13
                                        883
                                        51
                                        (Elm.Syntax.Expression.CaseExpression
                                            { expression =
                                                H.node1
                                                    863
                                                    18
                                                    31
                                                    (H.val "nodesToInsert")
                                            , cases =
                                                [ ( H.node1
                                                        864
                                                        17
                                                        19
                                                        (Elm.Syntax.Pattern.ListPattern
                                                            []
                                                        )
                                                  , H.node1
                                                        865
                                                        21
                                                        26
                                                        (H.val "empty")
                                                  )
                                                , ( H.node1
                                                        867
                                                        17
                                                        29
                                                        (Elm.Syntax.Pattern.UnConsPattern
                                                            (H.node1
                                                                867
                                                                17
                                                                21
                                                                (Elm.Syntax.Pattern.VarPattern
                                                                    "head"
                                                                )
                                                            )
                                                            (H.node1
                                                                867
                                                                25
                                                                29
                                                                (Elm.Syntax.Pattern.VarPattern
                                                                    "rest"
                                                                )
                                                            )
                                                        )
                                                  , H.node
                                                        868
                                                        21
                                                        883
                                                        51
                                                        (Elm.Syntax.Expression.LetExpression
                                                            { declarations =
                                                                [ H.node
                                                                    869
                                                                    25
                                                                    870
                                                                    62
                                                                    (Elm.Syntax.Expression.LetFunction
                                                                        { documentation =
                                                                            Nothing
                                                                        , signature =
                                                                            Nothing
                                                                        , declaration =
                                                                            H.node
                                                                                869
                                                                                25
                                                                                870
                                                                                62
                                                                                { name =
                                                                                    H.node1
                                                                                        869
                                                                                        25
                                                                                        35
                                                                                        "firstSlice"
                                                                                , arguments =
                                                                                    []
                                                                                , expression =
                                                                                    H.node1
                                                                                        870
                                                                                        29
                                                                                        62
                                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                                            "-"
                                                                                            Elm.Syntax.Infix.Left
                                                                                            (H.node1
                                                                                                870
                                                                                                29
                                                                                                33
                                                                                                (H.val
                                                                                                    "from"
                                                                                                )
                                                                                            )
                                                                                            (H.node1
                                                                                                870
                                                                                                36
                                                                                                62
                                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                    (H.node1
                                                                                                        870
                                                                                                        37
                                                                                                        61
                                                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                                                            "*"
                                                                                                            Elm.Syntax.Infix.Left
                                                                                                            (H.node1
                                                                                                                870
                                                                                                                37
                                                                                                                46
                                                                                                                (H.val
                                                                                                                    "skipNodes"
                                                                                                                )
                                                                                                            )
                                                                                                            (H.node1
                                                                                                                870
                                                                                                                49
                                                                                                                61
                                                                                                                (H.val
                                                                                                                    "branchFactor"
                                                                                                                )
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                }
                                                                        }
                                                                    )
                                                                , H.node
                                                                    872
                                                                    25
                                                                    880
                                                                    30
                                                                    (Elm.Syntax.Expression.LetFunction
                                                                        { documentation =
                                                                            Nothing
                                                                        , signature =
                                                                            Nothing
                                                                        , declaration =
                                                                            H.node
                                                                                872
                                                                                25
                                                                                880
                                                                                30
                                                                                { name =
                                                                                    H.node1
                                                                                        872
                                                                                        25
                                                                                        39
                                                                                        "initialBuilder"
                                                                                , arguments =
                                                                                    []
                                                                                , expression =
                                                                                    H.node
                                                                                        873
                                                                                        29
                                                                                        880
                                                                                        30
                                                                                        (Elm.Syntax.Expression.RecordExpr
                                                                                            [ H.node
                                                                                                873
                                                                                                31
                                                                                                877
                                                                                                41
                                                                                                ( H.node1
                                                                                                    873
                                                                                                    31
                                                                                                    35
                                                                                                    "tail"
                                                                                                , H.node
                                                                                                    874
                                                                                                    33
                                                                                                    877
                                                                                                    41
                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                        [ H.node1
                                                                                                            874
                                                                                                            33
                                                                                                            46
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                [ "JsArray"
                                                                                                                ]
                                                                                                                "slice"
                                                                                                            )
                                                                                                        , H.node1
                                                                                                            875
                                                                                                            37
                                                                                                            47
                                                                                                            (H.val
                                                                                                                "firstSlice"
                                                                                                            )
                                                                                                        , H.node1
                                                                                                            876
                                                                                                            37
                                                                                                            58
                                                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                (H.node1
                                                                                                                    876
                                                                                                                    38
                                                                                                                    57
                                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                                        [ H.node1
                                                                                                                            876
                                                                                                                            38
                                                                                                                            52
                                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                [ "JsArray"
                                                                                                                                ]
                                                                                                                                "length"
                                                                                                                            )
                                                                                                                        , H.node1
                                                                                                                            876
                                                                                                                            53
                                                                                                                            57
                                                                                                                            (H.val
                                                                                                                                "head"
                                                                                                                            )
                                                                                                                        ]
                                                                                                                    )
                                                                                                                )
                                                                                                            )
                                                                                                        , H.node1
                                                                                                            877
                                                                                                            37
                                                                                                            41
                                                                                                            (H.val
                                                                                                                "head"
                                                                                                            )
                                                                                                        ]
                                                                                                    )
                                                                                                )
                                                                                            , H.node
                                                                                                878
                                                                                                31
                                                                                                879
                                                                                                29
                                                                                                ( H.node1
                                                                                                    878
                                                                                                    31
                                                                                                    39
                                                                                                    "nodeList"
                                                                                                , H.node1
                                                                                                    878
                                                                                                    42
                                                                                                    44
                                                                                                    (Elm.Syntax.Expression.ListExpr
                                                                                                        []
                                                                                                    )
                                                                                                )
                                                                                            , H.node
                                                                                                879
                                                                                                31
                                                                                                880
                                                                                                29
                                                                                                ( H.node1
                                                                                                    879
                                                                                                    31
                                                                                                    43
                                                                                                    "nodeListSize"
                                                                                                , H.node1
                                                                                                    879
                                                                                                    46
                                                                                                    47
                                                                                                    (Elm.Syntax.Expression.Integer
                                                                                                        0
                                                                                                    )
                                                                                                )
                                                                                            ]
                                                                                        )
                                                                                }
                                                                        }
                                                                    )
                                                                ]
                                                            , expression =
                                                                H.node
                                                                    882
                                                                    25
                                                                    883
                                                                    51
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "|>"
                                                                        Elm.Syntax.Infix.Left
                                                                        (H.node1
                                                                            882
                                                                            25
                                                                            73
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    882
                                                                                    25
                                                                                    35
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "List"
                                                                                        ]
                                                                                        "foldl"
                                                                                    )
                                                                                , H.node1
                                                                                    882
                                                                                    36
                                                                                    53
                                                                                    (H.val
                                                                                        "appendHelpBuilder"
                                                                                    )
                                                                                , H.node1
                                                                                    882
                                                                                    54
                                                                                    68
                                                                                    (H.val
                                                                                        "initialBuilder"
                                                                                    )
                                                                                , H.node1
                                                                                    882
                                                                                    69
                                                                                    73
                                                                                    (H.val
                                                                                        "rest"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            883
                                                                            32
                                                                            51
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    883
                                                                                    32
                                                                                    46
                                                                                    (H.val
                                                                                        "builderToArray"
                                                                                    )
                                                                                , H.node1
                                                                                    883
                                                                                    47
                                                                                    51
                                                                                    (H.val
                                                                                        "True"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                            }
                                                        )
                                                  )
                                                ]
                                            }
                                        )
                                }
                            )
                        )
                    )
                )
            )
    }


emptyBuilder : Elm.Syntax.Expression.FunctionImplementation
emptyBuilder =
    { name = H.node1 900 1 13 "Array.emptyBuilder"
    , arguments = []
    , expression =
        H.node
            901
            5
            904
            6
            (Elm.Syntax.Expression.RecordExpr
                [ H.node1
                    901
                    7
                    27
                    ( H.node1 901 7 11 "tail"
                    , H.node1
                        901
                        14
                        27
                        (Elm.Syntax.Expression.FunctionOrValue
                            [ "JsArray" ]
                            "empty"
                        )
                    )
                , H.node
                    902
                    7
                    903
                    5
                    ( H.node1 902 7 15 "nodeList"
                    , H.node1 902 18 20 (Elm.Syntax.Expression.ListExpr [])
                    )
                , H.node
                    903
                    7
                    904
                    5
                    ( H.node1 903 7 19 "nodeListSize"
                    , H.node1 903 22 23 (Elm.Syntax.Expression.Integer 0)
                    )
                ]
            )
    }


builderFromArray : Elm.Syntax.Expression.FunctionImplementation
builderFromArray =
    { name = H.node1 910 1 17 "Array.builderFromArray"
    , arguments =
        [ H.node1
            910
            18
            53
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    910
                    19
                    52
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "Array_elm_builtin" }
                        [ H.node1
                            910
                            37
                            40
                            (Elm.Syntax.Pattern.VarPattern "len")
                        , H.node1 910 41 42 Elm.Syntax.Pattern.AllPattern
                        , H.node1
                            910
                            43
                            47
                            (Elm.Syntax.Pattern.VarPattern "tree")
                        , H.node1
                            910
                            48
                            52
                            (Elm.Syntax.Pattern.VarPattern "tail")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node
            911
            5
            923
            10
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        912
                        9
                        918
                        32
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    912
                                    9
                                    918
                                    32
                                    { name = H.node1 912 9 15 "helper"
                                    , arguments =
                                        [ H.node1
                                            912
                                            16
                                            20
                                            (Elm.Syntax.Pattern.VarPattern
                                                "node"
                                            )
                                        , H.node1
                                            912
                                            21
                                            24
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            913
                                            13
                                            918
                                            32
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        913
                                                        18
                                                        22
                                                        (H.val "node")
                                                , cases =
                                                    [ ( H.node1
                                                            914
                                                            17
                                                            32
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name =
                                                                    "SubTree"
                                                                }
                                                                [ H.node1
                                                                    914
                                                                    25
                                                                    32
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            915
                                                            21
                                                            53
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    915
                                                                    21
                                                                    34
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "JsArray"
                                                                        ]
                                                                        "foldl"
                                                                    )
                                                                , H.node1
                                                                    915
                                                                    35
                                                                    41
                                                                    (H.val
                                                                        "helper"
                                                                    )
                                                                , H.node1
                                                                    915
                                                                    42
                                                                    45
                                                                    (H.val "acc"
                                                                    )
                                                                , H.node1
                                                                    915
                                                                    46
                                                                    53
                                                                    (H.val
                                                                        "subTree"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            917
                                                            17
                                                            23
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Leaf"
                                                                }
                                                                [ H.node1
                                                                    917
                                                                    22
                                                                    23
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                ]
                                                            )
                                                      , H.node1
                                                            918
                                                            21
                                                            32
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Right
                                                                (H.node1
                                                                    918
                                                                    21
                                                                    25
                                                                    (H.val
                                                                        "node"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    918
                                                                    29
                                                                    32
                                                                    (H.val "acc"
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
                    ]
                , expression =
                    H.node
                        920
                        9
                        923
                        10
                        (Elm.Syntax.Expression.RecordExpr
                            [ H.node1
                                920
                                11
                                22
                                ( H.node1 920 11 15 "tail"
                                , H.node1 920 18 22 (H.val "tail")
                                )
                            , H.node
                                921
                                11
                                922
                                9
                                ( H.node1 921 11 19 "nodeList"
                                , H.node1
                                    921
                                    22
                                    50
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            921
                                            22
                                            35
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "foldl"
                                            )
                                        , H.node1 921 36 42 (H.val "helper")
                                        , H.node1
                                            921
                                            43
                                            45
                                            (Elm.Syntax.Expression.ListExpr [])
                                        , H.node1 921 46 50 (H.val "tree")
                                        ]
                                    )
                                )
                            , H.node
                                922
                                11
                                923
                                9
                                ( H.node1 922 11 23 "nodeListSize"
                                , H.node1
                                    922
                                    26
                                    45
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "//"
                                        Elm.Syntax.Infix.Left
                                        (H.node1 922 26 29 (H.val "len"))
                                        (H.node1
                                            922
                                            33
                                            45
                                            (H.val "branchFactor")
                                        )
                                    )
                                )
                            ]
                        )
                }
            )
    }


builderToArray : Elm.Syntax.Expression.FunctionImplementation
builderToArray =
    { name = H.node1 934 1 15 "Array.builderToArray"
    , arguments =
        [ H.node1 934 16 31 (Elm.Syntax.Pattern.VarPattern "reverseNodeList")
        , H.node1 934 32 39 (Elm.Syntax.Pattern.VarPattern "builder")
        ]
    , expression =
        H.node
            935
            5
            965
            29
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    935
                    8
                    33
                    (Elm.Syntax.Expression.OperatorApplication
                        "=="
                        Elm.Syntax.Infix.Non
                        (H.node1
                            935
                            8
                            28
                            (Elm.Syntax.Expression.RecordAccess
                                (H.node1 935 8 15 (H.val "builder"))
                                (H.node1 935 16 28 "nodeListSize")
                            )
                        )
                        (H.node1 935 32 33 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node
                    936
                    9
                    940
                    25
                    (Elm.Syntax.Expression.Application
                        [ H.node1 936 9 26 (H.val "Array_elm_builtin")
                        , H.node1
                            937
                            13
                            42
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    937
                                    14
                                    41
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            937
                                            14
                                            28
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "JsArray" ]
                                                "length"
                                            )
                                        , H.node1
                                            937
                                            29
                                            41
                                            (Elm.Syntax.Expression.RecordAccess
                                                (H.node1
                                                    937
                                                    29
                                                    36
                                                    (H.val "builder")
                                                )
                                                (H.node1 937 37 41 "tail")
                                            )
                                        ]
                                    )
                                )
                            )
                        , H.node1 938 13 22 (H.val "shiftStep")
                        , H.node1
                            939
                            13
                            26
                            (Elm.Syntax.Expression.FunctionOrValue
                                [ "JsArray" ]
                                "empty"
                            )
                        , H.node1
                            940
                            13
                            25
                            (Elm.Syntax.Expression.RecordAccess
                                (H.node1 940 13 20 (H.val "builder"))
                                (H.node1 940 21 25 "tail")
                            )
                        ]
                    )
                )
                (H.node
                    942
                    9
                    965
                    29
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ H.node
                                943
                                13
                                944
                                52
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            943
                                            13
                                            944
                                            52
                                            { name = H.node1 943 13 20 "treeLen"
                                            , arguments = []
                                            , expression =
                                                H.node1
                                                    944
                                                    17
                                                    52
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "*"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            944
                                                            17
                                                            37
                                                            (Elm.Syntax.Expression.RecordAccess
                                                                (H.node1
                                                                    944
                                                                    17
                                                                    24
                                                                    (H.val
                                                                        "builder"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    944
                                                                    25
                                                                    37
                                                                    "nodeListSize"
                                                                )
                                                            )
                                                        )
                                                        (H.node1
                                                            944
                                                            40
                                                            52
                                                            (H.val
                                                                "branchFactor"
                                                            )
                                                        )
                                                    )
                                            }
                                    }
                                )
                            , H.node
                                946
                                13
                                950
                                29
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            946
                                            13
                                            950
                                            29
                                            { name = H.node1 946 13 18 "depth"
                                            , arguments = []
                                            , expression =
                                                H.node
                                                    947
                                                    17
                                                    950
                                                    29
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "|>"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node
                                                            947
                                                            17
                                                            949
                                                            54
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "|>"
                                                                Elm.Syntax.Infix.Left
                                                                (H.node
                                                                    947
                                                                    17
                                                                    948
                                                                    31
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "|>"
                                                                        Elm.Syntax.Infix.Left
                                                                        (H.node1
                                                                            947
                                                                            17
                                                                            30
                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                (H.node1
                                                                                    947
                                                                                    18
                                                                                    29
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "-"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (H.node1
                                                                                            947
                                                                                            18
                                                                                            25
                                                                                            (H.val
                                                                                                "treeLen"
                                                                                            )
                                                                                        )
                                                                                        (H.node1
                                                                                            947
                                                                                            28
                                                                                            29
                                                                                            (Elm.Syntax.Expression.Integer
                                                                                                1
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            948
                                                                            24
                                                                            31
                                                                            (H.val
                                                                                "toFloat"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                (H.node1
                                                                    949
                                                                    24
                                                                    54
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            949
                                                                            24
                                                                            31
                                                                            (H.val
                                                                                "logBase"
                                                                            )
                                                                        , H.node1
                                                                            949
                                                                            32
                                                                            54
                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                (H.node1
                                                                                    949
                                                                                    33
                                                                                    53
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ H.node1
                                                                                            949
                                                                                            33
                                                                                            40
                                                                                            (H.val
                                                                                                "toFloat"
                                                                                            )
                                                                                        , H.node1
                                                                                            949
                                                                                            41
                                                                                            53
                                                                                            (H.val
                                                                                                "branchFactor"
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
                                                        (H.node1
                                                            950
                                                            24
                                                            29
                                                            (H.val "floor")
                                                        )
                                                    )
                                            }
                                    }
                                )
                            , H.node
                                952
                                13
                                956
                                37
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            952
                                            13
                                            956
                                            37
                                            { name =
                                                H.node1
                                                    952
                                                    13
                                                    28
                                                    "correctNodeList"
                                            , arguments = []
                                            , expression =
                                                H.node
                                                    953
                                                    17
                                                    956
                                                    37
                                                    (Elm.Syntax.Expression.IfBlock
                                                        (H.node1
                                                            953
                                                            20
                                                            35
                                                            (H.val
                                                                "reverseNodeList"
                                                            )
                                                        )
                                                        (H.node1
                                                            954
                                                            21
                                                            50
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    954
                                                                    21
                                                                    33
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , H.node1
                                                                    954
                                                                    34
                                                                    50
                                                                    (Elm.Syntax.Expression.RecordAccess
                                                                        (H.node1
                                                                            954
                                                                            34
                                                                            41
                                                                            (H.val
                                                                                "builder"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            954
                                                                            42
                                                                            50
                                                                            "nodeList"
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                        (H.node1
                                                            956
                                                            21
                                                            37
                                                            (Elm.Syntax.Expression.RecordAccess
                                                                (H.node1
                                                                    956
                                                                    21
                                                                    28
                                                                    (H.val
                                                                        "builder"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    956
                                                                    29
                                                                    37
                                                                    "nodeList"
                                                                )
                                                            )
                                                        )
                                                    )
                                            }
                                    }
                                )
                            , H.node
                                958
                                13
                                959
                                69
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            958
                                            13
                                            959
                                            69
                                            { name = H.node1 958 13 17 "tree"
                                            , arguments = []
                                            , expression =
                                                H.node1
                                                    959
                                                    17
                                                    69
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            959
                                                            17
                                                            32
                                                            (H.val
                                                                "treeFromBuilder"
                                                            )
                                                        , H.node1
                                                            959
                                                            33
                                                            48
                                                            (H.val
                                                                "correctNodeList"
                                                            )
                                                        , H.node1
                                                            959
                                                            49
                                                            69
                                                            (Elm.Syntax.Expression.RecordAccess
                                                                (H.node1
                                                                    959
                                                                    49
                                                                    56
                                                                    (H.val
                                                                        "builder"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    959
                                                                    57
                                                                    69
                                                                    "nodeListSize"
                                                                )
                                                            )
                                                        ]
                                                    )
                                            }
                                    }
                                )
                            ]
                        , expression =
                            H.node
                                961
                                13
                                965
                                29
                                (Elm.Syntax.Expression.Application
                                    [ H.node1
                                        961
                                        13
                                        30
                                        (H.val "Array_elm_builtin")
                                    , H.node1
                                        962
                                        17
                                        56
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node1
                                                962
                                                18
                                                55
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "+"
                                                    Elm.Syntax.Infix.Left
                                                    (H.node1
                                                        962
                                                        18
                                                        45
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                962
                                                                18
                                                                32
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    [ "JsArray"
                                                                    ]
                                                                    "length"
                                                                )
                                                            , H.node1
                                                                962
                                                                33
                                                                45
                                                                (Elm.Syntax.Expression.RecordAccess
                                                                    (H.node1
                                                                        962
                                                                        33
                                                                        40
                                                                        (H.val
                                                                            "builder"
                                                                        )
                                                                    )
                                                                    (H.node1
                                                                        962
                                                                        41
                                                                        45
                                                                        "tail"
                                                                    )
                                                                )
                                                            ]
                                                        )
                                                    )
                                                    (H.node1
                                                        962
                                                        48
                                                        55
                                                        (H.val "treeLen")
                                                    )
                                                )
                                            )
                                        )
                                    , H.node1
                                        963
                                        17
                                        45
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node1
                                                963
                                                18
                                                44
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "<|"
                                                    Elm.Syntax.Infix.Right
                                                    (H.node1
                                                        963
                                                        18
                                                        23
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                963
                                                                18
                                                                21
                                                                (H.val "max")
                                                            , H.node1
                                                                963
                                                                22
                                                                23
                                                                (Elm.Syntax.Expression.Integer
                                                                    5
                                                                )
                                                            ]
                                                        )
                                                    )
                                                    (H.node1
                                                        963
                                                        27
                                                        44
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "*"
                                                            Elm.Syntax.Infix.Left
                                                            (H.node1
                                                                963
                                                                27
                                                                32
                                                                (H.val "depth")
                                                            )
                                                            (H.node1
                                                                963
                                                                35
                                                                44
                                                                (H.val
                                                                    "shiftStep"
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    , H.node1 964 17 21 (H.val "tree")
                                    , H.node1
                                        965
                                        17
                                        29
                                        (Elm.Syntax.Expression.RecordAccess
                                            (H.node1 965 17 24 (H.val "builder")
                                            )
                                            (H.node1 965 25 29 "tail")
                                        )
                                    ]
                                )
                        }
                    )
                )
            )
    }


treeFromBuilder : Elm.Syntax.Expression.FunctionImplementation
treeFromBuilder =
    { name = H.node1 972 1 16 "Array.treeFromBuilder"
    , arguments =
        [ H.node1 972 17 25 (Elm.Syntax.Pattern.VarPattern "nodeList")
        , H.node1 972 26 38 (Elm.Syntax.Pattern.VarPattern "nodeListSize")
        ]
    , expression =
        H.node
            973
            5
            984
            28
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        974
                        9
                        976
                        27
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    974
                                    9
                                    976
                                    27
                                    { name = H.node1 974 9 20 "newNodeSize"
                                    , arguments = []
                                    , expression =
                                        H.node
                                            975
                                            13
                                            976
                                            27
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "|>"
                                                Elm.Syntax.Infix.Left
                                                (H.node1
                                                    975
                                                    13
                                                    62
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            975
                                                            14
                                                            61
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "/"
                                                                Elm.Syntax.Infix.Left
                                                                (H.node1
                                                                    975
                                                                    14
                                                                    36
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            975
                                                                            15
                                                                            35
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    975
                                                                                    15
                                                                                    22
                                                                                    (H.val
                                                                                        "toFloat"
                                                                                    )
                                                                                , H.node1
                                                                                    975
                                                                                    23
                                                                                    35
                                                                                    (H.val
                                                                                        "nodeListSize"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                (H.node1
                                                                    975
                                                                    39
                                                                    61
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            975
                                                                            40
                                                                            60
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    975
                                                                                    40
                                                                                    47
                                                                                    (H.val
                                                                                        "toFloat"
                                                                                    )
                                                                                , H.node1
                                                                                    975
                                                                                    48
                                                                                    60
                                                                                    (H.val
                                                                                        "branchFactor"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                                (H.node1
                                                    976
                                                    20
                                                    27
                                                    (H.val "ceiling")
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        978
                        9
                        984
                        28
                        (Elm.Syntax.Expression.IfBlock
                            (H.node1
                                978
                                12
                                28
                                (Elm.Syntax.Expression.OperatorApplication
                                    "=="
                                    Elm.Syntax.Infix.Non
                                    (H.node1 978 12 23 (H.val "newNodeSize"))
                                    (H.node1
                                        978
                                        27
                                        28
                                        (Elm.Syntax.Expression.Integer 1)
                                    )
                                )
                            )
                            (H.node
                                979
                                13
                                980
                                31
                                (Elm.Syntax.Expression.OperatorApplication
                                    "|>"
                                    Elm.Syntax.Infix.Left
                                    (H.node1
                                        979
                                        13
                                        61
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                979
                                                13
                                                39
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "JsArray" ]
                                                    "initializeFromList"
                                                )
                                            , H.node1
                                                979
                                                40
                                                52
                                                (H.val "branchFactor")
                                            , H.node1
                                                979
                                                53
                                                61
                                                (H.val "nodeList")
                                            ]
                                        )
                                    )
                                    (H.node1
                                        980
                                        20
                                        31
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "Tuple" ]
                                            "first"
                                        )
                                    )
                                )
                            )
                            (H.node
                                982
                                13
                                984
                                28
                                (Elm.Syntax.Expression.Application
                                    [ H.node1
                                        982
                                        13
                                        28
                                        (H.val "treeFromBuilder")
                                    , H.node1
                                        983
                                        17
                                        44
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node1
                                                983
                                                18
                                                43
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        983
                                                        18
                                                        31
                                                        (H.val "compressNodes")
                                                    , H.node1
                                                        983
                                                        32
                                                        40
                                                        (H.val "nodeList")
                                                    , H.node1
                                                        983
                                                        41
                                                        43
                                                        (Elm.Syntax.Expression.ListExpr
                                                            []
                                                        )
                                                    ]
                                                )
                                            )
                                        )
                                    , H.node1 984 17 28 (H.val "newNodeSize")
                                    ]
                                )
                            )
                        )
                }
            )
    }


compressNodes : Elm.Syntax.Expression.FunctionImplementation
compressNodes =
    { name = H.node1 991 1 14 "Array.compressNodes"
    , arguments =
        [ H.node1 991 15 20 (Elm.Syntax.Pattern.VarPattern "nodes")
        , H.node1 991 21 24 (Elm.Syntax.Pattern.VarPattern "acc")
        ]
    , expression =
        H.node
            992
            5
            1004
            52
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        993
                        9
                        994
                        58
                        (Elm.Syntax.Expression.LetDestructuring
                            (H.node1
                                993
                                9
                                33
                                (Elm.Syntax.Pattern.TuplePattern
                                    [ H.node1
                                        993
                                        11
                                        15
                                        (Elm.Syntax.Pattern.VarPattern "node")
                                    , H.node1
                                        993
                                        17
                                        31
                                        (Elm.Syntax.Pattern.VarPattern
                                            "remainingNodes"
                                        )
                                    ]
                                )
                            )
                            (H.node1
                                994
                                13
                                58
                                (Elm.Syntax.Expression.Application
                                    [ H.node1
                                        994
                                        13
                                        39
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "JsArray" ]
                                            "initializeFromList"
                                        )
                                    , H.node1 994 40 52 (H.val "branchFactor")
                                    , H.node1 994 53 58 (H.val "nodes")
                                    ]
                                )
                            )
                        )
                    , H.node
                        996
                        9
                        997
                        34
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    996
                                    9
                                    997
                                    34
                                    { name = H.node1 996 9 15 "newAcc"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            997
                                            13
                                            34
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "::"
                                                Elm.Syntax.Infix.Right
                                                (H.node1
                                                    997
                                                    13
                                                    27
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            997
                                                            14
                                                            26
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    997
                                                                    14
                                                                    21
                                                                    (H.val
                                                                        "SubTree"
                                                                    )
                                                                , H.node1
                                                                    997
                                                                    22
                                                                    26
                                                                    (H.val
                                                                        "node"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                )
                                                (H.node1 997 31 34 (H.val "acc")
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        999
                        9
                        1004
                        52
                        (Elm.Syntax.Expression.CaseExpression
                            { expression =
                                H.node1 999 14 28 (H.val "remainingNodes")
                            , cases =
                                [ ( H.node1
                                        1000
                                        13
                                        15
                                        (Elm.Syntax.Pattern.ListPattern [])
                                  , H.node1
                                        1001
                                        17
                                        36
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                1001
                                                17
                                                29
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "List" ]
                                                    "reverse"
                                                )
                                            , H.node1
                                                1001
                                                30
                                                36
                                                (H.val "newAcc")
                                            ]
                                        )
                                  )
                                , ( H.node1
                                        1003
                                        13
                                        14
                                        Elm.Syntax.Pattern.AllPattern
                                  , H.node1
                                        1004
                                        17
                                        52
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                1004
                                                17
                                                30
                                                (H.val "compressNodes")
                                            , H.node1
                                                1004
                                                31
                                                45
                                                (H.val "remainingNodes")
                                            , H.node1
                                                1004
                                                46
                                                52
                                                (H.val "newAcc")
                                            ]
                                        )
                                  )
                                ]
                            }
                        )
                }
            )
    }