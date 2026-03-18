module Book.MotorcycleChapter exposing (chapter)

import ElmBook.Chapter exposing (renderComponent)
import ElmBook.ElmUI exposing (Chapter)
import Motorcycle.Page
import View.Theme as Theme


chapter : Chapter state
chapter =
    ElmBook.Chapter.chapter "Motorcycle Panels"
        |> renderComponent
            (Motorcycle.Page.view (Theme.palette Theme.Light))
