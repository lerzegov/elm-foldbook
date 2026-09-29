module Core.List.Extra exposing (allDifferent, allDifferentBy, andMap, andThen, break, cartesianProduct, count, cycle, cycleHelp, dropWhile, dropWhileRight, elemIndex, elemIndices, filterNot, find, findIndex, findIndexHelp, findIndices, findMap, foldl1, foldr1, frequencies, functions, gatherEquals, gatherEqualsBy, gatherWith, getAt, greedyGroupsOf, greedyGroupsOfWithStep, group, groupWhile, groupsOf, groupsOfVarying, groupsOfVarying_, groupsOfWithStep, indexedFoldl, indexedFoldr, init, initialize, inits, intercalate, interweave, interweaveHelp, isInfixOf, isInfixOfHelp, isPermutationOf, isPrefixOf, isSubsequenceOf, isSuffixOf, iterate, iterateHelp, joinOn, last, lift2, lift3, lift4, mapAccuml, mapAccumr, maximumBy, maximumWith, minimumBy, minimumWith, notMember, permutations, remove, removeAt, removeHelp, removeIfIndex, removeOneMember, removeOneMemberHelp, reverseAppend, reverseMap, reverseRange, rowsLength, scanl, scanl1, scanr, scanr1, select, selectSplit, setAt, setIf, span, splitAt, splitWhen, stableSortWith, stoppableFoldl, stripPrefix, subsequences, subsequencesHelp, subsequencesNonEmpty, swapAt, tails, tailsHelp, takeWhile, takeWhileRight, transpose, triple, uncons, unconsLast, unfoldr, unique, uniqueBy, uniqueHelp, uniquePairs, updateAt, updateIf, updateIfIndex, zip, zip3)

{-| 
@docs functions, last, init, getAt, iterate, iterateHelp, initialize, cycle, cycleHelp, reverseRange, uncons, unconsLast, maximumBy, maximumWith, minimumBy, minimumWith, takeWhile, dropWhile, unique, uniqueBy, allDifferent, allDifferentBy, uniqueHelp, andMap, andThen, reverseMap, notMember, find, elemIndex, elemIndices, findIndex, findIndexHelp, findIndices, findMap, count, setIf, updateIf, updateAt, updateIfIndex, remove, removeHelp, setAt, stableSortWith, swapAt, removeAt, removeIfIndex, filterNot, intercalate, transpose, rowsLength, subsequences, subsequencesHelp, subsequencesNonEmpty, permutations, interweave, interweaveHelp, cartesianProduct, uniquePairs, reverseAppend, foldl1, foldr1, indexedFoldl, indexedFoldr, stoppableFoldl, scanl, scanl1, scanr, scanr1, mapAccuml, mapAccumr, unfoldr, splitAt, splitWhen, takeWhileRight, dropWhileRight, span, break, stripPrefix, group, groupWhile, inits, tails, tailsHelp, select, selectSplit, isPrefixOf, isSuffixOf, isInfixOf, isInfixOfHelp, isSubsequenceOf, isPermutationOf, removeOneMember, removeOneMemberHelp, zip, zip3, triple, lift2, lift3, lift4, groupsOf, groupsOfWithStep, groupsOfVarying, groupsOfVarying_, greedyGroupsOf, greedyGroupsOfWithStep, gatherEquals, gatherEqualsBy, gatherWith, frequencies, joinOn
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
        [ ( "last", last )
        , ( "init", init )
        , ( "getAt", getAt )
        , ( "iterate", iterate )
        , ( "iterateHelp", iterateHelp )
        , ( "initialize", initialize )
        , ( "cycle", cycle )
        , ( "cycleHelp", cycleHelp )
        , ( "reverseRange", reverseRange )
        , ( "uncons", uncons )
        , ( "unconsLast", unconsLast )
        , ( "maximumBy", maximumBy )
        , ( "maximumWith", maximumWith )
        , ( "minimumBy", minimumBy )
        , ( "minimumWith", minimumWith )
        , ( "takeWhile", takeWhile )
        , ( "dropWhile", dropWhile )
        , ( "unique", unique )
        , ( "uniqueBy", uniqueBy )
        , ( "allDifferent", allDifferent )
        , ( "allDifferentBy", allDifferentBy )
        , ( "uniqueHelp", uniqueHelp )
        , ( "andMap", andMap )
        , ( "andThen", andThen )
        , ( "reverseMap", reverseMap )
        , ( "notMember", notMember )
        , ( "find", find )
        , ( "elemIndex", elemIndex )
        , ( "elemIndices", elemIndices )
        , ( "findIndex", findIndex )
        , ( "findIndexHelp", findIndexHelp )
        , ( "findIndices", findIndices )
        , ( "findMap", findMap )
        , ( "count", count )
        , ( "setIf", setIf )
        , ( "updateIf", updateIf )
        , ( "updateAt", updateAt )
        , ( "updateIfIndex", updateIfIndex )
        , ( "remove", remove )
        , ( "removeHelp", removeHelp )
        , ( "setAt", setAt )
        , ( "stableSortWith", stableSortWith )
        , ( "swapAt", swapAt )
        , ( "removeAt", removeAt )
        , ( "removeIfIndex", removeIfIndex )
        , ( "filterNot", filterNot )
        , ( "intercalate", intercalate )
        , ( "transpose", transpose )
        , ( "rowsLength", rowsLength )
        , ( "subsequences", subsequences )
        , ( "subsequencesHelp", subsequencesHelp )
        , ( "subsequencesNonEmpty", subsequencesNonEmpty )
        , ( "permutations", permutations )
        , ( "interweave", interweave )
        , ( "interweaveHelp", interweaveHelp )
        , ( "cartesianProduct", cartesianProduct )
        , ( "uniquePairs", uniquePairs )
        , ( "reverseAppend", reverseAppend )
        , ( "foldl1", foldl1 )
        , ( "foldr1", foldr1 )
        , ( "indexedFoldl", indexedFoldl )
        , ( "indexedFoldr", indexedFoldr )
        , ( "stoppableFoldl", stoppableFoldl )
        , ( "scanl", scanl )
        , ( "scanl1", scanl1 )
        , ( "scanr", scanr )
        , ( "scanr1", scanr1 )
        , ( "mapAccuml", mapAccuml )
        , ( "mapAccumr", mapAccumr )
        , ( "unfoldr", unfoldr )
        , ( "splitAt", splitAt )
        , ( "splitWhen", splitWhen )
        , ( "takeWhileRight", takeWhileRight )
        , ( "dropWhileRight", dropWhileRight )
        , ( "span", span )
        , ( "break", break )
        , ( "stripPrefix", stripPrefix )
        , ( "group", group )
        , ( "groupWhile", groupWhile )
        , ( "inits", inits )
        , ( "tails", tails )
        , ( "tailsHelp", tailsHelp )
        , ( "select", select )
        , ( "selectSplit", selectSplit )
        , ( "isPrefixOf", isPrefixOf )
        , ( "isSuffixOf", isSuffixOf )
        , ( "isInfixOf", isInfixOf )
        , ( "isInfixOfHelp", isInfixOfHelp )
        , ( "isSubsequenceOf", isSubsequenceOf )
        , ( "isPermutationOf", isPermutationOf )
        , ( "removeOneMember", removeOneMember )
        , ( "removeOneMemberHelp", removeOneMemberHelp )
        , ( "zip", zip )
        , ( "zip3", zip3 )
        , ( "triple", triple )
        , ( "lift2", lift2 )
        , ( "lift3", lift3 )
        , ( "lift4", lift4 )
        , ( "groupsOf", groupsOf )
        , ( "groupsOfWithStep", groupsOfWithStep )
        , ( "groupsOfVarying", groupsOfVarying )
        , ( "groupsOfVarying_", groupsOfVarying_ )
        , ( "greedyGroupsOf", greedyGroupsOf )
        , ( "greedyGroupsOfWithStep", greedyGroupsOfWithStep )
        , ( "gatherEquals", gatherEquals )
        , ( "gatherEqualsBy", gatherEqualsBy )
        , ( "gatherWith", gatherWith )
        , ( "frequencies", frequencies )
        , ( "joinOn", joinOn )
        ]


last : Elm.Syntax.Expression.FunctionImplementation
last =
    { name = H.node1 88 1 5 "List.Extra.last"
    , arguments = [ H.node1 88 6 11 (Elm.Syntax.Pattern.VarPattern "items") ]
    , expression =
        H.node
            89
            5
            97
            22
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 89 10 15 (H.val "items")
                , cases =
                    [ ( H.node1 90 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 91 13 20 (H.val "Nothing")
                      )
                    , ( H.node1
                            93
                            9
                            14
                            (Elm.Syntax.Pattern.ListPattern
                                [ H.node1
                                    93
                                    11
                                    12
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                ]
                            )
                      , H.node1
                            94
                            13
                            19
                            (Elm.Syntax.Expression.Application
                                [ H.node1 94 13 17 (H.val "Just")
                                , H.node1 94 18 19 (H.val "x")
                                ]
                            )
                      )
                    , ( H.node1
                            96
                            9
                            18
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1 96 9 10 Elm.Syntax.Pattern.AllPattern)
                                (H.node1
                                    96
                                    14
                                    18
                                    (Elm.Syntax.Pattern.VarPattern "rest")
                                )
                            )
                      , H.node1
                            97
                            13
                            22
                            (Elm.Syntax.Expression.Application
                                [ H.node1 97 13 17 (H.val "last")
                                , H.node1 97 18 22 (H.val "rest")
                                ]
                            )
                      )
                    ]
                }
            )
    }


init : Elm.Syntax.Expression.FunctionImplementation
init =
    { name = H.node1 110 1 5 "List.Extra.init"
    , arguments = [ H.node1 110 6 11 (Elm.Syntax.Pattern.VarPattern "items") ]
    , expression =
        H.node
            111
            5
            119
            42
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 111 10 15 (H.val "items")
                , cases =
                    [ ( H.node1 112 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 113 13 20 (H.val "Nothing")
                      )
                    , ( H.node1
                            115
                            9
                            21
                            (Elm.Syntax.Pattern.VarPattern "nonEmptyList")
                      , H.node
                            116
                            13
                            119
                            42
                            (Elm.Syntax.Expression.OperatorApplication
                                "|>"
                                Elm.Syntax.Infix.Left
                                (H.node
                                    116
                                    13
                                    118
                                    29
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "|>"
                                        Elm.Syntax.Infix.Left
                                        (H.node
                                            116
                                            13
                                            117
                                            32
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "|>"
                                                Elm.Syntax.Infix.Left
                                                (H.node1
                                                    116
                                                    13
                                                    25
                                                    (H.val "nonEmptyList")
                                                )
                                                (H.node1
                                                    117
                                                    20
                                                    32
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "List" ]
                                                        "reverse"
                                                    )
                                                )
                                            )
                                        )
                                        (H.node1
                                            118
                                            20
                                            29
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "List" ]
                                                "tail"
                                            )
                                        )
                                    )
                                )
                                (H.node1
                                    119
                                    20
                                    42
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            119
                                            20
                                            29
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "Maybe" ]
                                                "map"
                                            )
                                        , H.node1
                                            119
                                            30
                                            42
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "List" ]
                                                "reverse"
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


getAt : Elm.Syntax.Expression.FunctionImplementation
getAt =
    { name = H.node1 126 1 6 "List.Extra.getAt"
    , arguments =
        [ H.node1 126 7 10 (Elm.Syntax.Pattern.VarPattern "idx")
        , H.node1 126 11 13 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node
            127
            5
            131
            38
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    127
                    8
                    15
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Non
                        (H.node1 127 8 11 (H.val "idx"))
                        (H.node1 127 14 15 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node1 128 9 16 (H.val "Nothing"))
                (H.node1
                    131
                    9
                    38
                    (Elm.Syntax.Expression.OperatorApplication
                        "<|"
                        Elm.Syntax.Infix.Right
                        (H.node1
                            131
                            9
                            18
                            (Elm.Syntax.Expression.FunctionOrValue
                                [ "List" ]
                                "head"
                            )
                        )
                        (H.node1
                            131
                            22
                            38
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    131
                                    22
                                    31
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "List" ]
                                        "drop"
                                    )
                                , H.node1 131 32 35 (H.val "idx")
                                , H.node1 131 36 38 (H.val "xs")
                                ]
                            )
                        )
                    )
                )
            )
    }


iterate : Elm.Syntax.Expression.FunctionImplementation
iterate =
    { name = H.node1 154 1 8 "List.Extra.iterate"
    , arguments =
        [ H.node1 154 9 10 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 154 11 12 (Elm.Syntax.Pattern.VarPattern "x")
        ]
    , expression =
        H.node1
            155
            5
            39
            (Elm.Syntax.Expression.OperatorApplication
                "|>"
                Elm.Syntax.Infix.Left
                (H.node1
                    155
                    5
                    23
                    (Elm.Syntax.Expression.Application
                        [ H.node1 155 5 16 (H.val "iterateHelp")
                        , H.node1 155 17 18 (H.val "f")
                        , H.node1 155 19 20 (H.val "x")
                        , H.node1 155 21 23 (Elm.Syntax.Expression.ListExpr [])
                        ]
                    )
                )
                (H.node1
                    155
                    27
                    39
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "reverse")
                )
            )
    }


iterateHelp : Elm.Syntax.Expression.FunctionImplementation
iterateHelp =
    { name = H.node1 159 1 12 "List.Extra.iterateHelp"
    , arguments =
        [ H.node1 159 13 14 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 159 15 16 (Elm.Syntax.Pattern.VarPattern "x")
        , H.node1 159 17 20 (Elm.Syntax.Pattern.VarPattern "acc")
        ]
    , expression =
        H.node
            160
            5
            165
            21
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        160
                        10
                        13
                        (Elm.Syntax.Expression.Application
                            [ H.node1 160 10 11 (H.val "f")
                            , H.node1 160 12 13 (H.val "x")
                            ]
                        )
                , cases =
                    [ ( H.node1
                            161
                            9
                            16
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    161
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "x_")
                                ]
                            )
                      , H.node1
                            162
                            13
                            40
                            (Elm.Syntax.Expression.Application
                                [ H.node1 162 13 24 (H.val "iterateHelp")
                                , H.node1 162 25 26 (H.val "f")
                                , H.node1 162 27 29 (H.val "x_")
                                , H.node1
                                    162
                                    30
                                    40
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            162
                                            31
                                            39
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "::"
                                                Elm.Syntax.Infix.Right
                                                (H.node1 162 31 32 (H.val "x"))
                                                (H.node1 162 36 39 (H.val "acc")
                                                )
                                            )
                                        )
                                    )
                                ]
                            )
                      )
                    , ( H.node1
                            164
                            9
                            16
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1
                            165
                            13
                            21
                            (Elm.Syntax.Expression.OperatorApplication
                                "::"
                                Elm.Syntax.Infix.Right
                                (H.node1 165 13 14 (H.val "x"))
                                (H.node1 165 18 21 (H.val "acc"))
                            )
                      )
                    ]
                }
            )
    }


initialize : Elm.Syntax.Expression.FunctionImplementation
initialize =
    { name = H.node1 174 1 11 "List.Extra.initialize"
    , arguments =
        [ H.node1 174 12 13 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 174 14 15 (Elm.Syntax.Pattern.VarPattern "f")
        ]
    , expression =
        H.node
            175
            5
            183
            20
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        176
                        9
                        181
                        42
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    176
                                    9
                                    181
                                    42
                                    { name = H.node1 176 9 13 "step"
                                    , arguments =
                                        [ H.node1
                                            176
                                            14
                                            15
                                            (Elm.Syntax.Pattern.VarPattern "i")
                                        , H.node1
                                            176
                                            16
                                            19
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            177
                                            13
                                            181
                                            42
                                            (Elm.Syntax.Expression.IfBlock
                                                (H.node1
                                                    177
                                                    16
                                                    21
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "<"
                                                        Elm.Syntax.Infix.Non
                                                        (H.node1
                                                            177
                                                            16
                                                            17
                                                            (H.val "i")
                                                        )
                                                        (H.node1
                                                            177
                                                            20
                                                            21
                                                            (Elm.Syntax.Expression.Integer
                                                                0
                                                            )
                                                        )
                                                    )
                                                )
                                                (H.node1 178 17 20 (H.val "acc")
                                                )
                                                (H.node1
                                                    181
                                                    17
                                                    42
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            181
                                                            17
                                                            21
                                                            (H.val "step")
                                                        , H.node1
                                                            181
                                                            22
                                                            29
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    181
                                                                    23
                                                                    28
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "-"
                                                                        Elm.Syntax.Infix.Left
                                                                        (H.node1
                                                                            181
                                                                            23
                                                                            24
                                                                            (H.val
                                                                                "i"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            181
                                                                            27
                                                                            28
                                                                            (Elm.Syntax.Expression.Integer
                                                                                1
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        , H.node1
                                                            181
                                                            30
                                                            42
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    181
                                                                    31
                                                                    41
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "::"
                                                                        Elm.Syntax.Infix.Right
                                                                        (H.node1
                                                                            181
                                                                            31
                                                                            34
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    181
                                                                                    31
                                                                                    32
                                                                                    (H.val
                                                                                        "f"
                                                                                    )
                                                                                , H.node1
                                                                                    181
                                                                                    33
                                                                                    34
                                                                                    (H.val
                                                                                        "i"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            181
                                                                            38
                                                                            41
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
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        183
                        5
                        20
                        (Elm.Syntax.Expression.Application
                            [ H.node1 183 5 9 (H.val "step")
                            , H.node1
                                183
                                10
                                17
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        183
                                        11
                                        16
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "-"
                                            Elm.Syntax.Infix.Left
                                            (H.node1 183 11 12 (H.val "n"))
                                            (H.node1
                                                183
                                                15
                                                16
                                                (Elm.Syntax.Expression.Integer 1
                                                )
                                            )
                                        )
                                    )
                                )
                            , H.node1
                                183
                                18
                                20
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


cycle : Elm.Syntax.Expression.FunctionImplementation
cycle =
    { name = H.node1 204 1 6 "List.Extra.cycle"
    , arguments =
        [ H.node1 204 7 10 (Elm.Syntax.Pattern.VarPattern "len")
        , H.node1 204 11 15 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            205
            5
            220
            27
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        206
                        9
                        207
                        29
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    206
                                    9
                                    207
                                    29
                                    { name = H.node1 206 9 20 "cycleLength"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            207
                                            13
                                            29
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    207
                                                    13
                                                    24
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "List" ]
                                                        "length"
                                                    )
                                                , H.node1
                                                    207
                                                    25
                                                    29
                                                    (H.val "list")
                                                ]
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        209
                        5
                        220
                        27
                        (Elm.Syntax.Expression.IfBlock
                            (H.node1
                                209
                                8
                                46
                                (Elm.Syntax.Expression.OperatorApplication
                                    "||"
                                    Elm.Syntax.Infix.Right
                                    (H.node1
                                        209
                                        8
                                        24
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "=="
                                            Elm.Syntax.Infix.Non
                                            (H.node1
                                                209
                                                8
                                                19
                                                (H.val "cycleLength")
                                            )
                                            (H.node1
                                                209
                                                23
                                                24
                                                (Elm.Syntax.Expression.Integer 0
                                                )
                                            )
                                        )
                                    )
                                    (H.node1
                                        209
                                        28
                                        46
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "=="
                                            Elm.Syntax.Infix.Non
                                            (H.node1
                                                209
                                                28
                                                39
                                                (H.val "cycleLength")
                                            )
                                            (H.node1 209 43 46 (H.val "len"))
                                        )
                                    )
                                )
                            )
                            (H.node1 210 9 13 (H.val "list"))
                            (H.node
                                212
                                10
                                220
                                27
                                (Elm.Syntax.Expression.IfBlock
                                    (H.node1
                                        212
                                        13
                                        30
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "<"
                                            Elm.Syntax.Infix.Non
                                            (H.node1
                                                212
                                                13
                                                24
                                                (H.val "cycleLength")
                                            )
                                            (H.node1 212 27 30 (H.val "len"))
                                        )
                                    )
                                    (H.node
                                        213
                                        9
                                        217
                                        14
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                213
                                                9
                                                21
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "List" ]
                                                    "reverse"
                                                )
                                            , H.node
                                                214
                                                13
                                                217
                                                14
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node
                                                        214
                                                        14
                                                        216
                                                        57
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                214
                                                                14
                                                                27
                                                                (H.val
                                                                    "reverseAppend"
                                                                )
                                                            , H.node1
                                                                215
                                                                17
                                                                63
                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                    (H.node1
                                                                        215
                                                                        18
                                                                        62
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                215
                                                                                18
                                                                                27
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    [ "List"
                                                                                    ]
                                                                                    "take"
                                                                                )
                                                                            , H.node1
                                                                                215
                                                                                28
                                                                                57
                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                    (H.node1
                                                                                        215
                                                                                        29
                                                                                        56
                                                                                        (Elm.Syntax.Expression.Application
                                                                                            [ H.node1
                                                                                                215
                                                                                                29
                                                                                                40
                                                                                                (H.val
                                                                                                    "remainderBy"
                                                                                                )
                                                                                            , H.node1
                                                                                                215
                                                                                                41
                                                                                                52
                                                                                                (H.val
                                                                                                    "cycleLength"
                                                                                                )
                                                                                            , H.node1
                                                                                                215
                                                                                                53
                                                                                                56
                                                                                                (H.val
                                                                                                    "len"
                                                                                                )
                                                                                            ]
                                                                                        )
                                                                                    )
                                                                                )
                                                                            , H.node1
                                                                                215
                                                                                58
                                                                                62
                                                                                (H.val
                                                                                    "list"
                                                                                )
                                                                            ]
                                                                        )
                                                                    )
                                                                )
                                                            , H.node1
                                                                216
                                                                17
                                                                57
                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                    (H.node1
                                                                        216
                                                                        18
                                                                        56
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                216
                                                                                18
                                                                                27
                                                                                (H.val
                                                                                    "cycleHelp"
                                                                                )
                                                                            , H.node1
                                                                                216
                                                                                28
                                                                                30
                                                                                (Elm.Syntax.Expression.ListExpr
                                                                                    []
                                                                                )
                                                                            , H.node1
                                                                                216
                                                                                31
                                                                                51
                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                    (H.node1
                                                                                        216
                                                                                        32
                                                                                        50
                                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                                            "//"
                                                                                            Elm.Syntax.Infix.Left
                                                                                            (H.node1
                                                                                                216
                                                                                                32
                                                                                                35
                                                                                                (H.val
                                                                                                    "len"
                                                                                                )
                                                                                            )
                                                                                            (H.node1
                                                                                                216
                                                                                                39
                                                                                                50
                                                                                                (H.val
                                                                                                    "cycleLength"
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                            , H.node1
                                                                                216
                                                                                52
                                                                                56
                                                                                (H.val
                                                                                    "list"
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
                                        220
                                        9
                                        27
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                220
                                                9
                                                18
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "List" ]
                                                    "take"
                                                )
                                            , H.node1 220 19 22 (H.val "len")
                                            , H.node1 220 23 27 (H.val "list")
                                            ]
                                        )
                                    )
                                )
                            )
                        )
                }
            )
    }


cycleHelp : Elm.Syntax.Expression.FunctionImplementation
cycleHelp =
    { name = H.node1 224 1 10 "List.Extra.cycleHelp"
    , arguments =
        [ H.node1 224 11 14 (Elm.Syntax.Pattern.VarPattern "acc")
        , H.node1 224 15 16 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 224 17 21 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            225
            5
            229
            12
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    225
                    8
                    13
                    (Elm.Syntax.Expression.OperatorApplication
                        ">"
                        Elm.Syntax.Infix.Non
                        (H.node1 225 8 9 (H.val "n"))
                        (H.node1 225 12 13 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node1
                    226
                    9
                    56
                    (Elm.Syntax.Expression.Application
                        [ H.node1 226 9 18 (H.val "cycleHelp")
                        , H.node1
                            226
                            19
                            43
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    226
                                    20
                                    42
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            226
                                            20
                                            33
                                            (H.val "reverseAppend")
                                        , H.node1 226 34 38 (H.val "list")
                                        , H.node1 226 39 42 (H.val "acc")
                                        ]
                                    )
                                )
                            )
                        , H.node1
                            226
                            44
                            51
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    226
                                    45
                                    50
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "-"
                                        Elm.Syntax.Infix.Left
                                        (H.node1 226 45 46 (H.val "n"))
                                        (H.node1
                                            226
                                            49
                                            50
                                            (Elm.Syntax.Expression.Integer 1)
                                        )
                                    )
                                )
                            )
                        , H.node1 226 52 56 (H.val "list")
                        ]
                    )
                )
                (H.node1 229 9 12 (H.val "acc"))
            )
    }


reverseRange : Elm.Syntax.Expression.FunctionImplementation
reverseRange =
    { name = H.node1 244 1 13 "List.Extra.reverseRange"
    , arguments = []
    , expression =
        H.node
            245
            5
            254
            14
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        246
                        9
                        252
                        21
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    247
                                    9
                                    252
                                    21
                                    { name = H.node1 247 9 15 "helper"
                                    , arguments =
                                        [ H.node1
                                            247
                                            16
                                            20
                                            (Elm.Syntax.Pattern.VarPattern
                                                "list"
                                            )
                                        , H.node1
                                            247
                                            21
                                            25
                                            (Elm.Syntax.Pattern.VarPattern
                                                "high"
                                            )
                                        , H.node1
                                            247
                                            26
                                            29
                                            (Elm.Syntax.Pattern.VarPattern "low"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            248
                                            13
                                            252
                                            21
                                            (Elm.Syntax.Expression.IfBlock
                                                (H.node1
                                                    248
                                                    16
                                                    27
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        ">="
                                                        Elm.Syntax.Infix.Non
                                                        (H.node1
                                                            248
                                                            16
                                                            20
                                                            (H.val "high")
                                                        )
                                                        (H.node1
                                                            248
                                                            24
                                                            27
                                                            (H.val "low")
                                                        )
                                                    )
                                                )
                                                (H.node1
                                                    249
                                                    17
                                                    52
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            249
                                                            17
                                                            23
                                                            (H.val "helper")
                                                        , H.node1
                                                            249
                                                            24
                                                            37
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    249
                                                                    25
                                                                    36
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "::"
                                                                        Elm.Syntax.Infix.Right
                                                                        (H.node1
                                                                            249
                                                                            25
                                                                            28
                                                                            (H.val
                                                                                "low"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            249
                                                                            32
                                                                            36
                                                                            (H.val
                                                                                "list"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        , H.node1
                                                            249
                                                            38
                                                            42
                                                            (H.val "high")
                                                        , H.node1
                                                            249
                                                            43
                                                            52
                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                (H.node1
                                                                    249
                                                                    44
                                                                    51
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "+"
                                                                        Elm.Syntax.Infix.Left
                                                                        (H.node1
                                                                            249
                                                                            44
                                                                            47
                                                                            (H.val
                                                                                "low"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            249
                                                                            50
                                                                            51
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
                                                (H.node1
                                                    252
                                                    17
                                                    21
                                                    (H.val "list")
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        254
                        5
                        14
                        (Elm.Syntax.Expression.Application
                            [ H.node1 254 5 11 (H.val "helper")
                            , H.node1
                                254
                                12
                                14
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


uncons : Elm.Syntax.Expression.FunctionImplementation
uncons =
    { name = H.node1 267 1 7 "List.Extra.uncons"
    , arguments = [ H.node1 267 8 12 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node
            268
            5
            273
            33
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 268 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 269 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 270 13 20 (H.val "Nothing")
                      )
                    , ( H.node1
                            272
                            9
                            22
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    272
                                    9
                                    14
                                    (Elm.Syntax.Pattern.VarPattern "first")
                                )
                                (H.node1
                                    272
                                    18
                                    22
                                    (Elm.Syntax.Pattern.VarPattern "rest")
                                )
                            )
                      , H.node1
                            273
                            13
                            33
                            (Elm.Syntax.Expression.Application
                                [ H.node1 273 13 17 (H.val "Just")
                                , H.node1
                                    273
                                    18
                                    33
                                    (Elm.Syntax.Expression.TupledExpression
                                        [ H.node1 273 20 25 (H.val "first")
                                        , H.node1 273 27 31 (H.val "rest")
                                        ]
                                    )
                                ]
                            )
                      )
                    ]
                }
            )
    }


unconsLast : Elm.Syntax.Expression.FunctionImplementation
unconsLast =
    { name = H.node1 286 1 11 "List.Extra.unconsLast"
    , arguments = [ H.node1 286 12 16 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node
            287
            5
            293
            24
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        287
                        10
                        27
                        (Elm.Syntax.Expression.Application
                            [ H.node1
                                287
                                10
                                22
                                (Elm.Syntax.Expression.FunctionOrValue
                                    [ "List" ]
                                    "reverse"
                                )
                            , H.node1 287 23 27 (H.val "list")
                            ]
                        )
                , cases =
                    [ ( H.node1 288 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 289 13 20 (H.val "Nothing")
                      )
                    , ( H.node1
                            291
                            9
                            22
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    291
                                    9
                                    14
                                    (Elm.Syntax.Pattern.VarPattern "last_")
                                )
                                (H.node1
                                    291
                                    18
                                    22
                                    (Elm.Syntax.Pattern.VarPattern "rest")
                                )
                            )
                      , H.node
                            292
                            13
                            293
                            24
                            (Elm.Syntax.Expression.OperatorApplication
                                "|>"
                                Elm.Syntax.Infix.Left
                                (H.node1
                                    292
                                    13
                                    41
                                    (Elm.Syntax.Expression.TupledExpression
                                        [ H.node1 292 15 20 (H.val "last_")
                                        , H.node1
                                            292
                                            22
                                            39
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    292
                                                    22
                                                    34
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "List" ]
                                                        "reverse"
                                                    )
                                                , H.node1
                                                    292
                                                    35
                                                    39
                                                    (H.val "rest")
                                                ]
                                            )
                                        ]
                                    )
                                )
                                (H.node1 293 20 24 (H.val "Just"))
                            )
                      )
                    ]
                }
            )
    }


maximumBy : Elm.Syntax.Expression.FunctionImplementation
maximumBy =
    { name = H.node1 299 1 10 "List.Extra.maximumBy"
    , arguments =
        [ H.node1 299 11 12 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 299 13 15 (Elm.Syntax.Pattern.VarPattern "ls")
        ]
    , expression =
        H.node
            300
            5
            320
            20
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        301
                        9
                        310
                        26
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    301
                                    9
                                    310
                                    26
                                    { name = H.node1 301 9 14 "maxBy"
                                    , arguments =
                                        [ H.node1
                                            301
                                            15
                                            16
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        , H.node1
                                            301
                                            17
                                            26
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    301
                                                    19
                                                    20
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "y"
                                                    )
                                                , H.node1
                                                    301
                                                    22
                                                    24
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "fy"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            302
                                            13
                                            310
                                            26
                                            (Elm.Syntax.Expression.LetExpression
                                                { declarations =
                                                    [ H.node
                                                        303
                                                        17
                                                        304
                                                        24
                                                        (Elm.Syntax.Expression.LetFunction
                                                            { documentation =
                                                                Nothing
                                                            , signature =
                                                                Nothing
                                                            , declaration =
                                                                H.node
                                                                    303
                                                                    17
                                                                    304
                                                                    24
                                                                    { name =
                                                                        H.node1
                                                                            303
                                                                            17
                                                                            19
                                                                            "fx"
                                                                    , arguments =
                                                                        []
                                                                    , expression =
                                                                        H.node1
                                                                            304
                                                                            21
                                                                            24
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    304
                                                                                    21
                                                                                    22
                                                                                    (H.val
                                                                                        "f"
                                                                                    )
                                                                                , H.node1
                                                                                    304
                                                                                    23
                                                                                    24
                                                                                    (H.val
                                                                                        "x"
                                                                                    )
                                                                                ]
                                                                            )
                                                                    }
                                                            }
                                                        )
                                                    ]
                                                , expression =
                                                    H.node
                                                        306
                                                        13
                                                        310
                                                        26
                                                        (Elm.Syntax.Expression.IfBlock
                                                            (H.node1
                                                                306
                                                                16
                                                                23
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    ">"
                                                                    Elm.Syntax.Infix.Non
                                                                    (H.node1
                                                                        306
                                                                        16
                                                                        18
                                                                        (H.val
                                                                            "fx"
                                                                        )
                                                                    )
                                                                    (H.node1
                                                                        306
                                                                        21
                                                                        23
                                                                        (H.val
                                                                            "fy"
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                            (H.node1
                                                                307
                                                                17
                                                                26
                                                                (Elm.Syntax.Expression.TupledExpression
                                                                    [ H.node1
                                                                        307
                                                                        19
                                                                        20
                                                                        (H.val
                                                                            "x"
                                                                        )
                                                                    , H.node1
                                                                        307
                                                                        22
                                                                        24
                                                                        (H.val
                                                                            "fx"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                            (H.node1
                                                                310
                                                                17
                                                                26
                                                                (Elm.Syntax.Expression.TupledExpression
                                                                    [ H.node1
                                                                        310
                                                                        19
                                                                        20
                                                                        (H.val
                                                                            "y"
                                                                        )
                                                                    , H.node1
                                                                        310
                                                                        22
                                                                        24
                                                                        (H.val
                                                                            "fy"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                        )
                                                }
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        312
                        5
                        320
                        20
                        (Elm.Syntax.Expression.CaseExpression
                            { expression = H.node1 312 10 12 (H.val "ls")
                            , cases =
                                [ ( H.node1
                                        313
                                        9
                                        15
                                        (Elm.Syntax.Pattern.ListPattern
                                            [ H.node1
                                                313
                                                11
                                                13
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "l_"
                                                )
                                            ]
                                        )
                                  , H.node1
                                        314
                                        13
                                        20
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 314 13 17 (H.val "Just")
                                            , H.node1 314 18 20 (H.val "l_")
                                            ]
                                        )
                                  )
                                , ( H.node1
                                        316
                                        9
                                        18
                                        (Elm.Syntax.Pattern.UnConsPattern
                                            (H.node1
                                                316
                                                9
                                                11
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "l_"
                                                )
                                            )
                                            (H.node1
                                                316
                                                15
                                                18
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "ls_"
                                                )
                                            )
                                        )
                                  , H.node1
                                        317
                                        13
                                        58
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "<|"
                                            Elm.Syntax.Infix.Right
                                            (H.node1 317 13 17 (H.val "Just"))
                                            (H.node1
                                                317
                                                21
                                                58
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "<|"
                                                    Elm.Syntax.Infix.Right
                                                    (H.node1
                                                        317
                                                        21
                                                        26
                                                        (H.val "first")
                                                    )
                                                    (H.node1
                                                        317
                                                        30
                                                        58
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                317
                                                                30
                                                                35
                                                                (H.val "foldl")
                                                            , H.node1
                                                                317
                                                                36
                                                                41
                                                                (H.val "maxBy")
                                                            , H.node1
                                                                317
                                                                42
                                                                54
                                                                (Elm.Syntax.Expression.TupledExpression
                                                                    [ H.node1
                                                                        317
                                                                        44
                                                                        46
                                                                        (H.val
                                                                            "l_"
                                                                        )
                                                                    , H.node1
                                                                        317
                                                                        48
                                                                        52
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                317
                                                                                48
                                                                                49
                                                                                (H.val
                                                                                    "f"
                                                                                )
                                                                            , H.node1
                                                                                317
                                                                                50
                                                                                52
                                                                                (H.val
                                                                                    "l_"
                                                                                )
                                                                            ]
                                                                        )
                                                                    ]
                                                                )
                                                            , H.node1
                                                                317
                                                                55
                                                                58
                                                                (H.val "ls_")
                                                            ]
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                  )
                                , ( H.node1
                                        319
                                        9
                                        10
                                        Elm.Syntax.Pattern.AllPattern
                                  , H.node1 320 13 20 (H.val "Nothing")
                                  )
                                ]
                            }
                        )
                }
            )
    }


maximumWith : Elm.Syntax.Expression.FunctionImplementation
maximumWith =
    { name = H.node1 335 1 12 "List.Extra.maximumWith"
    , arguments =
        [ H.node1 335 13 23 (Elm.Syntax.Pattern.VarPattern "comparator")
        , H.node1 335 24 28 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            336
            5
            345
            13
            (Elm.Syntax.Expression.Application
                [ H.node1 336 5 11 (H.val "foldl1")
                , H.node
                    337
                    9
                    344
                    10
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node
                            337
                            10
                            343
                            22
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        337
                                        11
                                        12
                                        (Elm.Syntax.Pattern.VarPattern "x")
                                    , H.node1
                                        337
                                        13
                                        14
                                        (Elm.Syntax.Pattern.VarPattern "y")
                                    ]
                                , expression =
                                    H.node
                                        338
                                        13
                                        343
                                        22
                                        (Elm.Syntax.Expression.CaseExpression
                                            { expression =
                                                H.node1
                                                    338
                                                    18
                                                    32
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            338
                                                            18
                                                            28
                                                            (H.val "comparator")
                                                        , H.node1
                                                            338
                                                            29
                                                            30
                                                            (H.val "x")
                                                        , H.node1
                                                            338
                                                            31
                                                            32
                                                            (H.val "y")
                                                        ]
                                                    )
                                            , cases =
                                                [ ( H.node1
                                                        339
                                                        17
                                                        19
                                                        (Elm.Syntax.Pattern.NamedPattern
                                                            { moduleName = []
                                                            , name = "GT"
                                                            }
                                                            []
                                                        )
                                                  , H.node1
                                                        340
                                                        21
                                                        22
                                                        (H.val "x")
                                                  )
                                                , ( H.node1
                                                        342
                                                        17
                                                        18
                                                        Elm.Syntax.Pattern.AllPattern
                                                  , H.node1
                                                        343
                                                        21
                                                        22
                                                        (H.val "y")
                                                  )
                                                ]
                                            }
                                        )
                                }
                            )
                        )
                    )
                , H.node1 345 9 13 (H.val "list")
                ]
            )
    }


