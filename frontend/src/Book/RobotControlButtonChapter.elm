module Book.RobotControlButtonChapter exposing (SharedState, chapter)

import Element exposing (column, spacing)
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (renderStatefulComponent)
import ElmBook.ElmUI exposing (Chapter)
import Robot.View
import View.Theme as Theme


type alias SharedState x =
    { x | themeMode : Theme.Mode }


chapter : Chapter (SharedState x)
chapter =
    ElmBook.Chapter.chapter "Robot Control Button"
        |> renderStatefulComponent
            (\state ->
                let
                    colors : Theme.Palette
                    colors =
                        Theme.palette state.themeMode
                in
                column
                    [ spacing 12 ]
                    [ Robot.View.controlButton colors "Move Forward" (Just (logAction "Move Forward"))
                    , Robot.View.controlButton colors "Move Forward" Nothing
                    ]
            )
