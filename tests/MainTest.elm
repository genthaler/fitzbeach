module MainTest exposing (tests)

import Expect
import Main exposing (Msg(..), initModel, update)
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
