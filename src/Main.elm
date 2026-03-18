module Main exposing
    ( Model
    , MotorcycleFeed
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
import Motorcycle.Page as MotorcyclePage
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
    , motorcycleFeed : MotorcycleFeed
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


type alias MotorcycleFeed =
    { visibleProducts : List MotorcyclePage.Product
    , pendingProducts : List MotorcyclePage.Product
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
                        initialMotorcycleFeed

                    else
                        model.motorcycleFeed
              }
            , Cmd.none
            )

        ResizeViewport width height ->
            ( { model | viewport = { width = width, height = height } }, Cmd.none )

        ReceiveNextProduct ->
            ( { model | motorcycleFeed = receiveNextProduct model.motorcycleFeed }, Cmd.none )


initModel : Model
initModel =
    { robot = Robot.initialRobot
    , history = []
    , themeMode = Theme.Light
    , currentPage = View.MotorcyclePage
    , motorcycleFeed = initialMotorcycleFeed
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


receiveNextProduct : MotorcycleFeed -> MotorcycleFeed
receiveNextProduct feed =
    case feed.pendingProducts of
        nextProduct :: remainingProducts ->
            { visibleProducts = feed.visibleProducts ++ [ nextProduct ]
            , pendingProducts = remainingProducts
            }

        [] ->
            feed


initialMotorcycleFeed : MotorcycleFeed
initialMotorcycleFeed =
    { visibleProducts = []
    , pendingProducts = MotorcyclePage.products
    }


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
