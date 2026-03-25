module Generated.Api.Product exposing
    ( Product
    , productEncoder
    , productDecoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode


type alias Product  =
    { id : Int
    , name : String
    , category : String
    , priceCents : Int
    , currency : String
    , imageUrl : String }


productEncoder : Product -> Json.Encode.Value
productEncoder a =
    Json.Encode.object [ ("id" , Json.Encode.int a.id)
    , ("name" , Json.Encode.string a.name)
    , ("category" , Json.Encode.string a.category)
    , ("priceCents" , Json.Encode.int a.priceCents)
    , ("currency" , Json.Encode.string a.currency)
    , ("imageUrl" , Json.Encode.string a.imageUrl) ]


productDecoder : Json.Decode.Decoder Product
productDecoder =
    Json.Decode.succeed Product |>
    Json.Decode.Pipeline.required "id" Json.Decode.int |>
    Json.Decode.Pipeline.required "name" Json.Decode.string |>
    Json.Decode.Pipeline.required "category" Json.Decode.string |>
    Json.Decode.Pipeline.required "priceCents" Json.Decode.int |>
    Json.Decode.Pipeline.required "currency" Json.Decode.string |>
    Json.Decode.Pipeline.required "imageUrl" Json.Decode.string