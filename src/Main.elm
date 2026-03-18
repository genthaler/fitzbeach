module Main exposing
    ( Model
    , Msg(..)
    , initModel
    , main
    , update
    )

import Browser
import Browser.Events
import Html
import Json.Decode as Decode
import Robot.Logic as RobotLogic
import Robot.Model as Robot
import View
import View.Theme as Theme


type alias Model =
    { robot : Robot.Robot
    , history : List RobotLogic.HistoryEntry
    , themeMode : Theme.Mode
    , currentPage : View.Page
    }


type Msg
    = MoveForward
    | TurnLeft
    | TurnRight
    | Undo
    | Reset
    | KeyboardCommand RobotLogic.Command
    | IgnoreKeyPress
    | SetTheme Theme.Mode
    | SelectPage View.Page


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
            ( RobotLogic.applyCommand RobotLogic.MoveForwardCommand model, Cmd.none )

        TurnLeft ->
            ( RobotLogic.applyCommand RobotLogic.TurnLeftCommand model, Cmd.none )

        TurnRight ->
            ( RobotLogic.applyCommand RobotLogic.TurnRightCommand model, Cmd.none )

        KeyboardCommand command ->
            ( RobotLogic.applyCommand command model, Cmd.none )

        IgnoreKeyPress ->
            ( model, Cmd.none )

        Undo ->
            ( RobotLogic.undo model, Cmd.none )

        Reset ->
            ( initModel, Cmd.none )

        SetTheme mode ->
            ( { model | themeMode = mode }, Cmd.none )

        SelectPage selectedPage ->
            ( { model | currentPage = selectedPage }, Cmd.none )


initModel : Model
initModel =
    { robot = Robot.initialRobot
    , history = []
    , themeMode = Theme.Light
    , currentPage = View.MotorcyclePage
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.currentPage of
        View.RobotPage ->
            Browser.Events.onKeyDown
                (Decode.map keyPressToMsg (Decode.field "key" Decode.string))

        View.MotorcyclePage ->
            Sub.none


keyPressToMsg : String -> Msg
keyPressToMsg key =
    case RobotLogic.commandFromKey key of
        Just command ->
            KeyboardCommand command

        Nothing ->
            IgnoreKeyPress


view : Model -> Html.Html Msg
view model =
    View.view model
        { selectPage = SelectPage
        , setTheme = SetTheme
        , robotControls =
            { moveForward = MoveForward
            , turnLeft = TurnLeft
            , turnRight = TurnRight
            , undo = Undo
            , reset = Reset
            }
        }
