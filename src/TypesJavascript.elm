module TypesJavascript exposing (..)
-- created to avoid circular dependency between Port and TypesMarkup
type alias BoundingClientRect =
    { left : Float
    , top : Float
    , right : Float
    , bottom : Float
    , width : Float
    , height : Float
    }

type alias Editor =
    { id : String
    , editorType : String
    , initialized : Bool
    }


