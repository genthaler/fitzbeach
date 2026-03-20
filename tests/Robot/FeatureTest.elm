module Robot.FeatureTest exposing (tests)

import Expect
import Robot.Feature as Feature exposing (Msg(..))
import Robot.Logic exposing (Command(..))
import Robot.Model exposing (Direction(..), facing, initialRobot, y)
import Test exposing (Test, describe, test)


tests : Test
tests =
    describe "Robot.Feature"
        [ test "MoveForward updates robot state and records history" <|
            \_ ->
                let
                    updatedModel =
                        Feature.update MoveForward Feature.initialModel
                in
                Expect.all
                    [ \_ -> Expect.equal 1 (y updatedModel.robot)
                    , \_ -> Expect.equal North (facing updatedModel.robot)
                    , \_ -> Expect.equal [ MoveForwardCommand ] (List.map .command updatedModel.history)
                    , \_ -> Expect.equal [ Feature.initialModel.robot ] (List.map .previousRobot updatedModel.history)
                    ]
                    ()
        , test "ApplyCommand and Undo preserve the existing behavior" <|
            \_ ->
                let
                    undoneModel =
                        Feature.initialModel
                            |> Feature.update (ApplyCommand MoveForwardCommand)
                            |> Feature.update (ApplyCommand TurnRightCommand)
                            |> Feature.update Undo
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
                        Feature.initialModel
                            |> Feature.update MoveForward
                            |> Feature.update TurnLeft
                            |> Feature.update Reset
                in
                Expect.equal
                    { robot = initialRobot, history = [] }
                    resetModel
        ]
