module Main exposing
    ( Flags
    , Model
    , Msg(..)
    , Viewport
    , defaultApiBaseUrl
    , initModel
    , keyboardCommandsEnabled
    , main
    , update
    )

import Browser
import Browser.Events
import Api.Health
import Generated.Api.HealthResponse exposing (HealthResponse)
import Generated.Api.Product exposing (Product)
import Html
import Http
import Json.Decode as Decode
import Motorcycle.Api
import Motorcycle.Model as Motorcycle
import Robot
import Robot.Logic as RobotLogic
import ServiceHealth exposing (ServiceHealth(..))
import String
import View
import View.Shell as Shell
import View.Theme as Theme


type alias Model =
    { robot : Robot.Model
    , themeMode : Theme.Mode
    , currentPage : View.Page
    , serviceHealth : ServiceHealth
    , motorcycleProducts : Motorcycle.ProductState
    , apiBaseUrl : String
    , viewport : Viewport
    }


type Msg
    = RobotMsg Robot.Msg
    | KeyboardCommand RobotLogic.Command
    | IgnoreKeyPress
    | SetTheme Theme.Mode
    | SelectPage View.Page
    | ResizeViewport Int Int
    | ReceiveHealth (Result Http.Error HealthResponse)
    | ReceiveProducts (Result Http.Error (List Product))


type alias Viewport =
    { width : Int
    , height : Int
    }


type alias Flags =
    { apiBaseUrl : String
    }


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        apiBaseUrl : String
        apiBaseUrl =
            normaliseApiBaseUrl flags.apiBaseUrl

        model : Model
        model =
            { initModel | apiBaseUrl = apiBaseUrl }
    in
    ( model, Cmd.batch [ loadHealth apiBaseUrl, loadProducts apiBaseUrl ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RobotMsg robotMsg ->
            ( { model | robot = Robot.update robotMsg model.robot }, Cmd.none )

        KeyboardCommand command ->
            ( { model | robot = Robot.update (Robot.ApplyCommand command) model.robot }, Cmd.none )

        IgnoreKeyPress ->
            ( model, Cmd.none )

        SetTheme mode ->
            ( { model | themeMode = mode }, Cmd.none )

        SelectPage selectedPage ->
            let
                retryProducts : Bool
                retryProducts =
                    selectedPage == View.MotorcyclePage && shouldRetryProducts model.motorcycleProducts

                retryHealth : Bool
                retryHealth =
                    selectedPage == View.MotorcyclePage && shouldRetryHealth model.serviceHealth
            in
            ( { model
                | currentPage = selectedPage
                , serviceHealth =
                    if retryHealth then
                        Checking

                    else
                        model.serviceHealth
                , motorcycleProducts =
                    if retryProducts then
                        Motorcycle.Loading

                    else
                        model.motorcycleProducts
              }
            , if retryProducts || retryHealth then
                Cmd.batch
                    [ if retryHealth then
                        loadHealth model.apiBaseUrl

                      else
                        Cmd.none
                    , if retryProducts then
                        loadProducts model.apiBaseUrl

                      else
                        Cmd.none
                    ]

              else
                Cmd.none
            )

        ResizeViewport width height ->
            ( { model | viewport = { width = width, height = height } }, Cmd.none )

        ReceiveHealth result ->
            ( { model | serviceHealth = healthStateFromResult model.apiBaseUrl result }, Cmd.none )

        ReceiveProducts result ->
            ( { model | motorcycleProducts = productStateFromResult model.apiBaseUrl result }, Cmd.none )


initModel : Model
initModel =
    { robot = Robot.initialModel
    , themeMode = Theme.Light
    , currentPage = View.MotorcyclePage
    , serviceHealth = Checking
    , motorcycleProducts = Motorcycle.Loading
    , apiBaseUrl = defaultApiBaseUrl
    , viewport = { width = 0, height = 0 }
    }


defaultApiBaseUrl : String
defaultApiBaseUrl =
    "http://localhost:8080"


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize ResizeViewport
        , if keyboardCommandsEnabled model.currentPage then
            Browser.Events.onKeyDown
                (Decode.map keyPressToMsg (Decode.field "key" Decode.string))

          else
            Sub.none
        ]


keyboardCommandsEnabled : View.Page -> Bool
keyboardCommandsEnabled currentPage =
    case currentPage of
        View.RobotPage ->
            True

        View.MotorcyclePage ->
            False


keyPressToMsg : String -> Msg
keyPressToMsg key =
    case RobotLogic.commandFromKey key of
        Just command ->
            KeyboardCommand command

        Nothing ->
            IgnoreKeyPress


loadHealth : String -> Cmd Msg
loadHealth apiBaseUrl =
    Api.Health.getHealth apiBaseUrl ReceiveHealth


loadProducts : String -> Cmd Msg
loadProducts apiBaseUrl =
    Motorcycle.Api.getProducts apiBaseUrl ReceiveProducts


shouldRetryHealth : ServiceHealth -> Bool
shouldRetryHealth serviceHealth =
    case serviceHealth of
        Unavailable _ ->
            True

        Checking ->
            False

        Available _ ->
            False


shouldRetryProducts : Motorcycle.ProductState -> Bool
shouldRetryProducts productState =
    case productState of
        Motorcycle.Failed _ ->
            True

        Motorcycle.Loading ->
            False

        Motorcycle.Loaded _ ->
            False


productStateFromResult : String -> Result Http.Error (List Product) -> Motorcycle.ProductState
productStateFromResult apiBaseUrl result =
    case result of
        Ok products ->
            Motorcycle.Loaded products

        Err error ->
            Motorcycle.Failed (httpErrorMessage apiBaseUrl error)


healthStateFromResult : String -> Result Http.Error HealthResponse -> ServiceHealth
healthStateFromResult apiBaseUrl result =
    case result of
        Ok response ->
            Available response.status

        Err error ->
            Unavailable (httpErrorMessage apiBaseUrl error)


httpErrorMessage : String -> Http.Error -> String
httpErrorMessage apiBaseUrl error =
    case error of
        Http.BadUrl _ ->
            "Check the frontend API URL."

        Http.Timeout ->
            "The request timed out."

        Http.NetworkError ->
            "Check that the product service is reachable at " ++ apiBaseUrl ++ "."

        Http.BadStatus statusCode ->
            "The service returned HTTP " ++ String.fromInt statusCode ++ "."

        Http.BadBody _ ->
            "The service returned unexpected JSON."


normaliseApiBaseUrl : String -> String
normaliseApiBaseUrl apiBaseUrl =
    if String.isEmpty apiBaseUrl then
        defaultApiBaseUrl

    else if String.endsWith "/" apiBaseUrl then
        String.dropRight 1 apiBaseUrl

    else
        apiBaseUrl


view : Model -> Html.Html Msg
view model =
    Shell.view
        { currentPage = model.currentPage
        , themeMode = model.themeMode
        , viewport = model.viewport
        , selectPage = SelectPage
        , setTheme = SetTheme
        , content = \colors compactLayout -> View.page model colors compactLayout (Robot.controls RobotMsg)
        }