minimumBy : Elm.Syntax.Expression.FunctionImplementation
minimumBy =
    { name = H.node1 351 1 10 "List.Extra.minimumBy"
    , arguments =
        [ H.node1 351 11 12 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 351 13 15 (Elm.Syntax.Pattern.VarPattern "ls")
        ]
    , expression =
        H.node
            352
            5
            372
            20
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        353
                        9
                        362
                        26
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    353
                                    9
                                    362
                                    26
                                    { name = H.node1 353 9 14 "minBy"
                                    , arguments =
                                        [ H.node1
                                            353
                                            15
                                            16
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        , H.node1
                                            353
                                            17
                                            26
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    353
                                                    19
                                                    20
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "y"
                                                    )
                                                , H.node1
                                                    353
                                                    22
                                                    24
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "fy"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            354
                                            13
                                            362
                                            26
                                            (Elm.Syntax.Expression.LetExpression
                                                { declarations =
                                                    [ H.node
                                                        355
                                                        17
                                                        356
                                                        24
                                                        (Elm.Syntax.Expression.LetFunction
                                                            { documentation =
                                                                Nothing
                                                            , signature =
                                                                Nothing
                                                            , declaration =
                                                                H.node
                                                                    355
                                                                    17
                                                                    356
                                                                    24
                                                                    { name =
                                                                        H.node1
                                                                            355
                                                                            17
                                                                            19
                                                                            "fx"
                                                                    , arguments =
                                                                        []
                                                                    , expression =
                                                                        H.node1
                                                                            356
                                                                            21
                                                                            24
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    356
                                                                                    21
                                                                                    22
                                                                                    (H.val
                                                                                        "f"
                                                                                    )
                                                                                , H.node1
                                                                                    356
                                                                                    23
                                                                                    24
                                                                                    (H.val
                                                                                        "x"
                                                                                    )
                                                                                ]
                                                                            )
                                                                    }
                                                            }
                                                        )
                                                    ]
                                                , expression =
                                                    H.node
                                                        358
                                                        13
                                                        362
                                                        26
                                                        (Elm.Syntax.Expression.IfBlock
                                                            (H.node1
                                                                358
                                                                16
                                                                23
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    "<"
                                                                    Elm.Syntax.Infix.Non
                                                                    (H.node1
                                                                        358
                                                                        16
                                                                        18
                                                                        (H.val
                                                                            "fx"
                                                                        )
                                                                    )
                                                                    (H.node1
                                                                        358
                                                                        21
                                                                        23
                                                                        (H.val
                                                                            "fy"
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                            (H.node1
                                                                359
                                                                17
                                                                26
                                                                (Elm.Syntax.Expression.TupledExpression
                                                                    [ H.node1
                                                                        359
                                                                        19
                                                                        20
                                                                        (H.val
                                                                            "x"
                                                                        )
                                                                    , H.node1
                                                                        359
                                                                        22
                                                                        24
                                                                        (H.val
                                                                            "fx"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                            (H.node1
                                                                362
                                                                17
                                                                26
                                                                (Elm.Syntax.Expression.TupledExpression
                                                                    [ H.node1
                                                                        362
                                                                        19
                                                                        20
                                                                        (H.val
                                                                            "y"
                                                                        )
                                                                    , H.node1
                                                                        362
                                                                        22
                                                                        24
                                                                        (H.val
                                                                            "fy"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                        )
                                                }
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node
                        364
                        5
                        372
                        20
                        (Elm.Syntax.Expression.CaseExpression
                            { expression = H.node1 364 10 12 (H.val "ls")
                            , cases =
                                [ ( H.node1
                                        365
                                        9
                                        15
                                        (Elm.Syntax.Pattern.ListPattern
                                            [ H.node1
                                                365
                                                11
                                                13
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "l_"
                                                )
                                            ]
                                        )
                                  , H.node1
                                        366
                                        13
                                        20
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 366 13 17 (H.val "Just")
                                            , H.node1 366 18 20 (H.val "l_")
                                            ]
                                        )
                                  )
                                , ( H.node1
                                        368
                                        9
                                        18
                                        (Elm.Syntax.Pattern.UnConsPattern
                                            (H.node1
                                                368
                                                9
                                                11
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "l_"
                                                )
                                            )
                                            (H.node1
                                                368
                                                15
                                                18
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "ls_"
                                                )
                                            )
                                        )
                                  , H.node1
                                        369
                                        13
                                        58
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "<|"
                                            Elm.Syntax.Infix.Right
                                            (H.node1 369 13 17 (H.val "Just"))
                                            (H.node1
                                                369
                                                21
                                                58
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "<|"
                                                    Elm.Syntax.Infix.Right
                                                    (H.node1
                                                        369
                                                        21
                                                        26
                                                        (H.val "first")
                                                    )
                                                    (H.node1
                                                        369
                                                        30
                                                        58
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                369
                                                                30
                                                                35
                                                                (H.val "foldl")
                                                            , H.node1
                                                                369
                                                                36
                                                                41
                                                                (H.val "minBy")
                                                            , H.node1
                                                                369
                                                                42
                                                                54
                                                                (Elm.Syntax.Expression.TupledExpression
                                                                    [ H.node1
                                                                        369
                                                                        44
                                                                        46
                                                                        (H.val
                                                                            "l_"
                                                                        )
                                                                    , H.node1
                                                                        369
                                                                        48
                                                                        52
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                369
                                                                                48
                                                                                49
                                                                                (H.val
                                                                                    "f"
                                                                                )
                                                                            , H.node1
                                                                                369
                                                                                50
                                                                                52
                                                                                (H.val
                                                                                    "l_"
                                                                                )
                                                                            ]
                                                                        )
                                                                    ]
                                                                )
                                                            , H.node1
                                                                369
                                                                55
                                                                58
                                                                (H.val "ls_")
                                                            ]
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                  )
                                , ( H.node1
                                        371
                                        9
                                        10
                                        Elm.Syntax.Pattern.AllPattern
                                  , H.node1 372 13 20 (H.val "Nothing")
                                  )
                                ]
                            }
                        )
                }
            )
    }


minimumWith : Elm.Syntax.Expression.FunctionImplementation
minimumWith =
    { name = H.node1 386 1 12 "List.Extra.minimumWith"
    , arguments =
        [ H.node1 386 13 23 (Elm.Syntax.Pattern.VarPattern "comparator")
        , H.node1 386 24 28 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            387
            5
            396
            13
            (Elm.Syntax.Expression.Application
                [ H.node1 387 5 11 (H.val "foldl1")
                , H.node
                    388
                    9
                    395
                    10
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node
                            388
                            10
                            394
                            22
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        388
                                        11
                                        12
                                        (Elm.Syntax.Pattern.VarPattern "x")
                                    , H.node1
                                        388
                                        13
                                        14
                                        (Elm.Syntax.Pattern.VarPattern "y")
                                    ]
                                , expression =
                                    H.node
                                        389
                                        13
                                        394
                                        22
                                        (Elm.Syntax.Expression.CaseExpression
                                            { expression =
                                                H.node1
                                                    389
                                                    18
                                                    32
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            389
                                                            18
                                                            28
                                                            (H.val "comparator")
                                                        , H.node1
                                                            389
                                                            29
                                                            30
                                                            (H.val "x")
                                                        , H.node1
                                                            389
                                                            31
                                                            32
                                                            (H.val "y")
                                                        ]
                                                    )
                                            , cases =
                                                [ ( H.node1
                                                        390
                                                        17
                                                        19
                                                        (Elm.Syntax.Pattern.NamedPattern
                                                            { moduleName = []
                                                            , name = "LT"
                                                            }
                                                            []
                                                        )
                                                  , H.node1
                                                        391
                                                        21
                                                        22
                                                        (H.val "x")
                                                  )
                                                , ( H.node1
                                                        393
                                                        17
                                                        18
                                                        Elm.Syntax.Pattern.AllPattern
                                                  , H.node1
                                                        394
                                                        21
                                                        22
                                                        (H.val "y")
                                                  )
                                                ]
                                            }
                                        )
                                }
                            )
                        )
                    )
                , H.node1 396 9 13 (H.val "list")
                ]
            )
    }


takeWhile : Elm.Syntax.Expression.FunctionImplementation
takeWhile =
    { name = H.node1 402 1 10 "List.Extra.takeWhile"
    , arguments =
        [ H.node1 402 11 20 (Elm.Syntax.Pattern.VarPattern "predicate") ]
    , expression =
        H.node
            403
            5
            416
            21
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        404
                        9
                        414
                        42
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    404
                                    9
                                    414
                                    42
                                    { name = H.node1 404 9 22 "takeWhileMemo"
                                    , arguments =
                                        [ H.node1
                                            404
                                            23
                                            27
                                            (Elm.Syntax.Pattern.VarPattern
                                                "memo"
                                            )
                                        , H.node1
                                            404
                                            28
                                            32
                                            (Elm.Syntax.Pattern.VarPattern
                                                "list"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            405
                                            13
                                            414
                                            42
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        405
                                                        18
                                                        22
                                                        (H.val "list")
                                                , cases =
                                                    [ ( H.node1
                                                            406
                                                            17
                                                            19
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , H.node1
                                                            407
                                                            21
                                                            38
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    407
                                                                    21
                                                                    33
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , H.node1
                                                                    407
                                                                    34
                                                                    38
                                                                    (H.val
                                                                        "memo"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            409
                                                            17
                                                            24
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    409
                                                                    17
                                                                    18
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "x"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    409
                                                                    22
                                                                    24
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "xs"
                                                                    )
                                                                )
                                                            )
                                                      , H.node
                                                            410
                                                            21
                                                            414
                                                            42
                                                            (Elm.Syntax.Expression.IfBlock
                                                                (H.node1
                                                                    410
                                                                    24
                                                                    35
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            410
                                                                            24
                                                                            33
                                                                            (H.val
                                                                                "predicate"
                                                                            )
                                                                        , H.node1
                                                                            410
                                                                            34
                                                                            35
                                                                            (H.val
                                                                                "x"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                                (H.node1
                                                                    411
                                                                    25
                                                                    53
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            411
                                                                            25
                                                                            38
                                                                            (H.val
                                                                                "takeWhileMemo"
                                                                            )
                                                                        , H.node1
                                                                            411
                                                                            39
                                                                            50
                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                (H.node1
                                                                                    411
                                                                                    40
                                                                                    49
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "::"
                                                                                        Elm.Syntax.Infix.Right
                                                                                        (H.node1
                                                                                            411
                                                                                            40
                                                                                            41
                                                                                            (H.val
                                                                                                "x"
                                                                                            )
                                                                                        )
                                                                                        (H.node1
                                                                                            411
                                                                                            45
                                                                                            49
                                                                                            (H.val
                                                                                                "memo"
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                            )
                                                                        , H.node1
                                                                            411
                                                                            51
                                                                            53
                                                                            (H.val
                                                                                "xs"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                                (H.node1
                                                                    414
                                                                    25
                                                                    42
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            414
                                                                            25
                                                                            37
                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                [ "List"
                                                                                ]
                                                                                "reverse"
                                                                            )
                                                                        , H.node1
                                                                            414
                                                                            38
                                                                            42
                                                                            (H.val
                                                                                "memo"
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
                    H.node1
                        416
                        5
                        21
                        (Elm.Syntax.Expression.Application
                            [ H.node1 416 5 18 (H.val "takeWhileMemo")
                            , H.node1
                                416
                                19
                                21
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


dropWhile : Elm.Syntax.Expression.FunctionImplementation
dropWhile =
    { name = H.node1 422 1 10 "List.Extra.dropWhile"
    , arguments =
        [ H.node1 422 11 20 (Elm.Syntax.Pattern.VarPattern "predicate")
        , H.node1 422 21 25 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            423
            5
            432
            21
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 423 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 424 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 425 13 15 (Elm.Syntax.Expression.ListExpr [])
                      )
                    , ( H.node1
                            427
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    427
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    427
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node
                            428
                            13
                            432
                            21
                            (Elm.Syntax.Expression.IfBlock
                                (H.node1
                                    428
                                    16
                                    27
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 428 16 25 (H.val "predicate")
                                        , H.node1 428 26 27 (H.val "x")
                                        ]
                                    )
                                )
                                (H.node1
                                    429
                                    17
                                    39
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 429 17 26 (H.val "dropWhile")
                                        , H.node1 429 27 36 (H.val "predicate")
                                        , H.node1 429 37 39 (H.val "xs")
                                        ]
                                    )
                                )
                                (H.node1 432 17 21 (H.val "list"))
                            )
                      )
                    ]
                }
            )
    }


unique : Elm.Syntax.Expression.FunctionImplementation
unique =
    { name = H.node1 442 1 7 "List.Extra.unique"
    , arguments = [ H.node1 442 8 12 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node1
            443
            5
            35
            (Elm.Syntax.Expression.Application
                [ H.node1 443 5 15 (H.val "uniqueHelp")
                , H.node1 443 16 24 (H.val "identity")
                , H.node1 443 25 27 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 443 28 32 (H.val "list")
                , H.node1 443 33 35 (Elm.Syntax.Expression.ListExpr [])
                ]
            )
    }


uniqueBy : Elm.Syntax.Expression.FunctionImplementation
uniqueBy =
    { name = H.node1 449 1 9 "List.Extra.uniqueBy"
    , arguments =
        [ H.node1 449 10 11 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 449 12 16 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node1
            450
            5
            28
            (Elm.Syntax.Expression.Application
                [ H.node1 450 5 15 (H.val "uniqueHelp")
                , H.node1 450 16 17 (H.val "f")
                , H.node1 450 18 20 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 450 21 25 (H.val "list")
                , H.node1 450 26 28 (Elm.Syntax.Expression.ListExpr [])
                ]
            )
    }


allDifferent : Elm.Syntax.Expression.FunctionImplementation
allDifferent =
    { name = H.node1 463 1 13 "List.Extra.allDifferent"
    , arguments = [ H.node1 463 14 18 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node1
            464
            5
            33
            (Elm.Syntax.Expression.Application
                [ H.node1 464 5 19 (H.val "allDifferentBy")
                , H.node1 464 20 28 (H.val "identity")
                , H.node1 464 29 33 (H.val "list")
                ]
            )
    }


allDifferentBy : Elm.Syntax.Expression.FunctionImplementation
allDifferentBy =
    { name = H.node1 470 1 15 "List.Extra.allDifferentBy"
    , arguments =
        [ H.node1 470 16 17 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 470 18 22 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node1
            471
            5
            54
            (Elm.Syntax.Expression.OperatorApplication
                "=="
                Elm.Syntax.Infix.Non
                (H.node1
                    471
                    5
                    21
                    (Elm.Syntax.Expression.Application
                        [ H.node1
                            471
                            5
                            16
                            (Elm.Syntax.Expression.FunctionOrValue
                                [ "List" ]
                                "length"
                            )
                        , H.node1 471 17 21 (H.val "list")
                        ]
                    )
                )
                (H.node1
                    471
                    25
                    54
                    (Elm.Syntax.Expression.Application
                        [ H.node1
                            471
                            25
                            36
                            (Elm.Syntax.Expression.FunctionOrValue
                                [ "List" ]
                                "length"
                            )
                        , H.node1
                            471
                            37
                            54
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    471
                                    38
                                    53
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 471 38 46 (H.val "uniqueBy")
                                        , H.node1 471 47 48 (H.val "f")
                                        , H.node1 471 49 53 (H.val "list")
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                )
            )
    }


uniqueHelp : Elm.Syntax.Expression.FunctionImplementation
uniqueHelp =
    { name = H.node1 475 1 11 "List.Extra.uniqueHelp"
    , arguments =
        [ H.node1 475 12 13 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 475 14 22 (Elm.Syntax.Pattern.VarPattern "existing")
        , H.node1 475 23 32 (Elm.Syntax.Pattern.VarPattern "remaining")
        , H.node1 475 33 44 (Elm.Syntax.Pattern.VarPattern "accumulator")
        ]
    , expression =
        H.node
            476
            5
            489
            85
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 476 10 19 (H.val "remaining")
                , cases =
                    [ ( H.node1 477 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1
                            478
                            13
                            37
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    478
                                    13
                                    25
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "List" ]
                                        "reverse"
                                    )
                                , H.node1 478 26 37 (H.val "accumulator")
                                ]
                            )
                      )
                    , ( H.node1
                            480
                            9
                            22
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    480
                                    9
                                    14
                                    (Elm.Syntax.Pattern.VarPattern "first")
                                )
                                (H.node1
                                    480
                                    18
                                    22
                                    (Elm.Syntax.Pattern.VarPattern "rest")
                                )
                            )
                      , H.node
                            481
                            13
                            489
                            85
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ H.node
                                        482
                                        17
                                        483
                                        28
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    482
                                                    17
                                                    483
                                                    28
                                                    { name =
                                                        H.node1
                                                            482
                                                            17
                                                            30
                                                            "computedFirst"
                                                    , arguments = []
                                                    , expression =
                                                        H.node1
                                                            483
                                                            21
                                                            28
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    483
                                                                    21
                                                                    22
                                                                    (H.val "f")
                                                                , H.node1
                                                                    483
                                                                    23
                                                                    28
                                                                    (H.val
                                                                        "first"
                                                                    )
                                                                ]
                                                            )
                                                    }
                                            }
                                        )
                                    ]
                                , expression =
                                    H.node
                                        485
                                        13
                                        489
                                        85
                                        (Elm.Syntax.Expression.IfBlock
                                            (H.node1
                                                485
                                                16
                                                50
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        485
                                                        16
                                                        27
                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                            [ "List" ]
                                                            "member"
                                                        )
                                                    , H.node1
                                                        485
                                                        28
                                                        41
                                                        (H.val "computedFirst")
                                                    , H.node1
                                                        485
                                                        42
                                                        50
                                                        (H.val "existing")
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                486
                                                17
                                                55
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        486
                                                        17
                                                        27
                                                        (H.val "uniqueHelp")
                                                    , H.node1
                                                        486
                                                        28
                                                        29
                                                        (H.val "f")
                                                    , H.node1
                                                        486
                                                        30
                                                        38
                                                        (H.val "existing")
                                                    , H.node1
                                                        486
                                                        39
                                                        43
                                                        (H.val "rest")
                                                    , H.node1
                                                        486
                                                        44
                                                        55
                                                        (H.val "accumulator")
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                489
                                                17
                                                85
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        489
                                                        17
                                                        27
                                                        (H.val "uniqueHelp")
                                                    , H.node1
                                                        489
                                                        28
                                                        29
                                                        (H.val "f")
                                                    , H.node1
                                                        489
                                                        30
                                                        57
                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                            (H.node1
                                                                489
                                                                31
                                                                56
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    "::"
                                                                    Elm.Syntax.Infix.Right
                                                                    (H.node1
                                                                        489
                                                                        31
                                                                        44
                                                                        (H.val
                                                                            "computedFirst"
                                                                        )
                                                                    )
                                                                    (H.node1
                                                                        489
                                                                        48
                                                                        56
                                                                        (H.val
                                                                            "existing"
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    , H.node1
                                                        489
                                                        58
                                                        62
                                                        (H.val "rest")
                                                    , H.node1
                                                        489
                                                        63
                                                        85
                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                            (H.node1
                                                                489
                                                                64
                                                                84
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    "::"
                                                                    Elm.Syntax.Infix.Right
                                                                    (H.node1
                                                                        489
                                                                        64
                                                                        69
                                                                        (H.val
                                                                            "first"
                                                                        )
                                                                    )
                                                                    (H.node1
                                                                        489
                                                                        73
                                                                        84
                                                                        (H.val
                                                                            "accumulator"
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
                      )
                    ]
                }
            )
    }


andMap : Elm.Syntax.Expression.FunctionImplementation
andMap =
    { name = H.node1 520 1 7 "List.Extra.andMap"
    , arguments =
        [ H.node1 520 8 9 (Elm.Syntax.Pattern.VarPattern "l")
        , H.node1 520 10 12 (Elm.Syntax.Pattern.VarPattern "fl")
        ]
    , expression =
        H.node1
            521
            5
            19
            (Elm.Syntax.Expression.Application
                [ H.node1 521 5 9 (H.val "map2")
                , H.node1 521 10 14 (Elm.Syntax.Expression.PrefixOperator "<|")
                , H.node1 521 15 17 (H.val "fl")
                , H.node1 521 18 19 (H.val "l")
                ]
            )
    }


andThen : Elm.Syntax.Expression.FunctionImplementation
andThen =
    { name = H.node1 552 1 8 "List.Extra.andThen"
    , arguments = []
    , expression = H.node1 553 5 14 (H.val "concatMap")
    }


reverseMap : Elm.Syntax.Expression.FunctionImplementation
reverseMap =
    { name = H.node1 564 1 11 "List.Extra.reverseMap"
    , arguments =
        [ H.node1 564 12 13 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 564 14 16 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node1
            565
            5
            39
            (Elm.Syntax.Expression.Application
                [ H.node1 565 5 10 (H.val "foldl")
                , H.node1
                    565
                    11
                    33
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            565
                            12
                            32
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        565
                                        13
                                        14
                                        (Elm.Syntax.Pattern.VarPattern "x")
                                    , H.node1
                                        565
                                        15
                                        18
                                        (Elm.Syntax.Pattern.VarPattern "acc")
                                    ]
                                , expression =
                                    H.node1
                                        565
                                        22
                                        32
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "::"
                                            Elm.Syntax.Infix.Right
                                            (H.node1
                                                565
                                                22
                                                25
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        565
                                                        22
                                                        23
                                                        (H.val "f")
                                                    , H.node1
                                                        565
                                                        24
                                                        25
                                                        (H.val "x")
                                                    ]
                                                )
                                            )
                                            (H.node1 565 29 32 (H.val "acc"))
                                        )
                                }
                            )
                        )
                    )
                , H.node1 565 34 36 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 565 37 39 (H.val "xs")
                ]
            )
    }


notMember : Elm.Syntax.Expression.FunctionImplementation
notMember =
    { name = H.node1 578 1 10 "List.Extra.notMember"
    , arguments = [ H.node1 578 11 12 (Elm.Syntax.Pattern.VarPattern "x") ]
    , expression =
        H.node1
            579
            5
            20
            (Elm.Syntax.Expression.OperatorApplication
                "<<"
                Elm.Syntax.Infix.Left
                (H.node1 579 5 8 (H.val "not"))
                (H.node1
                    579
                    12
                    20
                    (Elm.Syntax.Expression.Application
                        [ H.node1 579 12 18 (H.val "member")
                        , H.node1 579 19 20 (H.val "x")
                        ]
                    )
                )
            )
    }


find : Elm.Syntax.Expression.FunctionImplementation
find =
    { name = H.node1 590 1 5 "List.Extra.find"
    , arguments =
        [ H.node1 590 6 15 (Elm.Syntax.Pattern.VarPattern "predicate")
        , H.node1 590 16 20 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            591
            5
            600
            36
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 591 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 592 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 593 13 20 (H.val "Nothing")
                      )
                    , ( H.node1
                            595
                            9
                            22
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    595
                                    9
                                    14
                                    (Elm.Syntax.Pattern.VarPattern "first")
                                )
                                (H.node1
                                    595
                                    18
                                    22
                                    (Elm.Syntax.Pattern.VarPattern "rest")
                                )
                            )
                      , H.node
                            596
                            13
                            600
                            36
                            (Elm.Syntax.Expression.IfBlock
                                (H.node1
                                    596
                                    16
                                    31
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 596 16 25 (H.val "predicate")
                                        , H.node1 596 26 31 (H.val "first")
                                        ]
                                    )
                                )
                                (H.node1
                                    597
                                    17
                                    27
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 597 17 21 (H.val "Just")
                                        , H.node1 597 22 27 (H.val "first")
                                        ]
                                    )
                                )
                                (H.node1
                                    600
                                    17
                                    36
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 600 17 21 (H.val "find")
                                        , H.node1 600 22 31 (H.val "predicate")
                                        , H.node1 600 32 36 (H.val "rest")
                                        ]
                                    )
                                )
                            )
                      )
                    ]
                }
            )
    }


elemIndex : Elm.Syntax.Expression.FunctionImplementation
elemIndex =
    { name = H.node1 616 1 10 "List.Extra.elemIndex"
    , arguments = [ H.node1 616 11 12 (Elm.Syntax.Pattern.VarPattern "x") ]
    , expression =
        H.node1
            617
            5
            23
            (Elm.Syntax.Expression.Application
                [ H.node1 617 5 14 (H.val "findIndex")
                , H.node1
                    617
                    15
                    23
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            617
                            16
                            22
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    617
                                    16
                                    20
                                    (Elm.Syntax.Expression.PrefixOperator "==")
                                , H.node1 617 21 22 (H.val "x")
                                ]
                            )
                        )
                    )
                ]
            )
    }


elemIndices : Elm.Syntax.Expression.FunctionImplementation
elemIndices =
    { name = H.node1 633 1 12 "List.Extra.elemIndices"
    , arguments = [ H.node1 633 13 14 (Elm.Syntax.Pattern.VarPattern "x") ]
    , expression =
        H.node1
            634
            5
            25
            (Elm.Syntax.Expression.Application
                [ H.node1 634 5 16 (H.val "findIndices")
                , H.node1
                    634
                    17
                    25
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            634
                            18
                            24
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    634
                                    18
                                    22
                                    (Elm.Syntax.Expression.PrefixOperator "==")
                                , H.node1 634 23 24 (H.val "x")
                                ]
                            )
                        )
                    )
                ]
            )
    }


findIndex : Elm.Syntax.Expression.FunctionImplementation
findIndex =
    { name = H.node1 654 1 10 "List.Extra.findIndex"
    , arguments = []
    , expression =
        H.node1
            655
            5
            20
            (Elm.Syntax.Expression.Application
                [ H.node1 655 5 18 (H.val "findIndexHelp")
                , H.node1 655 19 20 (Elm.Syntax.Expression.Integer 0)
                ]
            )
    }


findIndexHelp : Elm.Syntax.Expression.FunctionImplementation
findIndexHelp =
    { name = H.node1 659 1 14 "List.Extra.findIndexHelp"
    , arguments =
        [ H.node1 659 15 20 (Elm.Syntax.Pattern.VarPattern "index")
        , H.node1 659 21 30 (Elm.Syntax.Pattern.VarPattern "predicate")
        , H.node1 659 31 35 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            660
            5
            669
            55
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 660 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 661 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 662 13 20 (H.val "Nothing")
                      )
                    , ( H.node1
                            664
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    664
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    664
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node
                            665
                            13
                            669
                            55
                            (Elm.Syntax.Expression.IfBlock
                                (H.node1
                                    665
                                    16
                                    27
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 665 16 25 (H.val "predicate")
                                        , H.node1 665 26 27 (H.val "x")
                                        ]
                                    )
                                )
                                (H.node1
                                    666
                                    17
                                    27
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 666 17 21 (H.val "Just")
                                        , H.node1 666 22 27 (H.val "index")
                                        ]
                                    )
                                )
                                (H.node1
                                    669
                                    17
                                    55
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            669
                                            17
                                            30
                                            (H.val "findIndexHelp")
                                        , H.node1
                                            669
                                            31
                                            42
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    669
                                                    32
                                                    41
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "+"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            669
                                                            32
                                                            37
                                                            (H.val "index")
                                                        )
                                                        (H.node1
                                                            669
                                                            40
                                                            41
                                                            (Elm.Syntax.Expression.Integer
                                                                1
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        , H.node1 669 43 52 (H.val "predicate")
                                        , H.node1 669 53 55 (H.val "xs")
                                        ]
                                    )
                                )
                            )
                      )
                    ]
                }
            )
    }


findIndices : Elm.Syntax.Expression.FunctionImplementation
findIndices =
    { name = H.node1 689 1 12 "List.Extra.findIndices"
    , arguments =
        [ H.node1 689 13 22 (Elm.Syntax.Pattern.VarPattern "predicate") ]
    , expression =
        H.node
            690
            5
            698
            32
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        691
                        9
                        696
                        20
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    691
                                    9
                                    696
                                    20
                                    { name = H.node1 691 9 20 "consIndexIf"
                                    , arguments =
                                        [ H.node1
                                            691
                                            21
                                            26
                                            (Elm.Syntax.Pattern.VarPattern
                                                "index"
                                            )
                                        , H.node1
                                            691
                                            27
                                            28
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        , H.node1
                                            691
                                            29
                                            32
                                            (Elm.Syntax.Pattern.VarPattern "acc"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            692
                                            13
                                            696
                                            20
                                            (Elm.Syntax.Expression.IfBlock
                                                (H.node1
                                                    692
                                                    16
                                                    27
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            692
                                                            16
                                                            25
                                                            (H.val "predicate")
                                                        , H.node1
                                                            692
                                                            26
                                                            27
                                                            (H.val "x")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    693
                                                    17
                                                    29
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "::"
                                                        Elm.Syntax.Infix.Right
                                                        (H.node1
                                                            693
                                                            17
                                                            22
                                                            (H.val "index")
                                                        )
                                                        (H.node1
                                                            693
                                                            26
                                                            29
                                                            (H.val "acc")
                                                        )
                                                    )
                                                )
                                                (H.node1 696 17 20 (H.val "acc")
                                                )
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        698
                        5
                        32
                        (Elm.Syntax.Expression.Application
                            [ H.node1 698 5 17 (H.val "indexedFoldr")
                            , H.node1 698 18 29 (H.val "consIndexIf")
                            , H.node1
                                698
                                30
                                32
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


findMap : Elm.Syntax.Expression.FunctionImplementation
findMap =
    { name = H.node1 741 1 8 "List.Extra.findMap"
    , arguments =
        [ H.node1 741 9 10 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 741 11 15 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            742
            5
            752
            35
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 742 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 743 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 744 13 20 (H.val "Nothing")
                      )
                    , ( H.node1
                            746
                            9
                            18
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    746
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "a")
                                )
                                (H.node1
                                    746
                                    14
                                    18
                                    (Elm.Syntax.Pattern.VarPattern "tail")
                                )
                            )
                      , H.node
                            747
                            13
                            752
                            35
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    H.node1
                                        747
                                        18
                                        21
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 747 18 19 (H.val "f")
                                            , H.node1 747 20 21 (H.val "a")
                                            ]
                                        )
                                , cases =
                                    [ ( H.node1
                                            748
                                            17
                                            23
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Just"
                                                }
                                                [ H.node1
                                                    748
                                                    22
                                                    23
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "b"
                                                    )
                                                ]
                                            )
                                      , H.node1
                                            749
                                            21
                                            27
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    749
                                                    21
                                                    25
                                                    (H.val "Just")
                                                , H.node1 749 26 27 (H.val "b")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            751
                                            17
                                            24
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Nothing"
                                                }
                                                []
                                            )
                                      , H.node1
                                            752
                                            21
                                            35
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    752
                                                    21
                                                    28
                                                    (H.val "findMap")
                                                , H.node1 752 29 30 (H.val "f")
                                                , H.node1
                                                    752
                                                    31
                                                    35
                                                    (H.val "tail")
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


