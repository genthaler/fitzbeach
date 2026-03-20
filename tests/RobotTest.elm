module RobotTest exposing (tests)

import Expect
import Robot exposing (Msg(..))
import Robot.Logic exposing (Command(..))
import Robot.Model exposing (Direction(..), facing, initialRobot, y)
import Test exposing (Test, describe, test)


tests : Test
tests =
    describe "Robot"
        [ test "MoveForward updates robot state and records history" <|
            \_ ->
                let
                    updatedModel =
                        Robot.update MoveForward Robot.initialModel
                in
                Expect.all
                    [ \_ -> Expect.equal 1 (y updatedModel.robot)
                    , \_ -> Expect.equal North (facing updatedModel.robot)
                    , \_ -> Expect.equal [ MoveForwardCommand ] (List.map .command updatedModel.history)
                    , \_ -> Expect.equal [ Robot.initialModel.robot ] (List.map .previousRobot updatedModel.history)
                    ]
                    ()
        , test "ApplyCommand and Undo preserve the existing behavior" <|
            \_ ->
                let
                    undoneModel =
                        Robot.initialModel
                            |> Robot.update (ApplyCommand MoveForwardCommand)
                            |> Robot.update (ApplyCommand TurnRightCommand)
                            |> Robot.update Undo
                in
                Expect.all
                    [ \_ -> Expect.equal 1 (y undoneModel.robot)
                    , \_ -> Expect.equal North (facing undoneModel.robot)
                    , \_ -> Expect.equal [ MoveForwardCommand ] (List.map .command undoneModel.history)
                    ]
                    ()
        , test "Reset restores the initial feature model" <|
            \_ ->
                let
                    resetModel =
                        Robot.initialModel
                            |> Robot.update MoveForward
                            |> Robot.update TurnLeft
                            |> Robot.update Reset
                in
                Expect.equal
                    { robot = initialRobot, history = [] }
                    resetModel
        ]
