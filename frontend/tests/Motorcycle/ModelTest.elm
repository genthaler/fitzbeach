module Motorcycle.ModelTest exposing (tests)

import Expect
import Generated.Api.Product exposing (Product, productDecoder)
import Json.Decode as Decode
import Motorcycle.Model exposing (priceLabel, sampleProducts)
import Test exposing (Test, describe, test)


tests : Test
tests =
    describe "Motorcycle.Model"
        [ test "productDecoder matches the backend payload shape" <|
            \_ ->
                let
                    payload =
                        """
                        {
                          "id": 7,
                          "name": "Range Utility Pouch",
                          "category": "Organisation",
                          "priceCents": 6900,
                          "currency": "USD",
                          "imageUrl": "https://example.com/range.jpg"
                        }
                        """

                    expectedProduct : Product
                    expectedProduct =
                        { id = 7
                        , name = "Range Utility Pouch"
                        , category = "Organisation"
                        , priceCents = 6900
                        , currency = "USD"
                        , imageUrl = "https://example.com/range.jpg"
                        }
                in
                Expect.equal (Ok expectedProduct) (Decode.decodeString productDecoder payload)
        , test "priceLabel formats cents as a currency string" <|
            \_ ->
                case sampleProducts of
                    product :: _ ->
                        Expect.equal "$4299.00" (priceLabel product)

                    [] ->
                        Expect.fail "Expected sampleProducts to include at least one product"
        ]
