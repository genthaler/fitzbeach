module View.Theme exposing (Mode(..), Palette, palette, toCssColor)

import Element exposing (Color, rgb255, toRgb)


type Mode
    = Light
    | Dark


type alias Palette =
    { appBackground : Color
    , bodyText : Color
    , buttonBackground : Color
    , buttonBorder : Color
    , buttonText : Color
    , detailText : Color
    , emptyCellBackground : Color
    , emptyCellBorder : Color
    , facingText : Color
    , panelBackground : Color
    , panelBorder : Color
    , robotAccent : Color
    , robotMarkerText : Color
    , robotSubtleText : Color
    }


palette : Mode -> Palette
palette mode =
    case mode of
        Light ->
            { appBackground = rgb255 255 255 255
            , bodyText = rgb255 51 51 51
            , buttonBackground = rgb255 247 247 247
            , buttonBorder = rgb255 225 225 225
            , buttonText = rgb255 51 51 51
            , detailText = rgb255 112 112 112
            , emptyCellBackground = rgb255 247 247 247
            , emptyCellBorder = rgb255 225 225 225
            , facingText = rgb255 112 112 112
            , panelBackground = rgb255 247 247 247
            , panelBorder = rgb255 225 225 225
            , robotAccent = rgb255 78 91 86
            , robotMarkerText = rgb255 248 245 240
            , robotSubtleText = rgb255 225 225 225
            }

        Dark ->
            { appBackground = rgb255 31 31 29
            , bodyText = rgb255 232 226 216
            , buttonBackground = rgb255 55 56 52
            , buttonBorder = rgb255 92 93 87
            , buttonText = rgb255 232 226 216
            , detailText = rgb255 176 168 156
            , emptyCellBackground = rgb255 45 46 43
            , emptyCellBorder = rgb255 92 93 87
            , facingText = rgb255 188 180 169
            , panelBackground = rgb255 38 39 36
            , panelBorder = rgb255 80 81 76
            , robotAccent = rgb255 96 110 104
            , robotMarkerText = rgb255 241 237 230
            , robotSubtleText = rgb255 191 184 174
            }


toCssColor : Color -> String
toCssColor color =
    let
        rgba : { red : Float, green : Float, blue : Float, alpha : Float }
        rgba =
            toRgb color
    in
    "rgba("
        ++ String.fromInt (round (rgba.red * 255))
        ++ ", "
        ++ String.fromInt (round (rgba.green * 255))
        ++ ", "
        ++ String.fromInt (round (rgba.blue * 255))
        ++ ", "
        ++ String.fromFloat rgba.alpha
        ++ ")"