count : Elm.Syntax.Expression.FunctionImplementation
count =
    { name = H.node1 769 1 6 "List.Extra.count"
    , arguments =
        [ H.node1 769 7 16 (Elm.Syntax.Pattern.VarPattern "predicate") ]
    , expression =
        H.node
            770
            5
            778
            10
            (Elm.Syntax.Expression.Application
                [ H.node1
                    770
                    5
                    15
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "foldl")
                , H.node
                    771
                    9
                    777
                    10
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node
                            771
                            10
                            776
                            20
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        771
                                        11
                                        12
                                        (Elm.Syntax.Pattern.VarPattern "x")
                                    , H.node1
                                        771
                                        13
                                        16
                                        (Elm.Syntax.Pattern.VarPattern "acc")
                                    ]
                                , expression =
                                    H.node
                                        772
                                        13
                                        776
                                        20
                                        (Elm.Syntax.Expression.IfBlock
                                            (H.node1
                                                772
                                                16
                                                27
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        772
                                                        16
                                                        25
                                                        (H.val "predicate")
                                                    , H.node1
                                                        772
                                                        26
                                                        27
                                                        (H.val "x")
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                773
                                                17
                                                24
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "+"
                                                    Elm.Syntax.Infix.Left
                                                    (H.node1
                                                        773
                                                        17
                                                        20
                                                        (H.val "acc")
                                                    )
                                                    (H.node1
                                                        773
                                                        23
                                                        24
                                                        (Elm.Syntax.Expression.Integer
                                                            1
                                                        )
                                                    )
                                                )
                                            )
                                            (H.node1 776 17 20 (H.val "acc"))
                                        )
                                }
                            )
                        )
                    )
                , H.node1 778 9 10 (Elm.Syntax.Expression.Integer 0)
                ]
            )
    }


setIf : Elm.Syntax.Expression.FunctionImplementation
setIf =
    { name = H.node1 784 1 6 "List.Extra.setIf"
    , arguments =
        [ H.node1 784 7 16 (Elm.Syntax.Pattern.VarPattern "predicate")
        , H.node1 784 17 28 (Elm.Syntax.Pattern.VarPattern "replacement")
        , H.node1 784 29 33 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node1
            785
            5
            49
            (Elm.Syntax.Expression.Application
                [ H.node1 785 5 13 (H.val "updateIf")
                , H.node1 785 14 23 (H.val "predicate")
                , H.node1
                    785
                    24
                    44
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            785
                            25
                            43
                            (Elm.Syntax.Expression.Application
                                [ H.node1 785 25 31 (H.val "always")
                                , H.node1 785 32 43 (H.val "replacement")
                                ]
                            )
                        )
                    )
                , H.node1 785 45 49 (H.val "list")
                ]
            )
    }


updateIf : Elm.Syntax.Expression.FunctionImplementation
updateIf =
    { name = H.node1 791 1 9 "List.Extra.updateIf"
    , arguments =
        [ H.node1 791 10 19 (Elm.Syntax.Pattern.VarPattern "predicate")
        , H.node1 791 20 26 (Elm.Syntax.Pattern.VarPattern "update")
        , H.node1 791 27 31 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            792
            5
            800
            13
            (Elm.Syntax.Expression.Application
                [ H.node1
                    792
                    5
                    13
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "map")
                , H.node
                    793
                    9
                    799
                    10
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node
                            793
                            10
                            798
                            21
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        793
                                        11
                                        15
                                        (Elm.Syntax.Pattern.VarPattern "item")
                                    ]
                                , expression =
                                    H.node
                                        794
                                        13
                                        798
                                        21
                                        (Elm.Syntax.Expression.IfBlock
                                            (H.node1
                                                794
                                                16
                                                30
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        794
                                                        16
                                                        25
                                                        (H.val "predicate")
                                                    , H.node1
                                                        794
                                                        26
                                                        30
                                                        (H.val "item")
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                795
                                                17
                                                28
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        795
                                                        17
                                                        23
                                                        (H.val "update")
                                                    , H.node1
                                                        795
                                                        24
                                                        28
                                                        (H.val "item")
                                                    ]
                                                )
                                            )
                                            (H.node1 798 17 21 (H.val "item"))
                                        )
                                }
                            )
                        )
                    )
                , H.node1 800 9 13 (H.val "list")
                ]
            )
    }


updateAt : Elm.Syntax.Expression.FunctionImplementation
updateAt =
    { name = H.node1 812 1 9 "List.Extra.updateAt"
    , arguments =
        [ H.node1 812 10 15 (Elm.Syntax.Pattern.VarPattern "index")
        , H.node1 812 16 18 (Elm.Syntax.Pattern.VarPattern "fn")
        , H.node1 812 19 23 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            813
            5
            827
            21
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    813
                    8
                    17
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Non
                        (H.node1 813 8 13 (H.val "index"))
                        (H.node1 813 16 17 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node1 814 9 13 (H.val "list"))
                (H.node
                    817
                    9
                    827
                    21
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ H.node
                                818
                                13
                                820
                                37
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            819
                                            13
                                            820
                                            37
                                            { name = H.node1 819 13 17 "tail"
                                            , arguments = []
                                            , expression =
                                                H.node1
                                                    820
                                                    17
                                                    37
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            820
                                                            17
                                                            26
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "List" ]
                                                                "drop"
                                                            )
                                                        , H.node1
                                                            820
                                                            27
                                                            32
                                                            (H.val "index")
                                                        , H.node1
                                                            820
                                                            33
                                                            37
                                                            (H.val "list")
                                                        ]
                                                    )
                                            }
                                    }
                                )
                            ]
                        , expression =
                            H.node
                                822
                                9
                                827
                                21
                                (Elm.Syntax.Expression.CaseExpression
                                    { expression =
                                        H.node1 822 14 18 (H.val "tail")
                                    , cases =
                                        [ ( H.node1
                                                823
                                                13
                                                20
                                                (Elm.Syntax.Pattern.UnConsPattern
                                                    (H.node1
                                                        823
                                                        13
                                                        14
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "x"
                                                        )
                                                    )
                                                    (H.node1
                                                        823
                                                        18
                                                        20
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "xs"
                                                        )
                                                    )
                                                )
                                          , H.node1
                                                824
                                                17
                                                51
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "++"
                                                    Elm.Syntax.Infix.Right
                                                    (H.node1
                                                        824
                                                        17
                                                        37
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                824
                                                                17
                                                                26
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    [ "List" ]
                                                                    "take"
                                                                )
                                                            , H.node1
                                                                824
                                                                27
                                                                32
                                                                (H.val "index")
                                                            , H.node1
                                                                824
                                                                33
                                                                37
                                                                (H.val "list")
                                                            ]
                                                        )
                                                    )
                                                    (H.node1
                                                        824
                                                        41
                                                        51
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "::"
                                                            Elm.Syntax.Infix.Right
                                                            (H.node1
                                                                824
                                                                41
                                                                45
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        824
                                                                        41
                                                                        43
                                                                        (H.val
                                                                            "fn"
                                                                        )
                                                                    , H.node1
                                                                        824
                                                                        44
                                                                        45
                                                                        (H.val
                                                                            "x"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                            (H.node1
                                                                824
                                                                49
                                                                51
                                                                (H.val "xs")
                                                            )
                                                        )
                                                    )
                                                )
                                          )
                                        , ( H.node1
                                                826
                                                13
                                                15
                                                (Elm.Syntax.Pattern.ListPattern
                                                    []
                                                )
                                          , H.node1 827 17 21 (H.val "list")
                                          )
                                        ]
                                    }
                                )
                        }
                    )
                )
            )
    }


updateIfIndex : Elm.Syntax.Expression.FunctionImplementation
updateIfIndex =
    { name = H.node1 839 1 14 "List.Extra.updateIfIndex"
    , arguments =
        [ H.node1 839 15 24 (Elm.Syntax.Pattern.VarPattern "predicate")
        , H.node1 839 25 31 (Elm.Syntax.Pattern.VarPattern "update")
        , H.node1 839 32 36 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            840
            5
            848
            13
            (Elm.Syntax.Expression.Application
                [ H.node1
                    840
                    5
                    20
                    (Elm.Syntax.Expression.FunctionOrValue
                        [ "List" ]
                        "indexedMap"
                    )
                , H.node
                    841
                    9
                    847
                    10
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node
                            841
                            10
                            846
                            18
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        841
                                        11
                                        12
                                        (Elm.Syntax.Pattern.VarPattern "i")
                                    , H.node1
                                        841
                                        13
                                        14
                                        (Elm.Syntax.Pattern.VarPattern "x")
                                    ]
                                , expression =
                                    H.node
                                        842
                                        13
                                        846
                                        18
                                        (Elm.Syntax.Expression.IfBlock
                                            (H.node1
                                                842
                                                16
                                                27
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        842
                                                        16
                                                        25
                                                        (H.val "predicate")
                                                    , H.node1
                                                        842
                                                        26
                                                        27
                                                        (H.val "i")
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                843
                                                17
                                                25
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        843
                                                        17
                                                        23
                                                        (H.val "update")
                                                    , H.node1
                                                        843
                                                        24
                                                        25
                                                        (H.val "x")
                                                    ]
                                                )
                                            )
                                            (H.node1 846 17 18 (H.val "x"))
                                        )
                                }
                            )
                        )
                    )
                , H.node1 848 9 13 (H.val "list")
                ]
            )
    }


remove : Elm.Syntax.Expression.FunctionImplementation
remove =
    { name = H.node1 854 1 7 "List.Extra.remove"
    , arguments =
        [ H.node1 854 8 9 (Elm.Syntax.Pattern.VarPattern "x")
        , H.node1 854 10 12 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node1
            855
            5
            26
            (Elm.Syntax.Expression.Application
                [ H.node1 855 5 15 (H.val "removeHelp")
                , H.node1 855 16 18 (H.val "xs")
                , H.node1 855 19 20 (H.val "x")
                , H.node1 855 21 23 (H.val "xs")
                , H.node1 855 24 26 (Elm.Syntax.Expression.ListExpr [])
                ]
            )
    }


removeHelp : Elm.Syntax.Expression.FunctionImplementation
removeHelp =
    { name = H.node1 859 1 11 "List.Extra.removeHelp"
    , arguments =
        [ H.node1 859 12 16 (Elm.Syntax.Pattern.VarPattern "list")
        , H.node1 859 17 18 (Elm.Syntax.Pattern.VarPattern "x")
        , H.node1 859 19 21 (Elm.Syntax.Pattern.VarPattern "xs")
        , H.node1 859 22 38 (Elm.Syntax.Pattern.VarPattern "previousElements")
        ]
    , expression =
        H.node
            860
            5
            869
            61
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 860 10 12 (H.val "xs")
                , cases =
                    [ ( H.node1 861 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 862 13 17 (H.val "list")
                      )
                    , ( H.node1
                            864
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    864
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "y")
                                )
                                (H.node1
                                    864
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "ys")
                                )
                            )
                      , H.node
                            865
                            13
                            869
                            61
                            (Elm.Syntax.Expression.IfBlock
                                (H.node1
                                    865
                                    16
                                    22
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "=="
                                        Elm.Syntax.Infix.Non
                                        (H.node1 865 16 17 (H.val "x"))
                                        (H.node1 865 21 22 (H.val "y"))
                                    )
                                )
                                (H.node1
                                    866
                                    17
                                    50
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            866
                                            17
                                            30
                                            (H.val "reverseAppend")
                                        , H.node1
                                            866
                                            31
                                            47
                                            (H.val "previousElements")
                                        , H.node1 866 48 50 (H.val "ys")
                                        ]
                                    )
                                )
                                (H.node1
                                    869
                                    17
                                    61
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 869 17 27 (H.val "removeHelp")
                                        , H.node1 869 28 32 (H.val "list")
                                        , H.node1 869 33 34 (H.val "x")
                                        , H.node1 869 35 37 (H.val "ys")
                                        , H.node1
                                            869
                                            38
                                            61
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    869
                                                    39
                                                    60
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "::"
                                                        Elm.Syntax.Infix.Right
                                                        (H.node1
                                                            869
                                                            39
                                                            40
                                                            (H.val "y")
                                                        )
                                                        (H.node1
                                                            869
                                                            44
                                                            60
                                                            (H.val
                                                                "previousElements"
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
                    ]
                }
            )
    }


setAt : Elm.Syntax.Expression.FunctionImplementation
setAt =
    { name = H.node1 879 1 6 "List.Extra.setAt"
    , arguments =
        [ H.node1 879 7 12 (Elm.Syntax.Pattern.VarPattern "index")
        , H.node1 879 13 18 (Elm.Syntax.Pattern.VarPattern "value")
        ]
    , expression =
        H.node1
            880
            5
            34
            (Elm.Syntax.Expression.Application
                [ H.node1 880 5 13 (H.val "updateAt")
                , H.node1 880 14 19 (H.val "index")
                , H.node1
                    880
                    20
                    34
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            880
                            21
                            33
                            (Elm.Syntax.Expression.Application
                                [ H.node1 880 21 27 (H.val "always")
                                , H.node1 880 28 33 (H.val "value")
                                ]
                            )
                        )
                    )
                ]
            )
    }


stableSortWith : Elm.Syntax.Expression.FunctionImplementation
stableSortWith =
    { name = H.node1 888 1 15 "List.Extra.stableSortWith"
    , arguments =
        [ H.node1 888 16 20 (Elm.Syntax.Pattern.VarPattern "pred")
        , H.node1 888 21 25 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            889
            5
            905
            64
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        890
                        9
                        891
                        52
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    890
                                    9
                                    891
                                    52
                                    { name = H.node1 890 9 22 "listWithIndex"
                                    , arguments = []
                                    , expression =
                                        H.node1
                                            891
                                            13
                                            52
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    891
                                                    13
                                                    28
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "List" ]
                                                        "indexedMap"
                                                    )
                                                , H.node1
                                                    891
                                                    29
                                                    47
                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                        (H.node1
                                                            891
                                                            30
                                                            46
                                                            (Elm.Syntax.Expression.LambdaExpression
                                                                { args =
                                                                    [ H.node1
                                                                        891
                                                                        31
                                                                        32
                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                            "i"
                                                                        )
                                                                    , H.node1
                                                                        891
                                                                        33
                                                                        34
                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                            "a"
                                                                        )
                                                                    ]
                                                                , expression =
                                                                    H.node1
                                                                        891
                                                                        38
                                                                        46
                                                                        (Elm.Syntax.Expression.TupledExpression
                                                                            [ H.node1
                                                                                891
                                                                                40
                                                                                41
                                                                                (H.val
                                                                                    "a"
                                                                                )
                                                                            , H.node1
                                                                                891
                                                                                43
                                                                                44
                                                                                (H.val
                                                                                    "i"
                                                                                )
                                                                            ]
                                                                        )
                                                                }
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    891
                                                    48
                                                    52
                                                    (H.val "list")
                                                ]
                                            )
                                    }
                            }
                        )
                    , H.node
                        893
                        9
                        903
                        27
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    893
                                    9
                                    903
                                    27
                                    { name = H.node1 893 9 22 "predWithIndex"
                                    , arguments =
                                        [ H.node1
                                            893
                                            23
                                            33
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    893
                                                    25
                                                    27
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "a1"
                                                    )
                                                , H.node1
                                                    893
                                                    29
                                                    31
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "i1"
                                                    )
                                                ]
                                            )
                                        , H.node1
                                            893
                                            34
                                            44
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    893
                                                    36
                                                    38
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "a2"
                                                    )
                                                , H.node1
                                                    893
                                                    40
                                                    42
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "i2"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            894
                                            13
                                            903
                                            27
                                            (Elm.Syntax.Expression.LetExpression
                                                { declarations =
                                                    [ H.node
                                                        895
                                                        17
                                                        896
                                                        31
                                                        (Elm.Syntax.Expression.LetFunction
                                                            { documentation =
                                                                Nothing
                                                            , signature =
                                                                Nothing
                                                            , declaration =
                                                                H.node
                                                                    895
                                                                    17
                                                                    896
                                                                    31
                                                                    { name =
                                                                        H.node1
                                                                            895
                                                                            17
                                                                            23
                                                                            "result"
                                                                    , arguments =
                                                                        []
                                                                    , expression =
                                                                        H.node1
                                                                            896
                                                                            21
                                                                            31
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    896
                                                                                    21
                                                                                    25
                                                                                    (H.val
                                                                                        "pred"
                                                                                    )
                                                                                , H.node1
                                                                                    896
                                                                                    26
                                                                                    28
                                                                                    (H.val
                                                                                        "a1"
                                                                                    )
                                                                                , H.node1
                                                                                    896
                                                                                    29
                                                                                    31
                                                                                    (H.val
                                                                                        "a2"
                                                                                    )
                                                                                ]
                                                                            )
                                                                    }
                                                            }
                                                        )
                                                    ]
                                                , expression =
                                                    H.node
                                                        898
                                                        13
                                                        903
                                                        27
                                                        (Elm.Syntax.Expression.CaseExpression
                                                            { expression =
                                                                H.node1
                                                                    898
                                                                    18
                                                                    24
                                                                    (H.val
                                                                        "result"
                                                                    )
                                                            , cases =
                                                                [ ( H.node1
                                                                        899
                                                                        17
                                                                        26
                                                                        (Elm.Syntax.Pattern.NamedPattern
                                                                            { moduleName =
                                                                                [ "Basics"
                                                                                ]
                                                                            , name =
                                                                                "EQ"
                                                                            }
                                                                            []
                                                                        )
                                                                  , H.node1
                                                                        900
                                                                        21
                                                                        41
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                900
                                                                                21
                                                                                35
                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                    [ "Basics"
                                                                                    ]
                                                                                    "compare"
                                                                                )
                                                                            , H.node1
                                                                                900
                                                                                36
                                                                                38
                                                                                (H.val
                                                                                    "i1"
                                                                                )
                                                                            , H.node1
                                                                                900
                                                                                39
                                                                                41
                                                                                (H.val
                                                                                    "i2"
                                                                                )
                                                                            ]
                                                                        )
                                                                  )
                                                                , ( H.node1
                                                                        902
                                                                        17
                                                                        18
                                                                        Elm.Syntax.Pattern.AllPattern
                                                                  , H.node1
                                                                        903
                                                                        21
                                                                        27
                                                                        (H.val
                                                                            "result"
                                                                        )
                                                                  )
                                                                ]
                                                            }
                                                        )
                                                }
                                            )
                                    }
                            }
                        )
                    ]
                , expression =
                    H.node1
                        905
                        5
                        64
                        (Elm.Syntax.Expression.OperatorApplication
                            "|>"
                            Elm.Syntax.Infix.Left
                            (H.node1
                                905
                                5
                                46
                                (Elm.Syntax.Expression.Application
                                    [ H.node1
                                        905
                                        5
                                        18
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "List" ]
                                            "sortWith"
                                        )
                                    , H.node1 905 19 32 (H.val "predWithIndex")
                                    , H.node1 905 33 46 (H.val "listWithIndex")
                                    ]
                                )
                            )
                            (H.node1
                                905
                                50
                                64
                                (Elm.Syntax.Expression.Application
                                    [ H.node1
                                        905
                                        50
                                        58
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "List" ]
                                            "map"
                                        )
                                    , H.node1 905 59 64 (H.val "first")
                                    ]
                                )
                            )
                        )
                }
            )
    }


swapAt : Elm.Syntax.Expression.FunctionImplementation
swapAt =
    { name = H.node1 916 1 7 "List.Extra.swapAt"
    , arguments =
        [ H.node1 916 8 14 (Elm.Syntax.Pattern.VarPattern "index1")
        , H.node1 916 15 21 (Elm.Syntax.Pattern.VarPattern "index2")
        , H.node1 916 22 23 (Elm.Syntax.Pattern.VarPattern "l")
        ]
    , expression =
        H.node
            917
            5
            936
            18
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    917
                    8
                    38
                    (Elm.Syntax.Expression.OperatorApplication
                        "||"
                        Elm.Syntax.Infix.Right
                        (H.node1
                            917
                            8
                            24
                            (Elm.Syntax.Expression.OperatorApplication
                                "=="
                                Elm.Syntax.Infix.Non
                                (H.node1 917 8 14 (H.val "index1"))
                                (H.node1 917 18 24 (H.val "index2"))
                            )
                        )
                        (H.node1
                            917
                            28
                            38
                            (Elm.Syntax.Expression.OperatorApplication
                                "<"
                                Elm.Syntax.Infix.Non
                                (H.node1 917 28 34 (H.val "index1"))
                                (H.node1
                                    917
                                    37
                                    38
                                    (Elm.Syntax.Expression.Integer 0)
                                )
                            )
                        )
                    )
                )
                (H.node1 918 9 10 (H.val "l"))
                (H.node
                    920
                    10
                    936
                    18
                    (Elm.Syntax.Expression.IfBlock
                        (H.node1
                            920
                            13
                            28
                            (Elm.Syntax.Expression.OperatorApplication
                                ">"
                                Elm.Syntax.Infix.Non
                                (H.node1 920 13 19 (H.val "index1"))
                                (H.node1 920 22 28 (H.val "index2"))
                            )
                        )
                        (H.node1
                            921
                            9
                            31
                            (Elm.Syntax.Expression.Application
                                [ H.node1 921 9 15 (H.val "swapAt")
                                , H.node1 921 16 22 (H.val "index2")
                                , H.node1 921 23 29 (H.val "index1")
                                , H.node1 921 30 31 (H.val "l")
                                ]
                            )
                        )
                        (H.node
                            924
                            9
                            936
                            18
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ H.node
                                        925
                                        13
                                        926
                                        33
                                        (Elm.Syntax.Expression.LetDestructuring
                                            (H.node1
                                                925
                                                13
                                                29
                                                (Elm.Syntax.Pattern.TuplePattern
                                                    [ H.node1
                                                        925
                                                        15
                                                        20
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "part1"
                                                        )
                                                    , H.node1
                                                        925
                                                        22
                                                        27
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "tail1"
                                                        )
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                926
                                                17
                                                33
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        926
                                                        17
                                                        24
                                                        (H.val "splitAt")
                                                    , H.node1
                                                        926
                                                        25
                                                        31
                                                        (H.val "index1")
                                                    , H.node1
                                                        926
                                                        32
                                                        33
                                                        (H.val "l")
                                                    ]
                                                )
                                            )
                                        )
                                    , H.node
                                        928
                                        13
                                        929
                                        48
                                        (Elm.Syntax.Expression.LetDestructuring
                                            (H.node1
                                                928
                                                13
                                                29
                                                (Elm.Syntax.Pattern.TuplePattern
                                                    [ H.node1
                                                        928
                                                        15
                                                        20
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "head2"
                                                        )
                                                    , H.node1
                                                        928
                                                        22
                                                        27
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "tail2"
                                                        )
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                929
                                                17
                                                48
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        929
                                                        17
                                                        24
                                                        (H.val "splitAt")
                                                    , H.node1
                                                        929
                                                        25
                                                        42
                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                            (H.node1
                                                                929
                                                                26
                                                                41
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    "-"
                                                                    Elm.Syntax.Infix.Left
                                                                    (H.node1
                                                                        929
                                                                        26
                                                                        32
                                                                        (H.val
                                                                            "index2"
                                                                        )
                                                                    )
                                                                    (H.node1
                                                                        929
                                                                        35
                                                                        41
                                                                        (H.val
                                                                            "index1"
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    , H.node1
                                                        929
                                                        43
                                                        48
                                                        (H.val "tail1")
                                                    ]
                                                )
                                            )
                                        )
                                    ]
                                , expression =
                                    H.node
                                        931
                                        9
                                        936
                                        18
                                        (Elm.Syntax.Expression.CaseExpression
                                            { expression =
                                                H.node1
                                                    931
                                                    14
                                                    44
                                                    (Elm.Syntax.Expression.TupledExpression
                                                        [ H.node1
                                                            931
                                                            16
                                                            28
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    931
                                                                    16
                                                                    22
                                                                    (H.val
                                                                        "uncons"
                                                                    )
                                                                , H.node1
                                                                    931
                                                                    23
                                                                    28
                                                                    (H.val
                                                                        "head2"
                                                                    )
                                                                ]
                                                            )
                                                        , H.node1
                                                            931
                                                            30
                                                            42
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    931
                                                                    30
                                                                    36
                                                                    (H.val
                                                                        "uncons"
                                                                    )
                                                                , H.node1
                                                                    931
                                                                    37
                                                                    42
                                                                    (H.val
                                                                        "tail2"
                                                                    )
                                                                ]
                                                            )
                                                        ]
                                                    )
                                            , cases =
                                                [ ( H.node1
                                                        932
                                                        13
                                                        63
                                                        (Elm.Syntax.Pattern.TuplePattern
                                                            [ H.node1
                                                                932
                                                                15
                                                                37
                                                                (Elm.Syntax.Pattern.NamedPattern
                                                                    { moduleName =
                                                                        []
                                                                    , name =
                                                                        "Just"
                                                                    }
                                                                    [ H.node1
                                                                        932
                                                                        20
                                                                        37
                                                                        (Elm.Syntax.Pattern.TuplePattern
                                                                            [ H.node1
                                                                                932
                                                                                22
                                                                                28
                                                                                (Elm.Syntax.Pattern.VarPattern
                                                                                    "value1"
                                                                                )
                                                                            , H.node1
                                                                                932
                                                                                30
                                                                                35
                                                                                (Elm.Syntax.Pattern.VarPattern
                                                                                    "part2"
                                                                                )
                                                                            ]
                                                                        )
                                                                    ]
                                                                )
                                                            , H.node1
                                                                932
                                                                39
                                                                61
                                                                (Elm.Syntax.Pattern.NamedPattern
                                                                    { moduleName =
                                                                        []
                                                                    , name =
                                                                        "Just"
                                                                    }
                                                                    [ H.node1
                                                                        932
                                                                        44
                                                                        61
                                                                        (Elm.Syntax.Pattern.TuplePattern
                                                                            [ H.node1
                                                                                932
                                                                                46
                                                                                52
                                                                                (Elm.Syntax.Pattern.VarPattern
                                                                                    "value2"
                                                                                )
                                                                            , H.node1
                                                                                932
                                                                                54
                                                                                59
                                                                                (Elm.Syntax.Pattern.VarPattern
                                                                                    "part3"
                                                                                )
                                                                            ]
                                                                        )
                                                                    ]
                                                                )
                                                            ]
                                                        )
                                                  , H.node1
                                                        933
                                                        17
                                                        72
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                933
                                                                17
                                                                28
                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                    [ "List" ]
                                                                    "concat"
                                                                )
                                                            , H.node1
                                                                933
                                                                29
                                                                72
                                                                (Elm.Syntax.Expression.ListExpr
                                                                    [ H.node1
                                                                        933
                                                                        31
                                                                        36
                                                                        (H.val
                                                                            "part1"
                                                                        )
                                                                    , H.node1
                                                                        933
                                                                        38
                                                                        53
                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                            "::"
                                                                            Elm.Syntax.Infix.Right
                                                                            (H.node1
                                                                                933
                                                                                38
                                                                                44
                                                                                (H.val
                                                                                    "value2"
                                                                                )
                                                                            )
                                                                            (H.node1
                                                                                933
                                                                                48
                                                                                53
                                                                                (H.val
                                                                                    "part2"
                                                                                )
                                                                            )
                                                                        )
                                                                    , H.node1
                                                                        933
                                                                        55
                                                                        70
                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                            "::"
                                                                            Elm.Syntax.Infix.Right
                                                                            (H.node1
                                                                                933
                                                                                55
                                                                                61
                                                                                (H.val
                                                                                    "value1"
                                                                                )
                                                                            )
                                                                            (H.node1
                                                                                933
                                                                                65
                                                                                70
                                                                                (H.val
                                                                                    "part3"
                                                                                )
                                                                            )
                                                                        )
                                                                    ]
                                                                )
                                                            ]
                                                        )
                                                  )
                                                , ( H.node1
                                                        935
                                                        13
                                                        14
                                                        Elm.Syntax.Pattern.AllPattern
                                                  , H.node1
                                                        936
                                                        17
                                                        18
                                                        (H.val "l")
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


removeAt : Elm.Syntax.Expression.FunctionImplementation
removeAt =
    { name = H.node1 948 1 9 "List.Extra.removeAt"
    , arguments =
        [ H.node1 948 10 15 (Elm.Syntax.Pattern.VarPattern "index")
        , H.node1 948 16 17 (Elm.Syntax.Pattern.VarPattern "l")
        ]
    , expression =
        H.node
            949
            5
            958
            37
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    949
                    8
                    17
                    (Elm.Syntax.Expression.OperatorApplication
                        "<"
                        Elm.Syntax.Infix.Non
                        (H.node1 949 8 13 (H.val "index"))
                        (H.node1 949 16 17 (Elm.Syntax.Expression.Integer 0))
                    )
                )
                (H.node1 950 9 10 (H.val "l"))
                (H.node
                    953
                    9
                    958
                    37
                    (Elm.Syntax.Expression.CaseExpression
                        { expression =
                            H.node1
                                953
                                14
                                26
                                (Elm.Syntax.Expression.Application
                                    [ H.node1 953 14 18 (H.val "drop")
                                    , H.node1 953 19 24 (H.val "index")
                                    , H.node1 953 25 26 (H.val "l")
                                    ]
                                )
                        , cases =
                            [ ( H.node1
                                    954
                                    13
                                    15
                                    (Elm.Syntax.Pattern.ListPattern [])
                              , H.node1 955 17 18 (H.val "l")
                              )
                            , ( H.node1
                                    957
                                    13
                                    22
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (H.node1
                                            957
                                            13
                                            14
                                            Elm.Syntax.Pattern.AllPattern
                                        )
                                        (H.node1
                                            957
                                            18
                                            22
                                            (Elm.Syntax.Pattern.VarPattern
                                                "rest"
                                            )
                                        )
                                    )
                              , H.node1
                                    958
                                    17
                                    37
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "++"
                                        Elm.Syntax.Infix.Right
                                        (H.node1
                                            958
                                            17
                                            29
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    958
                                                    17
                                                    21
                                                    (H.val "take")
                                                , H.node1
                                                    958
                                                    22
                                                    27
                                                    (H.val "index")
                                                , H.node1 958 28 29 (H.val "l")
                                                ]
                                            )
                                        )
                                        (H.node1 958 33 37 (H.val "rest"))
                                    )
                              )
                            ]
                        }
                    )
                )
            )
    }


removeIfIndex : Elm.Syntax.Expression.FunctionImplementation
removeIfIndex =
    { name = H.node1 970 1 14 "List.Extra.removeIfIndex"
    , arguments =
        [ H.node1 970 15 24 (Elm.Syntax.Pattern.VarPattern "predicate") ]
    , expression =
        H.node
            971
            5
            979
            11
            (Elm.Syntax.Expression.Application
                [ H.node1 971 5 17 (H.val "indexedFoldr")
                , H.node
                    972
                    9
                    978
                    10
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node
                            972
                            10
                            977
                            28
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        972
                                        11
                                        16
                                        (Elm.Syntax.Pattern.VarPattern "index")
                                    , H.node1
                                        972
                                        17
                                        21
                                        (Elm.Syntax.Pattern.VarPattern "item")
                                    , H.node1
                                        972
                                        22
                                        25
                                        (Elm.Syntax.Pattern.VarPattern "acc")
                                    ]
                                , expression =
                                    H.node
                                        973
                                        13
                                        977
                                        28
                                        (Elm.Syntax.Expression.IfBlock
                                            (H.node1
                                                973
                                                16
                                                31
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        973
                                                        16
                                                        25
                                                        (H.val "predicate")
                                                    , H.node1
                                                        973
                                                        26
                                                        31
                                                        (H.val "index")
                                                    ]
                                                )
                                            )
                                            (H.node1 974 17 20 (H.val "acc"))
                                            (H.node1
                                                977
                                                17
                                                28
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "::"
                                                    Elm.Syntax.Infix.Right
                                                    (H.node1
                                                        977
                                                        17
                                                        21
                                                        (H.val "item")
                                                    )
                                                    (H.node1
                                                        977
                                                        25
                                                        28
                                                        (H.val "acc")
                                                    )
                                                )
                                            )
                                        )
                                }
                            )
                        )
                    )
                , H.node1 979 9 11 (Elm.Syntax.Expression.ListExpr [])
                ]
            )
    }


filterNot : Elm.Syntax.Expression.FunctionImplementation
filterNot =
    { name = H.node1 994 1 10 "List.Extra.filterNot"
    , arguments =
        [ H.node1 994 11 15 (Elm.Syntax.Pattern.VarPattern "pred")
        , H.node1 994 16 20 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node1
            995
            5
            35
            (Elm.Syntax.Expression.Application
                [ H.node1
                    995
                    5
                    16
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "filter")
                , H.node1
                    995
                    17
                    30
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            995
                            18
                            29
                            (Elm.Syntax.Expression.OperatorApplication
                                "<<"
                                Elm.Syntax.Infix.Left
                                (H.node1 995 18 21 (H.val "not"))
                                (H.node1 995 25 29 (H.val "pred"))
                            )
                        )
                    )
                , H.node1 995 31 35 (H.val "list")
                ]
            )
    }


