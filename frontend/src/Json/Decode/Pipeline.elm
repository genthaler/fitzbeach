module Json.Decode.Pipeline exposing (required)

import Json.Decode as Decode exposing (Decoder)


required : String -> Decoder a -> Decoder (a -> b) -> Decoder b
required fieldName fieldDecoder accumulatedDecoder =
    Decode.map2 (<|) accumulatedDecoder (Decode.field fieldName fieldDecoder)
