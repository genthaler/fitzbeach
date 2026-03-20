module Robot.LogicTest exposing (tests)

import Expect
import Robot.Feature as Feature
import Robot.Logic exposing (Command(..), applyCommand, canApplyCommand, commandFromKey, undo)
import Robot.Model exposing (Direction(..), Robot, facing, fromCoordinates, initialRobot, y)
import Test exposing (Test, describe, test)


tests : Test
tests =
    describe "Robot.Logic"
        [ test "applyCommand MoveForward updates robot and records history" <|
            \_ ->
                let
                    updatedModel =
                        applyCommand MoveForwardCommand Feature.initialModel
                in
                Expect.all
                    [ \_ -> Expect.equal 1 (y updatedModel.robot)
                    , \_ -> Expect.equal North (facing updatedModel.robot)
                    , \_ -> Expect.equal [ MoveForwardCommand ] (List.map .command updatedModel.history)
                    , \_ -> Expect.equal [ Feature.initialModel.robot ] (List.map .previousRobot updatedModel.history)
                    ]
                    ()
        , test "applyCommand ignores a blocked move at the wall" <|
            \_ ->
                let
                    initialModel =
                        Feature.initialModel

                    edgeModel =
                        { initialModel | robot = robot 0 4 North }

                    updatedModel =
                        applyCommand MoveForwardCommand edgeModel
                in
                Expect.all
                    [ \_ -> Expect.equal edgeModel.robot updatedModel.robot
                    , \_ -> Expect.equal [] updatedModel.history
                    ]
                    ()
        , test "canApplyCommand rejects blocked forward moves at the wall" <|
            \_ ->
                Expect.equal False (canApplyCommand MoveForwardCommand (robot 0 4 North))
        , test "canApplyCommand allows valid forward moves and turns" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal True (canApplyCommand MoveForwardCommand Feature.initialModel.robot)
                    , \_ -> Expect.equal True (canApplyCommand TurnLeftCommand Feature.initialModel.robot)
                    , \_ -> Expect.equal True (canApplyCommand TurnRightCommand Feature.initialModel.robot)
                    ]
                    ()
        , test "applyCommand TurnLeft records the previous robot" <|
            \_ ->
                let
                    updatedModel =
                        applyCommand TurnLeftCommand Feature.initialModel
                in
                Expect.all
                    [ \_ -> Expect.equal West (facing updatedModel.robot)
                    , \_ -> Expect.equal [ TurnLeftCommand ] (List.map .command updatedModel.history)
                    , \_ -> Expect.equal [ Feature.initialModel.robot ] (List.map .previousRobot updatedModel.history)
                    ]
                    ()
        , test "applyCommand TurnRight records the previous robot" <|
            \_ ->
                let
                    updatedModel =
                        applyCommand TurnRightCommand Feature.initialModel
                in
                Expect.all
                    [ \_ -> Expect.equal East (facing updatedModel.robot)
                    , \_ -> Expect.equal [ TurnRightCommand ] (List.map .command updatedModel.history)
                    , \_ -> Expect.equal [ Feature.initialModel.robot ] (List.map .previousRobot updatedModel.history)
                    ]
                    ()
        , test "undo restores the previous robot and removes the latest history item" <|
            \_ ->
                let
                    movedModel =
                        Feature.initialModel
                            |> applyCommand MoveForwardCommand
                            |> applyCommand TurnRightCommand

                    undoneModel =
                        undo movedModel
                in
                Expect.all
                    [ \_ -> Expect.equal (robot 0 1 North) undoneModel.robot
                    , \_ -> Expect.equal [ MoveForwardCommand ] (List.map .command undoneModel.history)
                    , \_ -> Expect.equal [ Feature.initialModel.robot ] (List.map .previousRobot undoneModel.history)
                    ]
                    ()
        , test "undo with empty history is a no-op" <|
            \_ ->
                Expect.equal Feature.initialModel (undo Feature.initialModel)
        , test "commandFromKey maps supported keys and rejects others" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal (Just MoveForwardCommand) (commandFromKey "ArrowUp")
                    , \_ -> Expect.equal (Just TurnLeftCommand) (commandFromKey "ArrowLeft")
                    , \_ -> Expect.equal (Just TurnRightCommand) (commandFromKey "ArrowRight")
                    , \_ -> Expect.equal Nothing (commandFromKey "ArrowDown")
                    ]
                    ()
        ]


robot : Int -> Int -> Direction -> Robot
robot xCoordinate yCoordinate direction =
    fromCoordinates xCoordinate yCoordinate direction
        |> Maybe.withDefault initialRobot
