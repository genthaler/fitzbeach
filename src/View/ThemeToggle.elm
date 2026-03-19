module View.ThemeToggle exposing
    ( themeToggleDescription
    , toggleThemeMode
    , view
    )

import Element exposing (Element, el, height, html, px, toRgb, width)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Element.Region as Region
import Svg exposing (circle, defs, line, mask, rect, svg)
import Svg.Attributes as SvgAttributes
import View.Theme as Theme


view : Theme.Palette -> Theme.Mode -> msg -> Element msg
view colors activeMode onToggle =
    let
        nextMode =
            toggleThemeMode activeMode
    in
    Input.button
        [ Background.color colors.buttonBackground
        , Border.rounded 18
        , Border.width 1
        , Border.color colors.buttonBorder
        , Element.paddingXY 16 12
        , Region.description (themeToggleDescription nextMode)
        ]
        { onPress = Just onToggle
        , label = themeToggleIcon colors nextMode
        }


toggleThemeMode : Theme.Mode -> Theme.Mode
toggleThemeMode mode =
    case mode of
        Theme.Light ->
            Theme.Dark

        Theme.Dark ->
            Theme.Light


themeToggleDescription : Theme.Mode -> String
themeToggleDescription mode =
    case mode of
        Theme.Light ->
            "Switch to light theme"

        Theme.Dark ->
            "Switch to dark theme"


themeToggleIcon : Theme.Palette -> Theme.Mode -> Element msg
themeToggleIcon colors mode =
    case mode of
        Theme.Light ->
            sunIcon colors

        Theme.Dark ->
            moonIcon colors


sunIcon : Theme.Palette -> Element msg
sunIcon colors =
    el
        [ width (px 24)
        , height (px 24)
        ]
        (html (sunSvg (cssColor colors.buttonText)))


moonIcon : Theme.Palette -> Element msg
moonIcon colors =
    el
        [ width (px 24)
        , height (px 24)
        ]
        (html (moonSvg (cssColor colors.buttonText)))


sunSvg : String -> Svg.Svg msg
sunSvg strokeColor =
    svg
        [ SvgAttributes.viewBox "0 0 24 24"
        , SvgAttributes.width "24"
        , SvgAttributes.height "24"
        , SvgAttributes.fill "none"
        ]
        [ circle
            [ SvgAttributes.cx "12"
            , SvgAttributes.cy "12"
            , SvgAttributes.r "4.5"
            , SvgAttributes.stroke strokeColor
            , SvgAttributes.strokeWidth "2"
            ]
            []
        , line
            ([ SvgAttributes.x1 "12"
             , SvgAttributes.y1 "1.75"
             , SvgAttributes.x2 "12"
             , SvgAttributes.y2 "4.25"
             ]
                ++ rayAttributes strokeColor
            )
            []
        , line
            ([ SvgAttributes.x1 "12"
             , SvgAttributes.y1 "19.75"
             , SvgAttributes.x2 "12"
             , SvgAttributes.y2 "22.25"
             ]
                ++ rayAttributes strokeColor
            )
            []
        , line
            ([ SvgAttributes.x1 "1.75"
             , SvgAttributes.y1 "12"
             , SvgAttributes.x2 "4.25"
             , SvgAttributes.y2 "12"
             ]
                ++ rayAttributes strokeColor
            )
            []
        , line
            ([ SvgAttributes.x1 "19.75"
             , SvgAttributes.y1 "12"
             , SvgAttributes.x2 "22.25"
             , SvgAttributes.y2 "12"
             ]
                ++ rayAttributes strokeColor
            )
            []
        , line
            ([ SvgAttributes.x1 "4.4"
             , SvgAttributes.y1 "4.4"
             , SvgAttributes.x2 "6.2"
             , SvgAttributes.y2 "6.2"
             ]
                ++ rayAttributes strokeColor
            )
            []
        , line
            ([ SvgAttributes.x1 "17.8"
             , SvgAttributes.y1 "17.8"
             , SvgAttributes.x2 "19.6"
             , SvgAttributes.y2 "19.6"
             ]
                ++ rayAttributes strokeColor
            )
            []
        , line
            ([ SvgAttributes.x1 "17.8"
             , SvgAttributes.y1 "6.2"
             , SvgAttributes.x2 "19.6"
             , SvgAttributes.y2 "4.4"
             ]
                ++ rayAttributes strokeColor
            )
            []
        , line
            ([ SvgAttributes.x1 "4.4"
             , SvgAttributes.y1 "19.6"
             , SvgAttributes.x2 "6.2"
             , SvgAttributes.y2 "17.8"
             ]
                ++ rayAttributes strokeColor
            )
            []
        ]


moonSvg : String -> Svg.Svg msg
moonSvg fillColor =
    svg
        [ SvgAttributes.viewBox "0 0 24 24"
        , SvgAttributes.width "24"
        , SvgAttributes.height "24"
        , SvgAttributes.fill "none"
        ]
        [ defs []
            [ mask
                [ SvgAttributes.id "theme-toggle-moon-mask"
                , SvgAttributes.maskUnits "userSpaceOnUse"
                , SvgAttributes.x "0"
                , SvgAttributes.y "0"
                , SvgAttributes.width "24"
                , SvgAttributes.height "24"
                ]
                [ rect
                    [ SvgAttributes.x "0"
                    , SvgAttributes.y "0"
                    , SvgAttributes.width "24"
                    , SvgAttributes.height "24"
                    , SvgAttributes.fill "black"
                    ]
                    []
                , circle
                    [ SvgAttributes.cx "11.25"
                    , SvgAttributes.cy "12"
                    , SvgAttributes.r "8.5"
                    , SvgAttributes.fill "white"
                    ]
                    []
                , circle
                    [ SvgAttributes.cx "16"
                    , SvgAttributes.cy "9.5"
                    , SvgAttributes.r "8.5"
                    , SvgAttributes.fill "black"
                    ]
                    []
                ]
            ]
        , circle
            [ SvgAttributes.cx "11.25"
            , SvgAttributes.cy "12"
            , SvgAttributes.r "8.5"
            , SvgAttributes.fill fillColor
            , SvgAttributes.mask "url(#theme-toggle-moon-mask)"
            ]
            []
        ]


rayAttributes : String -> List (Svg.Attribute msg)
rayAttributes strokeColor =
    [ SvgAttributes.stroke strokeColor
    , SvgAttributes.strokeWidth "2"
    , SvgAttributes.strokeLinecap "round"
    ]


cssColor : Element.Color -> String
cssColor color =
    let
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
