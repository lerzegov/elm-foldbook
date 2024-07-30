module MarkupSource exposing (..)

import Browser
import Html
import Html.Attributes as HtmlAttr 
import Html.Events
import Element exposing (Element, el, column, row, text, layout, width, fill)
import Element.Font as UiFont
import Ports exposing (..)
import Json.Decode as Decode
import Element exposing (padding)
import Element exposing (spacing)


-- removed because init is managed by the custom component
-- port initializeEditor : (String -> msg) -> Sub msg

main =
    Browser.element {
        init = init
        , update = update
        , view = viewToHtml
        , subscriptions = subscriptions }

type alias Model =
    { editorMarkupContent : String }

type Msg
    = NoOp
    | MarkupContentChanged String

initialModel : Model
initialModel =
    { editorMarkupContent = elmMarkupDoc }

init : () -> (Model, Cmd Msg)
init _ =
    ( initialModel
    , Cmd.none
    )

yamlDoc = """
---
# This is a YAML document example
title: YAML Example
description: >
  This is a *multiline*
  description.
items:
  - name: Item 1
    quantity: 10
  - name: Item 2
    quantity: 5
settings:
  enabled: true
  threshold: 15
---

"""
elmMarkupDoc = """
|> Title
    This is a /formatted/ title

This is a paragraph with some *bold* and /italic/ and ~strikethrough~ text.

|> Subtitle
    Mo te passa con gli *amici del mattino* e /della sera/.

This is an Equation with a verbatim inline `x = y^2 -z`{eqn}

#This is a comment.

This is a Link: [My document]{link}

This a Value `ce__ricavi_2022`{value}

This is a Record that is not inlineContent because skips spaces and must stay on a single line:
{ person | name = "John", surname = "Doe", age = 30 }

This is a yaml code block:

~~~yaml
# This is a YAML document example
title: YAML Example
description: >
  This is a /multiline/
  description, ok not formatted as *markup*.
items:
  - name: Item 1
    quantity: 10
  - name: Item 2
    quantity: 5
settings:
  enabled: true
  threshold: 15
~~~

"""
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        MarkupContentChanged content ->
            -- Debug.log ("EditorContentChanged" ++ content) <|
            ( { model | editorMarkupContent = content }, Cmd.none )

view : Model -> Element Msg
view model =
    let
        codeMirrorElement =
            Element.html <| Html.node "code-mirror-markup-editor"
                            [ HtmlAttr.attribute "data-initial-value" model.editorMarkupContent
                            , HtmlAttr.attribute "id" "markup-editor"
                            , Html.Events.on "formulaContentChanged" (Decode.map MarkupContentChanged (Decode.at [ "detail" ] Decode.string)) 
                            ] []
    in
    column [padding 20, spacing 10, width fill]
        [ row [UiFont.size 24, UiFont.bold] [ text "Markup Editor" ]
        , el [UiFont.size 16] codeMirrorElement
        ]

-- to keep an autonomous main function that can be used in the browser
viewToHtml : Model -> Html.Html Msg
viewToHtml model =
    layout [] (view model)
        

subscriptions : Model -> Sub Msg
subscriptions model =
    -- removed because init is managed by the custom component
    markupContentChanged  MarkupContentChanged

