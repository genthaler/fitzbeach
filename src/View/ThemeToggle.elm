module View.ThemeToggle exposing
    ( themeToggleDescription
    , toggleThemeMode
    , view
    )

import Element exposing (Element, el, height, html, px, width)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Element.Region as Region
import Svg exposing (circle, defs, line, mask, rect, svg)
import Svg.Attributes as SvgAttributes
import View.Theme as Theme


type alias Point =
    { x : Float
    , y : Float
    }


view : Theme.Palette -> Theme.Mode -> msg -> Element msg
view colors activeMode onToggle =
    let
        nextMode : Theme.Mode
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


themeToggleIconViewBox : String
themeToggleIconViewBox =
    "0 0 "
        ++ String.fromInt themeToggleIconSize
        ++ " "
        ++ String.fromInt themeToggleIconSize


sunIcon : Theme.Palette -> Element msg
sunIcon colors =
    let
        strokeColor : String
        strokeColor =
            Theme.toCssColor colors.buttonText

        transparentFill : String
        transparentFill =
            "none"

        center : Float
        center =
            12

        sunBodyRadius : Float
        sunBodyRadius =
            4.5

        strokeWidth : Float
        strokeWidth =
            2

        rayVisibleGap : Float
        rayVisibleGap =
            4

        sunOuterRadius : Float
        sunOuterRadius =
            sunBodyRadius + (strokeWidth / 2)

        rayLength : Float
        rayLength =
            2.5

        strokeLinecap : String
        strokeLinecap =
            "round"

        rayAnglesInDegrees : List Float
        rayAnglesInDegrees =
            [ -90, -45, 0, 45, 90, 135, 180, 225 ]

        centerCoordinate : String
        centerCoordinate =
            String.fromFloat center

        sunRadius : String
        sunRadius =
            String.fromFloat sunBodyRadius

        rayStartDistance : Float
        rayStartDistance =
            sunOuterRadius + rayVisibleGap

        rayEndDistance : Float
        rayEndDistance =
            rayStartDistance + rayLength

        rayPoint : Float -> Float -> Point
        rayPoint distance angleInDegrees =
            let
                angleInRadians : Float
                angleInRadians =
                    degrees angleInDegrees
            in
            { x = center + (distance * cos angleInRadians)
            , y = center + (distance * sin angleInRadians)
            }

        ray : Float -> Svg.Svg msg
        ray angleInDegrees =
            let
                startPoint : Point
                startPoint =
                    rayPoint rayStartDistance angleInDegrees

                endPoint : Point
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
                [ SvgAttributes.viewBox themeToggleIconViewBox
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
        fillColor : String
        fillColor =
            Theme.toCssColor colors.buttonText

        transparentFill : String
        transparentFill =
            "none"

        maskId : String
        maskId =
            "theme-toggle-moon-mask"

        maskReference : String
        maskReference =
            "url(#" ++ maskId ++ ")"

        maskUnits : String
        maskUnits =
            "userSpaceOnUse"

        origin : String
        origin =
            "0"

        maskBackgroundFill : String
        maskBackgroundFill =
            "black"

        visibleMoonFill : String
        visibleMoonFill =
            "white"

        moonCenterX : Float
        moonCenterX =
            11.25

        moonCenterY : Float
        moonCenterY =
            12

        moonRadius : Float
        moonRadius =
            8.5

        shadowOffsetX : Float
        shadowOffsetX =
            4.75

        shadowOffsetY : Float
        shadowOffsetY =
            -2.5

        shadowRadiusMultiplier : Float
        shadowRadiusMultiplier =
            1

        shadowCenterX : Float
        shadowCenterX =
            moonCenterX + shadowOffsetX

        shadowCenterY : Float
        shadowCenterY =
            moonCenterY + shadowOffsetY

        shadowRadius : Float
        shadowRadius =
            moonRadius * shadowRadiusMultiplier
    in
    el
        [ width (px themeToggleIconSize)
        , height (px themeToggleIconSize)
        ]
        (html
            (svg
                [ SvgAttributes.viewBox themeToggleIconViewBox
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
