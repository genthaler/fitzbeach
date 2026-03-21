module Motorcycle.Api exposing (getProducts)

import Http
import Json.Decode as Decode
import Motorcycle.Model as Motorcycle


getProducts : (Result Http.Error (List Motorcycle.Product) -> msg) -> Cmd msg
getProducts toMsg =
    Http.get
        { url = "http://localhost:8080/products"
        , expect = Http.expectJson toMsg (Decode.list Motorcycle.productDecoder)
        }
