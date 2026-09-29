module Core exposing (dependency, functions, operators)

{-| 
@docs functions, operators, dependency
-}


import Core.Array
import Core.Basics
import Core.Bitwise
import Core.Char
import Core.Debug
import Core.Dict
import Core.Elm.JsArray
import Core.Elm.Kernel.List
import Core.Elm.Kernel.String
import Core.List
import Core.List.Extra
import Core.Maybe
import Core.Platform
import Core.Platform.Cmd
import Core.Platform.Sub
import Core.Process
import Core.Result
import Core.Set
import Core.String
import Core.Tuple
import Dict
import Elm.Dependency
import Elm.Interface
import Elm.Syntax.Expression
import Elm.Syntax.Infix
import Elm.Syntax.ModuleName
import Elm.Syntax.Node
import Elm.Syntax.Pattern
import FastDict
import H


functions :
    FastDict.Dict Elm.Syntax.ModuleName.ModuleName (FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation)
functions =
    FastDict.fromList
        [ ( [ "List", "Extra" ], Core.List.Extra.functions )
        , ( [ "Platform", "Sub" ], Core.Platform.Sub.functions )
        , ( [ "Platform", "Cmd" ], Core.Platform.Cmd.functions )
        , ( [ "Elm", "JsArray" ], Core.Elm.JsArray.functions )
        , ( [ "Tuple" ], Core.Tuple.functions )
        , ( [ "String" ], Core.String.functions )
        , ( [ "Set" ], Core.Set.functions )
        , ( [ "Result" ], Core.Result.functions )
        , ( [ "Process" ], Core.Process.functions )
        , ( [ "Platform" ], Core.Platform.functions )
        , ( [ "Maybe" ], Core.Maybe.functions )
        , ( [ "List" ], Core.List.functions )
        , ( [ "Dict" ], Core.Dict.functions )
        , ( [ "Debug" ], Core.Debug.functions )
        , ( [ "Char" ], Core.Char.functions )
        , ( [ "Bitwise" ], Core.Bitwise.functions )
        , ( [ "Basics" ], Core.Basics.functions )
        , ( [ "Array" ], Core.Array.functions )
        , ( [ "Elm", "Kernel", "String" ], Core.Elm.Kernel.String.functions )
        , ( [ "Elm", "Kernel", "List" ], Core.Elm.Kernel.List.functions )
        ]


operators : FastDict.Dict String Elm.Syntax.Pattern.QualifiedNameRef
operators =
    FastDict.fromList
        (List.concat [ Core.List.operators, Core.Basics.operators ])


