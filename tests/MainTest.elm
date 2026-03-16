module MainTest exposing (tests)

import Expect
import Main exposing (Command(..), Msg(..), applyCommand, applyKey, commandFromKey, initModel, themeToggleDescription, toggleThemeMode, undo, update)
import Robot exposing (Direction(..))
import Test exposing (Test, describe, test)
import View.Theme as Theme


tests : Test
tests =
    describe "Main"
        [ test "applyCommand MoveForward updates robot and records history" <|
            \_ ->
                let
                    updatedModel =
                        applyCommand MoveForwardCommand initModel
                in
                Expect.all
                    [ \_ -> Expect.equal 1 updatedModel.robot.y
                    , \_ -> Expect.equal North updatedModel.robot.facing
                    , \_ -> Expect.equal [ MoveForwardCommand ] updatedModel.history
                    , \_ -> Expect.equal [ initModel.robot ] updatedModel.previousRobots
                    ]
                    ()
        , test "applyCommand TurnLeft records the previous robot" <|
            \_ ->
                let
                    updatedModel =
                        applyCommand TurnLeftCommand initModel
                in
                Expect.all
                    [ \_ -> Expect.equal West updatedModel.robot.facing
                    , \_ -> Expect.equal [ TurnLeftCommand ] updatedModel.history
                    , \_ -> Expect.equal [ initModel.robot ] updatedModel.previousRobots
                    ]
                    ()
        , test "applyCommand TurnRight records the previous robot" <|
            \_ ->
                let
                    updatedModel =
                        applyCommand TurnRightCommand initModel
                in
                Expect.all
                    [ \_ -> Expect.equal East updatedModel.robot.facing
                    , \_ -> Expect.equal [ TurnRightCommand ] updatedModel.history
                    , \_ -> Expect.equal [ initModel.robot ] updatedModel.previousRobots
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
                    [ \_ -> Expect.equal { x = 0, y = 1, facing = North } undoneModel.robot
                    , \_ -> Expect.equal [ MoveForwardCommand ] undoneModel.history
                    , \_ -> Expect.equal [ initModel.robot ] undoneModel.previousRobots
                    ]
                    ()
        , test "undo with empty history is a no-op" <|
            \_ ->
                Expect.equal initModel (undo initModel)
        , test "update Reset returns the initial model" <|
            \_ ->
                let
                    dirtyModel =
                        initModel
                            |> applyCommand MoveForwardCommand
                            |> applyCommand TurnLeftCommand
                            |> (\model -> { model | themeMode = Theme.Dark })

                    ( resetModel, _ ) =
                        update Reset dirtyModel
                in
                Expect.equal initModel resetModel
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
                    , \_ -> Expect.equal movedModel.previousRobots updatedModel.previousRobots
                    ]
                    ()
        , test "applyKey ArrowUp matches MoveForwardCommand" <|
            \_ ->
                Expect.equal
                    (applyCommand MoveForwardCommand initModel)
                    (applyKey "ArrowUp" initModel)
        , test "applyKey ArrowLeft matches TurnLeftCommand" <|
            \_ ->
                Expect.equal
                    (applyCommand TurnLeftCommand initModel)
                    (applyKey "ArrowLeft" initModel)
        , test "applyKey ArrowRight matches TurnRightCommand" <|
            \_ ->
                Expect.equal
                    (applyCommand TurnRightCommand initModel)
                    (applyKey "ArrowRight" initModel)
        , test "applyKey ignores unknown keys" <|
            \_ ->
                Expect.equal initModel (applyKey "Enter" initModel)
        , test "commandFromKey maps supported keys and rejects others" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal (Just MoveForwardCommand) (commandFromKey "ArrowUp")
                    , \_ -> Expect.equal (Just TurnLeftCommand) (commandFromKey "ArrowLeft")
                    , \_ -> Expect.equal (Just TurnRightCommand) (commandFromKey "ArrowRight")
                    , \_ -> Expect.equal Nothing (commandFromKey "ArrowDown")
                    ]
                    ()
        , test "toggleThemeMode flips between light and dark" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal Theme.Dark (toggleThemeMode Theme.Light)
                    , \_ -> Expect.equal Theme.Light (toggleThemeMode Theme.Dark)
                    ]
                    ()
        , test "themeToggleDescription describes the next theme action" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal "Switch to light theme" (themeToggleDescription Theme.Light)
                    , \_ -> Expect.equal "Switch to dark theme" (themeToggleDescription Theme.Dark)
                    ]
                    ()
        ]
