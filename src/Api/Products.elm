module Api.Products exposing (getProducts)

import Generated.Api.Product exposing (Product, productDecoder)
import Http
import Json.Decode as Decode
import String


getProducts : String -> (Result Http.Error (List Product) -> msg) -> Cmd msg
getProducts apiBaseUrl toMsg =
    Http.get
        { url = productsUrl apiBaseUrl
        , expect = Http.expectJson toMsg (Decode.list productDecoder)
        }


productsUrl : String -> String
productsUrl apiBaseUrl =
    if String.endsWith "/" apiBaseUrl then
        apiBaseUrl ++ "products"

    else
        apiBaseUrl ++ "/products"
