module Book.ProductPanelChapter exposing (SharedState, chapter)

import ElmBook.Chapter exposing (renderStatefulComponent)
import ElmBook.ElmUI exposing (Chapter)
import Generated.Api.Product exposing (Product)
import Motorcycle.View
import View.Theme as Theme


type alias SharedState x =
    { x | themeMode : Theme.Mode }


chapter : Chapter (SharedState x)
chapter =
    ElmBook.Chapter.chapter "Product Panel"
        |> renderStatefulComponent
            (\state ->
                Motorcycle.View.productPanel
                    False
                    (Theme.palette state.themeMode)
                    samplePanel
            )


samplePanel : Product
samplePanel =
    { id = 1
    , name = "Ranch Road Saddlebag"
    , category = "Heritage Carry"
    , priceCents = 18900
    , currency = "USD"
    , imageUrl = "https://unsplash.com/photos/pFU2KqC7qp8/download?force=true&w=900"
    }
