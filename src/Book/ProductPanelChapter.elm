module Book.ProductPanelChapter exposing (SharedState, chapter)

import ElmBook.Chapter exposing (renderStatefulComponent)
import ElmBook.ElmUI exposing (Chapter)
import Motorcycle.Page
import View.Theme as Theme


type alias SharedState x =
    { x | themeMode : Theme.Mode }


chapter : Chapter (SharedState x)
chapter =
    ElmBook.Chapter.chapter "Product Panel"
        |> renderStatefulComponent
            (\state ->
                Motorcycle.Page.productPanel
                    (Theme.palette state.themeMode)
                    samplePanel
            )


samplePanel : Motorcycle.Page.ProductPanel
samplePanel =
    { name = "Transit"
    , price = "$89"
    , description = "Compact essentials"
    }
