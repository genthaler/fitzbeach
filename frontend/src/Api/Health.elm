module Api.Health exposing (getHealth)

import Generated.Api.HealthResponse exposing (HealthResponse, healthResponseDecoder)
import Http
import String


getHealth : String -> (Result Http.Error HealthResponse -> msg) -> Cmd msg
getHealth apiBaseUrl toMsg =
    Http.get
        { url = healthUrl apiBaseUrl
        , expect = Http.expectJson toMsg healthResponseDecoder
        }


healthUrl : String -> String
healthUrl apiBaseUrl =
    if String.endsWith "/" apiBaseUrl then
        apiBaseUrl ++ "health"

    else
        apiBaseUrl ++ "/health"
