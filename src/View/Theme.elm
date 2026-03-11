module View.Theme exposing
    ( appBackground
    , bodyText
    , buttonBackground
    , buttonBorder
    , buttonText
    , detailText
    , emptyCellBackground
    , emptyCellBorder
    , facingText
    , panelBackground
    , panelBorder
    , robotAccent
    , robotMarkerText
    , robotSubtleText
    )

import Element exposing (Color, rgb255)


appBackground : Color
appBackground =
    rgb255 245 242 236


bodyText : Color
bodyText =
    rgb255 44 42 39


detailText : Color
detailText =
    rgb255 122 114 106


facingText : Color
facingText =
    rgb255 108 101 94


panelBackground : Color
panelBackground =
    rgb255 251 249 245


panelBorder : Color
panelBorder =
    rgb255 211 203 193


emptyCellBackground : Color
emptyCellBackground =
    rgb255 247 244 238


emptyCellBorder : Color
emptyCellBorder =
    rgb255 214 207 198


robotAccent : Color
robotAccent =
    rgb255 78 91 86


robotMarkerText : Color
robotMarkerText =
    rgb255 248 245 240


robotSubtleText : Color
robotSubtleText =
    rgb255 218 212 204


buttonBackground : Color
buttonBackground =
    rgb255 239 234 227


buttonBorder : Color
buttonBorder =
    rgb255 206 198 188


buttonText : Color
buttonText =
    rgb255 63 59 55
