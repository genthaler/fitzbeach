module MainTest exposing (tests)

import Expect
import Main exposing (Msg(..), initModel, update)
import Motorcycle.Page
import Test exposing (Test, describe, test)
import View


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
                            Motorcycle.Page.productPanels
                in
                Expect.all
                    [ \_ -> Expect.equal (List.take 1 Motorcycle.Page.productPanels) firstModel.motorcycleFeed.visibleProducts
                    , \_ -> Expect.equal (List.drop 1 Motorcycle.Page.productPanels) firstModel.motorcycleFeed.pendingProducts
                    , \_ -> Expect.equal Motorcycle.Page.productPanels fullyLoadedModel.motorcycleFeed.visibleProducts
                    , \_ -> Expect.equal [] fullyLoadedModel.motorcycleFeed.pendingProducts
                    ]
                    ()
        ]
