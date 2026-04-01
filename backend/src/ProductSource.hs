{-# LANGUAGE OverloadedStrings #-}

module ProductSource
    ( allProducts
    ) where

import Prelude hiding (id)
import Product (Product (..))

allProducts :: [Product]
allProducts =
    [ Product
        { id = 1
        , name = "Saffron Sprint 125"
        , category = "City Scooter"
        , priceCents = 429900
        , currency = "USD"
        , imageUrl = "https://unsplash.com/photos/s2dz23qouqQ/download?force=true&w=900"
        }
    , Product
        { id = 2
        , name = "Coastline Rally 650"
        , category = "Open Road"
        , priceCents = 869900
        , currency = "USD"
        , imageUrl = "https://unsplash.com/photos/PdGdU9zMkRY/download?force=true&w=900"
        }
    , Product
        { id = 3
        , name = "Drift Textile Rider Jacket"
        , category = "Rider Apparel"
        , priceCents = 21900
        , currency = "USD"
        , imageUrl = "https://unsplash.com/photos/Fu7HrrSaUIE/download?force=true&w=900"
        }
    , Product
        { id = 4
        , name = "Sunline Cruiser 200"
        , category = "Weekend Escape"
        , priceCents = 519900
        , currency = "USD"
        , imageUrl = "https://unsplash.com/photos/7D9QdFY2jUk/download?force=true&w=900"
        }
    , Product
        { id = 5
        , name = "Ranch Road Saddlebag"
        , category = "Heritage Carry"
        , priceCents = 18900
        , currency = "USD"
        , imageUrl = "https://unsplash.com/photos/pFU2KqC7qp8/download?force=true&w=900"
        }
    , Product
        { id = 6
        , name = "Granite Touring Twin"
        , category = "Adventure Bike"
        , priceCents = 1129900
        , currency = "USD"
        , imageUrl = "https://unsplash.com/photos/n5yE3QCYiAY/download?force=true&w=900"
        }
    , Product
        { id = 7
        , name = "Marigold Lane 150"
        , category = "Scooter"
        , priceCents = 449900
        , currency = "USD"
        , imageUrl = "https://unsplash.com/photos/ssa5tbPhVcM/download?force=true&w=900"
        }
    , Product
        { id = 8
        , name = "Metro Lane Riding Gloves"
        , category = "Daily Carry"
        , priceCents = 7900
        , currency = "USD"
        , imageUrl = "https://unsplash.com/photos/kPfwWyUWubA/download?force=true&w=900"
        }
    , Product
        { id = 9
        , name = "Overnighter Roll Duffel"
        , category = "Road Trip Kit"
        , priceCents = 24900
        , currency = "USD"
        , imageUrl = "https://unsplash.com/photos/zBfE2FaPJ2o/download?force=true&w=900"
        }
    , Product
        { id = 10
        , name = "Copper State Pannier Pair"
        , category = "Cruiser Touring"
        , priceCents = 32900
        , currency = "USD"
        , imageUrl = "https://unsplash.com/photos/dp0r1MkhKNg/download?force=true&w=900"
        }
    , Product
        { id = 11
        , name = "Lane Split Commuter Pack"
        , category = "City Carry"
        , priceCents = 11900
        , currency = "USD"
        , imageUrl = "https://unsplash.com/photos/aMl7QzpzYdA/download?force=true&w=900"
        }
    ]
