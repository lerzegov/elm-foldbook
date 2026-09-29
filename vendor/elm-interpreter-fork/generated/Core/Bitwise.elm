module Core.Bitwise exposing (and, complement, functions, or, shiftLeftBy, shiftRightBy, shiftRightZfBy, xor)

{-| 
@docs functions, and, or, xor, complement, shiftLeftBy, shiftRightBy, shiftRightZfBy
-}


import Elm.Syntax.Expression
import Elm.Syntax.Node
import FastDict
import H


functions : FastDict.Dict String Elm.Syntax.Expression.FunctionImplementation
functions =
    FastDict.fromList
        [ ( "and", and )
        , ( "or", or )
        , ( "xor", xor )
        , ( "complement", complement )
        , ( "shiftLeftBy", shiftLeftBy )
        , ( "shiftRightBy", shiftRightBy )
        , ( "shiftRightZfBy", shiftRightZfBy )
        ]


and : Elm.Syntax.Expression.FunctionImplementation
and =
    { name = H.node1 24 1 4 "Bitwise.and"
    , arguments = []
    , expression =
        H.node1
            25
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "and"
            )
    }


or : Elm.Syntax.Expression.FunctionImplementation
or =
    { name = H.node1 31 1 3 "Bitwise.or"
    , arguments = []
    , expression =
        H.node1
            32
            3
            24
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "or"
            )
    }


xor : Elm.Syntax.Expression.FunctionImplementation
xor =
    { name = H.node1 38 1 4 "Bitwise.xor"
    , arguments = []
    , expression =
        H.node1
            39
            3
            25
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "xor"
            )
    }


complement : Elm.Syntax.Expression.FunctionImplementation
complement =
    { name = H.node1 45 1 11 "Bitwise.complement"
    , arguments = []
    , expression =
        H.node1
            46
            3
            32
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "complement"
            )
    }


shiftLeftBy : Elm.Syntax.Expression.FunctionImplementation
shiftLeftBy =
    { name = H.node1 56 1 12 "Bitwise.shiftLeftBy"
    , arguments = []
    , expression =
        H.node1
            57
            3
            33
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "shiftLeftBy"
            )
    }


shiftRightBy : Elm.Syntax.Expression.FunctionImplementation
shiftRightBy =
    { name = H.node1 74 1 13 "Bitwise.shiftRightBy"
    , arguments = []
    , expression =
        H.node1
            75
            3
            34
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "shiftRightBy"
            )
    }


shiftRightZfBy : Elm.Syntax.Expression.FunctionImplementation
shiftRightZfBy =
    { name = H.node1 91 1 15 "Bitwise.shiftRightZfBy"
    , arguments = []
    , expression =
        H.node1
            92
            3
            36
            (Elm.Syntax.Expression.FunctionOrValue
                [ "Elm", "Kernel", "Bitwise" ]
                "shiftRightZfBy"
            )
    }