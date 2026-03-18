module View exposing (Page(..), themeToggleDescription, toggleThemeMode, view)

import Element exposing (Element, centerY, column, el, fill, height, html, layout, padding, paddingEach, paddingXY, px, row, spacing, text, toRgb, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html
import Motorcycle.Page as MotorcyclePage
import Robot.Logic as RobotLogic
import Robot.Model as Robot
import Robot.View
import Svg exposing (circle, line, path, svg)
import Svg.Attributes as SvgAttributes
import View.Theme as Theme


type Page
    = MotorcyclePage
    | RobotPage


type alias Config msg =
    { selectPage : Page -> msg
    , setTheme : Theme.Mode -> msg
    , robotControls : Robot.View.Controls msg
    }


view :
    { a
        | robot : Robot.Robot
        , history : List RobotLogic.HistoryEntry
        , themeMode : Theme.Mode
        , currentPage : Page
    }
    -> Config msg
    -> Html.Html msg
view model config =
    layout
        []
        (page model config)


page :
    { a
        | robot : Robot.Robot
        , history : List RobotLogic.HistoryEntry
        , themeMode : Theme.Mode
        , currentPage : Page
    }
    -> Config msg
    -> Element msg
page model config =
    let
        colors =
            Theme.palette model.themeMode
    in
    column
        [ width fill
        , height fill
        , Background.color colors.appBackground
        , Font.color colors.bodyText
        , spacing 40
        , padding 40
        ]
        [ siteHeader colors model.currentPage model.themeMode config
        , pageBody colors model config.robotControls
        ]


siteHeader : Theme.Palette -> Page -> Theme.Mode -> Config msg -> Element msg
siteHeader colors currentPage themeMode config =
    row
        [ width fill
        , paddingEach { top = 8, right = 0, bottom = 8, left = 0 }
        ]
        [ row
            [ spacing 32
            , centerY
            ]
            [ el
                [ Font.size 20
                , Font.semiBold
                , centerY
                ]
                (text "Fitzbeach")
            , row
                [ spacing 24
                , centerY
                ]
                [ menuButton colors currentPage MotorcyclePage "Motorcycle" config
                , menuButton colors currentPage RobotPage "Robot" config
                ]
            ]
        , el [ width fill ] Element.none
        , themeToggleButton colors themeMode config
        ]


menuButton : Theme.Palette -> Page -> Page -> String -> Config msg -> Element msg
menuButton colors currentPage targetPage label config =
    Input.button
        [ Background.color colors.appBackground
        , Border.widthEach
            { top = 0, right = 0, bottom = 1, left = 0 }
        , Border.color
            (if currentPage == targetPage then
                colors.bodyText

             else
                colors.panelBorder
            )
        , paddingEach { top = 6, right = 0, bottom = 8, left = 0 }
        , Font.size 15
        , Font.color
            (if currentPage == targetPage then
                colors.bodyText

             else
                colors.detailText
            )
        ]
        { onPress = Just (config.selectPage targetPage)
        , label = text label
        }


pageBody :
    Theme.Palette
    ->
        { a
            | robot : Robot.Robot
            , history : List RobotLogic.HistoryEntry
            , currentPage : Page
        }
    -> Robot.View.Controls msg
    -> Element msg
pageBody colors model robotControls =
    case model.currentPage of
        MotorcyclePage ->
            MotorcyclePage.view colors

        RobotPage ->
            Robot.View.page colors model robotControls


themeToggleButton : Theme.Palette -> Theme.Mode -> Config msg -> Element msg
themeToggleButton colors activeMode config =
    let
        nextMode =
            toggleThemeMode activeMode
    in
    Input.button
        [ Background.color colors.buttonBackground
        , Border.rounded 18
        , Border.width 1
        , Border.color colors.buttonBorder
        , paddingXY 16 12
        , Region.description (themeToggleDescription nextMode)
        ]
        { onPress = Just (config.setTheme nextMode)
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
        [ path
            [ SvgAttributes.d "M14.3 2.7C10 3.5 6.75 7.28 6.75 11.8C6.75 16.9 10.9 21.05 16 21.05C17.26 21.05 18.47 20.8 19.57 20.33C17.96 20.08 16.45 19.31 15.27 18.13C11.84 14.7 11.52 9.28 14.3 2.7Z"
            , SvgAttributes.fill fillColor
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
