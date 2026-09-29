module Core.Basics exposing (abs, acos, add, always, and, apL, apR, append, asin, atan, atan2, ceiling, clamp, compare, composeL, composeR, cos, degrees, e, eq, fdiv, floor, fromPolar, functions, ge, gt, identity, idiv, isInfinite, isNaN, le, logBase, lt, max, min, modBy, mul, negate, neq, never, not, operators, or, pi, pow, radians, remainderBy, round, sin, sqrt, sub, tan, toFloat, toPolar, truncate, turns, xor)

{-| 
@docs functions, operators, add, sub, mul, fdiv, idiv, pow, toFloat, round, floor, ceiling, truncate, eq, neq, lt, gt, le, ge, min, max, compare, not, and, or, xor, append, modBy, remainderBy, negate, abs, clamp, sqrt, logBase, e, radians, degrees, turns, pi, cos, sin, tan, acos, asin, atan, atan2, fromPolar, toPolar, isNaN, isInfinite, composeL, composeR, apR, apL, identity, always, never
-}


import Elm.Syntax.Expression
import Elm.Syntax.Node
import Elm.Syntax.Pattern
import FastDict
import H


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "add", add )
        , ( "sub", sub )
        , ( "mul", mul )
        , ( "fdiv", fdiv )
        , ( "idiv", idiv )
        , ( "pow", pow )
        , ( "toFloat", toFloat )
        , ( "round", round )
        , ( "floor", floor )
        , ( "ceiling", ceiling )
        , ( "truncate", truncate )
        , ( "eq", eq )
        , ( "neq", neq )
        , ( "lt", lt )
        , ( "gt", gt )
        , ( "le", le )
        , ( "ge", ge )
        , ( "min", min )
        , ( "max", max )
        , ( "compare", compare )
        , ( "not", not )
        , ( "and", and )
        , ( "or", or )
        , ( "xor", xor )
        , ( "append", append )
        , ( "modBy", modBy )
        , ( "remainderBy", remainderBy )
        , ( "negate", negate )
        , ( "abs", abs )
        , ( "clamp", clamp )
        , ( "sqrt", sqrt )
        , ( "logBase", logBase )
        , ( "e", e )
        , ( "radians", radians )
        , ( "degrees", degrees )
        , ( "turns", turns )
        , ( "pi", pi )
        , ( "cos", cos )
        , ( "sin", sin )
        , ( "tan", tan )
        , ( "acos", acos )
        , ( "asin", asin )
        , ( "atan", atan )
        , ( "atan2", atan2 )
        , ( "fromPolar", fromPolar )
        , ( "toPolar", toPolar )
        , ( "isNaN", isNaN )
        , ( "isInfinite", isInfinite )
        , ( "composeL", composeL )
        , ( "composeR", composeR )
        , ( "apR", apR )
        , ( "apL", apL )
        , ( "identity", identity )
        , ( "always", always )
        , ( "never", never )
        ]


operators : List ( String, Elm.Syntax.Pattern.QualifiedNameRef )
operators =
    [ ( "<|", { moduleName = [ "Basics" ], name = "apL" } )
    , ( "|>", { moduleName = [ "Basics" ], name = "apR" } )
    , ( "||", { moduleName = [ "Basics" ], name = "or" } )
    , ( "&&", { moduleName = [ "Basics" ], name = "and" } )
    , ( "==", { moduleName = [ "Basics" ], name = "eq" } )
    , ( "/=", { moduleName = [ "Basics" ], name = "neq" } )
    , ( "<", { moduleName = [ "Basics" ], name = "lt" } )
    , ( ">", { moduleName = [ "Basics" ], name = "gt" } )
    , ( "<=", { moduleName = [ "Basics" ], name = "le" } )
    , ( ">=", { moduleName = [ "Basics" ], name = "ge" } )
    , ( "++", { moduleName = [ "Basics" ], name = "append" } )
    , ( "+", { moduleName = [ "Basics" ], name = "add" } )
    , ( "-", { moduleName = [ "Basics" ], name = "sub" } )
    , ( "*", { moduleName = [ "Basics" ], name = "mul" } )
    , ( "/", { moduleName = [ "Basics" ], name = "fdiv" } )
    , ( "//", { moduleName = [ "Basics" ], name = "idiv" } )
    , ( "^", { moduleName = [ "Basics" ], name = "pow" } )
    , ( "<<", { moduleName = [ "Basics" ], name = "composeL" } )
    , ( ">>", { moduleName = [ "Basics" ], name = "composeR" } )
    ]


