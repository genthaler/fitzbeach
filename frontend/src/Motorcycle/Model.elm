module Motorcycle.Model exposing (ProductState(..), priceLabel, sampleProducts)

import Generated.Api.Product exposing (Product)
import String


type ProductState
    = Loading
    | Loaded (List Product)
    | Failed String


priceLabel : Product -> String
priceLabel product =
    let
        centsText : String
        centsText =
            String.padLeft 2 '0' (String.fromInt (remainderBy 100 product.priceCents))
    in
    currencySymbol product.currency
        ++ String.fromInt (product.priceCents // 100)
        ++ "."
        ++ centsText


currencySymbol : String -> String
currencySymbol currency =
    case currency of
        "USD" ->
            "$"

        "AUD" ->
            "$"

        _ ->
            currency ++ " "


sampleProducts : List Product
sampleProducts =
    [ { id = 1
      , name = "Saffron Sprint 125"
      , category = "City Scooter"
      , priceCents = 429900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/s2dz23qouqQ/download?force=true&w=900"
      }
    , { id = 2
      , name = "Coastline Rally 650"
      , category = "Open Road"
      , priceCents = 869900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/PdGdU9zMkRY/download?force=true&w=900"
      }
    , { id = 3
      , name = "Drift Textile Rider Jacket"
      , category = "Rider Apparel"
      , priceCents = 21900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/Fu7HrrSaUIE/download?force=true&w=900"
      }
    , { id = 4
      , name = "Sunline Cruiser 200"
      , category = "Weekend Escape"
      , priceCents = 519900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/7D9QdFY2jUk/download?force=true&w=900"
      }
    , { id = 5
      , name = "Ranch Road Saddlebag"
      , category = "Heritage Carry"
      , priceCents = 18900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/pFU2KqC7qp8/download?force=true&w=900"
      }
    , { id = 6
      , name = "Granite Touring Twin"
      , category = "Adventure Bike"
      , priceCents = 1129900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/n5yE3QCYiAY/download?force=true&w=900"
      }
    , { id = 7
      , name = "Marigold Lane 150"
      , category = "Scooter"
      , priceCents = 449900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/ssa5tbPhVcM/download?force=true&w=900"
      }
    , { id = 8
      , name = "Metro Lane Riding Gloves"
      , category = "Daily Carry"
      , priceCents = 7900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/kPfwWyUWubA/download?force=true&w=900"
      }
    , { id = 9
      , name = "Overnighter Roll Duffel"
      , category = "Road Trip Kit"
      , priceCents = 24900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/zBfE2FaPJ2o/download?force=true&w=900"
      }
    , { id = 10
      , name = "Copper State Pannier Pair"
      , category = "Cruiser Touring"
      , priceCents = 32900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/dp0r1MkhKNg/download?force=true&w=900"
      }
    , { id = 11
      , name = "Lane Split Commuter Pack"
      , category = "City Carry"
      , priceCents = 11900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/aMl7QzpzYdA/download?force=true&w=900"
      }
    , { id = 12
      , name = "Veloce Street Rack"
      , category = "Urban Utility"
      , priceCents = 15900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/TqpXyai-0wg/download?force=true&w=900"
      }
    , { id = 13
      , name = "Apex Trail Scrambler"
      , category = "Scrambler"
      , priceCents = 939900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/kOrwoufQVgs/download?force=true&w=900"
      }
    , { id = 14
      , name = "Mesa Rider Boots"
      , category = "Rider Apparel"
      , priceCents = 16900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/JeQQF0LDY-Q/download?force=true&w=900"
      }
    , { id = 15
      , name = "Northline Weekend Pouch"
      , category = "Compact Carry"
      , priceCents = 9900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/ICk4Zwt7USM/download?force=true&w=900"
      }
    , { id = 16
      , name = "Cinder Frame Pack"
      , category = "Bikepacking"
      , priceCents = 13900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/c2ZGV8Trmbw/download?force=true&w=900"
      }
    , { id = 17
      , name = "Signal Mirror Set"
      , category = "Workshop Parts"
      , priceCents = 8900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/pJvWS0xjUec/download?force=true&w=900"
      }
    , { id = 18
      , name = "Bronze Mile Saddle Roll"
      , category = "Touring Gear"
      , priceCents = 20900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/Tq7fw_6MStA/download?force=true&w=900"
      }
    , { id = 19
      , name = "Night Shift Chain Lock"
      , category = "Security"
      , priceCents = 6900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/kG99I8LXEBA/download?force=true&w=900"
      }
    , { id = 20
      , name = "Summit Courier Satchel"
      , category = "Commuter Carry"
      , priceCents = 14900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/1R7LdUGPcp0/download?force=true&w=900"
      }
    , { id = 21
      , name = "Highline Tank Bag"
      , category = "Roadside Kit"
      , priceCents = 17900
      , currency = "USD"
      , imageUrl = "https://unsplash.com/photos/9ORAXkDMywE/download?force=true&w=900"
      }
    ]