dependency : Elm.Dependency.Dependency
dependency =
    { name = "elm/core"
    , version = "1.0.0"
    , interfaces =
        Dict.fromList
            [ ( [ "List", "Extra" ]
              , [ Elm.Interface.Function "last"
                , Elm.Interface.Function "init"
                , Elm.Interface.Function "getAt"
                , Elm.Interface.Function "uncons"
                , Elm.Interface.Function "unconsLast"
                , Elm.Interface.Function "maximumBy"
                , Elm.Interface.Function "maximumWith"
                , Elm.Interface.Function "minimumBy"
                , Elm.Interface.Function "minimumWith"
                , Elm.Interface.Function "andMap"
                , Elm.Interface.Function "andThen"
                , Elm.Interface.Function "reverseMap"
                , Elm.Interface.Function "takeWhile"
                , Elm.Interface.Function "dropWhile"
                , Elm.Interface.Function "unique"
                , Elm.Interface.Function "uniqueBy"
                , Elm.Interface.Function "allDifferent"
                , Elm.Interface.Function "allDifferentBy"
                , Elm.Interface.Function "setIf"
                , Elm.Interface.Function "setAt"
                , Elm.Interface.Function "remove"
                , Elm.Interface.Function "updateIf"
                , Elm.Interface.Function "updateAt"
                , Elm.Interface.Function "updateIfIndex"
                , Elm.Interface.Function "removeAt"
                , Elm.Interface.Function "removeIfIndex"
                , Elm.Interface.Function "filterNot"
                , Elm.Interface.Function "swapAt"
                , Elm.Interface.Function "stableSortWith"
                , Elm.Interface.Function "intercalate"
                , Elm.Interface.Function "transpose"
                , Elm.Interface.Function "subsequences"
                , Elm.Interface.Function "permutations"
                , Elm.Interface.Function "interweave"
                , Elm.Interface.Function "cartesianProduct"
                , Elm.Interface.Function "uniquePairs"
                , Elm.Interface.Function "foldl1"
                , Elm.Interface.Function "foldr1"
                , Elm.Interface.Function "indexedFoldl"
                , Elm.Interface.Function "indexedFoldr"
                , Elm.Interface.CustomType ( "Step", [ "Continue", "Stop" ] )
                , Elm.Interface.Function "stoppableFoldl"
                , Elm.Interface.Function "scanl"
                , Elm.Interface.Function "scanl1"
                , Elm.Interface.Function "scanr"
                , Elm.Interface.Function "scanr1"
                , Elm.Interface.Function "mapAccuml"
                , Elm.Interface.Function "mapAccumr"
                , Elm.Interface.Function "unfoldr"
                , Elm.Interface.Function "iterate"
                , Elm.Interface.Function "initialize"
                , Elm.Interface.Function "cycle"
                , Elm.Interface.Function "reverseRange"
                , Elm.Interface.Function "splitAt"
                , Elm.Interface.Function "splitWhen"
                , Elm.Interface.Function "takeWhileRight"
                , Elm.Interface.Function "dropWhileRight"
                , Elm.Interface.Function "span"
                , Elm.Interface.Function "break"
                , Elm.Interface.Function "stripPrefix"
                , Elm.Interface.Function "group"
                , Elm.Interface.Function "groupWhile"
                , Elm.Interface.Function "inits"
                , Elm.Interface.Function "tails"
                , Elm.Interface.Function "select"
                , Elm.Interface.Function "selectSplit"
                , Elm.Interface.Function "gatherEquals"
                , Elm.Interface.Function "gatherEqualsBy"
                , Elm.Interface.Function "gatherWith"
                , Elm.Interface.Function "subsequencesNonEmpty"
                , Elm.Interface.Function "frequencies"
                , Elm.Interface.Function "isPrefixOf"
                , Elm.Interface.Function "isSuffixOf"
                , Elm.Interface.Function "isInfixOf"
                , Elm.Interface.Function "isSubsequenceOf"
                , Elm.Interface.Function "isPermutationOf"
                , Elm.Interface.Function "notMember"
                , Elm.Interface.Function "find"
                , Elm.Interface.Function "elemIndex"
                , Elm.Interface.Function "elemIndices"
                , Elm.Interface.Function "findIndex"
                , Elm.Interface.Function "findIndices"
                , Elm.Interface.Function "findMap"
                , Elm.Interface.Function "count"
                , Elm.Interface.Function "zip"
                , Elm.Interface.Function "zip3"
                , Elm.Interface.Function "lift2"
                , Elm.Interface.Function "lift3"
                , Elm.Interface.Function "lift4"
                , Elm.Interface.Function "groupsOf"
                , Elm.Interface.Function "groupsOfWithStep"
                , Elm.Interface.Function "groupsOfVarying"
                , Elm.Interface.Function "greedyGroupsOf"
                , Elm.Interface.Function "greedyGroupsOfWithStep"
                , Elm.Interface.Function "joinOn"
                ]
              )
            , ( [ "Platform", "Sub" ]
              , [ Elm.Interface.CustomType ( "Sub", [] )
                , Elm.Interface.Function "none"
                , Elm.Interface.Function "batch"
                , Elm.Interface.Function "map"
                ]
              )
            , ( [ "Platform", "Cmd" ]
              , [ Elm.Interface.CustomType ( "Cmd", [] )
                , Elm.Interface.Function "none"
                , Elm.Interface.Function "batch"
                , Elm.Interface.Function "map"
                ]
              )
            , ( [ "Elm", "JsArray" ]
              , [ Elm.Interface.CustomType ( "JsArray", [] )
                , Elm.Interface.Function "empty"
                , Elm.Interface.Function "singleton"
                , Elm.Interface.Function "length"
                , Elm.Interface.Function "initialize"
                , Elm.Interface.Function "initializeFromList"
                , Elm.Interface.Function "unsafeGet"
                , Elm.Interface.Function "unsafeSet"
                , Elm.Interface.Function "push"
                , Elm.Interface.Function "foldl"
                , Elm.Interface.Function "foldr"
                , Elm.Interface.Function "map"
                , Elm.Interface.Function "indexedMap"
                , Elm.Interface.Function "slice"
                , Elm.Interface.Function "appendN"
                ]
              )
            , ( [ "Tuple" ]
              , [ Elm.Interface.Function "pair"
                , Elm.Interface.Function "first"
                , Elm.Interface.Function "second"
                , Elm.Interface.Function "mapFirst"
                , Elm.Interface.Function "mapSecond"
                , Elm.Interface.Function "mapBoth"
                ]
              )
            , ( [ "String" ]
              , [ Elm.Interface.CustomType ( "String", [] )
                , Elm.Interface.Function "isEmpty"
                , Elm.Interface.Function "length"
                , Elm.Interface.Function "reverse"
                , Elm.Interface.Function "repeat"
                , Elm.Interface.Function "replace"
                , Elm.Interface.Function "append"
                , Elm.Interface.Function "concat"
                , Elm.Interface.Function "split"
                , Elm.Interface.Function "join"
                , Elm.Interface.Function "words"
                , Elm.Interface.Function "lines"
                , Elm.Interface.Function "slice"
                , Elm.Interface.Function "left"
                , Elm.Interface.Function "right"
                , Elm.Interface.Function "dropLeft"
                , Elm.Interface.Function "dropRight"
                , Elm.Interface.Function "contains"
                , Elm.Interface.Function "startsWith"
                , Elm.Interface.Function "endsWith"
                , Elm.Interface.Function "indexes"
                , Elm.Interface.Function "indices"
                , Elm.Interface.Function "toInt"
                , Elm.Interface.Function "fromInt"
                , Elm.Interface.Function "toFloat"
                , Elm.Interface.Function "fromFloat"
                , Elm.Interface.Function "fromChar"
                , Elm.Interface.Function "cons"
                , Elm.Interface.Function "uncons"
                , Elm.Interface.Function "toList"
                , Elm.Interface.Function "fromList"
                , Elm.Interface.Function "toUpper"
                , Elm.Interface.Function "toLower"
                , Elm.Interface.Function "pad"
                , Elm.Interface.Function "padLeft"
                , Elm.Interface.Function "padRight"
                , Elm.Interface.Function "trim"
                , Elm.Interface.Function "trimLeft"
                , Elm.Interface.Function "trimRight"
                , Elm.Interface.Function "map"
                , Elm.Interface.Function "filter"
                , Elm.Interface.Function "foldl"
                , Elm.Interface.Function "foldr"
                , Elm.Interface.Function "any"
                , Elm.Interface.Function "all"
                ]
              )
            , ( [ "Set" ]
              , [ Elm.Interface.CustomType ( "Set", [] )
                , Elm.Interface.Function "empty"
                , Elm.Interface.Function "singleton"
                , Elm.Interface.Function "insert"
                , Elm.Interface.Function "remove"
                , Elm.Interface.Function "isEmpty"
                , Elm.Interface.Function "member"
                , Elm.Interface.Function "size"
                , Elm.Interface.Function "union"
                , Elm.Interface.Function "intersect"
                , Elm.Interface.Function "diff"
                , Elm.Interface.Function "toList"
                , Elm.Interface.Function "fromList"
                , Elm.Interface.Function "map"
                , Elm.Interface.Function "foldl"
                , Elm.Interface.Function "foldr"
                , Elm.Interface.Function "filter"
                , Elm.Interface.Function "partition"
                ]
              )
            , ( [ "Result" ]
              , [ Elm.Interface.CustomType ( "Result", [ "Ok", "Err" ] )
                , Elm.Interface.Function "withDefault"
                , Elm.Interface.Function "map"
                , Elm.Interface.Function "map2"
                , Elm.Interface.Function "map3"
                , Elm.Interface.Function "map4"
                , Elm.Interface.Function "map5"
                , Elm.Interface.Function "andThen"
                , Elm.Interface.Function "toMaybe"
                , Elm.Interface.Function "fromMaybe"
                , Elm.Interface.Function "mapError"
                ]
              )
            , ( [ "Process" ]
              , [ Elm.Interface.Alias "Id"
                , Elm.Interface.Function "spawn"
                , Elm.Interface.Function "sleep"
                , Elm.Interface.Function "kill"
                ]
              )
            , ( [ "Platform" ]
              , [ Elm.Interface.CustomType ( "Program", [] )
                , Elm.Interface.Function "worker"
                , Elm.Interface.CustomType ( "Task", [] )
                , Elm.Interface.CustomType ( "ProcessId", [] )
                , Elm.Interface.CustomType ( "Router", [] )
                , Elm.Interface.Function "sendToApp"
                , Elm.Interface.Function "sendToSelf"
                ]
              )
            , ( [ "Maybe" ]
              , [ Elm.Interface.CustomType ( "Maybe", [ "Just", "Nothing" ] )
                , Elm.Interface.Function "andThen"
                , Elm.Interface.Function "map"
                , Elm.Interface.Function "map2"
                , Elm.Interface.Function "map3"
                , Elm.Interface.Function "map4"
                , Elm.Interface.Function "map5"
                , Elm.Interface.Function "withDefault"
                ]
              )
            , ( [ "List" ]
              , [ Elm.Interface.Function "singleton"
                , Elm.Interface.Function "repeat"
                , Elm.Interface.Function "range"
                , Elm.Interface.Operator
                    { direction = H.node1 41 7 12 Elm.Syntax.Infix.Right
                    , precedence = H.node1 41 13 14 5
                    , operator = H.node1 41 15 19 "::"
                    , function = H.node1 41 22 26 "cons"
                    }
                , Elm.Interface.Function "map"
                , Elm.Interface.Function "indexedMap"
                , Elm.Interface.Function "foldl"
                , Elm.Interface.Function "foldr"
                , Elm.Interface.Function "filter"
                , Elm.Interface.Function "filterMap"
                , Elm.Interface.Function "length"
                , Elm.Interface.Function "reverse"
                , Elm.Interface.Function "member"
                , Elm.Interface.Function "all"
                , Elm.Interface.Function "any"
                , Elm.Interface.Function "maximum"
                , Elm.Interface.Function "minimum"
                , Elm.Interface.Function "sum"
                , Elm.Interface.Function "product"
                , Elm.Interface.Function "append"
                , Elm.Interface.Function "concat"
                , Elm.Interface.Function "concatMap"
                , Elm.Interface.Function "intersperse"
                , Elm.Interface.Function "map2"
                , Elm.Interface.Function "map3"
                , Elm.Interface.Function "map4"
                , Elm.Interface.Function "map5"
                , Elm.Interface.Function "sort"
                , Elm.Interface.Function "sortBy"
                , Elm.Interface.Function "sortWith"
                , Elm.Interface.Function "isEmpty"
                , Elm.Interface.Function "head"
                , Elm.Interface.Function "tail"
                , Elm.Interface.Function "take"
                , Elm.Interface.Function "drop"
                , Elm.Interface.Function "partition"
                , Elm.Interface.Function "unzip"
                ]
              )
            , ( [ "Dict" ]
              , [ Elm.Interface.CustomType ( "Dict", [] )
                , Elm.Interface.Function "empty"
                , Elm.Interface.Function "singleton"
                , Elm.Interface.Function "insert"
                , Elm.Interface.Function "update"
                , Elm.Interface.Function "remove"
                , Elm.Interface.Function "isEmpty"
                , Elm.Interface.Function "member"
                , Elm.Interface.Function "get"
                , Elm.Interface.Function "size"
                , Elm.Interface.Function "keys"
                , Elm.Interface.Function "values"
                , Elm.Interface.Function "toList"
                , Elm.Interface.Function "fromList"
                , Elm.Interface.Function "map"
                , Elm.Interface.Function "foldl"
                , Elm.Interface.Function "foldr"
                , Elm.Interface.Function "filter"
                , Elm.Interface.Function "partition"
                , Elm.Interface.Function "union"
                , Elm.Interface.Function "intersect"
                , Elm.Interface.Function "diff"
                , Elm.Interface.Function "merge"
                ]
              )
            , ( [ "Debug" ]
              , [ Elm.Interface.Function "toString"
                , Elm.Interface.Function "log"
                , Elm.Interface.Function "todo"
                ]
              )
            , ( [ "Char" ]
              , [ Elm.Interface.CustomType ( "Char", [] )
                , Elm.Interface.Function "isUpper"
                , Elm.Interface.Function "isLower"
                , Elm.Interface.Function "isAlpha"
                , Elm.Interface.Function "isAlphaNum"
                , Elm.Interface.Function "isDigit"
                , Elm.Interface.Function "isOctDigit"
                , Elm.Interface.Function "isHexDigit"
                , Elm.Interface.Function "toUpper"
                , Elm.Interface.Function "toLower"
                , Elm.Interface.Function "toLocaleUpper"
                , Elm.Interface.Function "toLocaleLower"
                , Elm.Interface.Function "toCode"
                , Elm.Interface.Function "fromCode"
                ]
              )
            , ( [ "Bitwise" ]
              , [ Elm.Interface.Function "and"
                , Elm.Interface.Function "or"
                , Elm.Interface.Function "xor"
                , Elm.Interface.Function "complement"
                , Elm.Interface.Function "shiftLeftBy"
                , Elm.Interface.Function "shiftRightBy"
                , Elm.Interface.Function "shiftRightZfBy"
                ]
              )
            , ( [ "Basics" ]
              , [ Elm.Interface.CustomType ( "Int", [] )
                , Elm.Interface.CustomType ( "Float", [] )
                , Elm.Interface.Operator
                    { direction = H.node1 82 7 11 Elm.Syntax.Infix.Left
                    , precedence = H.node1 82 13 14 6
                    , operator = H.node1 82 15 18 "+"
                    , function = H.node1 82 22 25 "add"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 83 7 11 Elm.Syntax.Infix.Left
                    , precedence = H.node1 83 13 14 6
                    , operator = H.node1 83 15 18 "-"
                    , function = H.node1 83 22 25 "sub"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 84 7 11 Elm.Syntax.Infix.Left
                    , precedence = H.node1 84 13 14 7
                    , operator = H.node1 84 15 18 "*"
                    , function = H.node1 84 22 25 "mul"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 85 7 11 Elm.Syntax.Infix.Left
                    , precedence = H.node1 85 13 14 7
                    , operator = H.node1 85 15 18 "/"
                    , function = H.node1 85 22 26 "fdiv"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 86 7 11 Elm.Syntax.Infix.Left
                    , precedence = H.node1 86 13 14 7
                    , operator = H.node1 86 15 19 "//"
                    , function = H.node1 86 22 26 "idiv"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 87 7 12 Elm.Syntax.Infix.Right
                    , precedence = H.node1 87 13 14 8
                    , operator = H.node1 87 15 18 "^"
                    , function = H.node1 87 22 25 "pow"
                    }
                , Elm.Interface.Function "toFloat"
                , Elm.Interface.Function "round"
                , Elm.Interface.Function "floor"
                , Elm.Interface.Function "ceiling"
                , Elm.Interface.Function "truncate"
                , Elm.Interface.Operator
                    { direction = H.node1 75 7 10 Elm.Syntax.Infix.Non
                    , precedence = H.node1 75 13 14 4
                    , operator = H.node1 75 15 19 "=="
                    , function = H.node1 75 22 24 "eq"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 76 7 10 Elm.Syntax.Infix.Non
                    , precedence = H.node1 76 13 14 4
                    , operator = H.node1 76 15 19 "/="
                    , function = H.node1 76 22 25 "neq"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 77 7 10 Elm.Syntax.Infix.Non
                    , precedence = H.node1 77 13 14 4
                    , operator = H.node1 77 15 18 "<"
                    , function = H.node1 77 22 24 "lt"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 78 7 10 Elm.Syntax.Infix.Non
                    , precedence = H.node1 78 13 14 4
                    , operator = H.node1 78 15 18 ">"
                    , function = H.node1 78 22 24 "gt"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 79 7 10 Elm.Syntax.Infix.Non
                    , precedence = H.node1 79 13 14 4
                    , operator = H.node1 79 15 19 "<="
                    , function = H.node1 79 22 24 "le"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 80 7 10 Elm.Syntax.Infix.Non
                    , precedence = H.node1 80 13 14 4
                    , operator = H.node1 80 15 19 ">="
                    , function = H.node1 80 22 24 "ge"
                    }
                , Elm.Interface.Function "max"
                , Elm.Interface.Function "min"
                , Elm.Interface.Function "compare"
                , Elm.Interface.CustomType ( "Order", [ "LT", "EQ", "GT" ] )
                , Elm.Interface.CustomType ( "Bool", [ "True", "False" ] )
                , Elm.Interface.Function "not"
                , Elm.Interface.Operator
                    { direction = H.node1 74 7 12 Elm.Syntax.Infix.Right
                    , precedence = H.node1 74 13 14 3
                    , operator = H.node1 74 15 19 "&&"
                    , function = H.node1 74 22 25 "and"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 73 7 12 Elm.Syntax.Infix.Right
                    , precedence = H.node1 73 13 14 2
                    , operator = H.node1 73 15 19 "||"
                    , function = H.node1 73 22 24 "or"
                    }
                , Elm.Interface.Function "xor"
                , Elm.Interface.Operator
                    { direction = H.node1 81 7 12 Elm.Syntax.Infix.Right
                    , precedence = H.node1 81 13 14 5
                    , operator = H.node1 81 15 19 "++"
                    , function = H.node1 81 22 28 "append"
                    }
                , Elm.Interface.Function "modBy"
                , Elm.Interface.Function "remainderBy"
                , Elm.Interface.Function "negate"
                , Elm.Interface.Function "abs"
                , Elm.Interface.Function "clamp"
                , Elm.Interface.Function "sqrt"
                , Elm.Interface.Function "logBase"
                , Elm.Interface.Function "e"
                , Elm.Interface.Function "pi"
                , Elm.Interface.Function "cos"
                , Elm.Interface.Function "sin"
                , Elm.Interface.Function "tan"
                , Elm.Interface.Function "acos"
                , Elm.Interface.Function "asin"
                , Elm.Interface.Function "atan"
                , Elm.Interface.Function "atan2"
                , Elm.Interface.Function "degrees"
                , Elm.Interface.Function "radians"
                , Elm.Interface.Function "turns"
                , Elm.Interface.Function "toPolar"
                , Elm.Interface.Function "fromPolar"
                , Elm.Interface.Function "isNaN"
                , Elm.Interface.Function "isInfinite"
                , Elm.Interface.Function "identity"
                , Elm.Interface.Function "always"
                , Elm.Interface.Operator
                    { direction = H.node1 71 7 12 Elm.Syntax.Infix.Right
                    , precedence = H.node1 71 13 14 0
                    , operator = H.node1 71 15 19 "<|"
                    , function = H.node1 71 22 25 "apL"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 72 7 11 Elm.Syntax.Infix.Left
                    , precedence = H.node1 72 13 14 0
                    , operator = H.node1 72 15 19 "|>"
                    , function = H.node1 72 22 25 "apR"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 88 7 11 Elm.Syntax.Infix.Left
                    , precedence = H.node1 88 13 14 9
                    , operator = H.node1 88 15 19 "<<"
                    , function = H.node1 88 22 30 "composeL"
                    }
                , Elm.Interface.Operator
                    { direction = H.node1 89 7 12 Elm.Syntax.Infix.Right
                    , precedence = H.node1 89 13 14 9
                    , operator = H.node1 89 15 19 ">>"
                    , function = H.node1 89 22 30 "composeR"
                    }
                , Elm.Interface.CustomType ( "Never", [] )
                , Elm.Interface.Function "never"
                ]
              )
            , ( [ "Array" ]
              , [ Elm.Interface.CustomType ( "Array", [] )
                , Elm.Interface.Function "empty"
                , Elm.Interface.Function "isEmpty"
                , Elm.Interface.Function "length"
                , Elm.Interface.Function "initialize"
                , Elm.Interface.Function "repeat"
                , Elm.Interface.Function "fromList"
                , Elm.Interface.Function "get"
                , Elm.Interface.Function "set"
                , Elm.Interface.Function "push"
                , Elm.Interface.Function "toList"
                , Elm.Interface.Function "toIndexedList"
                , Elm.Interface.Function "foldr"
                , Elm.Interface.Function "foldl"
                , Elm.Interface.Function "filter"
                , Elm.Interface.Function "map"
                , Elm.Interface.Function "indexedMap"
                , Elm.Interface.Function "append"
                , Elm.Interface.Function "slice"
                ]
              )
            , ( [ "Elm", "Kernel", "String" ]
              , [ Elm.Interface.Function "all"
                , Elm.Interface.Function "any"
                , Elm.Interface.Function "foldl"
                , Elm.Interface.Function "foldr"
                , Elm.Interface.Function "map"
                ]
              )
            , ( [ "Elm", "Kernel", "List" ]
              , [ Elm.Interface.Function "map2"
                , Elm.Interface.Function "map3"
                , Elm.Interface.Function "map4"
                , Elm.Interface.Function "map5"
                , Elm.Interface.Function "sortBy"
                ]
              )
            ]
    }