intercalate : Elm.Syntax.Expression.FunctionImplementation
intercalate =
    { name = H.node1 1005 1 12 "List.Extra.intercalate"
    , arguments = [ H.node1 1005 13 15 (Elm.Syntax.Pattern.VarPattern "xs") ]
    , expression =
        H.node1
            1006
            5
            29
            (Elm.Syntax.Expression.OperatorApplication
                "<<"
                Elm.Syntax.Infix.Left
                (H.node1 1006 5 11 (H.val "concat"))
                (H.node1
                    1006
                    15
                    29
                    (Elm.Syntax.Expression.Application
                        [ H.node1 1006 15 26 (H.val "intersperse")
                        , H.node1 1006 27 29 (H.val "xs")
                        ]
                    )
                )
            )
    }


transpose : Elm.Syntax.Expression.FunctionImplementation
transpose =
    { name = H.node1 1019 1 10 "List.Extra.transpose"
    , arguments =
        [ H.node1 1019 11 22 (Elm.Syntax.Pattern.VarPattern "listOfLists") ]
    , expression =
        H.node1
            1020
            5
            86
            (Elm.Syntax.Expression.Application
                [ H.node1
                    1020
                    5
                    15
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "foldr")
                , H.node1
                    1020
                    16
                    32
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            1020
                            17
                            31
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    1020
                                    17
                                    26
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "List" ]
                                        "map2"
                                    )
                                , H.node1
                                    1020
                                    27
                                    31
                                    (Elm.Syntax.Expression.PrefixOperator "::")
                                ]
                            )
                        )
                    )
                , H.node1
                    1020
                    33
                    74
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            1020
                            34
                            73
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    1020
                                    34
                                    45
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "List" ]
                                        "repeat"
                                    )
                                , H.node1
                                    1020
                                    46
                                    70
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            1020
                                            47
                                            69
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    1020
                                                    47
                                                    57
                                                    (H.val "rowsLength")
                                                , H.node1
                                                    1020
                                                    58
                                                    69
                                                    (H.val "listOfLists")
                                                ]
                                            )
                                        )
                                    )
                                , H.node1
                                    1020
                                    71
                                    73
                                    (Elm.Syntax.Expression.ListExpr [])
                                ]
                            )
                        )
                    )
                , H.node1 1020 75 86 (H.val "listOfLists")
                ]
            )
    }


rowsLength : Elm.Syntax.Expression.FunctionImplementation
rowsLength =
    { name = H.node1 1024 1 11 "List.Extra.rowsLength"
    , arguments =
        [ H.node1 1024 12 23 (Elm.Syntax.Pattern.VarPattern "listOfLists") ]
    , expression =
        H.node
            1025
            5
            1030
            26
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1025 10 21 (H.val "listOfLists")
                , cases =
                    [ ( H.node1 1026 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1027 13 14 (Elm.Syntax.Expression.Integer 0)
                      )
                    , ( H.node1
                            1029
                            9
                            15
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1029
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1029
                                    14
                                    15
                                    Elm.Syntax.Pattern.AllPattern
                                )
                            )
                      , H.node1
                            1030
                            13
                            26
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    1030
                                    13
                                    24
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "List" ]
                                        "length"
                                    )
                                , H.node1 1030 25 26 (H.val "x")
                                ]
                            )
                      )
                    ]
                }
            )
    }


subsequences : Elm.Syntax.Expression.FunctionImplementation
subsequences =
    { name = H.node1 1040 1 13 "List.Extra.subsequences"
    , arguments = [ H.node1 1040 14 16 (Elm.Syntax.Pattern.VarPattern "xs") ]
    , expression =
        H.node1
            1041
            5
            30
            (Elm.Syntax.Expression.OperatorApplication
                "::"
                Elm.Syntax.Infix.Right
                (H.node1 1041 5 7 (Elm.Syntax.Expression.ListExpr []))
                (H.node1
                    1041
                    11
                    30
                    (Elm.Syntax.Expression.Application
                        [ H.node1 1041 11 27 (H.val "subsequencesHelp")
                        , H.node1 1041 28 30 (H.val "xs")
                        ]
                    )
                )
            )
    }


subsequencesHelp : Elm.Syntax.Expression.FunctionImplementation
subsequencesHelp =
    { name = H.node1 1051 1 17 "List.Extra.subsequencesHelp"
    , arguments = [ H.node1 1051 18 22 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node
            1052
            5
            1061
            60
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1052 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 1053 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1054 13 15 (Elm.Syntax.Expression.ListExpr [])
                      )
                    , ( H.node1
                            1056
                            9
                            22
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1056
                                    9
                                    14
                                    (Elm.Syntax.Pattern.VarPattern "first")
                                )
                                (H.node1
                                    1056
                                    18
                                    22
                                    (Elm.Syntax.Pattern.VarPattern "rest")
                                )
                            )
                      , H.node
                            1057
                            13
                            1061
                            60
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ H.node
                                        1058
                                        17
                                        1059
                                        45
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    1058
                                                    17
                                                    1059
                                                    45
                                                    { name =
                                                        H.node1 1058 17 18 "f"
                                                    , arguments =
                                                        [ H.node1
                                                            1058
                                                            19
                                                            21
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "ys"
                                                            )
                                                        , H.node1
                                                            1058
                                                            22
                                                            23
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "r"
                                                            )
                                                        ]
                                                    , expression =
                                                        H.node1
                                                            1059
                                                            21
                                                            45
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Right
                                                                (H.node1
                                                                    1059
                                                                    21
                                                                    23
                                                                    (H.val "ys")
                                                                )
                                                                (H.node1
                                                                    1059
                                                                    27
                                                                    45
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "::"
                                                                        Elm.Syntax.Infix.Right
                                                                        (H.node1
                                                                            1059
                                                                            27
                                                                            40
                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                (H.node1
                                                                                    1059
                                                                                    28
                                                                                    39
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "::"
                                                                                        Elm.Syntax.Infix.Right
                                                                                        (H.node1
                                                                                            1059
                                                                                            28
                                                                                            33
                                                                                            (H.val
                                                                                                "first"
                                                                                            )
                                                                                        )
                                                                                        (H.node1
                                                                                            1059
                                                                                            37
                                                                                            39
                                                                                            (H.val
                                                                                                "ys"
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            1059
                                                                            44
                                                                            45
                                                                            (H.val
                                                                                "r"
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
                                    H.node1
                                        1061
                                        13
                                        60
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "::"
                                            Elm.Syntax.Infix.Right
                                            (H.node1
                                                1061
                                                13
                                                22
                                                (Elm.Syntax.Expression.ListExpr
                                                    [ H.node1
                                                        1061
                                                        15
                                                        20
                                                        (H.val "first")
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                1061
                                                26
                                                60
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        1061
                                                        26
                                                        31
                                                        (H.val "foldr")
                                                    , H.node1
                                                        1061
                                                        32
                                                        33
                                                        (H.val "f")
                                                    , H.node1
                                                        1061
                                                        34
                                                        36
                                                        (Elm.Syntax.Expression.ListExpr
                                                            []
                                                        )
                                                    , H.node1
                                                        1061
                                                        37
                                                        60
                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                            (H.node1
                                                                1061
                                                                38
                                                                59
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        1061
                                                                        38
                                                                        54
                                                                        (H.val
                                                                            "subsequencesHelp"
                                                                        )
                                                                    , H.node1
                                                                        1061
                                                                        55
                                                                        59
                                                                        (H.val
                                                                            "rest"
                                                                        )
                                                                    ]
                                                                )
                                                            )
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


subsequencesNonEmpty : Elm.Syntax.Expression.FunctionImplementation
subsequencesNonEmpty =
    { name = H.node1 1071 1 21 "List.Extra.subsequencesNonEmpty"
    , arguments = [ H.node1 1071 22 26 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node
            1072
            5
            1082
            68
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1072 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 1073 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1074 13 15 (Elm.Syntax.Expression.ListExpr [])
                      )
                    , ( H.node1
                            1076
                            9
                            22
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1076
                                    9
                                    14
                                    (Elm.Syntax.Pattern.VarPattern "first")
                                )
                                (H.node1
                                    1076
                                    18
                                    22
                                    (Elm.Syntax.Pattern.VarPattern "rest")
                                )
                            )
                      , H.node
                            1077
                            13
                            1082
                            68
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ H.node
                                        1078
                                        17
                                        1080
                                        59
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    1079
                                                    17
                                                    1080
                                                    59
                                                    { name =
                                                        H.node1 1079 17 18 "f"
                                                    , arguments =
                                                        [ H.node1
                                                            1079
                                                            19
                                                            29
                                                            (Elm.Syntax.Pattern.TuplePattern
                                                                [ H.node1
                                                                    1079
                                                                    21
                                                                    23
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "yf"
                                                                    )
                                                                , H.node1
                                                                    1079
                                                                    25
                                                                    27
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "ys"
                                                                    )
                                                                ]
                                                            )
                                                        , H.node1
                                                            1079
                                                            30
                                                            31
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "r"
                                                            )
                                                        ]
                                                    , expression =
                                                        H.node1
                                                            1080
                                                            21
                                                            59
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Right
                                                                (H.node1
                                                                    1080
                                                                    21
                                                                    31
                                                                    (Elm.Syntax.Expression.TupledExpression
                                                                        [ H.node1
                                                                            1080
                                                                            23
                                                                            25
                                                                            (H.val
                                                                                "yf"
                                                                            )
                                                                        , H.node1
                                                                            1080
                                                                            27
                                                                            29
                                                                            (H.val
                                                                                "ys"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                                (H.node1
                                                                    1080
                                                                    35
                                                                    59
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "::"
                                                                        Elm.Syntax.Infix.Right
                                                                        (H.node1
                                                                            1080
                                                                            35
                                                                            54
                                                                            (Elm.Syntax.Expression.TupledExpression
                                                                                [ H.node1
                                                                                    1080
                                                                                    37
                                                                                    42
                                                                                    (H.val
                                                                                        "first"
                                                                                    )
                                                                                , H.node1
                                                                                    1080
                                                                                    44
                                                                                    52
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "::"
                                                                                        Elm.Syntax.Infix.Right
                                                                                        (H.node1
                                                                                            1080
                                                                                            44
                                                                                            46
                                                                                            (H.val
                                                                                                "yf"
                                                                                            )
                                                                                        )
                                                                                        (H.node1
                                                                                            1080
                                                                                            50
                                                                                            52
                                                                                            (H.val
                                                                                                "ys"
                                                                                            )
                                                                                        )
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            1080
                                                                            58
                                                                            59
                                                                            (H.val
                                                                                "r"
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
                                    H.node1
                                        1082
                                        13
                                        68
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "::"
                                            Elm.Syntax.Infix.Right
                                            (H.node1
                                                1082
                                                13
                                                26
                                                (Elm.Syntax.Expression.TupledExpression
                                                    [ H.node1
                                                        1082
                                                        15
                                                        20
                                                        (H.val "first")
                                                    , H.node1
                                                        1082
                                                        22
                                                        24
                                                        (Elm.Syntax.Expression.ListExpr
                                                            []
                                                        )
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                1082
                                                30
                                                68
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        1082
                                                        30
                                                        35
                                                        (H.val "foldr")
                                                    , H.node1
                                                        1082
                                                        36
                                                        37
                                                        (H.val "f")
                                                    , H.node1
                                                        1082
                                                        38
                                                        40
                                                        (Elm.Syntax.Expression.ListExpr
                                                            []
                                                        )
                                                    , H.node1
                                                        1082
                                                        41
                                                        68
                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                            (H.node1
                                                                1082
                                                                42
                                                                67
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        1082
                                                                        42
                                                                        62
                                                                        (H.val
                                                                            "subsequencesNonEmpty"
                                                                        )
                                                                    , H.node1
                                                                        1082
                                                                        63
                                                                        67
                                                                        (H.val
                                                                            "rest"
                                                                        )
                                                                    ]
                                                                )
                                                            )
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


permutations : Elm.Syntax.Expression.FunctionImplementation
permutations =
    { name = H.node1 1092 1 13 "List.Extra.permutations"
    , arguments = [ H.node1 1092 14 17 (Elm.Syntax.Pattern.VarPattern "xs_") ]
    , expression =
        H.node
            1093
            5
            1102
            36
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1093 10 13 (H.val "xs_")
                , cases =
                    [ ( H.node1 1094 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1
                            1095
                            13
                            19
                            (Elm.Syntax.Expression.ListExpr
                                [ H.node1
                                    1095
                                    15
                                    17
                                    (Elm.Syntax.Expression.ListExpr [])
                                ]
                            )
                      )
                    , ( H.node1 1097 9 11 (Elm.Syntax.Pattern.VarPattern "xs")
                      , H.node
                            1098
                            13
                            1102
                            36
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ H.node
                                        1099
                                        17
                                        1100
                                        51
                                        (Elm.Syntax.Expression.LetFunction
                                            { documentation = Nothing
                                            , signature = Nothing
                                            , declaration =
                                                H.node
                                                    1099
                                                    17
                                                    1100
                                                    51
                                                    { name =
                                                        H.node1 1099 17 18 "f"
                                                    , arguments =
                                                        [ H.node1
                                                            1099
                                                            19
                                                            28
                                                            (Elm.Syntax.Pattern.TuplePattern
                                                                [ H.node1
                                                                    1099
                                                                    21
                                                                    22
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "y"
                                                                    )
                                                                , H.node1
                                                                    1099
                                                                    24
                                                                    26
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "ys"
                                                                    )
                                                                ]
                                                            )
                                                        ]
                                                    , expression =
                                                        H.node1
                                                            1100
                                                            21
                                                            51
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    1100
                                                                    21
                                                                    24
                                                                    (H.val "map"
                                                                    )
                                                                , H.node1
                                                                    1100
                                                                    25
                                                                    33
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            1100
                                                                            26
                                                                            32
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    1100
                                                                                    26
                                                                                    30
                                                                                    (Elm.Syntax.Expression.PrefixOperator
                                                                                        "::"
                                                                                    )
                                                                                , H.node1
                                                                                    1100
                                                                                    31
                                                                                    32
                                                                                    (H.val
                                                                                        "y"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                , H.node1
                                                                    1100
                                                                    34
                                                                    51
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            1100
                                                                            35
                                                                            50
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    1100
                                                                                    35
                                                                                    47
                                                                                    (H.val
                                                                                        "permutations"
                                                                                    )
                                                                                , H.node1
                                                                                    1100
                                                                                    48
                                                                                    50
                                                                                    (H.val
                                                                                        "ys"
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
                                    ]
                                , expression =
                                    H.node1
                                        1102
                                        13
                                        36
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                1102
                                                13
                                                22
                                                (H.val "concatMap")
                                            , H.node1 1102 23 24 (H.val "f")
                                            , H.node1
                                                1102
                                                25
                                                36
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        1102
                                                        26
                                                        35
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                1102
                                                                26
                                                                32
                                                                (H.val "select")
                                                            , H.node1
                                                                1102
                                                                33
                                                                35
                                                                (H.val "xs")
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


interweave : Elm.Syntax.Expression.FunctionImplementation
interweave =
    { name = H.node1 1119 1 11 "List.Extra.interweave"
    , arguments = []
    , expression =
        H.node1
            1120
            5
            22
            (Elm.Syntax.Expression.Application
                [ H.node1 1120 5 19 (H.val "interweaveHelp")
                , H.node1 1120 20 22 (Elm.Syntax.Expression.ListExpr [])
                ]
            )
    }


interweaveHelp : Elm.Syntax.Expression.FunctionImplementation
interweaveHelp =
    { name = H.node1 1124 1 15 "List.Extra.interweaveHelp"
    , arguments =
        [ H.node1 1124 16 19 (Elm.Syntax.Pattern.VarPattern "acc")
        , H.node1 1124 20 25 (Elm.Syntax.Pattern.VarPattern "list1")
        , H.node1 1124 26 31 (Elm.Syntax.Pattern.VarPattern "list2")
        ]
    , expression =
        H.node
            1125
            5
            1133
            36
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        1125
                        10
                        26
                        (Elm.Syntax.Expression.TupledExpression
                            [ H.node1 1125 12 17 (H.val "list1")
                            , H.node1 1125 19 24 (H.val "list2")
                            ]
                        )
                , cases =
                    [ ( H.node1
                            1126
                            9
                            29
                            (Elm.Syntax.Pattern.TuplePattern
                                [ H.node1
                                    1126
                                    11
                                    18
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (H.node1
                                            1126
                                            11
                                            12
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        )
                                        (H.node1
                                            1126
                                            16
                                            18
                                            (Elm.Syntax.Pattern.VarPattern "xs")
                                        )
                                    )
                                , H.node1
                                    1126
                                    20
                                    27
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (H.node1
                                            1126
                                            20
                                            21
                                            (Elm.Syntax.Pattern.VarPattern "y")
                                        )
                                        (H.node1
                                            1126
                                            25
                                            27
                                            (Elm.Syntax.Pattern.VarPattern "ys")
                                        )
                                    )
                                ]
                            )
                      , H.node1
                            1127
                            13
                            49
                            (Elm.Syntax.Expression.Application
                                [ H.node1 1127 13 27 (H.val "interweaveHelp")
                                , H.node1
                                    1127
                                    28
                                    43
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            1127
                                            29
                                            42
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "::"
                                                Elm.Syntax.Infix.Right
                                                (H.node1 1127 29 30 (H.val "y"))
                                                (H.node1
                                                    1127
                                                    34
                                                    42
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "::"
                                                        Elm.Syntax.Infix.Right
                                                        (H.node1
                                                            1127
                                                            34
                                                            35
                                                            (H.val "x")
                                                        )
                                                        (H.node1
                                                            1127
                                                            39
                                                            42
                                                            (H.val "acc")
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                , H.node1 1127 44 46 (H.val "xs")
                                , H.node1 1127 47 49 (H.val "ys")
                                ]
                            )
                      )
                    , ( H.node1
                            1129
                            9
                            18
                            (Elm.Syntax.Pattern.TuplePattern
                                [ H.node1
                                    1129
                                    11
                                    13
                                    (Elm.Syntax.Pattern.ListPattern [])
                                , H.node1
                                    1129
                                    15
                                    16
                                    Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , H.node1
                            1130
                            13
                            36
                            (Elm.Syntax.Expression.Application
                                [ H.node1 1130 13 26 (H.val "reverseAppend")
                                , H.node1 1130 27 30 (H.val "acc")
                                , H.node1 1130 31 36 (H.val "list2")
                                ]
                            )
                      )
                    , ( H.node1
                            1132
                            9
                            18
                            (Elm.Syntax.Pattern.TuplePattern
                                [ H.node1
                                    1132
                                    11
                                    12
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    1132
                                    14
                                    16
                                    (Elm.Syntax.Pattern.ListPattern [])
                                ]
                            )
                      , H.node1
                            1133
                            13
                            36
                            (Elm.Syntax.Expression.Application
                                [ H.node1 1133 13 26 (H.val "reverseAppend")
                                , H.node1 1133 27 30 (H.val "acc")
                                , H.node1 1133 31 36 (H.val "list1")
                                ]
                            )
                      )
                    ]
                }
            )
    }


cartesianProduct : Elm.Syntax.Expression.FunctionImplementation
cartesianProduct =
    { name = H.node1 1157 1 17 "List.Extra.cartesianProduct"
    , arguments = [ H.node1 1157 18 20 (Elm.Syntax.Pattern.VarPattern "ll") ]
    , expression =
        H.node
            1158
            5
            1163
            49
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1158 10 12 (H.val "ll")
                , cases =
                    [ ( H.node1 1159 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1
                            1160
                            13
                            19
                            (Elm.Syntax.Expression.ListExpr
                                [ H.node1
                                    1160
                                    15
                                    17
                                    (Elm.Syntax.Expression.ListExpr [])
                                ]
                            )
                      )
                    , ( H.node1
                            1162
                            9
                            18
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1162
                                    9
                                    11
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                                (H.node1
                                    1162
                                    15
                                    18
                                    (Elm.Syntax.Pattern.VarPattern "xss")
                                )
                            )
                      , H.node1
                            1163
                            13
                            49
                            (Elm.Syntax.Expression.Application
                                [ H.node1 1163 13 18 (H.val "lift2")
                                , H.node1
                                    1163
                                    19
                                    23
                                    (Elm.Syntax.Expression.PrefixOperator "::")
                                , H.node1 1163 24 26 (H.val "xs")
                                , H.node1
                                    1163
                                    27
                                    49
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            1163
                                            28
                                            48
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    1163
                                                    28
                                                    44
                                                    (H.val "cartesianProduct")
                                                , H.node1
                                                    1163
                                                    45
                                                    48
                                                    (H.val "xss")
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


uniquePairs : Elm.Syntax.Expression.FunctionImplementation
uniquePairs =
    { name = H.node1 1181 1 12 "List.Extra.uniquePairs"
    , arguments = [ H.node1 1181 13 15 (Elm.Syntax.Pattern.VarPattern "xs") ]
    , expression =
        H.node
            1182
            5
            1187
            61
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1182 10 12 (H.val "xs")
                , cases =
                    [ ( H.node1 1183 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1184 13 15 (Elm.Syntax.Expression.ListExpr [])
                      )
                    , ( H.node1
                            1186
                            9
                            17
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1186
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1186
                                    14
                                    17
                                    (Elm.Syntax.Pattern.VarPattern "xs_")
                                )
                            )
                      , H.node1
                            1187
                            13
                            61
                            (Elm.Syntax.Expression.OperatorApplication
                                "++"
                                Elm.Syntax.Infix.Right
                                (H.node1
                                    1187
                                    13
                                    42
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            1187
                                            13
                                            21
                                            (Elm.Syntax.Expression.FunctionOrValue
                                                [ "List" ]
                                                "map"
                                            )
                                        , H.node1
                                            1187
                                            22
                                            38
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    1187
                                                    23
                                                    37
                                                    (Elm.Syntax.Expression.LambdaExpression
                                                        { args =
                                                            [ H.node1
                                                                1187
                                                                24
                                                                25
                                                                (Elm.Syntax.Pattern.VarPattern
                                                                    "y"
                                                                )
                                                            ]
                                                        , expression =
                                                            H.node1
                                                                1187
                                                                29
                                                                37
                                                                (Elm.Syntax.Expression.TupledExpression
                                                                    [ H.node1
                                                                        1187
                                                                        31
                                                                        32
                                                                        (H.val
                                                                            "x"
                                                                        )
                                                                    , H.node1
                                                                        1187
                                                                        34
                                                                        35
                                                                        (H.val
                                                                            "y"
                                                                        )
                                                                    ]
                                                                )
                                                        }
                                                    )
                                                )
                                            )
                                        , H.node1 1187 39 42 (H.val "xs_")
                                        ]
                                    )
                                )
                                (H.node1
                                    1187
                                    46
                                    61
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            1187
                                            46
                                            57
                                            (H.val "uniquePairs")
                                        , H.node1 1187 58 61 (H.val "xs_")
                                        ]
                                    )
                                )
                            )
                      )
                    ]
                }
            )
    }


reverseAppend : Elm.Syntax.Expression.FunctionImplementation
reverseAppend =
    { name = H.node1 1191 1 14 "List.Extra.reverseAppend"
    , arguments =
        [ H.node1 1191 15 20 (Elm.Syntax.Pattern.VarPattern "list1")
        , H.node1 1191 21 26 (Elm.Syntax.Pattern.VarPattern "list2")
        ]
    , expression =
        H.node1
            1192
            5
            32
            (Elm.Syntax.Expression.Application
                [ H.node1
                    1192
                    5
                    15
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "foldl")
                , H.node1 1192 16 20 (Elm.Syntax.Expression.PrefixOperator "::")
                , H.node1 1192 21 26 (H.val "list2")
                , H.node1 1192 27 32 (H.val "list1")
                ]
            )
    }


foldl1 : Elm.Syntax.Expression.FunctionImplementation
foldl1 =
    { name = H.node1 1210 1 7 "List.Extra.foldl1"
    , arguments =
        [ H.node1 1210 8 12 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 1210 13 17 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1211
            5
            1216
            40
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1211 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 1212 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1213 13 20 (H.val "Nothing")
                      )
                    , ( H.node1
                            1215
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1215
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1215
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node1
                            1216
                            13
                            40
                            (Elm.Syntax.Expression.Application
                                [ H.node1 1216 13 17 (H.val "Just")
                                , H.node1
                                    1216
                                    18
                                    40
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            1216
                                            19
                                            39
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    1216
                                                    19
                                                    29
                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                        [ "List" ]
                                                        "foldl"
                                                    )
                                                , H.node1
                                                    1216
                                                    30
                                                    34
                                                    (H.val "func")
                                                , H.node1 1216 35 36 (H.val "x")
                                                , H.node1
                                                    1216
                                                    37
                                                    39
                                                    (H.val "xs")
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


foldr1 : Elm.Syntax.Expression.FunctionImplementation
foldr1 =
    { name = H.node1 1232 1 7 "List.Extra.foldr1"
    , arguments =
        [ H.node1 1232 8 12 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 1232 13 17 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node1
            1233
            5
            36
            (Elm.Syntax.Expression.Application
                [ H.node1 1233 5 11 (H.val "foldl1")
                , H.node1 1233 12 16 (H.val "func")
                , H.node1
                    1233
                    17
                    36
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            1233
                            18
                            35
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    1233
                                    18
                                    30
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "List" ]
                                        "reverse"
                                    )
                                , H.node1 1233 31 35 (H.val "list")
                                ]
                            )
                        )
                    )
                ]
            )
    }


indexedFoldl : Elm.Syntax.Expression.FunctionImplementation
indexedFoldl =
    { name = H.node1 1239 1 13 "List.Extra.indexedFoldl"
    , arguments =
        [ H.node1 1239 14 18 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 1239 19 22 (Elm.Syntax.Pattern.VarPattern "acc")
        , H.node1 1239 23 27 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1240
            5
            1245
            45
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        1241
                        9
                        1243
                        40
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    1242
                                    9
                                    1243
                                    40
                                    { name = H.node1 1242 9 13 "step"
                                    , arguments =
                                        [ H.node1
                                            1242
                                            14
                                            15
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        , H.node1
                                            1242
                                            16
                                            30
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    1242
                                                    18
                                                    19
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "i"
                                                    )
                                                , H.node1
                                                    1242
                                                    21
                                                    28
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "thisAcc"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        H.node1
                                            1243
                                            13
                                            40
                                            (Elm.Syntax.Expression.TupledExpression
                                                [ H.node1
                                                    1243
                                                    15
                                                    20
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "+"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            1243
                                                            15
                                                            16
                                                            (H.val "i")
                                                        )
                                                        (H.node1
                                                            1243
                                                            19
                                                            20
                                                            (Elm.Syntax.Expression.Integer
                                                                1
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    1243
                                                    22
                                                    38
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            1243
                                                            22
                                                            26
                                                            (H.val "func")
                                                        , H.node1
                                                            1243
                                                            27
                                                            28
                                                            (H.val "i")
                                                        , H.node1
                                                            1243
                                                            29
                                                            30
                                                            (H.val "x")
                                                        , H.node1
                                                            1243
                                                            31
                                                            38
                                                            (H.val "thisAcc")
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
                        1245
                        5
                        45
                        (Elm.Syntax.Expression.Application
                            [ H.node1 1245 5 11 (H.val "second")
                            , H.node1
                                1245
                                12
                                45
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        1245
                                        13
                                        44
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                1245
                                                13
                                                23
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "List" ]
                                                    "foldl"
                                                )
                                            , H.node1 1245 24 28 (H.val "step")
                                            , H.node1
                                                1245
                                                29
                                                39
                                                (Elm.Syntax.Expression.TupledExpression
                                                    [ H.node1
                                                        1245
                                                        31
                                                        32
                                                        (Elm.Syntax.Expression.Integer
                                                            0
                                                        )
                                                    , H.node1
                                                        1245
                                                        34
                                                        37
                                                        (H.val "acc")
                                                    ]
                                                )
                                            , H.node1 1245 40 44 (H.val "list")
                                            ]
                                        )
                                    )
                                )
                            ]
                        )
                }
            )
    }


indexedFoldr : Elm.Syntax.Expression.FunctionImplementation
indexedFoldr =
    { name = H.node1 1251 1 13 "List.Extra.indexedFoldr"
    , arguments =
        [ H.node1 1251 14 18 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 1251 19 22 (Elm.Syntax.Pattern.VarPattern "acc")
        , H.node1 1251 23 27 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1252
            5
            1257
            64
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        1253
                        9
                        1255
                        40
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    1254
                                    9
                                    1255
                                    40
                                    { name = H.node1 1254 9 13 "step"
                                    , arguments =
                                        [ H.node1
                                            1254
                                            14
                                            15
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        , H.node1
                                            1254
                                            16
                                            30
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    1254
                                                    18
                                                    19
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "i"
                                                    )
                                                , H.node1
                                                    1254
                                                    21
                                                    28
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "thisAcc"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        H.node1
                                            1255
                                            13
                                            40
                                            (Elm.Syntax.Expression.TupledExpression
                                                [ H.node1
                                                    1255
                                                    15
                                                    20
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "-"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            1255
                                                            15
                                                            16
                                                            (H.val "i")
                                                        )
                                                        (H.node1
                                                            1255
                                                            19
                                                            20
                                                            (Elm.Syntax.Expression.Integer
                                                                1
                                                            )
                                                        )
                                                    )
                                                , H.node1
                                                    1255
                                                    22
                                                    38
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            1255
                                                            22
                                                            26
                                                            (H.val "func")
                                                        , H.node1
                                                            1255
                                                            27
                                                            28
                                                            (H.val "i")
                                                        , H.node1
                                                            1255
                                                            29
                                                            30
                                                            (H.val "x")
                                                        , H.node1
                                                            1255
                                                            31
                                                            38
                                                            (H.val "thisAcc")
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
                        1257
                        5
                        64
                        (Elm.Syntax.Expression.Application
                            [ H.node1 1257 5 11 (H.val "second")
                            , H.node1
                                1257
                                12
                                64
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        1257
                                        13
                                        63
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                1257
                                                13
                                                23
                                                (Elm.Syntax.Expression.FunctionOrValue
                                                    [ "List" ]
                                                    "foldr"
                                                )
                                            , H.node1 1257 24 28 (H.val "step")
                                            , H.node1
                                                1257
                                                29
                                                58
                                                (Elm.Syntax.Expression.TupledExpression
                                                    [ H.node1
                                                        1257
                                                        31
                                                        51
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "-"
                                                            Elm.Syntax.Infix.Left
                                                            (H.node1
                                                                1257
                                                                31
                                                                47
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        1257
                                                                        31
                                                                        42
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            [ "List"
                                                                            ]
                                                                            "length"
                                                                        )
                                                                    , H.node1
                                                                        1257
                                                                        43
                                                                        47
                                                                        (H.val
                                                                            "list"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                            (H.node1
                                                                1257
                                                                50
                                                                51
                                                                (Elm.Syntax.Expression.Integer
                                                                    1
                                                                )
                                                            )
                                                        )
                                                    , H.node1
                                                        1257
                                                        53
                                                        56
                                                        (H.val "acc")
                                                    ]
                                                )
                                            , H.node1 1257 59 63 (H.val "list")
                                            ]
                                        )
                                    )
                                )
                            ]
                        )
                }
            )
    }


stoppableFoldl : Elm.Syntax.Expression.FunctionImplementation
stoppableFoldl =
    { name = H.node1 1282 1 15 "List.Extra.stoppableFoldl"
    , arguments =
        [ H.node1 1282 16 20 (Elm.Syntax.Pattern.VarPattern "func")
        , H.node1 1282 21 24 (Elm.Syntax.Pattern.VarPattern "acc")
        , H.node1 1282 25 29 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1283
            5
            1293
            29
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1283 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 1284 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1285 13 16 (H.val "acc")
                      )
                    , ( H.node1
                            1287
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1287
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1287
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node
                            1288
                            13
                            1293
                            29
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    H.node1
                                        1288
                                        18
                                        28
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 1288 18 22 (H.val "func")
                                            , H.node1 1288 23 24 (H.val "x")
                                            , H.node1 1288 25 28 (H.val "acc")
                                            ]
                                        )
                                , cases =
                                    [ ( H.node1
                                            1289
                                            17
                                            32
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Continue"
                                                }
                                                [ H.node1
                                                    1289
                                                    26
                                                    32
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "newAcc"
                                                    )
                                                ]
                                            )
                                      , H.node1
                                            1290
                                            21
                                            50
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    1290
                                                    21
                                                    35
                                                    (H.val "stoppableFoldl")
                                                , H.node1
                                                    1290
                                                    36
                                                    40
                                                    (H.val "func")
                                                , H.node1
                                                    1290
                                                    41
                                                    47
                                                    (H.val "newAcc")
                                                , H.node1
                                                    1290
                                                    48
                                                    50
                                                    (H.val "xs")
                                                ]
                                            )
                                      )
                                    , ( H.node1
                                            1292
                                            17
                                            30
                                            (Elm.Syntax.Pattern.NamedPattern
                                                { moduleName = []
                                                , name = "Stop"
                                                }
                                                [ H.node1
                                                    1292
                                                    22
                                                    30
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "finalAcc"
                                                    )
                                                ]
                                            )
                                      , H.node1 1293 21 29 (H.val "finalAcc")
                                      )
                                    ]
                                }
                            )
                      )
                    ]
                }
            )
    }


