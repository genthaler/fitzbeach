module Main exposing
    ( Model
    , Msg(..)
    , Viewport
    , initModel
    , keyboardCommandsEnabled
    , main
    , motorcycleFeedSubscriptionEnabled
    , update
    )

import Browser
import Browser.Events
import Html
import Json.Decode as Decode
import Motorcycle.Model as Motorcycle
import Robot
import Robot.Logic as RobotLogic
import Time
import View
import View.Shell as Shell
import View.Theme as Theme


type alias Model =
    { robot : Robot.Model
    , themeMode : Theme.Mode
    , currentPage : View.Page
    , motorcycleFeed : Motorcycle.Feed
    , viewport : Viewport
    }


type Msg
    = RobotMsg Robot.Msg
    | KeyboardCommand RobotLogic.Command
    | IgnoreKeyPress
    | SetTheme Theme.Mode
    | SelectPage View.Page
    | ResizeViewport Int Int
    | ReceiveNextProduct


type alias Viewport =
    { width : Int
    , height : Int
    }


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initModel, Cmd.none )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


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
            ( { model
                | currentPage = selectedPage
                , motorcycleFeed =
                    if selectedPage == View.MotorcyclePage then
                        Motorcycle.initialFeed

                    else
                        model.motorcycleFeed
              }
            , Cmd.none
            )

        ResizeViewport width height ->
            ( { model | viewport = { width = width, height = height } }, Cmd.none )

        ReceiveNextProduct ->
            ( { model | motorcycleFeed = Motorcycle.receiveNextProduct model.motorcycleFeed }, Cmd.none )


initModel : Model
initModel =
    { robot = Robot.initialModel
    , themeMode = Theme.Light
    , currentPage = View.MotorcyclePage
    , motorcycleFeed = Motorcycle.initialFeed
    , viewport = { width = 0, height = 0 }
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize ResizeViewport
        , if motorcycleFeedSubscriptionEnabled model then
            Time.every 250 (\_ -> ReceiveNextProduct)

          else
            Sub.none
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


motorcycleFeedSubscriptionEnabled : Model -> Bool
motorcycleFeedSubscriptionEnabled model =
    model.currentPage == View.MotorcyclePage
        && not (List.isEmpty model.motorcycleFeed.pendingProducts)


keyPressToMsg : String -> Msg
keyPressToMsg key =
    case RobotLogic.commandFromKey key of
        Just command ->
            KeyboardCommand command

        Nothing ->
            IgnoreKeyPress


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
