module Main exposing
    ( Command(..)
    , HistoryEntry
    , Model
    , Msg(..)
    , applyCommand
    , commandFromKey
    , initModel
    , main
    , themeToggleDescription
    , toggleThemeMode
    , undo
    , update
    )

import Browser
import Browser.Events
import Element exposing (Element, centerX, centerY, column, el, fill, height, html, layout, padding, paddingXY, px, row, spacing, text, toRgb, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html
import Json.Decode as Decode
import Robot
import Svg exposing (circle, line, path, svg)
import Svg.Attributes as SvgAttributes
import View.Grid as Grid
import View.Theme as Theme


type alias Model =
    { robot : Robot.Robot
    , history : List HistoryEntry
    , themeMode : Theme.Mode
    }


type alias HistoryEntry =
    { command : Command
    , previousRobot : Robot.Robot
    }


type Command
    = MoveForwardCommand
    | TurnLeftCommand
    | TurnRightCommand


type Msg
    = MoveForward
    | TurnLeft
    | TurnRight
    | Undo
    | Reset
    | KeyboardCommand Command
    | IgnoreKeyPress
    | SetTheme Theme.Mode


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initModel, Cmd.none )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MoveForward ->
            ( applyCommand MoveForwardCommand model, Cmd.none )

        TurnLeft ->
            ( applyCommand TurnLeftCommand model, Cmd.none )

        TurnRight ->
            ( applyCommand TurnRightCommand model, Cmd.none )

        KeyboardCommand command ->
            ( applyCommand command model, Cmd.none )

        IgnoreKeyPress ->
            ( model, Cmd.none )

        Undo ->
            ( undo model, Cmd.none )

        Reset ->
            ( initModel, Cmd.none )

        SetTheme mode ->
            ( { model | themeMode = mode }, Cmd.none )


initModel : Model
initModel =
    { robot = Robot.initialRobot
    , history = []
    , themeMode = Theme.Light
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onKeyDown
        (Decode.map keyPressToMsg (Decode.field "key" Decode.string))


keyPressToMsg : String -> Msg
keyPressToMsg key =
    case commandFromKey key of
        Just command ->
            KeyboardCommand command

        Nothing ->
            IgnoreKeyPress


commandFromKey : String -> Maybe Command
commandFromKey key =
    case key of
        "ArrowUp" ->
            Just MoveForwardCommand

        "ArrowLeft" ->
            Just TurnLeftCommand

        "ArrowRight" ->
            Just TurnRightCommand

        _ ->
            Nothing


applyCommand : Command -> Model -> Model
applyCommand command model =
    let
        updatedRobot =
            updateRobot command model.robot
    in
    if updatedRobot == model.robot then
        model

    else
        { model
            | robot = updatedRobot
            , history =
                { command = command
                , previousRobot = model.robot
                }
                    :: model.history
        }


undo : Model -> Model
undo model =
    case model.history of
        latestEntry :: restOfHistory ->
            { model
                | robot = latestEntry.previousRobot
                , history = restOfHistory
            }

        _ ->
            model


updateRobot : Command -> Robot.Robot -> Robot.Robot
updateRobot command robot =
    case command of
        MoveForwardCommand ->
            Robot.moveForward robot

        TurnLeftCommand ->
            Robot.turnLeft robot

        TurnRightCommand ->
            Robot.turnRight robot


view : Model -> Html.Html Msg
view model =
    layout
        []
        (page model)


page : Model -> Element Msg
page model =
    let
        colors =
            Theme.palette model.themeMode
    in
    column
        [ width fill
        , height fill
        , Background.color colors.appBackground
        , Font.color colors.bodyText
        , centerX
        , centerY
        , spacing 28
        , padding 40
        ]
        [ column
            [ centerX
            , spacing 8
            ]
            [ el [ centerX, Font.size 30 ] (text "Robot") ]
        , themeToggleButton colors model.themeMode
        , Grid.board colors model.robot
        , controlRow colors
        , commandHistory colors (List.map .command model.history)
        ]


themeToggleButton : Theme.Palette -> Theme.Mode -> Element Msg
themeToggleButton colors activeMode =
    let
        nextMode =
            toggleThemeMode activeMode
    in
    Input.button
        [ centerX
        , Background.color colors.buttonBackground
        , Border.rounded 18
        , Border.width 1
        , Border.color colors.buttonBorder
        , paddingXY 16 12
        , Region.description (themeToggleDescription nextMode)
        ]
        { onPress = Just (SetTheme nextMode)
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


themeToggleIcon : Theme.Palette -> Theme.Mode -> Element Msg
themeToggleIcon colors mode =
    case mode of
        Theme.Light ->
            sunIcon colors

        Theme.Dark ->
            moonIcon colors


sunIcon : Theme.Palette -> Element Msg
sunIcon colors =
    el
        [ width (px 24)
        , height (px 24)
        ]
        (html (sunSvg (cssColor colors.buttonText)))


moonIcon : Theme.Palette -> Element Msg
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


controlRow : Theme.Palette -> Element Msg
controlRow colors =
    row
        [ centerX
        , spacing 12
        ]
        [ controlButton colors "Move Forward" (Just MoveForward)
        , controlButton colors "Turn Left" (Just TurnLeft)
        , controlButton colors "Turn Right" (Just TurnRight)
        , controlButton colors "Undo" (Just Undo)
        , controlButton colors "Reset" (Just Reset)
        ]


controlButton : Theme.Palette -> String -> Maybe Msg -> Element Msg
controlButton colors label onPress =
    Input.button
        [ Background.color colors.buttonBackground
        , Border.rounded 16
        , Border.width 1
        , Border.color colors.buttonBorder
        , paddingXY 18 12
        , Font.size 14
        , Font.color colors.buttonText
        ]
        { onPress = onPress
        , label = text label
        }


commandHistory : Theme.Palette -> List Command -> Element Msg
commandHistory colors history =
    column
        [ width (px 340)
        , centerX
        , spacing 10
        ]
        [ el [ Font.size 14, Font.color colors.detailText ] (text "Command History")
        , case history of
            latest :: rest ->
                column
                    [ width fill
                    , spacing 8
                    ]
                    (historyItem colors True latest :: List.map (historyItem colors False) (List.take 5 rest))

            [] ->
                el
                    [ width fill
                    , Background.color colors.buttonBackground
                    , Border.rounded 16
                    , Border.width 1
                    , Border.color colors.buttonBorder
                    , paddingXY 18 12
                    , Font.size 14
                    , Font.color colors.buttonText
                    ]
                    (text "No commands yet")
        ]


historyItem : Theme.Palette -> Bool -> Command -> Element Msg
historyItem colors isLatest command =
    el
        [ width fill
        , Background.color
            (if isLatest then
                colors.buttonBackground

             else
                colors.buttonBackground
            )
        , Border.rounded 16
        , Border.width 1
        , Border.color colors.buttonBorder
        , paddingXY 18 12
        , Font.size 14
        , Font.color colors.buttonText
        ]
        (text
            (if isLatest then
                "Latest: " ++ commandLabel command

             else
                commandLabel command
            )
        )


commandLabel : Command -> String
commandLabel command =
    case command of
        MoveForwardCommand ->
            "Move Forward"

        TurnLeftCommand ->
            "Turn Left"

        TurnRightCommand ->
            "Turn Right"