scanl : Elm.Syntax.Expression.FunctionImplementation
scanl =
    { name = H.node1 1303 1 6 "List.Extra.scanl"
    , arguments =
        [ H.node1 1303 7 8 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 1303 9 10 (Elm.Syntax.Pattern.VarPattern "b")
        , H.node1 1303 11 13 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node
            1304
            5
            1315
            35
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        1305
                        9
                        1311
                        23
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    1305
                                    9
                                    1311
                                    23
                                    { name = H.node1 1305 9 14 "scan1"
                                    , arguments =
                                        [ H.node1
                                            1305
                                            15
                                            16
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        , H.node1
                                            1305
                                            17
                                            23
                                            (Elm.Syntax.Pattern.VarPattern
                                                "accAcc"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            1306
                                            13
                                            1311
                                            23
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        1306
                                                        18
                                                        24
                                                        (H.val "accAcc")
                                                , cases =
                                                    [ ( H.node1
                                                            1307
                                                            17
                                                            25
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    1307
                                                                    17
                                                                    20
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "acc"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    1307
                                                                    24
                                                                    25
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                )
                                                            )
                                                      , H.node1
                                                            1308
                                                            21
                                                            38
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Right
                                                                (H.node1
                                                                    1308
                                                                    21
                                                                    28
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            1308
                                                                            21
                                                                            22
                                                                            (H.val
                                                                                "f"
                                                                            )
                                                                        , H.node1
                                                                            1308
                                                                            23
                                                                            24
                                                                            (H.val
                                                                                "x"
                                                                            )
                                                                        , H.node1
                                                                            1308
                                                                            25
                                                                            28
                                                                            (H.val
                                                                                "acc"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                                (H.node1
                                                                    1308
                                                                    32
                                                                    38
                                                                    (H.val
                                                                        "accAcc"
                                                                    )
                                                                )
                                                            )
                                                      )
                                                    , ( H.node1
                                                            1310
                                                            17
                                                            19
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , H.node1
                                                            1311
                                                            21
                                                            23
                                                            (Elm.Syntax.Expression.ListExpr
                                                                []
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
                        1315
                        5
                        35
                        (Elm.Syntax.Expression.Application
                            [ H.node1 1315 5 12 (H.val "reverse")
                            , H.node1
                                1315
                                13
                                35
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        1315
                                        14
                                        34
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 1315 14 19 (H.val "foldl")
                                            , H.node1 1315 20 25 (H.val "scan1")
                                            , H.node1
                                                1315
                                                26
                                                31
                                                (Elm.Syntax.Expression.ListExpr
                                                    [ H.node1
                                                        1315
                                                        28
                                                        29
                                                        (H.val "b")
                                                    ]
                                                )
                                            , H.node1 1315 32 34 (H.val "xs")
                                            ]
                                        )
                                    )
                                )
                            ]
                        )
                }
            )
    }


scanl1 : Elm.Syntax.Expression.FunctionImplementation
scanl1 =
    { name = H.node1 1336 1 7 "List.Extra.scanl1"
    , arguments =
        [ H.node1 1336 8 9 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 1336 10 13 (Elm.Syntax.Pattern.VarPattern "xs_")
        ]
    , expression =
        H.node
            1337
            5
            1342
            25
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1337 10 13 (H.val "xs_")
                , cases =
                    [ ( H.node1 1338 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1339 13 15 (Elm.Syntax.Expression.ListExpr [])
                      )
                    , ( H.node1
                            1341
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1341
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1341
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node1
                            1342
                            13
                            25
                            (Elm.Syntax.Expression.Application
                                [ H.node1 1342 13 18 (H.val "scanl")
                                , H.node1 1342 19 20 (H.val "f")
                                , H.node1 1342 21 22 (H.val "x")
                                , H.node1 1342 23 25 (H.val "xs")
                                ]
                            )
                      )
                    ]
                }
            )
    }


scanr : Elm.Syntax.Expression.FunctionImplementation
scanr =
    { name = H.node1 1359 1 6 "List.Extra.scanr"
    , arguments =
        [ H.node1 1359 7 8 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 1359 9 12 (Elm.Syntax.Pattern.VarPattern "acc")
        , H.node1 1359 13 16 (Elm.Syntax.Pattern.VarPattern "xs_")
        ]
    , expression =
        H.node
            1360
            5
            1370
            23
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1360 10 13 (H.val "xs_")
                , cases =
                    [ ( H.node1 1361 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1
                            1362
                            13
                            20
                            (Elm.Syntax.Expression.ListExpr
                                [ H.node1 1362 15 18 (H.val "acc") ]
                            )
                      )
                    , ( H.node1
                            1364
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1364
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1364
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node
                            1365
                            13
                            1370
                            23
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    H.node1
                                        1365
                                        18
                                        32
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 1365 18 23 (H.val "scanr")
                                            , H.node1 1365 24 25 (H.val "f")
                                            , H.node1 1365 26 29 (H.val "acc")
                                            , H.node1 1365 30 32 (H.val "xs")
                                            ]
                                        )
                                , cases =
                                    [ ( H.node1
                                            1366
                                            17
                                            31
                                            (Elm.Syntax.Pattern.AsPattern
                                                (H.node1
                                                    1366
                                                    17
                                                    25
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (H.node1
                                                            1366
                                                            18
                                                            24
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    1366
                                                                    18
                                                                    19
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "q"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    1366
                                                                    23
                                                                    24
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                                (H.node1 1366 29 31 "qs")
                                            )
                                      , H.node1
                                            1367
                                            21
                                            32
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "::"
                                                Elm.Syntax.Infix.Right
                                                (H.node1
                                                    1367
                                                    21
                                                    26
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            1367
                                                            21
                                                            22
                                                            (H.val "f")
                                                        , H.node1
                                                            1367
                                                            23
                                                            24
                                                            (H.val "x")
                                                        , H.node1
                                                            1367
                                                            25
                                                            26
                                                            (H.val "q")
                                                        ]
                                                    )
                                                )
                                                (H.node1 1367 30 32 (H.val "qs")
                                                )
                                            )
                                      )
                                    , ( H.node1
                                            1369
                                            17
                                            19
                                            (Elm.Syntax.Pattern.ListPattern [])
                                      , H.node1
                                            1370
                                            21
                                            23
                                            (Elm.Syntax.Expression.ListExpr [])
                                      )
                                    ]
                                }
                            )
                      )
                    ]
                }
            )
    }


scanr1 : Elm.Syntax.Expression.FunctionImplementation
scanr1 =
    { name = H.node1 1383 1 7 "List.Extra.scanr1"
    , arguments =
        [ H.node1 1383 8 9 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 1383 10 13 (Elm.Syntax.Pattern.VarPattern "xs_")
        ]
    , expression =
        H.node
            1384
            5
            1397
            23
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1384 10 13 (H.val "xs_")
                , cases =
                    [ ( H.node1 1385 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1386 13 15 (Elm.Syntax.Expression.ListExpr [])
                      )
                    , ( H.node1
                            1388
                            9
                            14
                            (Elm.Syntax.Pattern.ListPattern
                                [ H.node1
                                    1388
                                    11
                                    12
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                ]
                            )
                      , H.node1
                            1389
                            13
                            18
                            (Elm.Syntax.Expression.ListExpr
                                [ H.node1 1389 15 16 (H.val "x") ]
                            )
                      )
                    , ( H.node1
                            1391
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1391
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1391
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node
                            1392
                            13
                            1397
                            23
                            (Elm.Syntax.Expression.CaseExpression
                                { expression =
                                    H.node1
                                        1392
                                        18
                                        29
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                1392
                                                18
                                                24
                                                (H.val "scanr1")
                                            , H.node1 1392 25 26 (H.val "f")
                                            , H.node1 1392 27 29 (H.val "xs")
                                            ]
                                        )
                                , cases =
                                    [ ( H.node1
                                            1393
                                            17
                                            31
                                            (Elm.Syntax.Pattern.AsPattern
                                                (H.node1
                                                    1393
                                                    17
                                                    25
                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                        (H.node1
                                                            1393
                                                            18
                                                            24
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    1393
                                                                    18
                                                                    19
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "q"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    1393
                                                                    23
                                                                    24
                                                                    Elm.Syntax.Pattern.AllPattern
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                                (H.node1 1393 29 31 "qs")
                                            )
                                      , H.node1
                                            1394
                                            21
                                            32
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "::"
                                                Elm.Syntax.Infix.Right
                                                (H.node1
                                                    1394
                                                    21
                                                    26
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            1394
                                                            21
                                                            22
                                                            (H.val "f")
                                                        , H.node1
                                                            1394
                                                            23
                                                            24
                                                            (H.val "x")
                                                        , H.node1
                                                            1394
                                                            25
                                                            26
                                                            (H.val "q")
                                                        ]
                                                    )
                                                )
                                                (H.node1 1394 30 32 (H.val "qs")
                                                )
                                            )
                                      )
                                    , ( H.node1
                                            1396
                                            17
                                            19
                                            (Elm.Syntax.Pattern.ListPattern [])
                                      , H.node1
                                            1397
                                            21
                                            23
                                            (Elm.Syntax.Expression.ListExpr [])
                                      )
                                    ]
                                }
                            )
                      )
                    ]
                }
            )
    }


mapAccuml : Elm.Syntax.Expression.FunctionImplementation
mapAccuml =
    { name = H.node1 1424 1 10 "List.Extra.mapAccuml"
    , arguments =
        [ H.node1 1424 11 12 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 1424 13 17 (Elm.Syntax.Pattern.VarPattern "acc0")
        , H.node1 1424 18 22 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1425
            5
            1438
            45
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        1426
                        9
                        1436
                        21
                        (Elm.Syntax.Expression.LetDestructuring
                            (H.node1
                                1426
                                9
                                36
                                (Elm.Syntax.Pattern.TuplePattern
                                    [ H.node1
                                        1426
                                        11
                                        19
                                        (Elm.Syntax.Pattern.VarPattern
                                            "accFinal"
                                        )
                                    , H.node1
                                        1426
                                        21
                                        34
                                        (Elm.Syntax.Pattern.VarPattern
                                            "generatedList"
                                        )
                                    ]
                                )
                            )
                            (H.node
                                1427
                                13
                                1436
                                21
                                (Elm.Syntax.Expression.Application
                                    [ H.node1
                                        1427
                                        13
                                        23
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "List" ]
                                            "foldl"
                                        )
                                    , H.node
                                        1428
                                        17
                                        1434
                                        18
                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                            (H.node
                                                1428
                                                18
                                                1433
                                                38
                                                (Elm.Syntax.Expression.LambdaExpression
                                                    { args =
                                                        [ H.node1
                                                            1428
                                                            19
                                                            20
                                                            (Elm.Syntax.Pattern.VarPattern
                                                                "x"
                                                            )
                                                        , H.node1
                                                            1428
                                                            21
                                                            33
                                                            (Elm.Syntax.Pattern.TuplePattern
                                                                [ H.node1
                                                                    1428
                                                                    23
                                                                    27
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "acc1"
                                                                    )
                                                                , H.node1
                                                                    1428
                                                                    29
                                                                    31
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "ys"
                                                                    )
                                                                ]
                                                            )
                                                        ]
                                                    , expression =
                                                        H.node
                                                            1429
                                                            21
                                                            1433
                                                            38
                                                            (Elm.Syntax.Expression.LetExpression
                                                                { declarations =
                                                                    [ H.node
                                                                        1430
                                                                        25
                                                                        1431
                                                                        37
                                                                        (Elm.Syntax.Expression.LetDestructuring
                                                                            (H.node1
                                                                                1430
                                                                                25
                                                                                36
                                                                                (Elm.Syntax.Pattern.TuplePattern
                                                                                    [ H.node1
                                                                                        1430
                                                                                        27
                                                                                        31
                                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                                            "acc2"
                                                                                        )
                                                                                    , H.node1
                                                                                        1430
                                                                                        33
                                                                                        34
                                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                                            "y"
                                                                                        )
                                                                                    ]
                                                                                )
                                                                            )
                                                                            (H.node1
                                                                                1431
                                                                                29
                                                                                37
                                                                                (Elm.Syntax.Expression.Application
                                                                                    [ H.node1
                                                                                        1431
                                                                                        29
                                                                                        30
                                                                                        (H.val
                                                                                            "f"
                                                                                        )
                                                                                    , H.node1
                                                                                        1431
                                                                                        31
                                                                                        35
                                                                                        (H.val
                                                                                            "acc1"
                                                                                        )
                                                                                    , H.node1
                                                                                        1431
                                                                                        36
                                                                                        37
                                                                                        (H.val
                                                                                            "x"
                                                                                        )
                                                                                    ]
                                                                                )
                                                                            )
                                                                        )
                                                                    ]
                                                                , expression =
                                                                    H.node1
                                                                        1433
                                                                        21
                                                                        38
                                                                        (Elm.Syntax.Expression.TupledExpression
                                                                            [ H.node1
                                                                                1433
                                                                                23
                                                                                27
                                                                                (H.val
                                                                                    "acc2"
                                                                                )
                                                                            , H.node1
                                                                                1433
                                                                                29
                                                                                36
                                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                                    "::"
                                                                                    Elm.Syntax.Infix.Right
                                                                                    (H.node1
                                                                                        1433
                                                                                        29
                                                                                        30
                                                                                        (H.val
                                                                                            "y"
                                                                                        )
                                                                                    )
                                                                                    (H.node1
                                                                                        1433
                                                                                        34
                                                                                        36
                                                                                        (H.val
                                                                                            "ys"
                                                                                        )
                                                                                    )
                                                                                )
                                                                            ]
                                                                        )
                                                                }
                                                            )
                                                    }
                                                )
                                            )
                                        )
                                    , H.node1
                                        1435
                                        17
                                        29
                                        (Elm.Syntax.Expression.TupledExpression
                                            [ H.node1 1435 19 23 (H.val "acc0")
                                            , H.node1
                                                1435
                                                25
                                                27
                                                (Elm.Syntax.Expression.ListExpr
                                                    []
                                                )
                                            ]
                                        )
                                    , H.node1 1436 17 21 (H.val "list")
                                    ]
                                )
                            )
                        )
                    ]
                , expression =
                    H.node1
                        1438
                        5
                        45
                        (Elm.Syntax.Expression.TupledExpression
                            [ H.node1 1438 7 15 (H.val "accFinal")
                            , H.node1
                                1438
                                17
                                43
                                (Elm.Syntax.Expression.Application
                                    [ H.node1
                                        1438
                                        17
                                        29
                                        (Elm.Syntax.Expression.FunctionOrValue
                                            [ "List" ]
                                            "reverse"
                                        )
                                    , H.node1 1438 30 43 (H.val "generatedList")
                                    ]
                                )
                            ]
                        )
                }
            )
    }


mapAccumr : Elm.Syntax.Expression.FunctionImplementation
mapAccumr =
    { name = H.node1 1465 1 10 "List.Extra.mapAccumr"
    , arguments =
        [ H.node1 1465 11 12 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 1465 13 17 (Elm.Syntax.Pattern.VarPattern "acc0")
        , H.node1 1465 18 22 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1466
            5
            1475
            13
            (Elm.Syntax.Expression.Application
                [ H.node1
                    1466
                    5
                    15
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "foldr")
                , H.node
                    1467
                    9
                    1473
                    10
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node
                            1467
                            10
                            1472
                            30
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        1467
                                        11
                                        12
                                        (Elm.Syntax.Pattern.VarPattern "x")
                                    , H.node1
                                        1467
                                        13
                                        25
                                        (Elm.Syntax.Pattern.TuplePattern
                                            [ H.node1
                                                1467
                                                15
                                                19
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "acc1"
                                                )
                                            , H.node1
                                                1467
                                                21
                                                23
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "ys"
                                                )
                                            ]
                                        )
                                    ]
                                , expression =
                                    H.node
                                        1468
                                        13
                                        1472
                                        30
                                        (Elm.Syntax.Expression.LetExpression
                                            { declarations =
                                                [ H.node
                                                    1469
                                                    17
                                                    1470
                                                    29
                                                    (Elm.Syntax.Expression.LetDestructuring
                                                        (H.node1
                                                            1469
                                                            17
                                                            28
                                                            (Elm.Syntax.Pattern.TuplePattern
                                                                [ H.node1
                                                                    1469
                                                                    19
                                                                    23
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "acc2"
                                                                    )
                                                                , H.node1
                                                                    1469
                                                                    25
                                                                    26
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "y"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                        (H.node1
                                                            1470
                                                            21
                                                            29
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    1470
                                                                    21
                                                                    22
                                                                    (H.val "f")
                                                                , H.node1
                                                                    1470
                                                                    23
                                                                    27
                                                                    (H.val
                                                                        "acc1"
                                                                    )
                                                                , H.node1
                                                                    1470
                                                                    28
                                                                    29
                                                                    (H.val "x")
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ]
                                            , expression =
                                                H.node1
                                                    1472
                                                    13
                                                    30
                                                    (Elm.Syntax.Expression.TupledExpression
                                                        [ H.node1
                                                            1472
                                                            15
                                                            19
                                                            (H.val "acc2")
                                                        , H.node1
                                                            1472
                                                            21
                                                            28
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Right
                                                                (H.node1
                                                                    1472
                                                                    21
                                                                    22
                                                                    (H.val "y")
                                                                )
                                                                (H.node1
                                                                    1472
                                                                    26
                                                                    28
                                                                    (H.val "ys")
                                                                )
                                                            )
                                                        ]
                                                    )
                                            }
                                        )
                                }
                            )
                        )
                    )
                , H.node1
                    1474
                    9
                    21
                    (Elm.Syntax.Expression.TupledExpression
                        [ H.node1 1474 11 15 (H.val "acc0")
                        , H.node1 1474 17 19 (Elm.Syntax.Expression.ListExpr [])
                        ]
                    )
                , H.node1 1475 9 13 (H.val "list")
                ]
            )
    }


unfoldr : Elm.Syntax.Expression.FunctionImplementation
unfoldr =
    { name = H.node1 1492 1 8 "List.Extra.unfoldr"
    , arguments =
        [ H.node1 1492 9 10 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 1492 11 15 (Elm.Syntax.Pattern.VarPattern "seed")
        ]
    , expression =
        H.node
            1493
            5
            1498
            29
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        1493
                        10
                        16
                        (Elm.Syntax.Expression.Application
                            [ H.node1 1493 10 11 (H.val "f")
                            , H.node1 1493 12 16 (H.val "seed")
                            ]
                        )
                , cases =
                    [ ( H.node1
                            1494
                            9
                            16
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Nothing" }
                                []
                            )
                      , H.node1 1495 13 15 (Elm.Syntax.Expression.ListExpr [])
                      )
                    , ( H.node1
                            1497
                            9
                            22
                            (Elm.Syntax.Pattern.NamedPattern
                                { moduleName = [], name = "Just" }
                                [ H.node1
                                    1497
                                    14
                                    22
                                    (Elm.Syntax.Pattern.TuplePattern
                                        [ H.node1
                                            1497
                                            16
                                            17
                                            (Elm.Syntax.Pattern.VarPattern "a")
                                        , H.node1
                                            1497
                                            19
                                            20
                                            (Elm.Syntax.Pattern.VarPattern "b")
                                        ]
                                    )
                                ]
                            )
                      , H.node1
                            1498
                            13
                            29
                            (Elm.Syntax.Expression.OperatorApplication
                                "::"
                                Elm.Syntax.Infix.Right
                                (H.node1 1498 13 14 (H.val "a"))
                                (H.node1
                                    1498
                                    18
                                    29
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 1498 18 25 (H.val "unfoldr")
                                        , H.node1 1498 26 27 (H.val "f")
                                        , H.node1 1498 28 29 (H.val "b")
                                        ]
                                    )
                                )
                            )
                      )
                    ]
                }
            )
    }


splitAt : Elm.Syntax.Expression.FunctionImplementation
splitAt =
    { name = H.node1 1523 1 8 "List.Extra.splitAt"
    , arguments =
        [ H.node1 1523 9 10 (Elm.Syntax.Pattern.VarPattern "n")
        , H.node1 1523 11 13 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node1
            1524
            5
            29
            (Elm.Syntax.Expression.TupledExpression
                [ H.node1
                    1524
                    7
                    16
                    (Elm.Syntax.Expression.Application
                        [ H.node1 1524 7 11 (H.val "take")
                        , H.node1 1524 12 13 (H.val "n")
                        , H.node1 1524 14 16 (H.val "xs")
                        ]
                    )
                , H.node1
                    1524
                    18
                    27
                    (Elm.Syntax.Expression.Application
                        [ H.node1 1524 18 22 (H.val "drop")
                        , H.node1 1524 23 24 (H.val "n")
                        , H.node1 1524 25 27 (H.val "xs")
                        ]
                    )
                ]
            )
    }


splitWhen : Elm.Syntax.Expression.FunctionImplementation
splitWhen =
    { name = H.node1 1537 1 10 "List.Extra.splitWhen"
    , arguments =
        [ H.node1 1537 11 20 (Elm.Syntax.Pattern.VarPattern "predicate")
        , H.node1 1537 21 25 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1538
            5
            1539
            44
            (Elm.Syntax.Expression.OperatorApplication
                "|>"
                Elm.Syntax.Infix.Left
                (H.node1
                    1538
                    5
                    29
                    (Elm.Syntax.Expression.Application
                        [ H.node1 1538 5 14 (H.val "findIndex")
                        , H.node1 1538 15 24 (H.val "predicate")
                        , H.node1 1538 25 29 (H.val "list")
                        ]
                    )
                )
                (H.node1
                    1539
                    12
                    44
                    (Elm.Syntax.Expression.Application
                        [ H.node1
                            1539
                            12
                            21
                            (Elm.Syntax.Expression.FunctionOrValue
                                [ "Maybe" ]
                                "map"
                            )
                        , H.node1
                            1539
                            22
                            44
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    1539
                                    23
                                    43
                                    (Elm.Syntax.Expression.LambdaExpression
                                        { args =
                                            [ H.node1
                                                1539
                                                24
                                                25
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "i"
                                                )
                                            ]
                                        , expression =
                                            H.node1
                                                1539
                                                29
                                                43
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        1539
                                                        29
                                                        36
                                                        (H.val "splitAt")
                                                    , H.node1
                                                        1539
                                                        37
                                                        38
                                                        (H.val "i")
                                                    , H.node1
                                                        1539
                                                        39
                                                        43
                                                        (H.val "list")
                                                    ]
                                                )
                                        }
                                    )
                                )
                            )
                        ]
                    )
                )
            )
    }


takeWhileRight : Elm.Syntax.Expression.FunctionImplementation
takeWhileRight =
    { name = H.node1 1549 1 15 "List.Extra.takeWhileRight"
    , arguments = [ H.node1 1549 16 17 (Elm.Syntax.Pattern.VarPattern "p") ]
    , expression =
        H.node
            1550
            5
            1558
            37
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        1551
                        9
                        1556
                        30
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    1551
                                    9
                                    1556
                                    30
                                    { name = H.node1 1551 9 13 "step"
                                    , arguments =
                                        [ H.node1
                                            1551
                                            14
                                            15
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        , H.node1
                                            1551
                                            16
                                            28
                                            (Elm.Syntax.Pattern.TuplePattern
                                                [ H.node1
                                                    1551
                                                    18
                                                    20
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "xs"
                                                    )
                                                , H.node1
                                                    1551
                                                    22
                                                    26
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "free"
                                                    )
                                                ]
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            1552
                                            13
                                            1556
                                            30
                                            (Elm.Syntax.Expression.IfBlock
                                                (H.node1
                                                    1552
                                                    16
                                                    27
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "&&"
                                                        Elm.Syntax.Infix.Right
                                                        (H.node1
                                                            1552
                                                            16
                                                            19
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    1552
                                                                    16
                                                                    17
                                                                    (H.val "p")
                                                                , H.node1
                                                                    1552
                                                                    18
                                                                    19
                                                                    (H.val "x")
                                                                ]
                                                            )
                                                        )
                                                        (H.node1
                                                            1552
                                                            23
                                                            27
                                                            (H.val "free")
                                                        )
                                                    )
                                                )
                                                (H.node1
                                                    1553
                                                    17
                                                    34
                                                    (Elm.Syntax.Expression.TupledExpression
                                                        [ H.node1
                                                            1553
                                                            19
                                                            26
                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                "::"
                                                                Elm.Syntax.Infix.Right
                                                                (H.node1
                                                                    1553
                                                                    19
                                                                    20
                                                                    (H.val "x")
                                                                )
                                                                (H.node1
                                                                    1553
                                                                    24
                                                                    26
                                                                    (H.val "xs")
                                                                )
                                                            )
                                                        , H.node1
                                                            1553
                                                            28
                                                            32
                                                            (H.val "True")
                                                        ]
                                                    )
                                                )
                                                (H.node1
                                                    1556
                                                    17
                                                    30
                                                    (Elm.Syntax.Expression.TupledExpression
                                                        [ H.node1
                                                            1556
                                                            19
                                                            21
                                                            (H.val "xs")
                                                        , H.node1
                                                            1556
                                                            23
                                                            28
                                                            (H.val "False")
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
                        1558
                        5
                        37
                        (Elm.Syntax.Expression.OperatorApplication
                            "<<"
                            Elm.Syntax.Infix.Left
                            (H.node1 1558 5 10 (H.val "first"))
                            (H.node1
                                1558
                                14
                                37
                                (Elm.Syntax.Expression.Application
                                    [ H.node1 1558 14 19 (H.val "foldr")
                                    , H.node1 1558 20 24 (H.val "step")
                                    , H.node1
                                        1558
                                        25
                                        37
                                        (Elm.Syntax.Expression.TupledExpression
                                            [ H.node1
                                                1558
                                                27
                                                29
                                                (Elm.Syntax.Expression.ListExpr
                                                    []
                                                )
                                            , H.node1 1558 31 35 (H.val "True")
                                            ]
                                        )
                                    ]
                                )
                            )
                        )
                }
            )
    }


dropWhileRight : Elm.Syntax.Expression.FunctionImplementation
dropWhileRight =
    { name = H.node1 1568 1 15 "List.Extra.dropWhileRight"
    , arguments = [ H.node1 1568 16 17 (Elm.Syntax.Pattern.VarPattern "p") ]
    , expression =
        H.node
            1569
            5
            1577
            11
            (Elm.Syntax.Expression.Application
                [ H.node1 1569 5 10 (H.val "foldr")
                , H.node
                    1570
                    9
                    1576
                    10
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node
                            1570
                            10
                            1575
                            24
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        1570
                                        11
                                        12
                                        (Elm.Syntax.Pattern.VarPattern "x")
                                    , H.node1
                                        1570
                                        13
                                        15
                                        (Elm.Syntax.Pattern.VarPattern "xs")
                                    ]
                                , expression =
                                    H.node
                                        1571
                                        13
                                        1575
                                        24
                                        (Elm.Syntax.Expression.IfBlock
                                            (H.node1
                                                1571
                                                16
                                                33
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "&&"
                                                    Elm.Syntax.Infix.Right
                                                    (H.node1
                                                        1571
                                                        16
                                                        19
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                1571
                                                                16
                                                                17
                                                                (H.val "p")
                                                            , H.node1
                                                                1571
                                                                18
                                                                19
                                                                (H.val "x")
                                                            ]
                                                        )
                                                    )
                                                    (H.node1
                                                        1571
                                                        23
                                                        33
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                1571
                                                                23
                                                                30
                                                                (H.val "isEmpty"
                                                                )
                                                            , H.node1
                                                                1571
                                                                31
                                                                33
                                                                (H.val "xs")
                                                            ]
                                                        )
                                                    )
                                                )
                                            )
                                            (H.node1
                                                1572
                                                17
                                                19
                                                (Elm.Syntax.Expression.ListExpr
                                                    []
                                                )
                                            )
                                            (H.node1
                                                1575
                                                17
                                                24
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "::"
                                                    Elm.Syntax.Infix.Right
                                                    (H.node1
                                                        1575
                                                        17
                                                        18
                                                        (H.val "x")
                                                    )
                                                    (H.node1
                                                        1575
                                                        22
                                                        24
                                                        (H.val "xs")
                                                    )
                                                )
                                            )
                                        )
                                }
                            )
                        )
                    )
                , H.node1 1577 9 11 (Elm.Syntax.Expression.ListExpr [])
                ]
            )
    }


span : Elm.Syntax.Expression.FunctionImplementation
span =
    { name = H.node1 1593 1 5 "List.Extra.span"
    , arguments =
        [ H.node1 1593 6 7 (Elm.Syntax.Pattern.VarPattern "p")
        , H.node1 1593 8 10 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node1
            1594
            5
            39
            (Elm.Syntax.Expression.TupledExpression
                [ H.node1
                    1594
                    7
                    21
                    (Elm.Syntax.Expression.Application
                        [ H.node1 1594 7 16 (H.val "takeWhile")
                        , H.node1 1594 17 18 (H.val "p")
                        , H.node1 1594 19 21 (H.val "xs")
                        ]
                    )
                , H.node1
                    1594
                    23
                    37
                    (Elm.Syntax.Expression.Application
                        [ H.node1 1594 23 32 (H.val "dropWhile")
                        , H.node1 1594 33 34 (H.val "p")
                        , H.node1 1594 35 37 (H.val "xs")
                        ]
                    )
                ]
            )
    }


break : Elm.Syntax.Expression.FunctionImplementation
break =
    { name = H.node1 1610 1 6 "List.Extra.break"
    , arguments = [ H.node1 1610 7 8 (Elm.Syntax.Pattern.VarPattern "p") ]
    , expression =
        H.node1
            1611
            5
            20
            (Elm.Syntax.Expression.Application
                [ H.node1 1611 5 9 (H.val "span")
                , H.node1
                    1611
                    10
                    20
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            1611
                            11
                            19
                            (Elm.Syntax.Expression.OperatorApplication
                                "<<"
                                Elm.Syntax.Infix.Left
                                (H.node1 1611 11 14 (H.val "not"))
                                (H.node1 1611 18 19 (H.val "p"))
                            )
                        )
                    )
                ]
            )
    }


