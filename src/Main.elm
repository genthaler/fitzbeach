module Main exposing (main)

import Browser
import Browser.Events
import Element exposing (Element, centerX, centerY, column, el, fill, height, layout, padding, paddingXY, px, row, spacing, text, width)
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
    { robot : Robot.Robot
    , history : List Command
    }


type Command
    = MoveForwardCommand
    | TurnLeftCommand
    | TurnRightCommand


type Msg
    = MoveForward
    | TurnLeft
    | TurnRight
    | Reset
    | KeyPressed String


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

        Reset ->
            ( initModel, Cmd.none )

        KeyPressed key ->
            ( applyKey key model, Cmd.none )


initModel : Model
initModel =
    { robot = Robot.initialRobot
    , history = []
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onKeyDown
        (Decode.map KeyPressed (Decode.field "key" Decode.string))


applyKey : String -> Model -> Model
applyKey key model =
    case commandFromKey key of
        Just command ->
            applyCommand command model

        Nothing ->
            model


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
    { model
        | robot = updateRobot command model.robot
        , history = command :: model.history
    }


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
        , Grid.board model.robot
        , controlRow
        , commandHistory model.history
        ]


controlRow : Element Msg
controlRow =
    row
        [ centerX
        , spacing 12
        ]
        [ controlButton "Move Forward" MoveForward
        , controlButton "Turn Left" TurnLeft
        , controlButton "Turn Right" TurnRight
        , controlButton "Reset" Reset
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


commandHistory : List Command -> Element Msg
commandHistory history =
    column
        [ width (px 340)
        , centerX
        , spacing 10
        ]
        [ el [ Font.size 14, Font.color Theme.detailText ] (text "Command History")
        , case history of
            latest :: rest ->
                column
                    [ width fill
                    , spacing 8
                    ]
                    (historyItem True latest :: List.map (historyItem False) (List.take 5 rest))

            [] ->
                el
                    [ width fill
                    , Background.color Theme.panelBackground
                    , Border.rounded 16
                    , Border.width 1
                    , Border.color Theme.panelBorder
                    , padding 14
                    , Font.size 14
                    , Font.color Theme.detailText
                    ]
                    (text "No commands yet")
        ]


historyItem : Bool -> Command -> Element Msg
historyItem isLatest command =
    el
        [ width fill
        , Background.color
            (if isLatest then
                Theme.buttonBackground

             else
                Theme.panelBackground
            )
        , Border.rounded 16
        , Border.width 1
        , Border.color Theme.panelBorder
        , paddingXY 14 12
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
