module Book.RobotChapter exposing (SharedState, chapter)

import Book.Fixtures exposing (RobotDemo)
import Element
import ElmBook.Actions exposing (mapUpdate)
import ElmBook.Chapter exposing (renderStatefulComponent)
import ElmBook.ElmUI exposing (Chapter)
import Robot
import Robot.View
import View.Theme as Theme


type alias SharedState x =
    { x
        | robotDemo : RobotDemo
        , themeMode : Theme.Mode
    }


chapter : Chapter (SharedState x)
chapter =
    ElmBook.Chapter.chapter "Robot Playground"
        |> renderStatefulComponent
            (\state ->
                Robot.View.view
                    False
                    (Theme.palette state.themeMode)
                    state.robotDemo
                    (Robot.controls identity)
                    |> Element.map
                        (mapUpdate
                            { toState = \sharedState robotDemo -> { sharedState | robotDemo = robotDemo }
                            , fromState = .robotDemo
                            , update = Robot.update
                            }
                        )
            )