stripPrefix : Elm.Syntax.Expression.FunctionImplementation
stripPrefix =
    { name = H.node1 1633 1 12 "List.Extra.stripPrefix"
    , arguments =
        [ H.node1 1633 13 19 (Elm.Syntax.Pattern.VarPattern "prefix")
        , H.node1 1633 20 22 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node
            1634
            5
            1650
            32
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        1635
                        9
                        1648
                        32
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    1635
                                    9
                                    1648
                                    32
                                    { name = H.node1 1635 9 13 "step"
                                    , arguments =
                                        [ H.node1
                                            1635
                                            14
                                            15
                                            (Elm.Syntax.Pattern.VarPattern "e")
                                        , H.node1
                                            1635
                                            16
                                            17
                                            (Elm.Syntax.Pattern.VarPattern "m")
                                        ]
                                    , expression =
                                        H.node
                                            1636
                                            13
                                            1648
                                            32
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        1636
                                                        18
                                                        19
                                                        (H.val "m")
                                                , cases =
                                                    [ ( H.node1
                                                            1637
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
                                                            1638
                                                            21
                                                            28
                                                            (H.val "Nothing")
                                                      )
                                                    , ( H.node1
                                                            1640
                                                            17
                                                            24
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Just"
                                                                }
                                                                [ H.node1
                                                                    1640
                                                                    22
                                                                    24
                                                                    (Elm.Syntax.Pattern.ListPattern
                                                                        []
                                                                    )
                                                                ]
                                                            )
                                                      , H.node1
                                                            1641
                                                            21
                                                            28
                                                            (H.val "Nothing")
                                                      )
                                                    , ( H.node1
                                                            1643
                                                            17
                                                            32
                                                            (Elm.Syntax.Pattern.NamedPattern
                                                                { moduleName =
                                                                    []
                                                                , name = "Just"
                                                                }
                                                                [ H.node1
                                                                    1643
                                                                    22
                                                                    32
                                                                    (Elm.Syntax.Pattern.ParenthesizedPattern
                                                                        (H.node1
                                                                            1643
                                                                            23
                                                                            31
                                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                                (H.node1
                                                                                    1643
                                                                                    23
                                                                                    24
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "x"
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    1643
                                                                                    28
                                                                                    31
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "xs_"
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                      , H.node
                                                            1644
                                                            21
                                                            1648
                                                            32
                                                            (Elm.Syntax.Expression.IfBlock
                                                                (H.node1
                                                                    1644
                                                                    24
                                                                    30
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "=="
                                                                        Elm.Syntax.Infix.Non
                                                                        (H.node1
                                                                            1644
                                                                            24
                                                                            25
                                                                            (H.val
                                                                                "e"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            1644
                                                                            29
                                                                            30
                                                                            (H.val
                                                                                "x"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                (H.node1
                                                                    1645
                                                                    25
                                                                    33
                                                                    (Elm.Syntax.Expression.Application
                                                                        [ H.node1
                                                                            1645
                                                                            25
                                                                            29
                                                                            (H.val
                                                                                "Just"
                                                                            )
                                                                        , H.node1
                                                                            1645
                                                                            30
                                                                            33
                                                                            (H.val
                                                                                "xs_"
                                                                            )
                                                                        ]
                                                                    )
                                                                )
                                                                (H.node1
                                                                    1648
                                                                    25
                                                                    32
                                                                    (H.val
                                                                        "Nothing"
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
                    H.node1
                        1650
                        5
                        32
                        (Elm.Syntax.Expression.Application
                            [ H.node1 1650 5 10 (H.val "foldl")
                            , H.node1 1650 11 15 (H.val "step")
                            , H.node1
                                1650
                                16
                                25
                                (Elm.Syntax.Expression.ParenthesizedExpression
                                    (H.node1
                                        1650
                                        17
                                        24
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1 1650 17 21 (H.val "Just")
                                            , H.node1 1650 22 24 (H.val "xs")
                                            ]
                                        )
                                    )
                                )
                            , H.node1 1650 26 32 (H.val "prefix")
                            ]
                        )
                }
            )
    }


group : Elm.Syntax.Expression.FunctionImplementation
group =
    { name = H.node1 1660 1 6 "List.Extra.group"
    , arguments = []
    , expression =
        H.node1
            1661
            5
            20
            (Elm.Syntax.Expression.Application
                [ H.node1 1661 5 15 (H.val "groupWhile")
                , H.node1 1661 16 20 (Elm.Syntax.Expression.PrefixOperator "==")
                ]
            )
    }


groupWhile : Elm.Syntax.Expression.FunctionImplementation
groupWhile =
    { name = H.node1 1688 1 11 "List.Extra.groupWhile"
    , arguments =
        [ H.node1 1688 12 23 (Elm.Syntax.Pattern.VarPattern "isSameGroup")
        , H.node1 1688 24 29 (Elm.Syntax.Pattern.VarPattern "items")
        ]
    , expression =
        H.node
            1689
            5
            1703
            14
            (Elm.Syntax.Expression.Application
                [ H.node1
                    1689
                    5
                    15
                    (Elm.Syntax.Expression.FunctionOrValue [ "List" ] "foldr")
                , H.node
                    1690
                    9
                    1701
                    10
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node
                            1690
                            10
                            1700
                            41
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        1690
                                        11
                                        12
                                        (Elm.Syntax.Pattern.VarPattern "x")
                                    , H.node1
                                        1690
                                        13
                                        16
                                        (Elm.Syntax.Pattern.VarPattern "acc")
                                    ]
                                , expression =
                                    H.node
                                        1691
                                        13
                                        1700
                                        41
                                        (Elm.Syntax.Expression.CaseExpression
                                            { expression =
                                                H.node1 1691 18 21 (H.val "acc")
                                            , cases =
                                                [ ( H.node1
                                                        1692
                                                        17
                                                        19
                                                        (Elm.Syntax.Pattern.ListPattern
                                                            []
                                                        )
                                                  , H.node1
                                                        1693
                                                        21
                                                        34
                                                        (Elm.Syntax.Expression.ListExpr
                                                            [ H.node1
                                                                1693
                                                                23
                                                                32
                                                                (Elm.Syntax.Expression.TupledExpression
                                                                    [ H.node1
                                                                        1693
                                                                        25
                                                                        26
                                                                        (H.val
                                                                            "x"
                                                                        )
                                                                    , H.node1
                                                                        1693
                                                                        28
                                                                        30
                                                                        (Elm.Syntax.Expression.ListExpr
                                                                            []
                                                                        )
                                                                    ]
                                                                )
                                                            ]
                                                        )
                                                  )
                                                , ( H.node1
                                                        1695
                                                        17
                                                        45
                                                        (Elm.Syntax.Pattern.UnConsPattern
                                                            (H.node1
                                                                1695
                                                                17
                                                                35
                                                                (Elm.Syntax.Pattern.TuplePattern
                                                                    [ H.node1
                                                                        1695
                                                                        19
                                                                        20
                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                            "y"
                                                                        )
                                                                    , H.node1
                                                                        1695
                                                                        22
                                                                        33
                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                            "restOfGroup"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                            (H.node1
                                                                1695
                                                                39
                                                                45
                                                                (Elm.Syntax.Pattern.VarPattern
                                                                    "groups"
                                                                )
                                                            )
                                                        )
                                                  , H.node
                                                        1696
                                                        21
                                                        1700
                                                        41
                                                        (Elm.Syntax.Expression.IfBlock
                                                            (H.node1
                                                                1696
                                                                24
                                                                39
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        1696
                                                                        24
                                                                        35
                                                                        (H.val
                                                                            "isSameGroup"
                                                                        )
                                                                    , H.node1
                                                                        1696
                                                                        36
                                                                        37
                                                                        (H.val
                                                                            "x"
                                                                        )
                                                                    , H.node1
                                                                        1696
                                                                        38
                                                                        39
                                                                        (H.val
                                                                            "y"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                            (H.node1
                                                                1697
                                                                25
                                                                58
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    "::"
                                                                    Elm.Syntax.Infix.Right
                                                                    (H.node1
                                                                        1697
                                                                        25
                                                                        48
                                                                        (Elm.Syntax.Expression.TupledExpression
                                                                            [ H.node1
                                                                                1697
                                                                                27
                                                                                28
                                                                                (H.val
                                                                                    "x"
                                                                                )
                                                                            , H.node1
                                                                                1697
                                                                                30
                                                                                46
                                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                                    "::"
                                                                                    Elm.Syntax.Infix.Right
                                                                                    (H.node1
                                                                                        1697
                                                                                        30
                                                                                        31
                                                                                        (H.val
                                                                                            "y"
                                                                                        )
                                                                                    )
                                                                                    (H.node1
                                                                                        1697
                                                                                        35
                                                                                        46
                                                                                        (H.val
                                                                                            "restOfGroup"
                                                                                        )
                                                                                    )
                                                                                )
                                                                            ]
                                                                        )
                                                                    )
                                                                    (H.node1
                                                                        1697
                                                                        52
                                                                        58
                                                                        (H.val
                                                                            "groups"
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                            (H.node1
                                                                1700
                                                                25
                                                                41
                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                    "::"
                                                                    Elm.Syntax.Infix.Right
                                                                    (H.node1
                                                                        1700
                                                                        25
                                                                        34
                                                                        (Elm.Syntax.Expression.TupledExpression
                                                                            [ H.node1
                                                                                1700
                                                                                27
                                                                                28
                                                                                (H.val
                                                                                    "x"
                                                                                )
                                                                            , H.node1
                                                                                1700
                                                                                30
                                                                                32
                                                                                (Elm.Syntax.Expression.ListExpr
                                                                                    []
                                                                                )
                                                                            ]
                                                                        )
                                                                    )
                                                                    (H.node1
                                                                        1700
                                                                        38
                                                                        41
                                                                        (H.val
                                                                            "acc"
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
                            )
                        )
                    )
                , H.node1 1702 9 11 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 1703 9 14 (H.val "items")
                ]
            )
    }


inits : Elm.Syntax.Expression.FunctionImplementation
inits =
    { name = H.node1 1713 1 6 "List.Extra.inits"
    , arguments = []
    , expression =
        H.node1
            1714
            5
            52
            (Elm.Syntax.Expression.Application
                [ H.node1 1714 5 10 (H.val "foldr")
                , H.node1
                    1714
                    11
                    45
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            1714
                            12
                            44
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        1714
                                        13
                                        14
                                        (Elm.Syntax.Pattern.VarPattern "e")
                                    , H.node1
                                        1714
                                        15
                                        18
                                        (Elm.Syntax.Pattern.VarPattern "acc")
                                    ]
                                , expression =
                                    H.node1
                                        1714
                                        22
                                        44
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "::"
                                            Elm.Syntax.Infix.Right
                                            (H.node1
                                                1714
                                                22
                                                24
                                                (Elm.Syntax.Expression.ListExpr
                                                    []
                                                )
                                            )
                                            (H.node1
                                                1714
                                                28
                                                44
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        1714
                                                        28
                                                        31
                                                        (H.val "map")
                                                    , H.node1
                                                        1714
                                                        32
                                                        40
                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                            (H.node1
                                                                1714
                                                                33
                                                                39
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        1714
                                                                        33
                                                                        37
                                                                        (Elm.Syntax.Expression.PrefixOperator
                                                                            "::"
                                                                        )
                                                                    , H.node1
                                                                        1714
                                                                        38
                                                                        39
                                                                        (H.val
                                                                            "e"
                                                                        )
                                                                    ]
                                                                )
                                                            )
                                                        )
                                                    , H.node1
                                                        1714
                                                        41
                                                        44
                                                        (H.val "acc")
                                                    ]
                                                )
                                            )
                                        )
                                }
                            )
                        )
                    )
                , H.node1
                    1714
                    46
                    52
                    (Elm.Syntax.Expression.ListExpr
                        [ H.node1 1714 48 50 (Elm.Syntax.Expression.ListExpr [])
                        ]
                    )
                ]
            )
    }


tails : Elm.Syntax.Expression.FunctionImplementation
tails =
    { name = H.node1 1724 1 6 "List.Extra.tails"
    , arguments = []
    , expression =
        H.node1
            1725
            5
            27
            (Elm.Syntax.Expression.Application
                [ H.node1 1725 5 10 (H.val "foldr")
                , H.node1 1725 11 20 (H.val "tailsHelp")
                , H.node1
                    1725
                    21
                    27
                    (Elm.Syntax.Expression.ListExpr
                        [ H.node1 1725 23 25 (Elm.Syntax.Expression.ListExpr [])
                        ]
                    )
                ]
            )
    }


tailsHelp : Elm.Syntax.Expression.FunctionImplementation
tailsHelp =
    { name = H.node1 1729 1 10 "List.Extra.tailsHelp"
    , arguments =
        [ H.node1 1729 11 12 (Elm.Syntax.Pattern.VarPattern "e")
        , H.node1 1729 13 17 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1730
            5
            1735
            15
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1730 10 14 (H.val "list")
                , cases =
                    [ ( H.node1
                            1731
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1731
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1731
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node1
                            1732
                            13
                            32
                            (Elm.Syntax.Expression.OperatorApplication
                                "::"
                                Elm.Syntax.Infix.Right
                                (H.node1
                                    1732
                                    13
                                    21
                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                        (H.node1
                                            1732
                                            14
                                            20
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "::"
                                                Elm.Syntax.Infix.Right
                                                (H.node1 1732 14 15 (H.val "e"))
                                                (H.node1 1732 19 20 (H.val "x"))
                                            )
                                        )
                                    )
                                )
                                (H.node1
                                    1732
                                    25
                                    32
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "::"
                                        Elm.Syntax.Infix.Right
                                        (H.node1 1732 25 26 (H.val "x"))
                                        (H.node1 1732 30 32 (H.val "xs"))
                                    )
                                )
                            )
                      )
                    , ( H.node1 1734 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1735 13 15 (Elm.Syntax.Expression.ListExpr [])
                      )
                    ]
                }
            )
    }


select : Elm.Syntax.Expression.FunctionImplementation
select =
    { name = H.node1 1745 1 7 "List.Extra.select"
    , arguments = [ H.node1 1745 8 12 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node
            1746
            5
            1751
            72
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1746 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 1747 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1748 13 15 (Elm.Syntax.Expression.ListExpr [])
                      )
                    , ( H.node1
                            1750
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1750
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1750
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node1
                            1751
                            13
                            72
                            (Elm.Syntax.Expression.OperatorApplication
                                "::"
                                Elm.Syntax.Infix.Right
                                (H.node1
                                    1751
                                    13
                                    22
                                    (Elm.Syntax.Expression.TupledExpression
                                        [ H.node1 1751 15 16 (H.val "x")
                                        , H.node1 1751 18 20 (H.val "xs")
                                        ]
                                    )
                                )
                                (H.node1
                                    1751
                                    26
                                    72
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 1751 26 29 (H.val "map")
                                        , H.node1
                                            1751
                                            30
                                            60
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    1751
                                                    31
                                                    59
                                                    (Elm.Syntax.Expression.LambdaExpression
                                                        { args =
                                                            [ H.node1
                                                                1751
                                                                32
                                                                41
                                                                (Elm.Syntax.Pattern.TuplePattern
                                                                    [ H.node1
                                                                        1751
                                                                        34
                                                                        35
                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                            "y"
                                                                        )
                                                                    , H.node1
                                                                        1751
                                                                        37
                                                                        39
                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                            "ys"
                                                                        )
                                                                    ]
                                                                )
                                                            ]
                                                        , expression =
                                                            H.node1
                                                                1751
                                                                45
                                                                59
                                                                (Elm.Syntax.Expression.TupledExpression
                                                                    [ H.node1
                                                                        1751
                                                                        47
                                                                        48
                                                                        (H.val
                                                                            "y"
                                                                        )
                                                                    , H.node1
                                                                        1751
                                                                        50
                                                                        57
                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                            "::"
                                                                            Elm.Syntax.Infix.Right
                                                                            (H.node1
                                                                                1751
                                                                                50
                                                                                51
                                                                                (H.val
                                                                                    "x"
                                                                                )
                                                                            )
                                                                            (H.node1
                                                                                1751
                                                                                55
                                                                                57
                                                                                (H.val
                                                                                    "ys"
                                                                                )
                                                                            )
                                                                        )
                                                                    ]
                                                                )
                                                        }
                                                    )
                                                )
                                            )
                                        , H.node1
                                            1751
                                            61
                                            72
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    1751
                                                    62
                                                    71
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            1751
                                                            62
                                                            68
                                                            (H.val "select")
                                                        , H.node1
                                                            1751
                                                            69
                                                            71
                                                            (H.val "xs")
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


selectSplit : Elm.Syntax.Expression.FunctionImplementation
selectSplit =
    { name = H.node1 1761 1 12 "List.Extra.selectSplit"
    , arguments = [ H.node1 1761 13 17 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node
            1762
            5
            1767
            93
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1762 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 1763 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1764 13 15 (Elm.Syntax.Expression.ListExpr [])
                      )
                    , ( H.node1
                            1766
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1766
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1766
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node1
                            1767
                            13
                            93
                            (Elm.Syntax.Expression.OperatorApplication
                                "::"
                                Elm.Syntax.Infix.Right
                                (H.node1
                                    1767
                                    13
                                    26
                                    (Elm.Syntax.Expression.TupledExpression
                                        [ H.node1
                                            1767
                                            15
                                            17
                                            (Elm.Syntax.Expression.ListExpr [])
                                        , H.node1 1767 19 20 (H.val "x")
                                        , H.node1 1767 22 24 (H.val "xs")
                                        ]
                                    )
                                )
                                (H.node1
                                    1767
                                    30
                                    93
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 1767 30 33 (H.val "map")
                                        , H.node1
                                            1767
                                            34
                                            76
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    1767
                                                    35
                                                    75
                                                    (Elm.Syntax.Expression.LambdaExpression
                                                        { args =
                                                            [ H.node1
                                                                1767
                                                                36
                                                                51
                                                                (Elm.Syntax.Pattern.TuplePattern
                                                                    [ H.node1
                                                                        1767
                                                                        38
                                                                        41
                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                            "lys"
                                                                        )
                                                                    , H.node1
                                                                        1767
                                                                        43
                                                                        44
                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                            "y"
                                                                        )
                                                                    , H.node1
                                                                        1767
                                                                        46
                                                                        49
                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                            "rys"
                                                                        )
                                                                    ]
                                                                )
                                                            ]
                                                        , expression =
                                                            H.node1
                                                                1767
                                                                55
                                                                75
                                                                (Elm.Syntax.Expression.TupledExpression
                                                                    [ H.node1
                                                                        1767
                                                                        57
                                                                        65
                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                            "::"
                                                                            Elm.Syntax.Infix.Right
                                                                            (H.node1
                                                                                1767
                                                                                57
                                                                                58
                                                                                (H.val
                                                                                    "x"
                                                                                )
                                                                            )
                                                                            (H.node1
                                                                                1767
                                                                                62
                                                                                65
                                                                                (H.val
                                                                                    "lys"
                                                                                )
                                                                            )
                                                                        )
                                                                    , H.node1
                                                                        1767
                                                                        67
                                                                        68
                                                                        (H.val
                                                                            "y"
                                                                        )
                                                                    , H.node1
                                                                        1767
                                                                        70
                                                                        73
                                                                        (H.val
                                                                            "rys"
                                                                        )
                                                                    ]
                                                                )
                                                        }
                                                    )
                                                )
                                            )
                                        , H.node1
                                            1767
                                            77
                                            93
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    1767
                                                    78
                                                    92
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            1767
                                                            78
                                                            89
                                                            (H.val "selectSplit"
                                                            )
                                                        , H.node1
                                                            1767
                                                            90
                                                            92
                                                            (H.val "xs")
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


isPrefixOf : Elm.Syntax.Expression.FunctionImplementation
isPrefixOf =
    { name = H.node1 1773 1 11 "List.Extra.isPrefixOf"
    , arguments =
        [ H.node1 1773 12 18 (Elm.Syntax.Pattern.VarPattern "prefix")
        , H.node1 1773 19 23 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1774
            5
            1786
            22
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        1774
                        10
                        26
                        (Elm.Syntax.Expression.TupledExpression
                            [ H.node1 1774 12 18 (H.val "prefix")
                            , H.node1 1774 20 24 (H.val "list")
                            ]
                        )
                , cases =
                    [ ( H.node1
                            1775
                            9
                            18
                            (Elm.Syntax.Pattern.TuplePattern
                                [ H.node1
                                    1775
                                    11
                                    13
                                    (Elm.Syntax.Pattern.ListPattern [])
                                , H.node1
                                    1775
                                    15
                                    16
                                    Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , H.node1 1776 13 17 (H.val "True")
                      )
                    , ( H.node1
                            1778
                            9
                            23
                            (Elm.Syntax.Pattern.TuplePattern
                                [ H.node1
                                    1778
                                    11
                                    17
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (H.node1
                                            1778
                                            11
                                            12
                                            Elm.Syntax.Pattern.AllPattern
                                        )
                                        (H.node1
                                            1778
                                            16
                                            17
                                            Elm.Syntax.Pattern.AllPattern
                                        )
                                    )
                                , H.node1
                                    1778
                                    19
                                    21
                                    (Elm.Syntax.Pattern.ListPattern [])
                                ]
                            )
                      , H.node1 1779 13 18 (H.val "False")
                      )
                    , ( H.node1
                            1781
                            9
                            29
                            (Elm.Syntax.Pattern.TuplePattern
                                [ H.node1
                                    1781
                                    11
                                    18
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (H.node1
                                            1781
                                            11
                                            12
                                            (Elm.Syntax.Pattern.VarPattern "p")
                                        )
                                        (H.node1
                                            1781
                                            16
                                            18
                                            (Elm.Syntax.Pattern.VarPattern "ps")
                                        )
                                    )
                                , H.node1
                                    1781
                                    20
                                    27
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (H.node1
                                            1781
                                            20
                                            21
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        )
                                        (H.node1
                                            1781
                                            25
                                            27
                                            (Elm.Syntax.Pattern.VarPattern "xs")
                                        )
                                    )
                                ]
                            )
                      , H.node
                            1782
                            13
                            1786
                            22
                            (Elm.Syntax.Expression.IfBlock
                                (H.node1
                                    1782
                                    16
                                    22
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "=="
                                        Elm.Syntax.Infix.Non
                                        (H.node1 1782 16 17 (H.val "p"))
                                        (H.node1 1782 21 22 (H.val "x"))
                                    )
                                )
                                (H.node1
                                    1783
                                    17
                                    33
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            1783
                                            17
                                            27
                                            (H.val "isPrefixOf")
                                        , H.node1 1783 28 30 (H.val "ps")
                                        , H.node1 1783 31 33 (H.val "xs")
                                        ]
                                    )
                                )
                                (H.node1 1786 17 22 (H.val "False"))
                            )
                      )
                    ]
                }
            )
    }


isSuffixOf : Elm.Syntax.Expression.FunctionImplementation
isSuffixOf =
    { name = H.node1 1792 1 11 "List.Extra.isSuffixOf"
    , arguments =
        [ H.node1 1792 12 18 (Elm.Syntax.Pattern.VarPattern "suffix")
        , H.node1 1792 19 21 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node1
            1793
            5
            45
            (Elm.Syntax.Expression.Application
                [ H.node1 1793 5 15 (H.val "isPrefixOf")
                , H.node1
                    1793
                    16
                    32
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            1793
                            17
                            31
                            (Elm.Syntax.Expression.Application
                                [ H.node1 1793 17 24 (H.val "reverse")
                                , H.node1 1793 25 31 (H.val "suffix")
                                ]
                            )
                        )
                    )
                , H.node1
                    1793
                    33
                    45
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            1793
                            34
                            44
                            (Elm.Syntax.Expression.Application
                                [ H.node1 1793 34 41 (H.val "reverse")
                                , H.node1 1793 42 44 (H.val "xs")
                                ]
                            )
                        )
                    )
                ]
            )
    }


isInfixOf : Elm.Syntax.Expression.FunctionImplementation
isInfixOf =
    { name = H.node1 1810 1 10 "List.Extra.isInfixOf"
    , arguments =
        [ H.node1 1810 11 20 (Elm.Syntax.Pattern.VarPattern "infixList")
        , H.node1 1810 21 25 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1811
            5
            1816
            36
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1811 10 19 (H.val "infixList")
                , cases =
                    [ ( H.node1 1812 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1813 13 17 (H.val "True")
                      )
                    , ( H.node1
                            1815
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1815
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1815
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node1
                            1816
                            13
                            36
                            (Elm.Syntax.Expression.Application
                                [ H.node1 1816 13 26 (H.val "isInfixOfHelp")
                                , H.node1 1816 27 28 (H.val "x")
                                , H.node1 1816 29 31 (H.val "xs")
                                , H.node1 1816 32 36 (H.val "list")
                                ]
                            )
                      )
                    ]
                }
            )
    }


isInfixOfHelp : Elm.Syntax.Expression.FunctionImplementation
isInfixOfHelp =
    { name = H.node1 1820 1 14 "List.Extra.isInfixOfHelp"
    , arguments =
        [ H.node1 1820 15 24 (Elm.Syntax.Pattern.VarPattern "infixHead")
        , H.node1 1820 25 34 (Elm.Syntax.Pattern.VarPattern "infixTail")
        , H.node1 1820 35 39 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1821
            5
            1830
            53
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1821 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 1822 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1 1823 13 18 (H.val "False")
                      )
                    , ( H.node1
                            1825
                            9
                            16
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1825
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1825
                                    14
                                    16
                                    (Elm.Syntax.Pattern.VarPattern "xs")
                                )
                            )
                      , H.node
                            1826
                            13
                            1830
                            53
                            (Elm.Syntax.Expression.IfBlock
                                (H.node1
                                    1826
                                    16
                                    57
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "&&"
                                        Elm.Syntax.Infix.Right
                                        (H.node1
                                            1826
                                            16
                                            30
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "=="
                                                Elm.Syntax.Infix.Non
                                                (H.node1 1826 16 17 (H.val "x"))
                                                (H.node1
                                                    1826
                                                    21
                                                    30
                                                    (H.val "infixHead")
                                                )
                                            )
                                        )
                                        (H.node1
                                            1826
                                            34
                                            57
                                            (Elm.Syntax.Expression.Application
                                                [ H.node1
                                                    1826
                                                    34
                                                    44
                                                    (H.val "isPrefixOf")
                                                , H.node1
                                                    1826
                                                    45
                                                    54
                                                    (H.val "infixTail")
                                                , H.node1
                                                    1826
                                                    55
                                                    57
                                                    (H.val "xs")
                                                ]
                                            )
                                        )
                                    )
                                )
                                (H.node1 1827 17 21 (H.val "True"))
                                (H.node1
                                    1830
                                    17
                                    53
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            1830
                                            17
                                            30
                                            (H.val "isInfixOfHelp")
                                        , H.node1 1830 31 40 (H.val "infixHead")
                                        , H.node1 1830 41 50 (H.val "infixTail")
                                        , H.node1 1830 51 53 (H.val "xs")
                                        ]
                                    )
                                )
                            )
                      )
                    ]
                }
            )
    }


isSubsequenceOf : Elm.Syntax.Expression.FunctionImplementation
isSubsequenceOf =
    { name = H.node1 1848 1 16 "List.Extra.isSubsequenceOf"
    , arguments =
        [ H.node1 1848 17 23 (Elm.Syntax.Pattern.VarPattern "subseq")
        , H.node1 1848 24 28 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1849
            5
            1861
            42
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        1849
                        10
                        26
                        (Elm.Syntax.Expression.TupledExpression
                            [ H.node1 1849 12 18 (H.val "subseq")
                            , H.node1 1849 20 24 (H.val "list")
                            ]
                        )
                , cases =
                    [ ( H.node1
                            1850
                            9
                            18
                            (Elm.Syntax.Pattern.TuplePattern
                                [ H.node1
                                    1850
                                    11
                                    13
                                    (Elm.Syntax.Pattern.ListPattern [])
                                , H.node1
                                    1850
                                    15
                                    16
                                    Elm.Syntax.Pattern.AllPattern
                                ]
                            )
                      , H.node1 1851 13 17 (H.val "True")
                      )
                    , ( H.node1
                            1853
                            9
                            18
                            (Elm.Syntax.Pattern.TuplePattern
                                [ H.node1
                                    1853
                                    11
                                    12
                                    Elm.Syntax.Pattern.AllPattern
                                , H.node1
                                    1853
                                    14
                                    16
                                    (Elm.Syntax.Pattern.ListPattern [])
                                ]
                            )
                      , H.node1 1854 13 18 (H.val "False")
                      )
                    , ( H.node1
                            1856
                            9
                            29
                            (Elm.Syntax.Pattern.TuplePattern
                                [ H.node1
                                    1856
                                    11
                                    18
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (H.node1
                                            1856
                                            11
                                            12
                                            (Elm.Syntax.Pattern.VarPattern "x")
                                        )
                                        (H.node1
                                            1856
                                            16
                                            18
                                            (Elm.Syntax.Pattern.VarPattern "xs")
                                        )
                                    )
                                , H.node1
                                    1856
                                    20
                                    27
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (H.node1
                                            1856
                                            20
                                            21
                                            (Elm.Syntax.Pattern.VarPattern "y")
                                        )
                                        (H.node1
                                            1856
                                            25
                                            27
                                            (Elm.Syntax.Pattern.VarPattern "ys")
                                        )
                                    )
                                ]
                            )
                      , H.node
                            1857
                            13
                            1861
                            42
                            (Elm.Syntax.Expression.IfBlock
                                (H.node1
                                    1857
                                    16
                                    22
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "=="
                                        Elm.Syntax.Infix.Non
                                        (H.node1 1857 16 17 (H.val "x"))
                                        (H.node1 1857 21 22 (H.val "y"))
                                    )
                                )
                                (H.node1
                                    1858
                                    17
                                    38
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            1858
                                            17
                                            32
                                            (H.val "isSubsequenceOf")
                                        , H.node1 1858 33 35 (H.val "xs")
                                        , H.node1 1858 36 38 (H.val "ys")
                                        ]
                                    )
                                )
                                (H.node1
                                    1861
                                    17
                                    42
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            1861
                                            17
                                            32
                                            (H.val "isSubsequenceOf")
                                        , H.node1 1861 33 39 (H.val "subseq")
                                        , H.node1 1861 40 42 (H.val "ys")
                                        ]
                                    )
                                )
                            )
                      )
                    ]
                }
            )
    }


isPermutationOf : Elm.Syntax.Expression.FunctionImplementation
isPermutationOf =
    { name = H.node1 1884 1 16 "List.Extra.isPermutationOf"
    , arguments =
        [ H.node1 1884 17 23 (Elm.Syntax.Pattern.VarPattern "permut")
        , H.node1 1884 24 26 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node
            1885
            5
            1898
            22
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1885 10 12 (H.val "xs")
                , cases =
                    [ ( H.node1 1886 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1
                            1887
                            13
                            32
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    1887
                                    13
                                    25
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "List" ]
                                        "isEmpty"
                                    )
                                , H.node1 1887 26 32 (H.val "permut")
                                ]
                            )
                      )
                    , ( H.node1
                            1889
                            9
                            19
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1889
                                    9
                                    10
                                    (Elm.Syntax.Pattern.VarPattern "x")
                                )
                                (H.node1
                                    1889
                                    14
                                    19
                                    (Elm.Syntax.Pattern.VarPattern "after")
                                )
                            )
                      , H.node
                            1890
                            13
                            1898
                            22
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ H.node
                                        1891
                                        17
                                        1892
                                        45
                                        (Elm.Syntax.Expression.LetDestructuring
                                            (H.node1
                                                1891
                                                17
                                                38
                                                (Elm.Syntax.Pattern.RecordPattern
                                                    [ H.node1
                                                        1891
                                                        19
                                                        27
                                                        "foundAny"
                                                    , H.node1
                                                        1891
                                                        29
                                                        36
                                                        "without"
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                1892
                                                21
                                                45
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        1892
                                                        21
                                                        36
                                                        (H.val "removeOneMember"
                                                        )
                                                    , H.node1
                                                        1892
                                                        37
                                                        38
                                                        (H.val "x")
                                                    , H.node1
                                                        1892
                                                        39
                                                        45
                                                        (H.val "permut")
                                                    ]
                                                )
                                            )
                                        )
                                    ]
                                , expression =
                                    H.node
                                        1894
                                        13
                                        1898
                                        22
                                        (Elm.Syntax.Expression.IfBlock
                                            (H.node1
                                                1894
                                                16
                                                24
                                                (H.val "foundAny")
                                            )
                                            (H.node1
                                                1895
                                                17
                                                46
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        1895
                                                        17
                                                        32
                                                        (H.val "isPermutationOf"
                                                        )
                                                    , H.node1
                                                        1895
                                                        33
                                                        40
                                                        (H.val "without")
                                                    , H.node1
                                                        1895
                                                        41
                                                        46
                                                        (H.val "after")
                                                    ]
                                                )
                                            )
                                            (H.node1 1898 17 22 (H.val "False"))
                                        )
                                }
                            )
                      )
                    ]
                }
            )
    }


removeOneMember : Elm.Syntax.Expression.FunctionImplementation
removeOneMember =
    { name = H.node1 1902 1 16 "List.Extra.removeOneMember"
    , arguments =
        [ H.node1 1902 17 24 (Elm.Syntax.Pattern.VarPattern "culprit")
        , H.node1 1902 25 26 (Elm.Syntax.Pattern.VarPattern "l")
        ]
    , expression =
        H.node1
            1903
            5
            37
            (Elm.Syntax.Expression.Application
                [ H.node1 1903 5 24 (H.val "removeOneMemberHelp")
                , H.node1 1903 25 32 (H.val "culprit")
                , H.node1 1903 33 35 (Elm.Syntax.Expression.ListExpr [])
                , H.node1 1903 36 37 (H.val "l")
                ]
            )
    }


removeOneMemberHelp : Elm.Syntax.Expression.FunctionImplementation
removeOneMemberHelp =
    { name = H.node1 1906 1 20 "List.Extra.removeOneMemberHelp"
    , arguments =
        [ H.node1 1906 21 28 (Elm.Syntax.Pattern.VarPattern "culprit")
        , H.node1 1906 29 35 (Elm.Syntax.Pattern.VarPattern "before")
        , H.node1 1906 36 40 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1907
            5
            1916
            67
            (Elm.Syntax.Expression.CaseExpression
                { expression = H.node1 1907 10 14 (H.val "list")
                , cases =
                    [ ( H.node1 1908 9 11 (Elm.Syntax.Pattern.ListPattern [])
                      , H.node1
                            1909
                            13
                            47
                            (Elm.Syntax.Expression.RecordExpr
                                [ H.node1
                                    1909
                                    15
                                    31
                                    ( H.node1 1909 15 23 "foundAny"
                                    , H.node1 1909 26 31 (H.val "False")
                                    )
                                , H.node1
                                    1909
                                    33
                                    46
                                    ( H.node1 1909 33 40 "without"
                                    , H.node1
                                        1909
                                        43
                                        45
                                        (Elm.Syntax.Expression.ListExpr [])
                                    )
                                ]
                            )
                      )
                    , ( H.node1
                            1911
                            9
                            22
                            (Elm.Syntax.Pattern.UnConsPattern
                                (H.node1
                                    1911
                                    9
                                    13
                                    (Elm.Syntax.Pattern.VarPattern "head")
                                )
                                (H.node1
                                    1911
                                    17
                                    22
                                    (Elm.Syntax.Pattern.VarPattern "after")
                                )
                            )
                      , H.node
                            1912
                            13
                            1916
                            67
                            (Elm.Syntax.Expression.IfBlock
                                (H.node1
                                    1912
                                    16
                                    31
                                    (Elm.Syntax.Expression.OperatorApplication
                                        "=="
                                        Elm.Syntax.Infix.Non
                                        (H.node1 1912 16 20 (H.val "head"))
                                        (H.node1 1912 24 31 (H.val "culprit"))
                                    )
                                )
                                (H.node1
                                    1913
                                    17
                                    63
                                    (Elm.Syntax.Expression.RecordExpr
                                        [ H.node1
                                            1913
                                            19
                                            34
                                            ( H.node1 1913 19 27 "foundAny"
                                            , H.node1 1913 30 34 (H.val "True")
                                            )
                                        , H.node1
                                            1913
                                            36
                                            62
                                            ( H.node1 1913 36 43 "without"
                                            , H.node1
                                                1913
                                                46
                                                61
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "++"
                                                    Elm.Syntax.Infix.Right
                                                    (H.node1
                                                        1913
                                                        46
                                                        52
                                                        (H.val "before")
                                                    )
                                                    (H.node1
                                                        1913
                                                        56
                                                        61
                                                        (H.val "after")
                                                    )
                                                )
                                            )
                                        ]
                                    )
                                )
                                (H.node1
                                    1916
                                    17
                                    67
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1
                                            1916
                                            17
                                            36
                                            (H.val "removeOneMemberHelp")
                                        , H.node1 1916 37 44 (H.val "culprit")
                                        , H.node1
                                            1916
                                            45
                                            61
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    1916
                                                    46
                                                    60
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "::"
                                                        Elm.Syntax.Infix.Right
                                                        (H.node1
                                                            1916
                                                            46
                                                            50
                                                            (H.val "head")
                                                        )
                                                        (H.node1
                                                            1916
                                                            54
                                                            60
                                                            (H.val "before")
                                                        )
                                                    )
                                                )
                                            )
                                        , H.node1 1916 62 67 (H.val "after")
                                        ]
                                    )
                                )
                            )
                      )
                    ]
                }
            )
    }


zip : Elm.Syntax.Expression.FunctionImplementation
zip =
    { name = H.node1 1922 1 4 "List.Extra.zip"
    , arguments = []
    , expression =
        H.node1
            1923
            5
            20
            (Elm.Syntax.Expression.Application
                [ H.node1 1923 5 9 (H.val "map2")
                , H.node1
                    1923
                    10
                    20
                    (Elm.Syntax.Expression.FunctionOrValue [ "Tuple" ] "pair")
                ]
            )
    }


zip3 : Elm.Syntax.Expression.FunctionImplementation
zip3 =
    { name = H.node1 1929 1 5 "List.Extra.zip3"
    , arguments = []
    , expression =
        H.node1
            1930
            5
            16
            (Elm.Syntax.Expression.Application
                [ H.node1 1930 5 9 (H.val "map3")
                , H.node1 1930 10 16 (H.val "triple")
                ]
            )
    }


triple : Elm.Syntax.Expression.FunctionImplementation
triple =
    { name = H.node1 1934 1 7 "List.Extra.triple"
    , arguments =
        [ H.node1 1934 8 9 (Elm.Syntax.Pattern.VarPattern "a")
        , H.node1 1934 10 11 (Elm.Syntax.Pattern.VarPattern "b")
        , H.node1 1934 12 13 (Elm.Syntax.Pattern.VarPattern "c")
        ]
    , expression =
        H.node1
            1935
            5
            16
            (Elm.Syntax.Expression.TupledExpression
                [ H.node1 1935 7 8 (H.val "a")
                , H.node1 1935 10 11 (H.val "b")
                , H.node1 1935 13 14 (H.val "c")
                ]
            )
    }


