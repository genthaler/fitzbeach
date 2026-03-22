module Motorcycle.Api exposing (getProducts)

import Http
import Json.Decode as Decode
import Motorcycle.Model as Motorcycle
import String


getProducts : String -> (Result Http.Error (List Motorcycle.Product) -> msg) -> Cmd msg
getProducts apiBaseUrl toMsg =
    Http.get
        { url = productsUrl apiBaseUrl
        , expect = Http.expectJson toMsg (Decode.list Motorcycle.productDecoder)
        }


productsUrl : String -> String
productsUrl apiBaseUrl =
    if String.endsWith "/" apiBaseUrl then
        apiBaseUrl ++ "products"

    else
        apiBaseUrl ++ "/products"