add : Elm.Syntax.Expression.FunctionImplementation
add =
    { name = H.node1 169 1 4 "Basics.add"
    , arguments = []
    , expression =
        H.node1
            170
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "add"
            )
    }


sub : Elm.Syntax.Expression.FunctionImplementation
sub =
    { name = H.node1 178 1 4 "Basics.sub"
    , arguments = []
    , expression =
        H.node1
            179
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "sub"
            )
    }


mul : Elm.Syntax.Expression.FunctionImplementation
mul =
    { name = H.node1 187 1 4 "Basics.mul"
    , arguments = []
    , expression =
        H.node1
            188
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "mul"
            )
    }


fdiv : Elm.Syntax.Expression.FunctionImplementation
fdiv =
    { name = H.node1 204 1 5 "Basics.fdiv"
    , arguments = []
    , expression =
        H.node1
            205
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "fdiv"
            )
    }


idiv : Elm.Syntax.Expression.FunctionImplementation
idiv =
    { name = H.node1 226 1 5 "Basics.idiv"
    , arguments = []
    , expression =
        H.node1
            227
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "idiv"
            )
    }


pow : Elm.Syntax.Expression.FunctionImplementation
pow =
    { name = H.node1 236 1 4 "Basics.pow"
    , arguments = []
    , expression =
        H.node1
            237
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "pow"
            )
    }


toFloat : Elm.Syntax.Expression.FunctionImplementation
toFloat =
    { name = H.node1 253 1 8 "Basics.toFloat"
    , arguments = []
    , expression =
        H.node1
            254
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "toFloat"
            )
    }


round : Elm.Syntax.Expression.FunctionImplementation
round =
    { name = H.node1 269 1 6 "Basics.round"
    , arguments = []
    , expression =
        H.node1
            270
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "round"
            )
    }


floor : Elm.Syntax.Expression.FunctionImplementation
floor =
    { name = H.node1 285 1 6 "Basics.floor"
    , arguments = []
    , expression =
        H.node1
            286
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "floor"
            )
    }


ceiling : Elm.Syntax.Expression.FunctionImplementation
ceiling =
    { name = H.node1 301 1 8 "Basics.ceiling"
    , arguments = []
    , expression =
        H.node1
            302
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "ceiling"
            )
    }


truncate : Elm.Syntax.Expression.FunctionImplementation
truncate =
    { name = H.node1 317 1 9 "Basics.truncate"
    , arguments = []
    , expression =
        H.node1
            318
            3
            29
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "truncate"
            )
    }


eq : Elm.Syntax.Expression.FunctionImplementation
eq =
    { name = H.node1 349 1 3 "Basics.eq"
    , arguments = []
    , expression =
        H.node1
            350
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "equal"
            )
    }


neq : Elm.Syntax.Expression.FunctionImplementation
neq =
    { name = H.node1 358 1 4 "Basics.neq"
    , arguments = []
    , expression =
        H.node1
            359
            3
            28
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "notEqual"
            )
    }


lt : Elm.Syntax.Expression.FunctionImplementation
lt =
    { name = H.node1 368 1 3 "Basics.lt"
    , arguments = []
    , expression =
        H.node1
            369
            3
            22
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "lt"
            )
    }


gt : Elm.Syntax.Expression.FunctionImplementation
gt =
    { name = H.node1 374 1 3 "Basics.gt"
    , arguments = []
    , expression =
        H.node1
            375
            3
            22
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "gt"
            )
    }


le : Elm.Syntax.Expression.FunctionImplementation
le =
    { name = H.node1 380 1 3 "Basics.le"
    , arguments = []
    , expression =
        H.node1
            381
            3
            22
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "le"
            )
    }