lift2 : Elm.Syntax.Expression.FunctionImplementation
lift2 =
    { name = H.node1 1946 1 6 "List.Extra.lift2"
    , arguments =
        [ H.node1 1946 7 8 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 1946 9 11 (Elm.Syntax.Pattern.VarPattern "la")
        , H.node1 1946 12 14 (Elm.Syntax.Pattern.VarPattern "lb")
        ]
    , expression =
        H.node1
            1947
            5
            58
            (Elm.Syntax.Expression.OperatorApplication
                "|>"
                Elm.Syntax.Infix.Left
                (H.node1 1947 5 7 (H.val "la"))
                (H.node1
                    1947
                    11
                    58
                    (Elm.Syntax.Expression.Application
                        [ H.node1 1947 11 18 (H.val "andThen")
                        , H.node1
                            1947
                            19
                            58
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    1947
                                    20
                                    57
                                    (Elm.Syntax.Expression.LambdaExpression
                                        { args =
                                            [ H.node1
                                                1947
                                                21
                                                22
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "a"
                                                )
                                            ]
                                        , expression =
                                            H.node1
                                                1947
                                                26
                                                57
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "|>"
                                                    Elm.Syntax.Infix.Left
                                                    (H.node1
                                                        1947
                                                        26
                                                        28
                                                        (H.val "lb")
                                                    )
                                                    (H.node1
                                                        1947
                                                        32
                                                        57
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                1947
                                                                32
                                                                39
                                                                (H.val "andThen"
                                                                )
                                                            , H.node1
                                                                1947
                                                                40
                                                                57
                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                    (H.node1
                                                                        1947
                                                                        41
                                                                        56
                                                                        (Elm.Syntax.Expression.LambdaExpression
                                                                            { args =
                                                                                [ H.node1
                                                                                    1947
                                                                                    42
                                                                                    43
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "b"
                                                                                    )
                                                                                ]
                                                                            , expression =
                                                                                H.node1
                                                                                    1947
                                                                                    47
                                                                                    56
                                                                                    (Elm.Syntax.Expression.ListExpr
                                                                                        [ H.node1
                                                                                            1947
                                                                                            49
                                                                                            54
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    1947
                                                                                                    49
                                                                                                    50
                                                                                                    (H.val
                                                                                                        "f"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    1947
                                                                                                    51
                                                                                                    52
                                                                                                    (H.val
                                                                                                        "a"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    1947
                                                                                                    53
                                                                                                    54
                                                                                                    (H.val
                                                                                                        "b"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                            }
                                                                        )
                                                                    )
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                        }
                                    )
                                )
                            )
                        ]
                    )
                )
            )
    }


lift3 : Elm.Syntax.Expression.FunctionImplementation
lift3 =
    { name = H.node1 1952 1 6 "List.Extra.lift3"
    , arguments =
        [ H.node1 1952 7 8 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 1952 9 11 (Elm.Syntax.Pattern.VarPattern "la")
        , H.node1 1952 12 14 (Elm.Syntax.Pattern.VarPattern "lb")
        , H.node1 1952 15 17 (Elm.Syntax.Pattern.VarPattern "lc")
        ]
    , expression =
        H.node1
            1953
            5
            82
            (Elm.Syntax.Expression.OperatorApplication
                "|>"
                Elm.Syntax.Infix.Left
                (H.node1 1953 5 7 (H.val "la"))
                (H.node1
                    1953
                    11
                    82
                    (Elm.Syntax.Expression.Application
                        [ H.node1 1953 11 18 (H.val "andThen")
                        , H.node1
                            1953
                            19
                            82
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    1953
                                    20
                                    81
                                    (Elm.Syntax.Expression.LambdaExpression
                                        { args =
                                            [ H.node1
                                                1953
                                                21
                                                22
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "a"
                                                )
                                            ]
                                        , expression =
                                            H.node1
                                                1953
                                                26
                                                81
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "|>"
                                                    Elm.Syntax.Infix.Left
                                                    (H.node1
                                                        1953
                                                        26
                                                        28
                                                        (H.val "lb")
                                                    )
                                                    (H.node1
                                                        1953
                                                        32
                                                        81
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                1953
                                                                32
                                                                39
                                                                (H.val "andThen"
                                                                )
                                                            , H.node1
                                                                1953
                                                                40
                                                                81
                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                    (H.node1
                                                                        1953
                                                                        41
                                                                        80
                                                                        (Elm.Syntax.Expression.LambdaExpression
                                                                            { args =
                                                                                [ H.node1
                                                                                    1953
                                                                                    42
                                                                                    43
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "b"
                                                                                    )
                                                                                ]
                                                                            , expression =
                                                                                H.node1
                                                                                    1953
                                                                                    47
                                                                                    80
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "|>"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (H.node1
                                                                                            1953
                                                                                            47
                                                                                            49
                                                                                            (H.val
                                                                                                "lc"
                                                                                            )
                                                                                        )
                                                                                        (H.node1
                                                                                            1953
                                                                                            53
                                                                                            80
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    1953
                                                                                                    53
                                                                                                    60
                                                                                                    (H.val
                                                                                                        "andThen"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    1953
                                                                                                    61
                                                                                                    80
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (H.node1
                                                                                                            1953
                                                                                                            62
                                                                                                            79
                                                                                                            (Elm.Syntax.Expression.LambdaExpression
                                                                                                                { args =
                                                                                                                    [ H.node1
                                                                                                                        1953
                                                                                                                        63
                                                                                                                        64
                                                                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                                                                            "c"
                                                                                                                        )
                                                                                                                    ]
                                                                                                                , expression =
                                                                                                                    H.node1
                                                                                                                        1953
                                                                                                                        68
                                                                                                                        79
                                                                                                                        (Elm.Syntax.Expression.ListExpr
                                                                                                                            [ H.node1
                                                                                                                                1953
                                                                                                                                70
                                                                                                                                77
                                                                                                                                (Elm.Syntax.Expression.Application
                                                                                                                                    [ H.node1
                                                                                                                                        1953
                                                                                                                                        70
                                                                                                                                        71
                                                                                                                                        (H.val
                                                                                                                                            "f"
                                                                                                                                        )
                                                                                                                                    , H.node1
                                                                                                                                        1953
                                                                                                                                        72
                                                                                                                                        73
                                                                                                                                        (H.val
                                                                                                                                            "a"
                                                                                                                                        )
                                                                                                                                    , H.node1
                                                                                                                                        1953
                                                                                                                                        74
                                                                                                                                        75
                                                                                                                                        (H.val
                                                                                                                                            "b"
                                                                                                                                        )
                                                                                                                                    , H.node1
                                                                                                                                        1953
                                                                                                                                        76
                                                                                                                                        77
                                                                                                                                        (H.val
                                                                                                                                            "c"
                                                                                                                                        )
                                                                                                                                    ]
                                                                                                                                )
                                                                                                                            ]
                                                                                                                        )
                                                                                                                }
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                        )
                                                                                    )
                                                                            }
                                                                        )
                                                                    )
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                        }
                                    )
                                )
                            )
                        ]
                    )
                )
            )
    }


lift4 : Elm.Syntax.Expression.FunctionImplementation
lift4 =
    { name = H.node1 1958 1 6 "List.Extra.lift4"
    , arguments =
        [ H.node1 1958 7 8 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 1958 9 11 (Elm.Syntax.Pattern.VarPattern "la")
        , H.node1 1958 12 14 (Elm.Syntax.Pattern.VarPattern "lb")
        , H.node1 1958 15 17 (Elm.Syntax.Pattern.VarPattern "lc")
        , H.node1 1958 18 20 (Elm.Syntax.Pattern.VarPattern "ld")
        ]
    , expression =
        H.node1
            1959
            5
            106
            (Elm.Syntax.Expression.OperatorApplication
                "|>"
                Elm.Syntax.Infix.Left
                (H.node1 1959 5 7 (H.val "la"))
                (H.node1
                    1959
                    11
                    106
                    (Elm.Syntax.Expression.Application
                        [ H.node1 1959 11 18 (H.val "andThen")
                        , H.node1
                            1959
                            19
                            106
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    1959
                                    20
                                    105
                                    (Elm.Syntax.Expression.LambdaExpression
                                        { args =
                                            [ H.node1
                                                1959
                                                21
                                                22
                                                (Elm.Syntax.Pattern.VarPattern
                                                    "a"
                                                )
                                            ]
                                        , expression =
                                            H.node1
                                                1959
                                                26
                                                105
                                                (Elm.Syntax.Expression.OperatorApplication
                                                    "|>"
                                                    Elm.Syntax.Infix.Left
                                                    (H.node1
                                                        1959
                                                        26
                                                        28
                                                        (H.val "lb")
                                                    )
                                                    (H.node1
                                                        1959
                                                        32
                                                        105
                                                        (Elm.Syntax.Expression.Application
                                                            [ H.node1
                                                                1959
                                                                32
                                                                39
                                                                (H.val "andThen"
                                                                )
                                                            , H.node1
                                                                1959
                                                                40
                                                                105
                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                    (H.node1
                                                                        1959
                                                                        41
                                                                        104
                                                                        (Elm.Syntax.Expression.LambdaExpression
                                                                            { args =
                                                                                [ H.node1
                                                                                    1959
                                                                                    42
                                                                                    43
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "b"
                                                                                    )
                                                                                ]
                                                                            , expression =
                                                                                H.node1
                                                                                    1959
                                                                                    47
                                                                                    104
                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                        "|>"
                                                                                        Elm.Syntax.Infix.Left
                                                                                        (H.node1
                                                                                            1959
                                                                                            47
                                                                                            49
                                                                                            (H.val
                                                                                                "lc"
                                                                                            )
                                                                                        )
                                                                                        (H.node1
                                                                                            1959
                                                                                            53
                                                                                            104
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    1959
                                                                                                    53
                                                                                                    60
                                                                                                    (H.val
                                                                                                        "andThen"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    1959
                                                                                                    61
                                                                                                    104
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (H.node1
                                                                                                            1959
                                                                                                            62
                                                                                                            103
                                                                                                            (Elm.Syntax.Expression.LambdaExpression
                                                                                                                { args =
                                                                                                                    [ H.node1
                                                                                                                        1959
                                                                                                                        63
                                                                                                                        64
                                                                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                                                                            "c"
                                                                                                                        )
                                                                                                                    ]
                                                                                                                , expression =
                                                                                                                    H.node1
                                                                                                                        1959
                                                                                                                        68
                                                                                                                        103
                                                                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                                                                            "|>"
                                                                                                                            Elm.Syntax.Infix.Left
                                                                                                                            (H.node1
                                                                                                                                1959
                                                                                                                                68
                                                                                                                                70
                                                                                                                                (H.val
                                                                                                                                    "ld"
                                                                                                                                )
                                                                                                                            )
                                                                                                                            (H.node1
                                                                                                                                1959
                                                                                                                                74
                                                                                                                                103
                                                                                                                                (Elm.Syntax.Expression.Application
                                                                                                                                    [ H.node1
                                                                                                                                        1959
                                                                                                                                        74
                                                                                                                                        81
                                                                                                                                        (H.val
                                                                                                                                            "andThen"
                                                                                                                                        )
                                                                                                                                    , H.node1
                                                                                                                                        1959
                                                                                                                                        82
                                                                                                                                        103
                                                                                                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                                            (H.node1
                                                                                                                                                1959
                                                                                                                                                83
                                                                                                                                                102
                                                                                                                                                (Elm.Syntax.Expression.LambdaExpression
                                                                                                                                                    { args =
                                                                                                                                                        [ H.node1
                                                                                                                                                            1959
                                                                                                                                                            84
                                                                                                                                                            85
                                                                                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                                                                                "d"
                                                                                                                                                            )
                                                                                                                                                        ]
                                                                                                                                                    , expression =
                                                                                                                                                        H.node1
                                                                                                                                                            1959
                                                                                                                                                            89
                                                                                                                                                            102
                                                                                                                                                            (Elm.Syntax.Expression.ListExpr
                                                                                                                                                                [ H.node1
                                                                                                                                                                    1959
                                                                                                                                                                    91
                                                                                                                                                                    100
                                                                                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                                                                                        [ H.node1
                                                                                                                                                                            1959
                                                                                                                                                                            91
                                                                                                                                                                            92
                                                                                                                                                                            (H.val
                                                                                                                                                                                "f"
                                                                                                                                                                            )
                                                                                                                                                                        , H.node1
                                                                                                                                                                            1959
                                                                                                                                                                            93
                                                                                                                                                                            94
                                                                                                                                                                            (H.val
                                                                                                                                                                                "a"
                                                                                                                                                                            )
                                                                                                                                                                        , H.node1
                                                                                                                                                                            1959
                                                                                                                                                                            95
                                                                                                                                                                            96
                                                                                                                                                                            (H.val
                                                                                                                                                                                "b"
                                                                                                                                                                            )
                                                                                                                                                                        , H.node1
                                                                                                                                                                            1959
                                                                                                                                                                            97
                                                                                                                                                                            98
                                                                                                                                                                            (H.val
                                                                                                                                                                                "c"
                                                                                                                                                                            )
                                                                                                                                                                        , H.node1
                                                                                                                                                                            1959
                                                                                                                                                                            99
                                                                                                                                                                            100
                                                                                                                                                                            (H.val
                                                                                                                                                                                "d"
                                                                                                                                                                            )
                                                                                                                                                                        ]
                                                                                                                                                                    )
                                                                                                                                                                ]
                                                                                                                                                            )
                                                                                                                                                    }
                                                                                                                                                )
                                                                                                                                            )
                                                                                                                                        )
                                                                                                                                    ]
                                                                                                                                )
                                                                                                                            )
                                                                                                                        )
                                                                                                                }
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                        )
                                                                                    )
                                                                            }
                                                                        )
                                                                    )
                                                                )
                                                            ]
                                                        )
                                                    )
                                                )
                                        }
                                    )
                                )
                            )
                        ]
                    )
                )
            )
    }


groupsOf : Elm.Syntax.Expression.FunctionImplementation
groupsOf =
    { name = H.node1 1971 1 9 "List.Extra.groupsOf"
    , arguments =
        [ H.node1 1971 10 14 (Elm.Syntax.Pattern.VarPattern "size")
        , H.node1 1971 15 17 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node1
            1972
            5
            34
            (Elm.Syntax.Expression.Application
                [ H.node1 1972 5 21 (H.val "groupsOfWithStep")
                , H.node1 1972 22 26 (H.val "size")
                , H.node1 1972 27 31 (H.val "size")
                , H.node1 1972 32 34 (H.val "xs")
                ]
            )
    }


groupsOfWithStep : Elm.Syntax.Expression.FunctionImplementation
groupsOfWithStep =
    { name = H.node1 1996 1 17 "List.Extra.groupsOfWithStep"
    , arguments =
        [ H.node1 1996 18 22 (Elm.Syntax.Pattern.VarPattern "size")
        , H.node1 1996 23 27 (Elm.Syntax.Pattern.VarPattern "step")
        , H.node1 1996 28 32 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            1997
            5
            2022
            19
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    1997
                    8
                    30
                    (Elm.Syntax.Expression.OperatorApplication
                        "||"
                        Elm.Syntax.Infix.Right
                        (H.node1
                            1997
                            8
                            17
                            (Elm.Syntax.Expression.OperatorApplication
                                "<="
                                Elm.Syntax.Infix.Non
                                (H.node1 1997 8 12 (H.val "size"))
                                (H.node1
                                    1997
                                    16
                                    17
                                    (Elm.Syntax.Expression.Integer 0)
                                )
                            )
                        )
                        (H.node1
                            1997
                            21
                            30
                            (Elm.Syntax.Expression.OperatorApplication
                                "<="
                                Elm.Syntax.Infix.Non
                                (H.node1 1997 21 25 (H.val "step"))
                                (H.node1
                                    1997
                                    29
                                    30
                                    (Elm.Syntax.Expression.Integer 0)
                                )
                            )
                        )
                    )
                )
                (H.node1 1998 9 11 (Elm.Syntax.Expression.ListExpr []))
                (H.node
                    2001
                    9
                    2022
                    19
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ H.node
                                2002
                                13
                                2020
                                41
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            2003
                                            13
                                            2020
                                            41
                                            { name = H.node1 2003 13 15 "go"
                                            , arguments =
                                                [ H.node1
                                                    2003
                                                    16
                                                    18
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "xs"
                                                    )
                                                , H.node1
                                                    2003
                                                    19
                                                    22
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "acc"
                                                    )
                                                ]
                                            , expression =
                                                H.node
                                                    2004
                                                    17
                                                    2020
                                                    41
                                                    (Elm.Syntax.Expression.IfBlock
                                                        (H.node1
                                                            2004
                                                            20
                                                            35
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    2004
                                                                    20
                                                                    32
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "isEmpty"
                                                                    )
                                                                , H.node1
                                                                    2004
                                                                    33
                                                                    35
                                                                    (H.val "xs")
                                                                ]
                                                            )
                                                        )
                                                        (H.node1
                                                            2005
                                                            21
                                                            37
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    2005
                                                                    21
                                                                    33
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , H.node1
                                                                    2005
                                                                    34
                                                                    37
                                                                    (H.val "acc"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                        (H.node
                                                            2008
                                                            21
                                                            2020
                                                            41
                                                            (Elm.Syntax.Expression.LetExpression
                                                                { declarations =
                                                                    [ H.node
                                                                        2009
                                                                        25
                                                                        2010
                                                                        46
                                                                        (Elm.Syntax.Expression.LetFunction
                                                                            { documentation =
                                                                                Nothing
                                                                            , signature =
                                                                                Nothing
                                                                            , declaration =
                                                                                H.node
                                                                                    2009
                                                                                    25
                                                                                    2010
                                                                                    46
                                                                                    { name =
                                                                                        H.node1
                                                                                            2009
                                                                                            25
                                                                                            34
                                                                                            "thisGroup"
                                                                                    , arguments =
                                                                                        []
                                                                                    , expression =
                                                                                        H.node1
                                                                                            2010
                                                                                            29
                                                                                            46
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    2010
                                                                                                    29
                                                                                                    38
                                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                                        [ "List"
                                                                                                        ]
                                                                                                        "take"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    2010
                                                                                                    39
                                                                                                    43
                                                                                                    (H.val
                                                                                                        "size"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    2010
                                                                                                    44
                                                                                                    46
                                                                                                    (H.val
                                                                                                        "xs"
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                    }
                                                                            }
                                                                        )
                                                                    ]
                                                                , expression =
                                                                    H.node
                                                                        2012
                                                                        21
                                                                        2020
                                                                        41
                                                                        (Elm.Syntax.Expression.IfBlock
                                                                            (H.node1
                                                                                2012
                                                                                24
                                                                                53
                                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                                    "=="
                                                                                    Elm.Syntax.Infix.Non
                                                                                    (H.node1
                                                                                        2012
                                                                                        24
                                                                                        28
                                                                                        (H.val
                                                                                            "size"
                                                                                        )
                                                                                    )
                                                                                    (H.node1
                                                                                        2012
                                                                                        32
                                                                                        53
                                                                                        (Elm.Syntax.Expression.Application
                                                                                            [ H.node1
                                                                                                2012
                                                                                                32
                                                                                                43
                                                                                                (Elm.Syntax.Expression.FunctionOrValue
                                                                                                    [ "List"
                                                                                                    ]
                                                                                                    "length"
                                                                                                )
                                                                                            , H.node1
                                                                                                2012
                                                                                                44
                                                                                                53
                                                                                                (H.val
                                                                                                    "thisGroup"
                                                                                                )
                                                                                            ]
                                                                                        )
                                                                                    )
                                                                                )
                                                                            )
                                                                            (H.node
                                                                                2013
                                                                                25
                                                                                2017
                                                                                51
                                                                                (Elm.Syntax.Expression.LetExpression
                                                                                    { declarations =
                                                                                        [ H.node
                                                                                            2014
                                                                                            29
                                                                                            2015
                                                                                            50
                                                                                            (Elm.Syntax.Expression.LetFunction
                                                                                                { documentation =
                                                                                                    Nothing
                                                                                                , signature =
                                                                                                    Nothing
                                                                                                , declaration =
                                                                                                    H.node
                                                                                                        2014
                                                                                                        29
                                                                                                        2015
                                                                                                        50
                                                                                                        { name =
                                                                                                            H.node1
                                                                                                                2014
                                                                                                                29
                                                                                                                33
                                                                                                                "rest"
                                                                                                        , arguments =
                                                                                                            []
                                                                                                        , expression =
                                                                                                            H.node1
                                                                                                                2015
                                                                                                                33
                                                                                                                50
                                                                                                                (Elm.Syntax.Expression.Application
                                                                                                                    [ H.node1
                                                                                                                        2015
                                                                                                                        33
                                                                                                                        42
                                                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                            [ "List"
                                                                                                                            ]
                                                                                                                            "drop"
                                                                                                                        )
                                                                                                                    , H.node1
                                                                                                                        2015
                                                                                                                        43
                                                                                                                        47
                                                                                                                        (H.val
                                                                                                                            "step"
                                                                                                                        )
                                                                                                                    , H.node1
                                                                                                                        2015
                                                                                                                        48
                                                                                                                        50
                                                                                                                        (H.val
                                                                                                                            "xs"
                                                                                                                        )
                                                                                                                    ]
                                                                                                                )
                                                                                                        }
                                                                                                }
                                                                                            )
                                                                                        ]
                                                                                    , expression =
                                                                                        H.node1
                                                                                            2017
                                                                                            25
                                                                                            51
                                                                                            (Elm.Syntax.Expression.Application
                                                                                                [ H.node1
                                                                                                    2017
                                                                                                    25
                                                                                                    27
                                                                                                    (H.val
                                                                                                        "go"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    2017
                                                                                                    28
                                                                                                    32
                                                                                                    (H.val
                                                                                                        "rest"
                                                                                                    )
                                                                                                , H.node1
                                                                                                    2017
                                                                                                    33
                                                                                                    51
                                                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                        (H.node1
                                                                                                            2017
                                                                                                            34
                                                                                                            50
                                                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                                                "::"
                                                                                                                Elm.Syntax.Infix.Right
                                                                                                                (H.node1
                                                                                                                    2017
                                                                                                                    34
                                                                                                                    43
                                                                                                                    (H.val
                                                                                                                        "thisGroup"
                                                                                                                    )
                                                                                                                )
                                                                                                                (H.node1
                                                                                                                    2017
                                                                                                                    47
                                                                                                                    50
                                                                                                                    (H.val
                                                                                                                        "acc"
                                                                                                                    )
                                                                                                                )
                                                                                                            )
                                                                                                        )
                                                                                                    )
                                                                                                ]
                                                                                            )
                                                                                    }
                                                                                )
                                                                            )
                                                                            (H.node1
                                                                                2020
                                                                                25
                                                                                41
                                                                                (Elm.Syntax.Expression.Application
                                                                                    [ H.node1
                                                                                        2020
                                                                                        25
                                                                                        37
                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                            [ "List"
                                                                                            ]
                                                                                            "reverse"
                                                                                        )
                                                                                    , H.node1
                                                                                        2020
                                                                                        38
                                                                                        41
                                                                                        (H.val
                                                                                            "acc"
                                                                                        )
                                                                                    ]
                                                                                )
                                                                            )
                                                                        )
                                                                }
                                                            )
                                                        )
                                                    )
                                            }
                                    }
                                )
                            ]
                        , expression =
                            H.node1
                                2022
                                9
                                19
                                (Elm.Syntax.Expression.Application
                                    [ H.node1 2022 9 11 (H.val "go")
                                    , H.node1 2022 12 16 (H.val "list")
                                    , H.node1
                                        2022
                                        17
                                        19
                                        (Elm.Syntax.Expression.ListExpr [])
                                    ]
                                )
                        }
                    )
                )
            )
    }


groupsOfVarying : Elm.Syntax.Expression.FunctionImplementation
groupsOfVarying =
    { name = H.node1 2038 1 16 "List.Extra.groupsOfVarying"
    , arguments =
        [ H.node1 2038 17 30 (Elm.Syntax.Pattern.VarPattern "listOfLengths")
        , H.node1 2038 31 35 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node1
            2039
            5
            43
            (Elm.Syntax.Expression.Application
                [ H.node1 2039 5 21 (H.val "groupsOfVarying_")
                , H.node1 2039 22 35 (H.val "listOfLengths")
                , H.node1 2039 36 40 (H.val "list")
                , H.node1 2039 41 43 (Elm.Syntax.Expression.ListExpr [])
                ]
            )
    }


groupsOfVarying_ : Elm.Syntax.Expression.FunctionImplementation
groupsOfVarying_ =
    { name = H.node1 2043 1 17 "List.Extra.groupsOfVarying_"
    , arguments =
        [ H.node1 2043 18 31 (Elm.Syntax.Pattern.VarPattern "listOfLengths")
        , H.node1 2043 32 36 (Elm.Syntax.Pattern.VarPattern "list")
        , H.node1 2043 37 41 (Elm.Syntax.Pattern.VarPattern "accu")
        ]
    , expression =
        H.node
            2044
            5
            2053
            30
            (Elm.Syntax.Expression.CaseExpression
                { expression =
                    H.node1
                        2044
                        10
                        33
                        (Elm.Syntax.Expression.TupledExpression
                            [ H.node1 2044 12 25 (H.val "listOfLengths")
                            , H.node1 2044 27 31 (H.val "list")
                            ]
                        )
                , cases =
                    [ ( H.node1
                            2045
                            9
                            42
                            (Elm.Syntax.Pattern.TuplePattern
                                [ H.node1
                                    2045
                                    11
                                    32
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (H.node1
                                            2045
                                            11
                                            17
                                            (Elm.Syntax.Pattern.VarPattern
                                                "length"
                                            )
                                        )
                                        (H.node1
                                            2045
                                            21
                                            32
                                            (Elm.Syntax.Pattern.VarPattern
                                                "tailLengths"
                                            )
                                        )
                                    )
                                , H.node1
                                    2045
                                    34
                                    40
                                    (Elm.Syntax.Pattern.UnConsPattern
                                        (H.node1
                                            2045
                                            34
                                            35
                                            Elm.Syntax.Pattern.AllPattern
                                        )
                                        (H.node1
                                            2045
                                            39
                                            40
                                            Elm.Syntax.Pattern.AllPattern
                                        )
                                    )
                                ]
                            )
                      , H.node
                            2046
                            13
                            2050
                            61
                            (Elm.Syntax.Expression.LetExpression
                                { declarations =
                                    [ H.node
                                        2047
                                        17
                                        2048
                                        40
                                        (Elm.Syntax.Expression.LetDestructuring
                                            (H.node1
                                                2047
                                                17
                                                31
                                                (Elm.Syntax.Pattern.TuplePattern
                                                    [ H.node1
                                                        2047
                                                        19
                                                        23
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "head"
                                                        )
                                                    , H.node1
                                                        2047
                                                        25
                                                        29
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "tail"
                                                        )
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                2048
                                                21
                                                40
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        2048
                                                        21
                                                        28
                                                        (H.val "splitAt")
                                                    , H.node1
                                                        2048
                                                        29
                                                        35
                                                        (H.val "length")
                                                    , H.node1
                                                        2048
                                                        36
                                                        40
                                                        (H.val "list")
                                                    ]
                                                )
                                            )
                                        )
                                    ]
                                , expression =
                                    H.node1
                                        2050
                                        13
                                        61
                                        (Elm.Syntax.Expression.Application
                                            [ H.node1
                                                2050
                                                13
                                                29
                                                (H.val "groupsOfVarying_")
                                            , H.node1
                                                2050
                                                30
                                                41
                                                (H.val "tailLengths")
                                            , H.node1 2050 42 46 (H.val "tail")
                                            , H.node1
                                                2050
                                                47
                                                61
                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                    (H.node1
                                                        2050
                                                        48
                                                        60
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "::"
                                                            Elm.Syntax.Infix.Right
                                                            (H.node1
                                                                2050
                                                                48
                                                                52
                                                                (H.val "head")
                                                            )
                                                            (H.node1
                                                                2050
                                                                56
                                                                60
                                                                (H.val "accu")
                                                            )
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                }
                            )
                      )
                    , ( H.node1 2052 9 10 Elm.Syntax.Pattern.AllPattern
                      , H.node1
                            2053
                            13
                            30
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    2053
                                    13
                                    25
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "List" ]
                                        "reverse"
                                    )
                                , H.node1 2053 26 30 (H.val "accu")
                                ]
                            )
                      )
                    ]
                }
            )
    }


greedyGroupsOf : Elm.Syntax.Expression.FunctionImplementation
greedyGroupsOf =
    { name = H.node1 2066 1 15 "List.Extra.greedyGroupsOf"
    , arguments =
        [ H.node1 2066 16 20 (Elm.Syntax.Pattern.VarPattern "size")
        , H.node1 2066 21 23 (Elm.Syntax.Pattern.VarPattern "xs")
        ]
    , expression =
        H.node1
            2067
            5
            40
            (Elm.Syntax.Expression.Application
                [ H.node1 2067 5 27 (H.val "greedyGroupsOfWithStep")
                , H.node1 2067 28 32 (H.val "size")
                , H.node1 2067 33 37 (H.val "size")
                , H.node1 2067 38 40 (H.val "xs")
                ]
            )
    }


greedyGroupsOfWithStep : Elm.Syntax.Expression.FunctionImplementation
greedyGroupsOfWithStep =
    { name = H.node1 2090 1 23 "List.Extra.greedyGroupsOfWithStep"
    , arguments =
        [ H.node1 2090 24 28 (Elm.Syntax.Pattern.VarPattern "size")
        , H.node1 2090 29 33 (Elm.Syntax.Pattern.VarPattern "step")
        , H.node1 2090 34 38 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            2091
            5
            2106
            19
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    2091
                    8
                    30
                    (Elm.Syntax.Expression.OperatorApplication
                        "||"
                        Elm.Syntax.Infix.Right
                        (H.node1
                            2091
                            8
                            17
                            (Elm.Syntax.Expression.OperatorApplication
                                "<="
                                Elm.Syntax.Infix.Non
                                (H.node1 2091 8 12 (H.val "size"))
                                (H.node1
                                    2091
                                    16
                                    17
                                    (Elm.Syntax.Expression.Integer 0)
                                )
                            )
                        )
                        (H.node1
                            2091
                            21
                            30
                            (Elm.Syntax.Expression.OperatorApplication
                                "<="
                                Elm.Syntax.Infix.Non
                                (H.node1 2091 21 25 (H.val "step"))
                                (H.node1
                                    2091
                                    29
                                    30
                                    (Elm.Syntax.Expression.Integer 0)
                                )
                            )
                        )
                    )
                )
                (H.node1 2092 9 11 (Elm.Syntax.Expression.ListExpr []))
                (H.node
                    2095
                    9
                    2106
                    19
                    (Elm.Syntax.Expression.LetExpression
                        { declarations =
                            [ H.node
                                2096
                                13
                                2104
                                51
                                (Elm.Syntax.Expression.LetFunction
                                    { documentation = Nothing
                                    , signature = Nothing
                                    , declaration =
                                        H.node
                                            2097
                                            13
                                            2104
                                            51
                                            { name = H.node1 2097 13 15 "go"
                                            , arguments =
                                                [ H.node1
                                                    2097
                                                    16
                                                    18
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "xs"
                                                    )
                                                , H.node1
                                                    2097
                                                    19
                                                    22
                                                    (Elm.Syntax.Pattern.VarPattern
                                                        "acc"
                                                    )
                                                ]
                                            , expression =
                                                H.node
                                                    2098
                                                    17
                                                    2104
                                                    51
                                                    (Elm.Syntax.Expression.IfBlock
                                                        (H.node1
                                                            2098
                                                            20
                                                            35
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    2098
                                                                    20
                                                                    32
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "isEmpty"
                                                                    )
                                                                , H.node1
                                                                    2098
                                                                    33
                                                                    35
                                                                    (H.val "xs")
                                                                ]
                                                            )
                                                        )
                                                        (H.node1
                                                            2099
                                                            21
                                                            37
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    2099
                                                                    21
                                                                    33
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , H.node1
                                                                    2099
                                                                    34
                                                                    37
                                                                    (H.val "acc"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                        (H.node
                                                            2102
                                                            21
                                                            2104
                                                            51
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    2102
                                                                    21
                                                                    23
                                                                    (H.val "go")
                                                                , H.node1
                                                                    2103
                                                                    25
                                                                    44
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            2103
                                                                            26
                                                                            43
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    2103
                                                                                    26
                                                                                    35
                                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                                        [ "List"
                                                                                        ]
                                                                                        "drop"
                                                                                    )
                                                                                , H.node1
                                                                                    2103
                                                                                    36
                                                                                    40
                                                                                    (H.val
                                                                                        "step"
                                                                                    )
                                                                                , H.node1
                                                                                    2103
                                                                                    41
                                                                                    43
                                                                                    (H.val
                                                                                        "xs"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                , H.node1
                                                                    2104
                                                                    25
                                                                    51
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            2104
                                                                            26
                                                                            50
                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                "::"
                                                                                Elm.Syntax.Infix.Right
                                                                                (H.node1
                                                                                    2104
                                                                                    26
                                                                                    43
                                                                                    (Elm.Syntax.Expression.Application
                                                                                        [ H.node1
                                                                                            2104
                                                                                            26
                                                                                            35
                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                [ "List"
                                                                                                ]
                                                                                                "take"
                                                                                            )
                                                                                        , H.node1
                                                                                            2104
                                                                                            36
                                                                                            40
                                                                                            (H.val
                                                                                                "size"
                                                                                            )
                                                                                        , H.node1
                                                                                            2104
                                                                                            41
                                                                                            43
                                                                                            (H.val
                                                                                                "xs"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    2104
                                                                                    47
                                                                                    50
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
                                                    )
                                            }
                                    }
                                )
                            ]
                        , expression =
                            H.node1
                                2106
                                9
                                19
                                (Elm.Syntax.Expression.Application
                                    [ H.node1 2106 9 11 (H.val "go")
                                    , H.node1 2106 12 16 (H.val "list")
                                    , H.node1
                                        2106
                                        17
                                        19
                                        (Elm.Syntax.Expression.ListExpr [])
                                    ]
                                )
                        }
                    )
                )
            )
    }


gatherEquals : Elm.Syntax.Expression.FunctionImplementation
gatherEquals =
    { name = H.node1 2119 1 13 "List.Extra.gatherEquals"
    , arguments = [ H.node1 2119 14 18 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node1
            2120
            5
            25
            (Elm.Syntax.Expression.Application
                [ H.node1 2120 5 15 (H.val "gatherWith")
                , H.node1 2120 16 20 (Elm.Syntax.Expression.PrefixOperator "==")
                , H.node1 2120 21 25 (H.val "list")
                ]
            )
    }


gatherEqualsBy : Elm.Syntax.Expression.FunctionImplementation
gatherEqualsBy =
    { name = H.node1 2133 1 15 "List.Extra.gatherEqualsBy"
    , arguments =
        [ H.node1 2133 16 23 (Elm.Syntax.Pattern.VarPattern "extract")
        , H.node1 2133 24 28 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node1
            2134
            5
            53
            (Elm.Syntax.Expression.Application
                [ H.node1 2134 5 15 (H.val "gatherWith")
                , H.node1
                    2134
                    16
                    48
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            2134
                            17
                            47
                            (Elm.Syntax.Expression.LambdaExpression
                                { args =
                                    [ H.node1
                                        2134
                                        18
                                        19
                                        (Elm.Syntax.Pattern.VarPattern "a")
                                    , H.node1
                                        2134
                                        20
                                        21
                                        (Elm.Syntax.Pattern.VarPattern "b")
                                    ]
                                , expression =
                                    H.node1
                                        2134
                                        25
                                        47
                                        (Elm.Syntax.Expression.OperatorApplication
                                            "=="
                                            Elm.Syntax.Infix.Non
                                            (H.node1
                                                2134
                                                25
                                                34
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        2134
                                                        25
                                                        32
                                                        (H.val "extract")
                                                    , H.node1
                                                        2134
                                                        33
                                                        34
                                                        (H.val "a")
                                                    ]
                                                )
                                            )
                                            (H.node1
                                                2134
                                                38
                                                47
                                                (Elm.Syntax.Expression.Application
                                                    [ H.node1
                                                        2134
                                                        38
                                                        45
                                                        (H.val "extract")
                                                    , H.node1
                                                        2134
                                                        46
                                                        47
                                                        (H.val "b")
                                                    ]
                                                )
                                            )
                                        )
                                }
                            )
                        )
                    )
                , H.node1 2134 49 53 (H.val "list")
                ]
            )
    }


