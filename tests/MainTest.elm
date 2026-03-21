module MainTest exposing (tests)

import Expect
import Main exposing (Msg(..), initModel, keyboardCommandsEnabled, motorcycleFeedSubscriptionEnabled, update)
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
                Expect.equal View.MotorcyclePage initModel.currentPage
        , test "keyboard commands are enabled only on the robot page" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal True (keyboardCommandsEnabled View.RobotPage)
                    , \_ -> Expect.equal False (keyboardCommandsEnabled View.MotorcyclePage)
                    ]
                    ()
        , test "motorcycle feed subscription is enabled only while products remain on the motorcycle page" <|
            \_ ->
                let
                    withPendingProducts =
                        initModel

                    withoutPendingProducts =
                        { initModel
                            | motorcycleFeed =
                                { visibleProducts = Motorcycle.Model.products
                                , pendingProducts = []
                                }
                        }

                    robotPageModel =
                        { initModel | currentPage = View.RobotPage }
                in
                Expect.all
                    [ \_ -> Expect.equal True (motorcycleFeedSubscriptionEnabled withPendingProducts)
                    , \_ -> Expect.equal False (motorcycleFeedSubscriptionEnabled withoutPendingProducts)
                    , \_ -> Expect.equal False (motorcycleFeedSubscriptionEnabled robotPageModel)
                    ]
                    ()
        , test "motorcycle products stream into the model one at a time" <|
            \_ ->
                let
                    tick =
                        ReceiveNextProduct

                    ( firstModel, _ ) =
                        update tick initModel

                    fullyLoadedModel =
                        List.foldl
                            (\_ model -> Tuple.first (update tick model))
                            initModel
                            Motorcycle.Model.products
                in
                Expect.all
                    [ \_ -> Expect.equal (List.take 1 Motorcycle.Model.products) firstModel.motorcycleFeed.visibleProducts
                    , \_ -> Expect.equal (List.drop 1 Motorcycle.Model.products) firstModel.motorcycleFeed.pendingProducts
                    , \_ -> Expect.equal Motorcycle.Model.products fullyLoadedModel.motorcycleFeed.visibleProducts
                    , \_ -> Expect.equal [] fullyLoadedModel.motorcycleFeed.pendingProducts
                    ]
                    ()
        , test "selecting the motorcycle page restarts the simulated product feed" <|
            \_ ->
                let
                    advanceFeed =
                        Tuple.first << update ReceiveNextProduct

                    progressedModel =
                        initModel
                            |> advanceFeed
                            |> advanceFeed
                            |> (\model -> Tuple.first (update (SelectPage View.RobotPage) model))

                    ( restartedModel, _ ) =
                        update (SelectPage View.MotorcyclePage) progressedModel
                in
                Expect.all
                    [ \_ -> Expect.equal View.MotorcyclePage restartedModel.currentPage
                    , \_ -> Expect.equal [] restartedModel.motorcycleFeed.visibleProducts
                    , \_ -> Expect.equal Motorcycle.Model.products restartedModel.motorcycleFeed.pendingProducts
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
                    , \_ -> Expect.equal dirtyModel.motorcycleFeed updatedModel.motorcycleFeed
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
                    , \_ -> Expect.equal dirtyModel.motorcycleFeed updatedModel.motorcycleFeed
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
                    , \_ -> Expect.equal dirtyModel.motorcycleFeed updatedModel.motorcycleFeed
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
                    , \_ -> Expect.equal dirtyModel.motorcycleFeed updatedModel.motorcycleFeed
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
                    , \_ -> Expect.equal progressedModel.motorcycleFeed updatedModel.motorcycleFeed
                    ]
                    ()
        ]
