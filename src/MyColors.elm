module MyColors exposing (..)

import Element exposing (Color, rgb255, rgba)

-- Define your mnemonic color functions
lightGray : Color
lightGray = rgb255 200 200 200

darkGray : Color
darkGray = rgb255 100 100 100

-- Other colors as needed
red : Color
red = rgb255 255 0 0

green : Color
green = rgb255 0 255 0

paleGreen : Color
paleGreen = rgb255 207 253 188

blue : Color
blue = rgb255 0 0 255

white : Color
white = rgb255 255 255 255

darkCharcoal : Color
darkCharcoal = rgb255 0x2E 0x34 0x36

lightRed : Color
lightRed =
    rgb255 234 144 136

lightBlue : Color
lightBlue =
    rgb255 136 176 234

yellow : Color
yellow =
    rgb255 255 255 0

pink : Color
pink =
    rgb255 255 192 203

myTransparent : Color
myTransparent =
    rgba 0 0 0 0