ge : Elm.Syntax.Expression.FunctionImplementation
ge =
    { name = H.node1 386 1 3 "Basics.ge"
    , arguments = []
    , expression =
        H.node1
            387
            3
            22
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "ge"
            )
    }


min : Elm.Syntax.Expression.FunctionImplementation
min =
    { name = H.node1 396 1 4 "Basics.min"
    , arguments =
        [ H.node1 396 5 6 (Elm.Syntax.Pattern.VarPattern "x")
        , H.node1 396 7 8 (Elm.Syntax.Pattern.VarPattern "y")
        ]
    , expression =
        H.node1
            397
            3
            26
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    397
                    6
                    12
                    (Elm.Syntax.Expression.Application
                        [ H.node1 397 6 8 (H.val "lt")
                        , H.node1 397 9 10 (H.val "x")
                        , H.node1 397 11 12 (H.val "y")
                        ]
                    )
                )
                (H.node1 397 18 19 (H.val "x"))
                (H.node1 397 25 26 (H.val "y"))
            )
    }


max : Elm.Syntax.Expression.FunctionImplementation
max =
    { name = H.node1 406 1 4 "Basics.max"
    , arguments =
        [ H.node1 406 5 6 (Elm.Syntax.Pattern.VarPattern "x")
        , H.node1 406 7 8 (Elm.Syntax.Pattern.VarPattern "y")
        ]
    , expression =
        H.node1
            407
            3
            26
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    407
                    6
                    12
                    (Elm.Syntax.Expression.Application
                        [ H.node1 407 6 8 (H.val "gt")
                        , H.node1 407 9 10 (H.val "x")
                        , H.node1 407 11 12 (H.val "y")
                        ]
                    )
                )
                (H.node1 407 18 19 (H.val "x"))
                (H.node1 407 25 26 (H.val "y"))
            )
    }


compare : Elm.Syntax.Expression.FunctionImplementation
compare =
    { name = H.node1 419 1 8 "Basics.compare"
    , arguments = []
    , expression =
        H.node1
            420
            3
            27
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "compare"
            )
    }


not : Elm.Syntax.Expression.FunctionImplementation
not =
    { name = H.node1 453 1 4 "Basics.not"
    , arguments = []
    , expression =
        H.node1
            454
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "not"
            )
    }


and : Elm.Syntax.Expression.FunctionImplementation
and =
    { name = H.node1 469 1 4 "Basics.and"
    , arguments = []
    , expression =
        H.node1
            470
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "and"
            )
    }


or : Elm.Syntax.Expression.FunctionImplementation
or =
    { name = H.node1 485 1 3 "Basics.or"
    , arguments = []
    , expression =
        H.node1
            486
            3
            23
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "or"
            )
    }


xor : Elm.Syntax.Expression.FunctionImplementation
xor =
    { name = H.node1 497 1 4 "Basics.xor"
    , arguments = []
    , expression =
        H.node1
            498
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "xor"
            )
    }


append : Elm.Syntax.Expression.FunctionImplementation
append =
    { name = H.node1 511 1 7 "Basics.append"
    , arguments = []
    , expression =
        H.node1
            512
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Utils" ]
                "append"
            )
    }


modBy : Elm.Syntax.Expression.FunctionImplementation
modBy =
    { name = H.node1 540 1 6 "Basics.modBy"
    , arguments = []
    , expression =
        H.node1
            541
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "modBy"
            )
    }


remainderBy : Elm.Syntax.Expression.FunctionImplementation
remainderBy =
    { name = H.node1 556 1 12 "Basics.remainderBy"
    , arguments = []
    , expression =
        H.node1
            557
            3
            32
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "remainderBy"
            )
    }


negate : Elm.Syntax.Expression.FunctionImplementation
negate =
    { name = H.node1 567 1 7 "Basics.negate"
    , arguments = [ H.node1 567 8 9 (Elm.Syntax.Pattern.VarPattern "n") ]
    , expression =
        H.node1
            568
            3
            5
            (Elm.Syntax.Expression.Negation (H.node1 568 4 5 (H.val "n")))
    }


