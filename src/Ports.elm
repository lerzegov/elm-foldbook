port module Ports exposing (..)

import Json.Encode as Encode exposing (Value)
import TypesJavascript exposing (BoundingClientRect)



-- NB two types of ports
--  1) sending data or commands to javascript from Elm => Cmd msg, arg is data in Elm, callback func stays in javascript
--  2) receiving data or commands from javascript to Elm => Sub msg, arg is callback func in Elm, receiving data from javascript
--     Sub ports must be configured in Elm subscriptions where they are mapped onto an update Action with the same args
-- NB all ports are defined for the whole app in this file
--    to use a port in a module, import it with exposing (..) and use it in the module
-- NB if a port is not used in Elm, it will not be compiled into the final JS bundle
--    so on <script> load in the browser the js code calling the port function will rais runtime error undefined!!
-- Home


port openNewTab : String -> Cmd msg


port reloadPage : () -> Cmd msg


-- CODEMIRROR

port initializeEditor : String -> Cmd msg
port disposeEditor : String -> Cmd msg

port receiveHints : { editorId : String, hints : List { label : String } } -> Cmd msg


port requestHints : ({ editorId : String, word : String } -> msg) -> Sub msg


port formulaContentChanged : ({ editorId : String, content : String } -> msg) -> Sub msg -- sub to javascript


port markupContentChanged : (String -> msg) -> Sub msg



-- spreadsheetUI editing TODO check
-- port focusAndSelect : String -> Cmd msg
-- markup-foldbook
-- mathlive
-- Define the port that receives an object with `id` and `value` as strings
--port mathFieldInput : ({ id : String, value : String, mathJson : Encode.Value } -> msg) -> Sub msg


port mathFieldInput : ({ id : String, value : String, mathJson : Encode.Value, result : String } -> msg) -> Sub msg



-- Define ports for saving the file


port saveFile : { content : String, path : String } -> Cmd msg


port scrollToAnchor : String -> Cmd msg
