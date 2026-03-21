module Motorcycle.ModelTest exposing (tests)

import Expect
import Motorcycle.Model exposing (Feed, initialFeed, products, receiveNextProduct)
import Test exposing (Test, describe, test)


tests : Test
tests =
    describe "Motorcycle.Model"
        [ test "initialFeed starts with all products pending and none visible" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal [] initialFeed.visibleProducts
                    , \_ -> Expect.equal products initialFeed.pendingProducts
                    ]
                    ()
        , test "receiveNextProduct reveals the next product and keeps the remaining queue" <|
            \_ ->
                let
                    updatedFeed =
                        receiveNextProduct initialFeed
                in
                Expect.all
                    [ \_ -> Expect.equal (List.take 1 products) updatedFeed.visibleProducts
                    , \_ -> Expect.equal (List.drop 1 products) updatedFeed.pendingProducts
                    ]
                    ()
        , test "receiveNextProduct is a no-op when no products remain pending" <|
            \_ ->
                let
                    completedFeed : Feed
                    completedFeed =
                        { visibleProducts = products
                        , pendingProducts = []
                        }
                in
                Expect.equal completedFeed (receiveNextProduct completedFeed)
        ]