abs : Elm.Syntax.Expression.FunctionImplementation
abs =
    { name = H.node1 581 1 4 "Basics.abs"
    , arguments = [ H.node1 581 5 6 (Elm.Syntax.Pattern.VarPattern "n") ]
    , expression =
        H.node1
            582
            3
            27
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    582
                    6
                    12
                    (Elm.Syntax.Expression.Application
                        [ H.node1 582 6 8 (H.val "lt")
                        , H.node1 582 9 10 (H.val "n")
                        , H.node1 582 11 12 (Elm.Syntax.Expression.Integer 0)
                        ]
                    )
                )
                (H.node1
                    582
                    18
                    20
                    (Elm.Syntax.Expression.Negation
                        (H.node1 582 19 20 (H.val "n"))
                    )
                )
                (H.node1 582 26 27 (H.val "n"))
            )
    }


clamp : Elm.Syntax.Expression.FunctionImplementation
clamp =
    { name = H.node1 593 1 6 "Basics.clamp"
    , arguments =
        [ H.node1 593 7 10 (Elm.Syntax.Pattern.VarPattern "low")
        , H.node1 593 11 15 (Elm.Syntax.Pattern.VarPattern "high")
        , H.node1 593 16 22 (Elm.Syntax.Pattern.VarPattern "number")
        ]
    , expression =
        H.node
            594
            3
            599
            11
            (Elm.Syntax.Expression.IfBlock
                (H.node1
                    594
                    6
                    19
                    (Elm.Syntax.Expression.Application
                        [ H.node1 594 6 8 (H.val "lt")
                        , H.node1 594 9 15 (H.val "number")
                        , H.node1 594 16 19 (H.val "low")
                        ]
                    )
                )
                (H.node1 595 5 8 (H.val "low"))
                (H.node
                    596
                    8
                    599
                    11
                    (Elm.Syntax.Expression.IfBlock
                        (H.node1
                            596
                            11
                            25
                            (Elm.Syntax.Expression.Application
                                [ H.node1 596 11 13 (H.val "gt")
                                , H.node1 596 14 20 (H.val "number")
                                , H.node1 596 21 25 (H.val "high")
                                ]
                            )
                        )
                        (H.node1 597 5 9 (H.val "high"))
                        (H.node1 599 5 11 (H.val "number"))
                    )
                )
            )
    }


sqrt : Elm.Syntax.Expression.FunctionImplementation
sqrt =
    { name = H.node1 610 1 5 "Basics.sqrt"
    , arguments = []
    , expression =
        H.node1
            611
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "sqrt"
            )
    }


logBase : Elm.Syntax.Expression.FunctionImplementation
logBase =
    { name = H.node1 620 1 8 "Basics.logBase"
    , arguments =
        [ H.node1 620 9 13 (Elm.Syntax.Pattern.VarPattern "base")
        , H.node1 620 14 20 (Elm.Syntax.Pattern.VarPattern "number")
        ]
    , expression =
        H.node
            621
            3
            623
            33
            (Elm.Syntax.Expression.Application
                [ H.node1 621 3 7 (H.val "fdiv")
                , H.node1
                    622
                    5
                    35
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            622
                            6
                            34
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    622
                                    6
                                    27
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Elm", "Kernel", "Basics" ]
                                        "log"
                                    )
                                , H.node1 622 28 34 (H.val "number")
                                ]
                            )
                        )
                    )
                , H.node1
                    623
                    5
                    33
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            623
                            6
                            32
                            (Elm.Syntax.Expression.Application
                                [ H.node1
                                    623
                                    6
                                    27
                                    (Elm.Syntax.Expression.FunctionOrValue
                                        [ "Elm", "Kernel", "Basics" ]
                                        "log"
                                    )
                                , H.node1 623 28 32 (H.val "base")
                                ]
                            )
                        )
                    )
                ]
            )
    }


e : Elm.Syntax.Expression.FunctionImplementation
e =
    { name = H.node1 629 1 2 "Basics.e"
    , arguments = []
    , expression =
        H.node1
            630
            3
            22
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "e"
            )
    }


radians : Elm.Syntax.Expression.FunctionImplementation
radians =
    { name = H.node1 642 1 8 "Basics.radians"
    , arguments =
        [ H.node1 642 9 23 (Elm.Syntax.Pattern.VarPattern "angleInRadians") ]
    , expression = H.node1 643 3 17 (H.val "angleInRadians")
    }


