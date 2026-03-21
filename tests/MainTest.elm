module MainTest exposing (tests)

import Expect
import Http
import Main exposing (Msg(..), initModel, keyboardCommandsEnabled, update)
import Motorcycle.Model
import Robot
import Robot.Logic exposing (Command(..))
import Test exposing (Test, describe, test)
import View
import View.Theme as Theme


tests : Test
tests =
    describe "Main"
        [ test "initModel starts on the motorcycle page" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal View.MotorcyclePage initModel.currentPage
                    , \_ -> Expect.equal Motorcycle.Model.Loading initModel.motorcycleProducts
                    ]
                    ()
        , test "keyboard commands are enabled only on the robot page" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal True (keyboardCommandsEnabled View.RobotPage)
                    , \_ -> Expect.equal False (keyboardCommandsEnabled View.MotorcyclePage)
                    ]
                    ()
        , test "successful product responses populate the motorcycle collection" <|
            \_ ->
                let
                    products =
                        Motorcycle.Model.sampleProducts

                    ( updatedModel, _ ) =
                        update (ReceiveProducts (Ok products)) initModel
                in
                Expect.all
                    [ \_ -> Expect.equal (Motorcycle.Model.Loaded products) updatedModel.motorcycleProducts
                    , \_ -> Expect.equal initModel.robot updatedModel.robot
                    , \_ -> Expect.equal initModel.currentPage updatedModel.currentPage
                    ]
                    ()
        , test "failed product responses store an error state" <|
            \_ ->
                let
                    ( updatedModel, _ ) =
                        update (ReceiveProducts (Err Http.NetworkError)) initModel
                in
                Expect.all
                    [ \_ -> Expect.equal (Motorcycle.Model.Failed "Start the local Haskell service on http://localhost:8080.") updatedModel.motorcycleProducts
                    , \_ -> Expect.equal initModel.robot updatedModel.robot
                    , \_ -> Expect.equal initModel.currentPage updatedModel.currentPage
                    ]
                    ()
        , test "keyboard command delegates to the robot feature without affecting other root state" <|
            \_ ->
                let
                    dirtyModel =
                        { initModel
                            | themeMode = Theme.Dark
                            , currentPage = View.RobotPage
                        }

                    ( updatedModel, _ ) =
                        update (KeyboardCommand MoveForwardCommand) dirtyModel
                in
                Expect.all
                    [ \_ ->
                        Expect.equal
                            (Robot.update (Robot.ApplyCommand MoveForwardCommand) dirtyModel.robot)
                            updatedModel.robot
                    , \_ -> Expect.equal Theme.Dark updatedModel.themeMode
                    , \_ -> Expect.equal View.RobotPage updatedModel.currentPage
                    , \_ -> Expect.equal dirtyModel.motorcycleProducts updatedModel.motorcycleProducts
                    ]
                    ()
        , test "RobotMsg delegates to the robot feature without affecting root-only state" <|
            \_ ->
                let
                    dirtyModel =
                        { initModel
                            | themeMode = Theme.Dark
                            , currentPage = View.RobotPage
                        }

                    ( updatedModel, _ ) =
                        update (RobotMsg Robot.TurnLeft) dirtyModel
                in
                Expect.all
                    [ \_ -> Expect.equal (Robot.update Robot.TurnLeft dirtyModel.robot) updatedModel.robot
                    , \_ -> Expect.equal Theme.Dark updatedModel.themeMode
                    , \_ -> Expect.equal View.RobotPage updatedModel.currentPage
                    , \_ -> Expect.equal dirtyModel.motorcycleProducts updatedModel.motorcycleProducts
                    , \_ -> Expect.equal dirtyModel.viewport updatedModel.viewport
                    ]
                    ()
        , test "IgnoreKeyPress is a no-op" <|
            \_ ->
                Expect.equal initModel (Tuple.first (update IgnoreKeyPress initModel))
        , test "SetTheme changes only the theme mode" <|
            \_ ->
                let
                    dirtyModel =
                        { initModel
                            | robot = Robot.update Robot.MoveForward initModel.robot
                            , currentPage = View.RobotPage
                        }

                    ( updatedModel, _ ) =
                        update (SetTheme Theme.Dark) dirtyModel
                in
                Expect.all
                    [ \_ -> Expect.equal Theme.Dark updatedModel.themeMode
                    , \_ -> Expect.equal dirtyModel.robot updatedModel.robot
                    , \_ -> Expect.equal dirtyModel.currentPage updatedModel.currentPage
                    , \_ -> Expect.equal dirtyModel.motorcycleProducts updatedModel.motorcycleProducts
                    , \_ -> Expect.equal dirtyModel.viewport updatedModel.viewport
                    ]
                    ()
        , test "ResizeViewport changes only the viewport" <|
            \_ ->
                let
                    dirtyModel =
                        { initModel
                            | robot = Robot.update Robot.MoveForward initModel.robot
                            , themeMode = Theme.Dark
                            , currentPage = View.RobotPage
                        }

                    ( updatedModel, _ ) =
                        update (ResizeViewport 640 480) dirtyModel
                in
                Expect.all
                    [ \_ -> Expect.equal { width = 640, height = 480 } updatedModel.viewport
                    , \_ -> Expect.equal dirtyModel.robot updatedModel.robot
                    , \_ -> Expect.equal Theme.Dark updatedModel.themeMode
                    , \_ -> Expect.equal dirtyModel.currentPage updatedModel.currentPage
                    , \_ -> Expect.equal dirtyModel.motorcycleProducts updatedModel.motorcycleProducts
                    ]
                    ()
        , test "selecting the robot page changes only the current page" <|
            \_ ->
                let
                    progressedModel =
                        { initModel
                            | robot = Robot.update Robot.MoveForward initModel.robot
                            , themeMode = Theme.Dark
                        }

                    ( updatedModel, _ ) =
                        update (SelectPage View.RobotPage) progressedModel
                in
                Expect.all
                    [ \_ -> Expect.equal View.RobotPage updatedModel.currentPage
                    , \_ -> Expect.equal progressedModel.robot updatedModel.robot
                    , \_ -> Expect.equal progressedModel.themeMode updatedModel.themeMode
                    , \_ -> Expect.equal progressedModel.motorcycleProducts updatedModel.motorcycleProducts
                    ]
                    ()
        ]
