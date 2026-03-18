module Robot.Logic exposing (Command(..), HistoryEntry, applyCommand, canApplyCommand, commandFromKey, label, undo)

import Robot.Model as Robot


type Command
    = MoveForwardCommand
    | TurnLeftCommand
    | TurnRightCommand


type alias HistoryEntry =
    { command : Command
    , previousRobot : Robot.Robot
    }


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


applyCommand :
    Command
    -> { a | robot : Robot.Robot, history : List HistoryEntry }
    -> { a | robot : Robot.Robot, history : List HistoryEntry }
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


canApplyCommand : Command -> Robot.Robot -> Bool
canApplyCommand command robot =
    updateRobot command robot /= robot


undo :
    { a | robot : Robot.Robot, history : List HistoryEntry }
    -> { a | robot : Robot.Robot, history : List HistoryEntry }
undo model =
    case model.history of
        latestEntry :: restOfHistory ->
            { model
                | robot = latestEntry.previousRobot
                , history = restOfHistory
            }

        [] ->
            model


label : Command -> String
label command =
    case command of
        MoveForwardCommand ->
            "Move Forward"

        TurnLeftCommand ->
            "Turn Left"

        TurnRightCommand ->
            "Turn Right"


updateRobot : Command -> Robot.Robot -> Robot.Robot
updateRobot command robot =
    case command of
        MoveForwardCommand ->
            Robot.moveForward robot

        TurnLeftCommand ->
            Robot.turnLeft robot

        TurnRightCommand ->
            Robot.turnRight robot
