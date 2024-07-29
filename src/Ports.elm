port module Ports exposing (..)

import Json.Encode exposing (Value)
-- NB two types of ports
--  1) sending data or commands to javascript from Elm => Cmd msg, arg is data in Elm, callback func in javascript
--  2) receiving data or commands from javascript to Elm => Sub msg, arg is callback func in Elm, data in javascript

-- NB if a port is not used in Elm, it will not be compiled into the final JS bundle
--    so on <script> load in the browser the js code calling the port function will rais runtime error undefined!!

-- Home
port openNewTab : String -> Cmd msg

port reloadPage : () -> Cmd msg


port receiveHints : { editorId : String, hints : List { label : String } } -> Cmd msg
port requestHints : ({ editorId : String, word : String } -> msg) -> Sub msg

-- removed because init is managed by the custom component
-- port initializeEditor : { editorId : String, initialValue : String } -> Cmd msg
port editorContentChanged : (String -> msg) -> Sub msg -- sub to javascript

-- spreadsheetUI editing
port focusAndSelect : String -> Cmd msg


