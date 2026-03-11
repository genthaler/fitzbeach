module Main exposing (main)

import Browser
import Browser.Events
import Element exposing (Element, centerX, centerY, column, el, fill, height, layout, padding, paddingXY, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Json.Decode as Decode
import Robot
import View.Grid as Grid
import View.Theme as Theme


type alias Model =
    Robot.Robot


type Msg
    = MoveForward
    | TurnLeft
    | TurnRight
    | KeyPressed String


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( Robot.initialRobot, Cmd.none )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MoveForward ->
            ( Robot.moveForward model, Cmd.none )

        TurnLeft ->
            ( Robot.turnLeft model, Cmd.none )

        TurnRight ->
            ( Robot.turnRight model, Cmd.none )

        KeyPressed key ->
            ( applyKey key model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onKeyDown
        (Decode.map KeyPressed (Decode.field "key" Decode.string))


applyKey : String -> Model -> Model
applyKey key model =
    case key of
        "ArrowUp" ->
            Robot.moveForward model

        "ArrowLeft" ->
            Robot.turnLeft model

        "ArrowRight" ->
            Robot.turnRight model

        _ ->
            model


view : Model -> Html.Html Msg
view model =
    layout
        []
        (content model)


content : Model -> Element Msg
content robot =
    column
        [ width fill
        , height fill
        , Background.color Theme.appBackground
        , Font.color Theme.bodyText
        , centerX
        , centerY
        , spacing 28
        , padding 40
        ]
        [ column
            [ centerX
            , spacing 8
            ]
            [ el [ centerX, Font.size 14, Font.color Theme.detailText ] (text "5x5 Robot Grid")
            , el [ centerX, Font.size 34 ] (text "Bellroy Robot")
            ]
        , Grid.board robot
        , controls
        ]


controls : Element Msg
controls =
    row
        [ centerX
        , spacing 12
        ]
        [ controlButton "Move Forward" MoveForward
        , controlButton "Turn Left" TurnLeft
        , controlButton "Turn Right" TurnRight
        ]


controlButton : String -> Msg -> Element Msg
controlButton label msg =
    Input.button
        [ Background.color Theme.buttonBackground
        , Border.rounded 999
        , Border.width 1
        , Border.color Theme.buttonBorder
        , paddingXY 18 12
        , Font.size 14
        , Font.color Theme.buttonText
        ]
        { onPress = Just msg
        , label = text label
        }
