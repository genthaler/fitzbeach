module Robot.LogicTest exposing (tests)

import Expect
import Main exposing (Msg(..), initModel, update)
import Robot.Logic exposing (Command(..), applyCommand, canApplyCommand, commandFromKey, undo)
import Robot.Model exposing (Direction(..), Robot, facing, fromCoordinates, initialRobot, y)
import Test exposing (Test, describe, test)
import View
import View.Theme as Theme


tests : Test
tests =
    describe "Robot.Logic"
        [ test "applyCommand MoveForward updates robot and records history" <|
            \_ ->
                let
                    updatedModel =
                        applyCommand MoveForwardCommand initModel
                in
                Expect.all
                    [ \_ -> Expect.equal 1 (y updatedModel.robot)
                    , \_ -> Expect.equal North (facing updatedModel.robot)
                    , \_ -> Expect.equal [ MoveForwardCommand ] (List.map .command updatedModel.history)
                    , \_ -> Expect.equal [ initModel.robot ] (List.map .previousRobot updatedModel.history)
                    ]
                    ()
        , test "applyCommand ignores a blocked move at the wall" <|
            \_ ->
                let
                    edgeModel =
                        { initModel | robot = robot 0 4 North }

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
                    [ \_ -> Expect.equal True (canApplyCommand MoveForwardCommand initModel.robot)
                    , \_ -> Expect.equal True (canApplyCommand TurnLeftCommand initModel.robot)
                    , \_ -> Expect.equal True (canApplyCommand TurnRightCommand initModel.robot)
                    ]
                    ()
        , test "applyCommand TurnLeft records the previous robot" <|
            \_ ->
                let
                    updatedModel =
                        applyCommand TurnLeftCommand initModel
                in
                Expect.all
                    [ \_ -> Expect.equal West (facing updatedModel.robot)
                    , \_ -> Expect.equal [ TurnLeftCommand ] (List.map .command updatedModel.history)
                    , \_ -> Expect.equal [ initModel.robot ] (List.map .previousRobot updatedModel.history)
                    ]
                    ()
        , test "applyCommand TurnRight records the previous robot" <|
            \_ ->
                let
                    updatedModel =
                        applyCommand TurnRightCommand initModel
                in
                Expect.all
                    [ \_ -> Expect.equal East (facing updatedModel.robot)
                    , \_ -> Expect.equal [ TurnRightCommand ] (List.map .command updatedModel.history)
                    , \_ -> Expect.equal [ initModel.robot ] (List.map .previousRobot updatedModel.history)
                    ]
                    ()
        , test "undo restores the previous robot and removes the latest history item" <|
            \_ ->
                let
                    movedModel =
                        initModel
                            |> applyCommand MoveForwardCommand
                            |> applyCommand TurnRightCommand

                    undoneModel =
                        undo movedModel
                in
                Expect.all
                    [ \_ -> Expect.equal (robot 0 1 North) undoneModel.robot
                    , \_ -> Expect.equal [ MoveForwardCommand ] (List.map .command undoneModel.history)
                    , \_ -> Expect.equal [ initModel.robot ] (List.map .previousRobot undoneModel.history)
                    ]
                    ()
        , test "undo with empty history is a no-op" <|
            \_ ->
                Expect.equal initModel (undo initModel)
        , test "keyboard command message applies a command without raw key strings" <|
            \_ ->
                Expect.equal
                    (applyCommand MoveForwardCommand initModel)
                    (Tuple.first (update (KeyboardCommand MoveForwardCommand) initModel))
        , test "ignored key presses are no-ops" <|
            \_ ->
                Expect.equal initModel (Tuple.first (update IgnoreKeyPress initModel))
        , test "commandFromKey maps supported keys and rejects others" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal (Just MoveForwardCommand) (commandFromKey "ArrowUp")
                    , \_ -> Expect.equal (Just TurnLeftCommand) (commandFromKey "ArrowLeft")
                    , \_ -> Expect.equal (Just TurnRightCommand) (commandFromKey "ArrowRight")
                    , \_ -> Expect.equal Nothing (commandFromKey "ArrowDown")
                    ]
                    ()
        , test "update Reset clears robot state without leaving the current page or theme" <|
            \_ ->
                let
                    dirtyModel =
                        initModel
                            |> applyCommand MoveForwardCommand
                            |> applyCommand TurnLeftCommand
                            |> (\model -> { model | themeMode = Theme.Dark })
                            |> (\model -> { model | currentPage = View.RobotPage })

                    ( resetModel, _ ) =
                        update Reset dirtyModel
                in
                Expect.all
                    [ \_ -> Expect.equal initialRobot resetModel.robot
                    , \_ -> Expect.equal [] resetModel.history
                    , \_ -> Expect.equal Theme.Dark resetModel.themeMode
                    , \_ -> Expect.equal View.RobotPage resetModel.currentPage
                    , \_ -> Expect.equal dirtyModel.viewport resetModel.viewport
                    ]
                    ()
        , test "update SetTheme changes only the theme mode" <|
            \_ ->
                let
                    movedModel =
                        applyCommand MoveForwardCommand initModel

                    ( updatedModel, _ ) =
                        update (SetTheme Theme.Dark) movedModel
                in
                Expect.all
                    [ \_ -> Expect.equal Theme.Dark updatedModel.themeMode
                    , \_ -> Expect.equal movedModel.robot updatedModel.robot
                    , \_ -> Expect.equal movedModel.history updatedModel.history
                    , \_ -> Expect.equal movedModel.currentPage updatedModel.currentPage
                    ]
                    ()
        , test "update SelectPage changes only the current page" <|
            \_ ->
                let
                    movedModel =
                        applyCommand MoveForwardCommand initModel

                    ( updatedModel, _ ) =
                        update (SelectPage View.RobotPage) movedModel
                in
                Expect.all
                    [ \_ -> Expect.equal View.RobotPage updatedModel.currentPage
                    , \_ -> Expect.equal movedModel.robot updatedModel.robot
                    , \_ -> Expect.equal movedModel.history updatedModel.history
                    , \_ -> Expect.equal movedModel.themeMode updatedModel.themeMode
                    ]
                    ()
        ]


robot : Int -> Int -> Direction -> Robot
robot xCoordinate yCoordinate direction =
    fromCoordinates xCoordinate yCoordinate direction
        |> Maybe.withDefault initialRobot
