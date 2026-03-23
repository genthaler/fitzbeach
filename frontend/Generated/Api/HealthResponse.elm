module Generated.Api.HealthResponse exposing
    ( HealthResponse
    , healthResponseEncoder
    , healthResponseDecoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode


type alias HealthResponse  =
    { status : String }


healthResponseEncoder : HealthResponse -> Json.Encode.Value
healthResponseEncoder a =
    Json.Encode.object [("status" , Json.Encode.string a.status)]


healthResponseDecoder : Json.Decode.Decoder HealthResponse
healthResponseDecoder =
    Json.Decode.succeed HealthResponse |>
    Json.Decode.Pipeline.required "status" Json.Decode.string