degrees : Elm.Syntax.Expression.FunctionImplementation
degrees =
    { name = H.node1 651 1 8 "Basics.degrees"
    , arguments =
        [ H.node1 651 9 23 (Elm.Syntax.Pattern.VarPattern "angleInDegrees") ]
    , expression =
        H.node1
            652
            3
            35
            (Elm.Syntax.Expression.Application
                [ H.node1 652 3 7 (H.val "fdiv")
                , H.node1
                    652
                    8
                    31
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            652
                            9
                            30
                            (Elm.Syntax.Expression.Application
                                [ H.node1 652 9 12 (H.val "mul")
                                , H.node1 652 13 27 (H.val "angleInDegrees")
                                , H.node1 652 28 30 (H.val "pi")
                                ]
                            )
                        )
                    )
                , H.node1 652 32 35 (Elm.Syntax.Expression.Integer 180)
                ]
            )
    }


turns : Elm.Syntax.Expression.FunctionImplementation
turns =
    { name = H.node1 660 1 6 "Basics.turns"
    , arguments =
        [ H.node1 660 7 19 (Elm.Syntax.Pattern.VarPattern "angleInTurns") ]
    , expression =
        H.node1
            661
            3
            30
            (Elm.Syntax.Expression.Application
                [ H.node1 661 3 6 (H.val "mul")
                , H.node1
                    661
                    7
                    17
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            661
                            8
                            16
                            (Elm.Syntax.Expression.Application
                                [ H.node1 661 8 11 (H.val "mul")
                                , H.node1
                                    661
                                    12
                                    13
                                    (Elm.Syntax.Expression.Integer 2)
                                , H.node1 661 14 16 (H.val "pi")
                                ]
                            )
                        )
                    )
                , H.node1 661 18 30 (H.val "angleInTurns")
                ]
            )
    }


pi : Elm.Syntax.Expression.FunctionImplementation
pi =
    { name = H.node1 671 1 3 "Basics.pi"
    , arguments = []
    , expression =
        H.node1
            672
            3
            23
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "pi"
            )
    }


cos : Elm.Syntax.Expression.FunctionImplementation
cos =
    { name = H.node1 684 1 4 "Basics.cos"
    , arguments = []
    , expression =
        H.node1
            685
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "cos"
            )
    }


sin : Elm.Syntax.Expression.FunctionImplementation
sin =
    { name = H.node1 697 1 4 "Basics.sin"
    , arguments = []
    , expression =
        H.node1
            698
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "sin"
            )
    }


tan : Elm.Syntax.Expression.FunctionImplementation
tan =
    { name = H.node1 709 1 4 "Basics.tan"
    , arguments = []
    , expression =
        H.node1
            710
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "tan"
            )
    }


acos : Elm.Syntax.Expression.FunctionImplementation
acos =
    { name = H.node1 719 1 5 "Basics.acos"
    , arguments = []
    , expression =
        H.node1
            720
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "acos"
            )
    }


asin : Elm.Syntax.Expression.FunctionImplementation
asin =
    { name = H.node1 729 1 5 "Basics.asin"
    , arguments = []
    , expression =
        H.node1
            730
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "asin"
            )
    }


atan : Elm.Syntax.Expression.FunctionImplementation
atan =
    { name = H.node1 752 1 5 "Basics.atan"
    , arguments = []
    , expression =
        H.node1
            753
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "atan"
            )
    }


atan2 : Elm.Syntax.Expression.FunctionImplementation
atan2 =
    { name = H.node1 767 1 6 "Basics.atan2"
    , arguments = []
    , expression =
        H.node1
            768
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "atan2"
            )
    }


