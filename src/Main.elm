module Main exposing
    ( Model
    , Msg(..)
    , Viewport
    , initModel
    , main
    , update
    )

import Browser
import Browser.Events
import Html
import Json.Decode as Decode
import Motorcycle.Model as Motorcycle
import Robot.Logic as RobotLogic
import Robot.Model as Robot
import Time
import View
import View.Theme as Theme


type alias Model =
    { robot : Robot.Robot
    , history : List RobotLogic.HistoryEntry
    , themeMode : Theme.Mode
    , currentPage : View.Page
    , motorcycleFeed : Motorcycle.Feed
    , viewport : Viewport
    }


type Msg
    = MoveForward
    | TurnLeft
    | TurnRight
    | Undo
    | Reset
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
        MoveForward ->
            ( RobotLogic.applyCommand RobotLogic.MoveForwardCommand model, Cmd.none )

        TurnLeft ->
            ( RobotLogic.applyCommand RobotLogic.TurnLeftCommand model, Cmd.none )

        TurnRight ->
            ( RobotLogic.applyCommand RobotLogic.TurnRightCommand model, Cmd.none )

        KeyboardCommand command ->
            ( RobotLogic.applyCommand command model, Cmd.none )

        IgnoreKeyPress ->
            ( model, Cmd.none )

        Undo ->
            ( RobotLogic.undo model, Cmd.none )

        Reset ->
            ( { model | robot = Robot.initialRobot, history = [] }, Cmd.none )

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
    { robot = Robot.initialRobot
    , history = []
    , themeMode = Theme.Light
    , currentPage = View.MotorcyclePage
    , motorcycleFeed = Motorcycle.initialFeed
    , viewport = { width = 0, height = 0 }
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize ResizeViewport
        , if model.currentPage /= View.MotorcyclePage || List.isEmpty model.motorcycleFeed.pendingProducts then
            Sub.none

          else
            Time.every 250 (\_ -> ReceiveNextProduct)
        , case model.currentPage of
            View.RobotPage ->
                Browser.Events.onKeyDown
                    (Decode.map keyPressToMsg (Decode.field "key" Decode.string))

            View.MotorcyclePage ->
                Sub.none
        ]


keyPressToMsg : String -> Msg
keyPressToMsg key =
    case RobotLogic.commandFromKey key of
        Just command ->
            KeyboardCommand command

        Nothing ->
            IgnoreKeyPress


view : Model -> Html.Html Msg
view model =
    View.view model
        { selectPage = SelectPage
        , setTheme = SetTheme
        , robotControls =
            { moveForward = MoveForward
            , turnLeft = TurnLeft
            , turnRight = TurnRight
            , undo = Undo
            , reset = Reset
            }
        }
