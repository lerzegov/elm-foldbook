port module Ports exposing (..)

import Json.Encode exposing (Value)

-- Home
port openNewTab : String -> Cmd msg

port receiveHints : { editorId : String, hints : List String } -> Cmd msg
port requestHints : ({ editorId : String, word : String } -> msg) -> Sub msg

-- removed because init is managed by the custom component
-- port initializeEditor : { editorId : String, initialValue : String } -> Cmd msg
port editorContentChanged : (String -> msg) -> Sub msg -- sub to javascript