fromPolar : Elm.Syntax.Expression.FunctionImplementation
fromPolar =
    { name = H.node1 780 1 10 "Basics.fromPolar"
    , arguments =
        [ H.node1
            780
            11
            26
            (Elm.Syntax.Pattern.TuplePattern
                [ H.node1 780 12 18 (Elm.Syntax.Pattern.VarPattern "radius")
                , H.node1 780 20 25 (Elm.Syntax.Pattern.VarPattern "theta")
                ]
            )
        ]
    , expression =
        H.node
            781
            3
            783
            4
            (Elm.Syntax.Expression.TupledExpression
                [ H.node1
                    781
                    5
                    27
                    (Elm.Syntax.Expression.Application
                        [ H.node1 781 5 8 (H.val "mul")
                        , H.node1 781 9 15 (H.val "radius")
                        , H.node1
                            781
                            16
                            27
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    781
                                    17
                                    26
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 781 17 20 (H.val "cos")
                                        , H.node1 781 21 26 (H.val "theta")
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                , H.node1
                    782
                    5
                    27
                    (Elm.Syntax.Expression.Application
                        [ H.node1 782 5 8 (H.val "mul")
                        , H.node1 782 9 15 (H.val "radius")
                        , H.node1
                            782
                            16
                            27
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    782
                                    17
                                    26
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 782 17 20 (H.val "sin")
                                        , H.node1 782 21 26 (H.val "theta")
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                ]
            )
    }


toPolar : Elm.Syntax.Expression.FunctionImplementation
toPolar =
    { name = H.node1 792 1 8 "Basics.toPolar"
    , arguments =
        [ H.node1
            792
            9
            17
            (Elm.Syntax.Pattern.TuplePattern
                [ H.node1 792 11 12 (Elm.Syntax.Pattern.VarPattern "x")
                , H.node1 792 14 15 (Elm.Syntax.Pattern.VarPattern "y")
                ]
            )
        ]
    , expression =
        H.node
            793
            3
            795
            4
            (Elm.Syntax.Expression.TupledExpression
                [ H.node1
                    793
                    5
                    35
                    (Elm.Syntax.Expression.Application
                        [ H.node1 793 5 9 (H.val "sqrt")
                        , H.node1
                            793
                            10
                            35
                            (Elm.Syntax.Expression.ParenthesizedExpression
                                (H.node1
                                    793
                                    11
                                    34
                                    (Elm.Syntax.Expression.Application
                                        [ H.node1 793 11 14 (H.val "add")
                                        , H.node1
                                            793
                                            15
                                            24
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    793
                                                    16
                                                    23
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            793
                                                            16
                                                            19
                                                            (H.val "mul")
                                                        , H.node1
                                                            793
                                                            20
                                                            21
                                                            (H.val "x")
                                                        , H.node1
                                                            793
                                                            22
                                                            23
                                                            (H.val "x")
                                                        ]
                                                    )
                                                )
                                            )
                                        , H.node1
                                            793
                                            25
                                            34
                                            (Elm.Syntax.Expression.ParenthesizedExpression
                                                (H.node1
                                                    793
                                                    26
                                                    33
                                                    (Elm.Syntax.Expression.Application
                                                        [ H.node1
                                                            793
                                                            26
                                                            29
                                                            (H.val "mul")
                                                        , H.node1
                                                            793
                                                            30
                                                            31
                                                            (H.val "y")
                                                        , H.node1
                                                            793
                                                            32
                                                            33
                                                            (H.val "y")
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
                , H.node1
                    794
                    5
                    14
                    (Elm.Syntax.Expression.Application
                        [ H.node1 794 5 10 (H.val "atan2")
                        , H.node1 794 11 12 (H.val "y")
                        , H.node1 794 13 14 (H.val "x")
                        ]
                    )
                ]
            )
    }


isNaN : Elm.Syntax.Expression.FunctionImplementation
isNaN =
    { name = H.node1 812 1 6 "Basics.isNaN"
    , arguments = []
    , expression =
        H.node1
            813
            3
            26
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "isNaN"
            )
    }


isInfinite : Elm.Syntax.Expression.FunctionImplementation
isInfinite =
    { name = H.node1 827 1 11 "Basics.isInfinite"
    , arguments = []
    , expression =
        H.node1
            828
            3
            31
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Basics" ]
                "isInfinite"
            )
    }


composeL : Elm.Syntax.Expression.FunctionImplementation
composeL =
    { name = H.node1 849 1 9 "Basics.composeL"
    , arguments =
        [ H.node1 849 10 11 (Elm.Syntax.Pattern.VarPattern "g")
        , H.node1 849 12 13 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 849 14 15 (Elm.Syntax.Pattern.VarPattern "x")
        ]
    , expression =
        H.node1
            850
            3
            10
            (Elm.Syntax.Expression.Application
                [ H.node1 850 3 4 (H.val "g")
                , H.node1
                    850
                    5
                    10
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            850
                            6
                            9
                            (Elm.Syntax.Expression.Application
                                [ H.node1 850 6 7 (H.val "f")
                                , H.node1 850 8 9 (H.val "x")
                                ]
                            )
                        )
                    )
                ]
            )
    }


composeR : Elm.Syntax.Expression.FunctionImplementation
composeR =
    { name = H.node1 860 1 9 "Basics.composeR"
    , arguments =
        [ H.node1 860 10 11 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 860 12 13 (Elm.Syntax.Pattern.VarPattern "g")
        , H.node1 860 14 15 (Elm.Syntax.Pattern.VarPattern "x")
        ]
    , expression =
        H.node1
            861
            3
            10
            (Elm.Syntax.Expression.Application
                [ H.node1 861 3 4 (H.val "g")
                , H.node1
                    861
                    5
                    10
                    (Elm.Syntax.Expression.ParenthesizedExpression
                        (H.node1
                            861
                            6
                            9
                            (Elm.Syntax.Expression.Application
                                [ H.node1 861 6 7 (H.val "f")
                                , H.node1 861 8 9 (H.val "x")
                                ]
                            )
                        )
                    )
                ]
            )
    }


apR : Elm.Syntax.Expression.FunctionImplementation
apR =
    { name = H.node1 895 1 4 "Basics.apR"
    , arguments =
        [ H.node1 895 5 6 (Elm.Syntax.Pattern.VarPattern "x")
        , H.node1 895 7 8 (Elm.Syntax.Pattern.VarPattern "f")
        ]
    , expression =
        H.node1
            896
            3
            6
            (Elm.Syntax.Expression.Application
                [ H.node1 896 3 4 (H.val "f"), H.node1 896 5 6 (H.val "x") ]
            )
    }


apL : Elm.Syntax.Expression.FunctionImplementation
apL =
    { name = H.node1 905 1 4 "Basics.apL"
    , arguments =
        [ H.node1 905 5 6 (Elm.Syntax.Pattern.VarPattern "f")
        , H.node1 905 7 8 (Elm.Syntax.Pattern.VarPattern "x")
        ]
    , expression =
        H.node1
            906
            3
            6
            (Elm.Syntax.Expression.Application
                [ H.node1 906 3 4 (H.val "f"), H.node1 906 5 6 (H.val "x") ]
            )
    }


identity : Elm.Syntax.Expression.FunctionImplementation
identity =
    { name = H.node1 913 1 9 "Basics.identity"
    , arguments = [ H.node1 913 10 11 (Elm.Syntax.Pattern.VarPattern "x") ]
    , expression = H.node1 914 3 4 (H.val "x")
    }


always : Elm.Syntax.Expression.FunctionImplementation
always =
    { name = H.node1 926 1 7 "Basics.always"
    , arguments =
        [ H.node1 926 8 9 (Elm.Syntax.Pattern.VarPattern "a")
        , H.node1 926 10 11 Elm.Syntax.Pattern.AllPattern
        ]
    , expression = H.node1 927 3 4 (H.val "a")
    }


never : Elm.Syntax.Expression.FunctionImplementation
never =
    { name = H.node1 969 1 6 "Basics.never"
    , arguments =
        [ H.node1
            969
            7
            24
            (Elm.Syntax.Pattern.ParenthesizedPattern
                (H.node1
                    969
                    8
                    23
                    (Elm.Syntax.Pattern.NamedPattern
                        { moduleName = [], name = "JustOneMore" }
                        [ H.node1
                            969
                            20
                            23
                            (Elm.Syntax.Pattern.VarPattern "nvr")
                        ]
                    )
                )
            )
        ]
    , expression =
        H.node1
            970
            3
            12
            (Elm.Syntax.Expression.Application
                [ H.node1 970 3 8 (H.val "never")
                , H.node1 970 9 12 (H.val "nvr")
                ]
            )
    }