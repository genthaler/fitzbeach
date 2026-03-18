module Book.MotorcycleChapter exposing (SharedState, chapter)

import ElmBook.Chapter exposing (renderStatefulComponent)
import ElmBook.ElmUI exposing (Chapter)
import Motorcycle.Page
import View.Theme as Theme


type alias SharedState x =
    { x | themeMode : Theme.Mode }


chapter : Chapter (SharedState x)
chapter =
    ElmBook.Chapter.chapter "Motorcycle Panels"
        |> renderStatefulComponent
            (\state ->
                Motorcycle.Page.view (Theme.palette state.themeMode)
            )
