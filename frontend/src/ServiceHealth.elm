module ServiceHealth exposing (ServiceHealth(..))


type ServiceHealth
    = Checking
    | Available String
    | Unavailable String
