module Book.RobotChapter exposing (SharedState, chapter)

import Book.Fixtures exposing (RobotDemo)
import Element
import ElmBook.Actions exposing (mapUpdate)
import ElmBook.Chapter exposing (renderStatefulComponent)
import ElmBook.ElmUI exposing (Chapter)
import Robot.Logic as RobotLogic
import Robot.View
import View.Theme as Theme


type alias SharedState x =
    { x
        | robotDemo : RobotDemo
        , themeMode : Theme.Mode
    }


type Msg
    = MoveForward
    | TurnLeft
    | TurnRight
    | Undo
    | Reset


chapter : Chapter (SharedState x)
chapter =
    ElmBook.Chapter.chapter "Robot Playground"
        |> renderStatefulComponent
            (\state ->
                Robot.View.page
                    False
                    (Theme.palette state.themeMode)
                    state.robotDemo
                    { moveForward = MoveForward
                    , turnLeft = TurnLeft
                    , turnRight = TurnRight
                    , undo = Undo
                    , reset = Reset
                    }
                    |> Element.map
                        (mapUpdate
                            { toState = \sharedState robotDemo -> { sharedState | robotDemo = robotDemo }
                            , fromState = .robotDemo
                            , update = update
                            }
                        )
            )


update : Msg -> RobotDemo -> RobotDemo
update msg model =
    case msg of
        MoveForward ->
            RobotLogic.applyCommand RobotLogic.MoveForwardCommand model

        TurnLeft ->
            RobotLogic.applyCommand RobotLogic.TurnLeftCommand model

        TurnRight ->
            RobotLogic.applyCommand RobotLogic.TurnRightCommand model

        Undo ->
            RobotLogic.undo model

        Reset ->
            Book.Fixtures.initialRobotDemo
