module Robot.Feature exposing
    ( Model
    , Msg(..)
    , controls
    , initialModel
    , update
    )

import Robot.Logic as Logic
import Robot.Model as Robot
import Robot.View


type alias Model =
    { robot : Robot.Robot
    , history : List Logic.HistoryEntry
    }


type Msg
    = MoveForward
    | TurnLeft
    | TurnRight
    | Undo
    | Reset
    | ApplyCommand Logic.Command


initialModel : Model
initialModel =
    { robot = Robot.initialRobot
    , history = []
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        MoveForward ->
            Logic.applyCommand Logic.MoveForwardCommand model

        TurnLeft ->
            Logic.applyCommand Logic.TurnLeftCommand model

        TurnRight ->
            Logic.applyCommand Logic.TurnRightCommand model

        Undo ->
            Logic.undo model

        Reset ->
            initialModel

        ApplyCommand command ->
            Logic.applyCommand command model


controls : (Msg -> msg) -> Robot.View.Controls msg
controls toMsg =
    { moveForward = toMsg MoveForward
    , turnLeft = toMsg TurnLeft
    , turnRight = toMsg TurnRight
    , undo = toMsg Undo
    , reset = toMsg Reset
    }