gatherWith : Elm.Syntax.Expression.FunctionImplementation
gatherWith =
    { name = H.node1 2146 1 11 "List.Extra.gatherWith"
    , arguments =
        [ H.node1 2146 12 18 (Elm.Syntax.Pattern.VarPattern "testFn")
        , H.node1 2146 19 23 (Elm.Syntax.Pattern.VarPattern "list")
        ]
    , expression =
        H.node
            2147
            5
            2161
            19
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        2148
                        9
                        2159
                        75
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    2149
                                    9
                                    2159
                                    75
                                    { name = H.node1 2149 9 15 "helper"
                                    , arguments =
                                        [ H.node1
                                            2149
                                            16
                                            25
                                            (Elm.Syntax.Pattern.VarPattern
                                                "scattered"
                                            )
                                        , H.node1
                                            2149
                                            26
                                            34
                                            (Elm.Syntax.Pattern.VarPattern
                                                "gathered"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            2150
                                            13
                                            2159
                                            75
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        2150
                                                        18
                                                        27
                                                        (H.val "scattered")
                                                , cases =
                                                    [ ( H.node1
                                                            2151
                                                            17
                                                            19
                                                            (Elm.Syntax.Pattern.ListPattern
                                                                []
                                                            )
                                                      , H.node1
                                                            2152
                                                            21
                                                            42
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    2152
                                                                    21
                                                                    33
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "reverse"
                                                                    )
                                                                , H.node1
                                                                    2152
                                                                    34
                                                                    42
                                                                    (H.val
                                                                        "gathered"
                                                                    )
                                                                ]
                                                            )
                                                      )
                                                    , ( H.node1
                                                            2154
                                                            17
                                                            39
                                                            (Elm.Syntax.Pattern.UnConsPattern
                                                                (H.node1
                                                                    2154
                                                                    17
                                                                    25
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "toGather"
                                                                    )
                                                                )
                                                                (H.node1
                                                                    2154
                                                                    29
                                                                    39
                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                        "population"
                                                                    )
                                                                )
                                                            )
                                                      , H.node
                                                            2155
                                                            21
                                                            2159
                                                            75
                                                            (Elm.Syntax.Expression.LetExpression
                                                                { declarations =
                                                                    [ H.node
                                                                        2156
                                                                        25
                                                                        2157
                                                                        72
                                                                        (Elm.Syntax.Expression.LetDestructuring
                                                                            (H.node1
                                                                                2156
                                                                                25
                                                                                49
                                                                                (Elm.Syntax.Pattern.TuplePattern
                                                                                    [ H.node1
                                                                                        2156
                                                                                        27
                                                                                        36
                                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                                            "gathering"
                                                                                        )
                                                                                    , H.node1
                                                                                        2156
                                                                                        38
                                                                                        47
                                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                                            "remaining"
                                                                                        )
                                                                                    ]
                                                                                )
                                                                            )
                                                                            (H.node1
                                                                                2157
                                                                                29
                                                                                72
                                                                                (Elm.Syntax.Expression.Application
                                                                                    [ H.node1
                                                                                        2157
                                                                                        29
                                                                                        43
                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                            [ "List"
                                                                                            ]
                                                                                            "partition"
                                                                                        )
                                                                                    , H.node1
                                                                                        2157
                                                                                        44
                                                                                        61
                                                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                            (H.node1
                                                                                                2157
                                                                                                45
                                                                                                60
                                                                                                (Elm.Syntax.Expression.Application
                                                                                                    [ H.node1
                                                                                                        2157
                                                                                                        45
                                                                                                        51
                                                                                                        (H.val
                                                                                                            "testFn"
                                                                                                        )
                                                                                                    , H.node1
                                                                                                        2157
                                                                                                        52
                                                                                                        60
                                                                                                        (H.val
                                                                                                            "toGather"
                                                                                                        )
                                                                                                    ]
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                    , H.node1
                                                                                        2157
                                                                                        62
                                                                                        72
                                                                                        (H.val
                                                                                            "population"
                                                                                        )
                                                                                    ]
                                                                                )
                                                                            )
                                                                        )
                                                                    ]
                                                                , expression =
                                                                    H.node1
                                                                        2159
                                                                        21
                                                                        75
                                                                        (Elm.Syntax.Expression.Application
                                                                            [ H.node1
                                                                                2159
                                                                                21
                                                                                27
                                                                                (H.val
                                                                                    "helper"
                                                                                )
                                                                            , H.node1
                                                                                2159
                                                                                28
                                                                                37
                                                                                (H.val
                                                                                    "remaining"
                                                                                )
                                                                            , H.node1
                                                                                2159
                                                                                38
                                                                                75
                                                                                (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                    (H.node1
                                                                                        2159
                                                                                        39
                                                                                        74
                                                                                        (Elm.Syntax.Expression.OperatorApplication
                                                                                            "::"
                                                                                            Elm.Syntax.Infix.Right
                                                                                            (H.node1
                                                                                                2159
                                                                                                39
                                                                                                62
                                                                                                (Elm.Syntax.Expression.TupledExpression
                                                                                                    [ H.node1
                                                                                                        2159
                                                                                                        41
                                                                                                        49
                                                                                                        (H.val
                                                                                                            "toGather"
                                                                                                        )
                                                                                                    , H.node1
                                                                                                        2159
                                                                                                        51
                                                                                                        60
                                                                                                        (H.val
                                                                                                            "gathering"
                                                                                                        )
                                                                                                    ]
                                                                                                )
                                                                                            )
                                                                                            (H.node1
                                                                                                2159
                                                                                                66
                                                                                                74
                                                                                                (H.val
                                                                                                    "gathered"
                                                                                                )
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
                    ]
                , expression =
                    H.node1
                        2161
                        5
                        19
                        (Elm.Syntax.Expression.Application
                            [ H.node1 2161 5 11 (H.val "helper")
                            , H.node1 2161 12 16 (H.val "list")
                            , H.node1
                                2161
                                17
                                19
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }


frequencies : Elm.Syntax.Expression.FunctionImplementation
frequencies =
    { name = H.node1 2173 1 12 "List.Extra.frequencies"
    , arguments = [ H.node1 2173 13 17 (Elm.Syntax.Pattern.VarPattern "list") ]
    , expression =
        H.node
            2174
            5
            2177
            60
            (Elm.Syntax.Expression.OperatorApplication
                "|>"
                Elm.Syntax.Infix.Left
                (H.node
                    2174
                    5
                    2176
                    17
                    (Elm.Syntax.Expression.OperatorApplication
                        "|>"
                        Elm.Syntax.Infix.Left
                        (H.node
                            2174
                            5
                            2175
                            21
                            (Elm.Syntax.Expression.OperatorApplication
                                "|>"
                                Elm.Syntax.Infix.Left
                                (H.node1 2174 5 9 (H.val "list"))
                                (H.node1
                                    2175
                                    12
                                    21
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "List" ]
                                        "sort"
                                    )
                                )
                            )
                        )
                        (H.node1 2176 12 17 (H.val "group"))
                    )
                )
                (H.node1
                    2177
                    12
                    60
                    (Elm.Syntax.Expression.Application
                        [ H.node1
                            2177
                            12
                            20
                            (Elm.Syntax.Expression.FunctionOrValue
                                [ "List" ]
                                "map"
                            )
                        , H.node1
                            2177
                            21
                            60
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    2177
                                    22
                                    59
                                    (Elm.Syntax.Expression.LambdaExpression
                                        { args =
                                            [ H.node1
                                                2177
                                                23
                                                31
                                                (Elm.Syntax.Pattern.TuplePattern
                                                    [ H.node1
                                                        2177
                                                        25
                                                        26
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "x"
                                                        )
                                                    , H.node1
                                                        2177
                                                        28
                                                        29
                                                        (Elm.Syntax.Pattern.VarPattern
                                                            "y"
                                                        )
                                                    ]
                                                )
                                            ]
                                        , expression =
                                            H.node1
                                                2177
                                                35
                                                59
                                                (Elm.Syntax.Expression.TupledExpression
                                                    [ H.node1
                                                        2177
                                                        37
                                                        38
                                                        (H.val "x")
                                                    , H.node1
                                                        2177
                                                        40
                                                        57
                                                        (Elm.Syntax.Expression.OperatorApplication
                                                            "+"
                                                            Elm.Syntax.Infix.Left
                                                            (H.node1
                                                                2177
                                                                40
                                                                41
                                                                (Elm.Syntax.Expression.Integer
                                                                    1
                                                                )
                                                            )
                                                            (H.node1
                                                                2177
                                                                44
                                                                57
                                                                (Elm.Syntax.Expression.Application
                                                                    [ H.node1
                                                                        2177
                                                                        44
                                                                        55
                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                            [ "List"
                                                                            ]
                                                                            "length"
                                                                        )
                                                                    , H.node1
                                                                        2177
                                                                        56
                                                                        57
                                                                        (H.val
                                                                            "y"
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
                            )
                        ]
                    )
                )
            )
    }


joinOn : Elm.Syntax.Expression.FunctionImplementation
joinOn =
    { name = H.node1 2216 1 7 "List.Extra.joinOn"
    , arguments =
        [ H.node1 2216 8 16 (Elm.Syntax.Pattern.VarPattern "selectFn")
        , H.node1 2216 17 23 (Elm.Syntax.Pattern.VarPattern "aKeyFn")
        , H.node1 2216 24 30 (Elm.Syntax.Pattern.VarPattern "bKeyFn")
        , H.node1 2216 31 36 (Elm.Syntax.Pattern.VarPattern "aList")
        , H.node1 2216 37 42 (Elm.Syntax.Pattern.VarPattern "bList")
        ]
    , expression =
        H.node
            2217
            5
            2258
            42
            (Elm.Syntax.Expression.LetExpression
                { declarations =
                    [ H.node
                        2218
                        9
                        2222
                        46
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    2219
                                    9
                                    2222
                                    46
                                    { name = H.node1 2219 9 22 "aListWithKeys"
                                    , arguments = []
                                    , expression =
                                        H.node
                                            2220
                                            13
                                            2222
                                            46
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "|>"
                                                Elm.Syntax.Infix.Left
                                                (H.node
                                                    2220
                                                    13
                                                    2221
                                                    43
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "|>"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            2220
                                                            13
                                                            51
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    2220
                                                                    13
                                                                    21
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "map"
                                                                    )
                                                                , H.node1
                                                                    2220
                                                                    22
                                                                    45
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            2220
                                                                            23
                                                                            44
                                                                            (Elm.Syntax.Expression.LambdaExpression
                                                                                { args =
                                                                                    [ H.node1
                                                                                        2220
                                                                                        24
                                                                                        25
                                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                                            "a"
                                                                                        )
                                                                                    ]
                                                                                , expression =
                                                                                    H.node1
                                                                                        2220
                                                                                        29
                                                                                        44
                                                                                        (Elm.Syntax.Expression.TupledExpression
                                                                                            [ H.node1
                                                                                                2220
                                                                                                31
                                                                                                39
                                                                                                (Elm.Syntax.Expression.Application
                                                                                                    [ H.node1
                                                                                                        2220
                                                                                                        31
                                                                                                        37
                                                                                                        (H.val
                                                                                                            "aKeyFn"
                                                                                                        )
                                                                                                    , H.node1
                                                                                                        2220
                                                                                                        38
                                                                                                        39
                                                                                                        (H.val
                                                                                                            "a"
                                                                                                        )
                                                                                                    ]
                                                                                                )
                                                                                            , H.node1
                                                                                                2220
                                                                                                41
                                                                                                42
                                                                                                (H.val
                                                                                                    "a"
                                                                                                )
                                                                                            ]
                                                                                        )
                                                                                }
                                                                            )
                                                                        )
                                                                    )
                                                                , H.node1
                                                                    2220
                                                                    46
                                                                    51
                                                                    (H.val
                                                                        "aList"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                        (H.node1
                                                            2221
                                                            20
                                                            43
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    2221
                                                                    20
                                                                    31
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "sortBy"
                                                                    )
                                                                , H.node1
                                                                    2221
                                                                    32
                                                                    43
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "Tuple"
                                                                        ]
                                                                        "first"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                )
                                                (H.node1
                                                    2222
                                                    20
                                                    46
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            2222
                                                            20
                                                            34
                                                            (H.val
                                                                "gatherEqualsBy"
                                                            )
                                                        , H.node1
                                                            2222
                                                            35
                                                            46
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Tuple" ]
                                                                "first"
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    , H.node
                        2224
                        9
                        2228
                        46
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    2225
                                    9
                                    2228
                                    46
                                    { name = H.node1 2225 9 22 "bListWithKeys"
                                    , arguments = []
                                    , expression =
                                        H.node
                                            2226
                                            13
                                            2228
                                            46
                                            (Elm.Syntax.Expression.OperatorApplication
                                                "|>"
                                                Elm.Syntax.Infix.Left
                                                (H.node
                                                    2226
                                                    13
                                                    2227
                                                    43
                                                    (Elm.Syntax.Expression.OperatorApplication
                                                        "|>"
                                                        Elm.Syntax.Infix.Left
                                                        (H.node1
                                                            2226
                                                            13
                                                            51
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    2226
                                                                    13
                                                                    21
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "map"
                                                                    )
                                                                , H.node1
                                                                    2226
                                                                    22
                                                                    45
                                                                    (Elm.Syntax.Expression.ParenthesizedExpression
                                                                        (H.node1
                                                                            2226
                                                                            23
                                                                            44
                                                                            (Elm.Syntax.Expression.LambdaExpression
                                                                                { args =
                                                                                    [ H.node1
                                                                                        2226
                                                                                        24
                                                                                        25
                                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                                            "b"
                                                                                        )
                                                                                    ]
                                                                                , expression =
                                                                                    H.node1
                                                                                        2226
                                                                                        29
                                                                                        44
                                                                                        (Elm.Syntax.Expression.TupledExpression
                                                                                            [ H.node1
                                                                                                2226
                                                                                                31
                                                                                                39
                                                                                                (Elm.Syntax.Expression.Application
                                                                                                    [ H.node1
                                                                                                        2226
                                                                                                        31
                                                                                                        37
                                                                                                        (H.val
                                                                                                            "bKeyFn"
                                                                                                        )
                                                                                                    , H.node1
                                                                                                        2226
                                                                                                        38
                                                                                                        39
                                                                                                        (H.val
                                                                                                            "b"
                                                                                                        )
                                                                                                    ]
                                                                                                )
                                                                                            , H.node1
                                                                                                2226
                                                                                                41
                                                                                                42
                                                                                                (H.val
                                                                                                    "b"
                                                                                                )
                                                                                            ]
                                                                                        )
                                                                                }
                                                                            )
                                                                        )
                                                                    )
                                                                , H.node1
                                                                    2226
                                                                    46
                                                                    51
                                                                    (H.val
                                                                        "bList"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                        (H.node1
                                                            2227
                                                            20
                                                            43
                                                            (Elm.Syntax.Expression.Application
                                                                [ H.node1
                                                                    2227
                                                                    20
                                                                    31
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "List"
                                                                        ]
                                                                        "sortBy"
                                                                    )
                                                                , H.node1
                                                                    2227
                                                                    32
                                                                    43
                                                                    (Elm.Syntax.Expression.FunctionOrValue
                                                                        [ "Tuple"
                                                                        ]
                                                                        "first"
                                                                    )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                )
                                                (H.node1
                                                    2228
                                                    20
                                                    46
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            2228
                                                            20
                                                            34
                                                            (H.val
                                                                "gatherEqualsBy"
                                                            )
                                                        , H.node1
                                                            2228
                                                            35
                                                            46
                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                [ "Tuple" ]
                                                                "first"
                                                            )
                                                        ]
                                                    )
                                                )
                                            )
                                    }
                            }
                        )
                    , H.node
                        2230
                        9
                        2256
                        27
                        (Elm.Syntax.Expression.LetFunction
                            { documentation = Nothing
                            , signature = Nothing
                            , declaration =
                                H.node
                                    2231
                                    9
                                    2256
                                    27
                                    { name = H.node1 2231 9 15 "helper"
                                    , arguments =
                                        [ H.node1
                                            2231
                                            16
                                            20
                                            (Elm.Syntax.Pattern.VarPattern
                                                "aInp"
                                            )
                                        , H.node1
                                            2231
                                            21
                                            25
                                            (Elm.Syntax.Pattern.VarPattern
                                                "bInp"
                                            )
                                        , H.node1
                                            2231
                                            26
                                            32
                                            (Elm.Syntax.Pattern.VarPattern
                                                "result"
                                            )
                                        ]
                                    , expression =
                                        H.node
                                            2232
                                            13
                                            2256
                                            27
                                            (Elm.Syntax.Expression.CaseExpression
                                                { expression =
                                                    H.node1
                                                        2232
                                                        18
                                                        32
                                                        (Elm.Syntax.Expression.TupledExpression
                                                            [ H.node1
                                                                2232
                                                                20
                                                                24
                                                                (H.val "aInp")
                                                            , H.node1
                                                                2232
                                                                26
                                                                30
                                                                (H.val "bInp")
                                                            ]
                                                        )
                                                , cases =
                                                    [ ( H.node1
                                                            2233
                                                            17
                                                            83
                                                            (Elm.Syntax.Pattern.TuplePattern
                                                                [ H.node1
                                                                    2233
                                                                    19
                                                                    49
                                                                    (Elm.Syntax.Pattern.UnConsPattern
                                                                        (H.node1
                                                                            2233
                                                                            19
                                                                            39
                                                                            (Elm.Syntax.Pattern.TuplePattern
                                                                                [ H.node1
                                                                                    2233
                                                                                    21
                                                                                    32
                                                                                    (Elm.Syntax.Pattern.TuplePattern
                                                                                        [ H.node1
                                                                                            2233
                                                                                            23
                                                                                            27
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "aKey"
                                                                                            )
                                                                                        , H.node1
                                                                                            2233
                                                                                            29
                                                                                            30
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "a"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                                , H.node1
                                                                                    2233
                                                                                    34
                                                                                    37
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "ass"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            2233
                                                                            43
                                                                            49
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "restAs"
                                                                            )
                                                                        )
                                                                    )
                                                                , H.node1
                                                                    2233
                                                                    51
                                                                    81
                                                                    (Elm.Syntax.Pattern.UnConsPattern
                                                                        (H.node1
                                                                            2233
                                                                            51
                                                                            71
                                                                            (Elm.Syntax.Pattern.TuplePattern
                                                                                [ H.node1
                                                                                    2233
                                                                                    53
                                                                                    64
                                                                                    (Elm.Syntax.Pattern.TuplePattern
                                                                                        [ H.node1
                                                                                            2233
                                                                                            55
                                                                                            59
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "bKey"
                                                                                            )
                                                                                        , H.node1
                                                                                            2233
                                                                                            61
                                                                                            62
                                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                                "b"
                                                                                            )
                                                                                        ]
                                                                                    )
                                                                                , H.node1
                                                                                    2233
                                                                                    66
                                                                                    69
                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                        "bss"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            2233
                                                                            75
                                                                            81
                                                                            (Elm.Syntax.Pattern.VarPattern
                                                                                "restBs"
                                                                            )
                                                                        )
                                                                    )
                                                                ]
                                                            )
                                                      , H.node
                                                            2234
                                                            21
                                                            2253
                                                            50
                                                            (Elm.Syntax.Expression.IfBlock
                                                                (H.node1
                                                                    2234
                                                                    24
                                                                    36
                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                        "=="
                                                                        Elm.Syntax.Infix.Non
                                                                        (H.node1
                                                                            2234
                                                                            24
                                                                            28
                                                                            (H.val
                                                                                "aKey"
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            2234
                                                                            32
                                                                            36
                                                                            (H.val
                                                                                "bKey"
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                                (H.node
                                                                    2235
                                                                    25
                                                                    2247
                                                                    62
                                                                    (Elm.Syntax.Expression.LetExpression
                                                                        { declarations =
                                                                            [ H.node
                                                                                2236
                                                                                29
                                                                                2245
                                                                                57
                                                                                (Elm.Syntax.Expression.LetFunction
                                                                                    { documentation =
                                                                                        Nothing
                                                                                    , signature =
                                                                                        Nothing
                                                                                    , declaration =
                                                                                        H.node
                                                                                            2236
                                                                                            29
                                                                                            2245
                                                                                            57
                                                                                            { name =
                                                                                                H.node1
                                                                                                    2236
                                                                                                    29
                                                                                                    33
                                                                                                    "prod"
                                                                                            , arguments =
                                                                                                []
                                                                                            , expression =
                                                                                                H.node
                                                                                                    2237
                                                                                                    33
                                                                                                    2245
                                                                                                    57
                                                                                                    (Elm.Syntax.Expression.Application
                                                                                                        [ H.node1
                                                                                                            2237
                                                                                                            33
                                                                                                            47
                                                                                                            (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                [ "List"
                                                                                                                ]
                                                                                                                "concatMap"
                                                                                                            )
                                                                                                        , H.node
                                                                                                            2238
                                                                                                            37
                                                                                                            2244
                                                                                                            38
                                                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                (H.node
                                                                                                                    2238
                                                                                                                    38
                                                                                                                    2243
                                                                                                                    65
                                                                                                                    (Elm.Syntax.Expression.LambdaExpression
                                                                                                                        { args =
                                                                                                                            [ H.node1
                                                                                                                                2238
                                                                                                                                39
                                                                                                                                48
                                                                                                                                (Elm.Syntax.Pattern.TuplePattern
                                                                                                                                    [ H.node1
                                                                                                                                        2238
                                                                                                                                        41
                                                                                                                                        42
                                                                                                                                        Elm.Syntax.Pattern.AllPattern
                                                                                                                                    , H.node1
                                                                                                                                        2238
                                                                                                                                        44
                                                                                                                                        46
                                                                                                                                        (Elm.Syntax.Pattern.VarPattern
                                                                                                                                            "sA"
                                                                                                                                        )
                                                                                                                                    ]
                                                                                                                                )
                                                                                                                            ]
                                                                                                                        , expression =
                                                                                                                            H.node
                                                                                                                                2239
                                                                                                                                41
                                                                                                                                2243
                                                                                                                                65
                                                                                                                                (Elm.Syntax.Expression.Application
                                                                                                                                    [ H.node1
                                                                                                                                        2239
                                                                                                                                        41
                                                                                                                                        49
                                                                                                                                        (Elm.Syntax.Expression.FunctionOrValue
                                                                                                                                            [ "List"
                                                                                                                                            ]
                                                                                                                                            "map"
                                                                                                                                        )
                                                                                                                                    , H.node
                                                                                                                                        2240
                                                                                                                                        45
                                                                                                                                        2242
                                                                                                                                        46
                                                                                                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                                            (H.node
                                                                                                                                                2240
                                                                                                                                                46
                                                                                                                                                2241
                                                                                                                                                63
                                                                                                                                                (Elm.Syntax.Expression.LambdaExpression
                                                                                                                                                    { args =
                                                                                                                                                        [ H.node1
                                                                                                                                                            2240
                                                                                                                                                            47
                                                                                                                                                            56
                                                                                                                                                            (Elm.Syntax.Pattern.TuplePattern
                                                                                                                                                                [ H.node1
                                                                                                                                                                    2240
                                                                                                                                                                    49
                                                                                                                                                                    50
                                                                                                                                                                    Elm.Syntax.Pattern.AllPattern
                                                                                                                                                                , H.node1
                                                                                                                                                                    2240
                                                                                                                                                                    52
                                                                                                                                                                    54
                                                                                                                                                                    (Elm.Syntax.Pattern.VarPattern
                                                                                                                                                                        "sB"
                                                                                                                                                                    )
                                                                                                                                                                ]
                                                                                                                                                            )
                                                                                                                                                        ]
                                                                                                                                                    , expression =
                                                                                                                                                        H.node1
                                                                                                                                                            2241
                                                                                                                                                            49
                                                                                                                                                            63
                                                                                                                                                            (Elm.Syntax.Expression.Application
                                                                                                                                                                [ H.node1
                                                                                                                                                                    2241
                                                                                                                                                                    49
                                                                                                                                                                    57
                                                                                                                                                                    (H.val
                                                                                                                                                                        "selectFn"
                                                                                                                                                                    )
                                                                                                                                                                , H.node1
                                                                                                                                                                    2241
                                                                                                                                                                    58
                                                                                                                                                                    60
                                                                                                                                                                    (H.val
                                                                                                                                                                        "sA"
                                                                                                                                                                    )
                                                                                                                                                                , H.node1
                                                                                                                                                                    2241
                                                                                                                                                                    61
                                                                                                                                                                    63
                                                                                                                                                                    (H.val
                                                                                                                                                                        "sB"
                                                                                                                                                                    )
                                                                                                                                                                ]
                                                                                                                                                            )
                                                                                                                                                    }
                                                                                                                                                )
                                                                                                                                            )
                                                                                                                                        )
                                                                                                                                    , H.node1
                                                                                                                                        2243
                                                                                                                                        45
                                                                                                                                        65
                                                                                                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                                            (H.node1
                                                                                                                                                2243
                                                                                                                                                46
                                                                                                                                                64
                                                                                                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                                                                                                    "::"
                                                                                                                                                    Elm.Syntax.Infix.Right
                                                                                                                                                    (H.node1
                                                                                                                                                        2243
                                                                                                                                                        46
                                                                                                                                                        57
                                                                                                                                                        (Elm.Syntax.Expression.TupledExpression
                                                                                                                                                            [ H.node1
                                                                                                                                                                2243
                                                                                                                                                                48
                                                                                                                                                                52
                                                                                                                                                                (H.val
                                                                                                                                                                    "bKey"
                                                                                                                                                                )
                                                                                                                                                            , H.node1
                                                                                                                                                                2243
                                                                                                                                                                54
                                                                                                                                                                55
                                                                                                                                                                (H.val
                                                                                                                                                                    "b"
                                                                                                                                                                )
                                                                                                                                                            ]
                                                                                                                                                        )
                                                                                                                                                    )
                                                                                                                                                    (H.node1
                                                                                                                                                        2243
                                                                                                                                                        61
                                                                                                                                                        64
                                                                                                                                                        (H.val
                                                                                                                                                            "bss"
                                                                                                                                                        )
                                                                                                                                                    )
                                                                                                                                                )
                                                                                                                                            )
                                                                                                                                        )
                                                                                                                                    ]
                                                                                                                                )
                                                                                                                        }
                                                                                                                    )
                                                                                                                )
                                                                                                            )
                                                                                                        , H.node1
                                                                                                            2245
                                                                                                            37
                                                                                                            57
                                                                                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                                                (H.node1
                                                                                                                    2245
                                                                                                                    38
                                                                                                                    56
                                                                                                                    (Elm.Syntax.Expression.OperatorApplication
                                                                                                                        "::"
                                                                                                                        Elm.Syntax.Infix.Right
                                                                                                                        (H.node1
                                                                                                                            2245
                                                                                                                            38
                                                                                                                            49
                                                                                                                            (Elm.Syntax.Expression.TupledExpression
                                                                                                                                [ H.node1
                                                                                                                                    2245
                                                                                                                                    40
                                                                                                                                    44
                                                                                                                                    (H.val
                                                                                                                                        "aKey"
                                                                                                                                    )
                                                                                                                                , H.node1
                                                                                                                                    2245
                                                                                                                                    46
                                                                                                                                    47
                                                                                                                                    (H.val
                                                                                                                                        "a"
                                                                                                                                    )
                                                                                                                                ]
                                                                                                                            )
                                                                                                                        )
                                                                                                                        (H.node1
                                                                                                                            2245
                                                                                                                            53
                                                                                                                            56
                                                                                                                            (H.val
                                                                                                                                "ass"
                                                                                                                            )
                                                                                                                        )
                                                                                                                    )
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
                                                                                2247
                                                                                25
                                                                                62
                                                                                (Elm.Syntax.Expression.Application
                                                                                    [ H.node1
                                                                                        2247
                                                                                        25
                                                                                        31
                                                                                        (H.val
                                                                                            "helper"
                                                                                        )
                                                                                    , H.node1
                                                                                        2247
                                                                                        32
                                                                                        38
                                                                                        (H.val
                                                                                            "restAs"
                                                                                        )
                                                                                    , H.node1
                                                                                        2247
                                                                                        39
                                                                                        45
                                                                                        (H.val
                                                                                            "restBs"
                                                                                        )
                                                                                    , H.node1
                                                                                        2247
                                                                                        46
                                                                                        62
                                                                                        (Elm.Syntax.Expression.ParenthesizedExpression
                                                                                            (H.node1
                                                                                                2247
                                                                                                47
                                                                                                61
                                                                                                (Elm.Syntax.Expression.OperatorApplication
                                                                                                    "++"
                                                                                                    Elm.Syntax.Infix.Right
                                                                                                    (H.node1
                                                                                                        2247
                                                                                                        47
                                                                                                        51
                                                                                                        (H.val
                                                                                                            "prod"
                                                                                                        )
                                                                                                    )
                                                                                                    (H.node1
                                                                                                        2247
                                                                                                        55
                                                                                                        61
                                                                                                        (H.val
                                                                                                            "result"
                                                                                                        )
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                        )
                                                                                    ]
                                                                                )
                                                                        }
                                                                    )
                                                                )
                                                                (H.node
                                                                    2249
                                                                    26
                                                                    2253
                                                                    50
                                                                    (Elm.Syntax.Expression.IfBlock
                                                                        (H.node1
                                                                            2249
                                                                            29
                                                                            40
                                                                            (Elm.Syntax.Expression.OperatorApplication
                                                                                "<"
                                                                                Elm.Syntax.Infix.Non
                                                                                (H.node1
                                                                                    2249
                                                                                    29
                                                                                    33
                                                                                    (H.val
                                                                                        "aKey"
                                                                                    )
                                                                                )
                                                                                (H.node1
                                                                                    2249
                                                                                    36
                                                                                    40
                                                                                    (H.val
                                                                                        "bKey"
                                                                                    )
                                                                                )
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            2250
                                                                            25
                                                                            50
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    2250
                                                                                    25
                                                                                    31
                                                                                    (H.val
                                                                                        "helper"
                                                                                    )
                                                                                , H.node1
                                                                                    2250
                                                                                    32
                                                                                    38
                                                                                    (H.val
                                                                                        "restAs"
                                                                                    )
                                                                                , H.node1
                                                                                    2250
                                                                                    39
                                                                                    43
                                                                                    (H.val
                                                                                        "bInp"
                                                                                    )
                                                                                , H.node1
                                                                                    2250
                                                                                    44
                                                                                    50
                                                                                    (H.val
                                                                                        "result"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                        (H.node1
                                                                            2253
                                                                            25
                                                                            50
                                                                            (Elm.Syntax.Expression.Application
                                                                                [ H.node1
                                                                                    2253
                                                                                    25
                                                                                    31
                                                                                    (H.val
                                                                                        "helper"
                                                                                    )
                                                                                , H.node1
                                                                                    2253
                                                                                    32
                                                                                    36
                                                                                    (H.val
                                                                                        "aInp"
                                                                                    )
                                                                                , H.node1
                                                                                    2253
                                                                                    37
                                                                                    43
                                                                                    (H.val
                                                                                        "restBs"
                                                                                    )
                                                                                , H.node1
                                                                                    2253
                                                                                    44
                                                                                    50
                                                                                    (H.val
                                                                                        "result"
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                      )
                                                    , ( H.node1
                                                            2255
                                                            17
                                                            18
                                                            Elm.Syntax.Pattern.AllPattern
                                                      , H.node1
                                                            2256
                                                            21
                                                            27
                                                            (H.val "result")
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
                        2258
                        5
                        42
                        (Elm.Syntax.Expression.Application
                            [ H.node1 2258 5 11 (H.val "helper")
                            , H.node1 2258 12 25 (H.val "aListWithKeys")
                            , H.node1 2258 26 39 (H.val "bListWithKeys")
                            , H.node1
                                2258
                                40
                                42
                                (Elm.Syntax.Expression.ListExpr [])
                            ]
                        )
                }
            )
    }