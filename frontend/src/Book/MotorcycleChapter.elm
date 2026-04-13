module Book.MotorcycleChapter exposing (SharedState, chapter)

import ElmBook.Chapter exposing (renderStatefulComponent)
import ElmBook.ElmUI exposing (Chapter)
import Motorcycle.Model
import Motorcycle.View
import ServiceHealth
import View.Theme as Theme


type alias SharedState x =
    { x | themeMode : Theme.Mode }


chapter : Chapter (SharedState x)
chapter =
    ElmBook.Chapter.chapter "Motorcycle Panels"
        |> renderStatefulComponent
            (\state ->
                Motorcycle.View.view
                    False
                    (Theme.palette state.themeMode)
                    (ServiceHealth.Available "healthy")
                    (Motorcycle.Model.Loaded Motorcycle.Model.sampleProducts)
            )
