module View.Theme exposing (Mode(..), Palette, palette)

import Element exposing (Color, rgb255)


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
            { appBackground = rgb255 245 242 236
            , bodyText = rgb255 44 42 39
            , buttonBackground = rgb255 239 234 227
            , buttonBorder = rgb255 206 198 188
            , buttonText = rgb255 63 59 55
            , detailText = rgb255 122 114 106
            , emptyCellBackground = rgb255 247 244 238
            , emptyCellBorder = rgb255 214 207 198
            , facingText = rgb255 108 101 94
            , panelBackground = rgb255 251 249 245
            , panelBorder = rgb255 211 203 193
            , robotAccent = rgb255 78 91 86
            , robotMarkerText = rgb255 248 245 240
            , robotSubtleText = rgb255 218 212 204
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
