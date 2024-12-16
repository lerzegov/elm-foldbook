module MyColors exposing (..)

import Color
import Element exposing (fromRgb, rgb255, rgba)



-- import avh4/elm-color for compatibility with my games and chatGpt apps
-- helper function


uiColor : Color.Color -> Element.Color
uiColor color =
    fromRgb <| Color.toRgba color



-- Define your mnemonic color functions
purple : Element.Color
purple =
    Color.purple
        |> uiColor

darkPurple : Element.Color
darkPurple =
    Color.darkPurple
        |> uiColor

orange : Element.Color
orange =
    Color.orange
        |> uiColor

darkOrange : Element.Color
darkOrange =
    Color.darkOrange
        |> uiColor

lightGray : Element.Color
lightGray =
    Color.lightGray
        |> uiColor


darkGray : Element.Color
darkGray =
    Color.darkGray
        |> uiColor


veryLightGray : Element.Color
veryLightGray =
    rgb255 240 240 240



-- Other colors as needed


red : Element.Color
red =
    Color.lightRed
        |> uiColor


green : Element.Color
green =
    Color.green
        |> uiColor


paleGreen : Element.Color
paleGreen =
    Color.lightGreen
        |> uiColor


blue : Element.Color
blue =
    Color.blue
        |> uiColor


white : Element.Color
white =
    Color.white
        |> uiColor


darkCharcoal : Element.Color
darkCharcoal =
    Color.darkCharcoal
        |> uiColor


lightRed : Element.Color
lightRed =
    Color.lightRed
        |> uiColor


lightBlue : Element.Color
lightBlue =
    Color.lightBlue
        |> uiColor


yellow : Element.Color
yellow =
    Color.yellow
        |> uiColor


pink : Element.Color
pink =
    rgb255 255 192 203


myTransparent : Element.Color
myTransparent =
    rgba 0 0 0 0
