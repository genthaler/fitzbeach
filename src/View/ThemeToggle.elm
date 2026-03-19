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


themeToggleIconSize : Int
themeToggleIconSize =
    24


sunIcon : Theme.Palette -> Element msg
sunIcon colors =
    let
        strokeColor =
            cssColor colors.buttonText

        viewBox =
            "0 0 24 24"

        transparentFill =
            "none"

        center =
            12

        sunBodyRadius =
            4.5

        strokeWidth =
            2

        rayVisibleGap =
            4

        sunOuterRadius =
            sunBodyRadius + (strokeWidth / 2)

        rayLength =
            2.5

        strokeLinecap =
            "round"

        rayAnglesInDegrees =
            [ -90, -45, 0, 45, 90, 135, 180, 225 ]

        centerCoordinate =
            String.fromFloat center

        sunRadius =
            String.fromFloat sunBodyRadius

        rayStartDistance =
            sunOuterRadius + rayVisibleGap

        rayEndDistance =
            rayStartDistance + rayLength

        rayPoint distance angleInDegrees =
            let
                angleInRadians =
                    degrees angleInDegrees
            in
            { x = center + (distance * cos angleInRadians)
            , y = center + (distance * sin angleInRadians)
            }

        ray angleInDegrees =
            let
                startPoint =
                    rayPoint rayStartDistance angleInDegrees

                endPoint =
                    rayPoint rayEndDistance angleInDegrees
            in
            line
                [ SvgAttributes.x1 (String.fromFloat startPoint.x)
                , SvgAttributes.y1 (String.fromFloat startPoint.y)
                , SvgAttributes.x2 (String.fromFloat endPoint.x)
                , SvgAttributes.y2 (String.fromFloat endPoint.y)
                , SvgAttributes.stroke strokeColor
                , SvgAttributes.strokeWidth (String.fromFloat strokeWidth)
                , SvgAttributes.strokeLinecap strokeLinecap
                ]
                []
    in
    el
        [ width (px themeToggleIconSize)
        , height (px themeToggleIconSize)
        ]
        (html
            (svg
                [ SvgAttributes.viewBox viewBox
                , SvgAttributes.width (String.fromInt themeToggleIconSize)
                , SvgAttributes.height (String.fromInt themeToggleIconSize)
                , SvgAttributes.fill transparentFill
                ]
                (circle
                    [ SvgAttributes.cx centerCoordinate
                    , SvgAttributes.cy centerCoordinate
                    , SvgAttributes.r sunRadius
                    , SvgAttributes.stroke strokeColor
                    , SvgAttributes.strokeWidth (String.fromFloat strokeWidth)
                    ]
                    []
                    :: List.map ray rayAnglesInDegrees
                )
            )
        )


moonIcon : Theme.Palette -> Element msg
moonIcon colors =
    let
        fillColor =
            cssColor colors.buttonText

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
            11.25

        moonCenterY =
            12

        moonRadius =
            8.5

        shadowOffsetX =
            4.75

        shadowOffsetY =
            -2.5

        shadowRadiusMultiplier =
            1

        shadowCenterX =
            moonCenterX + shadowOffsetX

        shadowCenterY =
            moonCenterY + shadowOffsetY

        shadowRadius =
            moonRadius * shadowRadiusMultiplier
    in
    el
        [ width (px themeToggleIconSize)
        , height (px themeToggleIconSize)
        ]
        (html
            (svg
                [ SvgAttributes.viewBox viewBox
                , SvgAttributes.width (String.fromInt themeToggleIconSize)
                , SvgAttributes.height (String.fromInt themeToggleIconSize)
                , SvgAttributes.fill transparentFill
                ]
                [ defs []
                    [ mask
                        [ SvgAttributes.id maskId
                        , SvgAttributes.maskUnits maskUnits
                        , SvgAttributes.x origin
                        , SvgAttributes.y origin
                        , SvgAttributes.width (String.fromInt themeToggleIconSize)
                        , SvgAttributes.height (String.fromInt themeToggleIconSize)
                        ]
                        [ rect
                            [ SvgAttributes.x origin
                            , SvgAttributes.y origin
                            , SvgAttributes.width (String.fromInt themeToggleIconSize)
                            , SvgAttributes.height (String.fromInt themeToggleIconSize)
                            , SvgAttributes.fill maskBackgroundFill
                            ]
                            []
                        , circle
                            [ SvgAttributes.cx (String.fromFloat moonCenterX)
                            , SvgAttributes.cy (String.fromFloat moonCenterY)
                            , SvgAttributes.r (String.fromFloat moonRadius)
                            , SvgAttributes.fill visibleMoonFill
                            ]
                            []
                        , circle
                            [ SvgAttributes.cx (String.fromFloat shadowCenterX)
                            , SvgAttributes.cy (String.fromFloat shadowCenterY)
                            , SvgAttributes.r (String.fromFloat shadowRadius)
                            , SvgAttributes.fill maskBackgroundFill
                            ]
                            []
                        ]
                    ]
                , circle
                    [ SvgAttributes.cx (String.fromFloat moonCenterX)
                    , SvgAttributes.cy (String.fromFloat moonCenterY)
                    , SvgAttributes.r (String.fromFloat moonRadius)
                    , SvgAttributes.fill fillColor
                    , SvgAttributes.mask maskReference
                    ]
                    []
                ]
            )
        )


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
