port module Ports exposing (..)

import Json.Encode exposing (Value)

-- Home
port openNewTab : String -> Cmd msg

port sendDatasetRefs : Value -> Cmd msg
port sendDataArrayRefs : Value -> Cmd msg
port sendDimRefs : Value -> Cmd msg

port receiveHints : Value -> Cmd msg
port requestHints : (String -> msg) -> Sub msg -- sub to javascript


port initializeEditor : (String , String) -> Cmd msg
port editorContentChanged : (String -> msg) -> Sub msg -- sub to javascript
