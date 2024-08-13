port module Ports exposing (..)

import Json.Encode exposing (Value)
-- NB two types of ports
--  1) sending data or commands to javascript from Elm => Cmd msg, arg is data in Elm, callback func in javascript
--  2) receiving data or commands from javascript to Elm => Sub msg, arg is callback func in Elm, data in javascript

-- NB all ports are defined for the whole app in this file
--    to use a port in a module, import it with exposing (..) and use it in the module

-- NB if a port is not used in Elm, it will not be compiled into the final JS bundle
--    so on <script> load in the browser the js code calling the port function will rais runtime error undefined!!

-- Home
port openNewTab : String -> Cmd msg

port reloadPage : () -> Cmd msg


port receiveHints : { editorId : String, hints : List { label : String } } -> Cmd msg
port requestHints : ({ editorId : String, word : String } -> msg) -> Sub msg

-- removed because init is managed by the custom component
-- port initializeEditor : { editorId : String, initialValue : String } -> Cmd msg
port formulaContentChanged : (String -> msg) -> Sub msg -- sub to javascript
port markupContentChanged : (String -> msg) -> Sub msg

-- spreadsheetUI editing TODO check
-- port focusAndSelect : String -> Cmd msg

-- markup-foldbook

-- mathquill 
-- port renderMathQuill : (String, String) -> Cmd msg -- (parentId, input)

port receiveLatex : ( ( String, String, String ) -> msg ) -> Sub msg





-- Define ports for saving the file
port saveFile : { content : String, path : String } -> Cmd msg


