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
      , name = "Transit Helmet Bag"
      , category = "Moto Travel"
      , priceCents = 18900
      , currency = "USD"
      , imageUrl = "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80"
      }
    , { id = 2
      , name = "Contour Tank Sling"
      , category = "Daily Carry"
      , priceCents = 12900
      , currency = "USD"
      , imageUrl = "https://images.unsplash.com/photo-1523398002811-999ca8dec234?auto=format&fit=crop&w=900&q=80"
      }
    , { id = 3
      , name = "Summit Roll Pack"
      , category = "Weekend Ride"
      , priceCents = 24900
      , currency = "USD"
      , imageUrl = "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=900&q=80"
      }
    , { id = 4
      , name = "Range Utility Pouch"
      , category = "Organisation"
      , priceCents = 6900
      , currency = "USD"
      , imageUrl = "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=900&q=80"
      }
    ]
