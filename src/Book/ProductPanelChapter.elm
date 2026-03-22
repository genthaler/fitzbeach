module Book.ProductPanelChapter exposing (SharedState, chapter)

import ElmBook.Chapter exposing (renderStatefulComponent)
import ElmBook.ElmUI exposing (Chapter)
import Motorcycle
import Motorcycle.Model
import View.Theme as Theme


type alias SharedState x =
    { x | themeMode : Theme.Mode }


chapter : Chapter (SharedState x)
chapter =
    ElmBook.Chapter.chapter "Product Panel"
        |> renderStatefulComponent
            (\state ->
                Motorcycle.productPanel
                    False
                    (Theme.palette state.themeMode)
                    samplePanel
            )


samplePanel : Motorcycle.Model.Product
samplePanel =
    { id = 1
    , name = "Transit Helmet Bag"
    , category = "Moto Travel"
    , priceCents = 18900
    , currency = "USD"
    , imageUrl = "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80"
    }
