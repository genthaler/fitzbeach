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
    let
        iconSize =
            "24"

        viewBox =
            "0 0 24 24"

        transparentFill =
            "none"

        center =
            "12"

        sunBodyRadius =
            "4.5"

        strokeWidth =
            "2"

        strokeLinecap =
            "round"

        verticalRayInnerY =
            "4.25"

        verticalRayOuterY =
            "1.75"

        bottomRayInnerY =
            "19.75"

        bottomRayOuterY =
            "22.25"

        horizontalRayInnerX =
            "4.25"

        horizontalRayOuterX =
            "1.75"

        rightRayInnerX =
            "19.75"

        rightRayOuterX =
            "22.25"

        diagonalRayInnerStart =
            "6.2"

        diagonalRayInnerEnd =
            "17.8"

        diagonalRayOuterStart =
            "4.4"

        diagonalRayOuterEnd =
            "19.6"

        ray x1 y1 x2 y2 =
            line
                [ SvgAttributes.x1 x1
                , SvgAttributes.y1 y1
                , SvgAttributes.x2 x2
                , SvgAttributes.y2 y2
                , SvgAttributes.stroke strokeColor
                , SvgAttributes.strokeWidth strokeWidth
                , SvgAttributes.strokeLinecap strokeLinecap
                ]
                []
    in
    svg
        [ SvgAttributes.viewBox viewBox
        , SvgAttributes.width iconSize
        , SvgAttributes.height iconSize
        , SvgAttributes.fill transparentFill
        ]
        [ circle
            [ SvgAttributes.cx center
            , SvgAttributes.cy center
            , SvgAttributes.r sunBodyRadius
            , SvgAttributes.stroke strokeColor
            , SvgAttributes.strokeWidth strokeWidth
            ]
            []
        , ray center verticalRayOuterY center verticalRayInnerY
        , ray center bottomRayInnerY center bottomRayOuterY
        , ray horizontalRayOuterX center horizontalRayInnerX center
        , ray rightRayInnerX center rightRayOuterX center
        , ray diagonalRayOuterStart diagonalRayOuterStart diagonalRayInnerStart diagonalRayInnerStart
        , ray diagonalRayInnerEnd diagonalRayInnerEnd diagonalRayOuterEnd diagonalRayOuterEnd
        , ray diagonalRayInnerEnd diagonalRayInnerStart diagonalRayOuterEnd diagonalRayOuterStart
        , ray diagonalRayOuterStart diagonalRayOuterEnd diagonalRayInnerStart diagonalRayInnerEnd
        ]


moonSvg : String -> Svg.Svg msg
moonSvg fillColor =
    let
        iconSize =
            "24"

        viewBox =
            "0 0 24 24"

        transparentFill =
            "none"

        maskId =
            "theme-toggle-moon-mask"

        maskReference =
            "url(#" ++ maskId ++ ")"

        maskUnits =
            "userSpaceOnUse"

        origin =
            "0"

        maskBackgroundFill =
            "black"

        visibleMoonFill =
            "white"

        moonCenterX =
            "11.25"

        moonCenterY =
            "12"

        moonRadius =
            "8.5"

        shadowCenterX =
            "16"

        shadowCenterY =
            "9.5"

        shadowRadius =
            "8.5"
    in
    svg
        [ SvgAttributes.viewBox viewBox
        , SvgAttributes.width iconSize
        , SvgAttributes.height iconSize
        , SvgAttributes.fill transparentFill
        ]
        [ defs []
            [ mask
                [ SvgAttributes.id maskId
                , SvgAttributes.maskUnits maskUnits
                , SvgAttributes.x origin
                , SvgAttributes.y origin
                , SvgAttributes.width iconSize
                , SvgAttributes.height iconSize
                ]
                [ rect
                    [ SvgAttributes.x origin
                    , SvgAttributes.y origin
                    , SvgAttributes.width iconSize
                    , SvgAttributes.height iconSize
                    , SvgAttributes.fill maskBackgroundFill
                    ]
                    []
                , circle
                    [ SvgAttributes.cx moonCenterX
                    , SvgAttributes.cy moonCenterY
                    , SvgAttributes.r moonRadius
                    , SvgAttributes.fill visibleMoonFill
                    ]
                    []
                , circle
                    [ SvgAttributes.cx shadowCenterX
                    , SvgAttributes.cy shadowCenterY
                    , SvgAttributes.r shadowRadius
                    , SvgAttributes.fill maskBackgroundFill
                    ]
                    []
                ]
            ]
        , circle
            [ SvgAttributes.cx moonCenterX
            , SvgAttributes.cy moonCenterY
            , SvgAttributes.r moonRadius
            , SvgAttributes.fill fillColor
            , SvgAttributes.mask maskReference
            ]
            []
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
