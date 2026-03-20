module Motorcycle.Model exposing
    ( Feed
    , Product
    , initialFeed
    , products
    , receiveNextProduct
    )


type alias Product =
    { name : String
    , price : String
    , description : String
    }


type alias Feed =
    { visibleProducts : List Product
    , pendingProducts : List Product
    }


products : List Product
products =
    [ { name = "Transit"
      , price = "$89"
      , description = "Compact essentials"
      }
    , { name = "Materials"
      , price = "$129"
      , description = "Light, durable, adaptable"
      }
    , { name = "Carry"
      , price = "$159"
      , description = "Everyday travel use"
      }
    , { name = "Packing"
      , price = "$199"
      , description = "Organised without bulk"
      }
    , { name = "Summit"
      , price = "$69"
      , description = "Slim carry for short city rides"
      }
    , { name = "Contour"
      , price = "$79"
      , description = "Compact storage with a refined shell"
      }
    , { name = "Drift"
      , price = "$99"
      , description = "Everyday capacity with quick access"
      }
    , { name = "Terrain"
      , price = "$109"
      , description = "Balanced organisation for longer hauls"
      }
    , { name = "Axis"
      , price = "$119"
      , description = "Structured carry with understated detailing"
      }
    , { name = "Range"
      , price = "$139"
      , description = "Versatile storage for mixed travel days"
      }
    , { name = "Nomad"
      , price = "$149"
      , description = "Lightweight packing with durable finishes"
      }
    , { name = "Vector"
      , price = "$169"
      , description = "Purposeful compartments in a calm form"
      }
    , { name = "Roam"
      , price = "$179"
      , description = "Expanded capacity without visual bulk"
      }
    , { name = "Passage"
      , price = "$189"
      , description = "Travel-ready layout with quiet utility"
      }
    ]


initialFeed : Feed
initialFeed =
    { visibleProducts = []
    , pendingProducts = products
    }


receiveNextProduct : Feed -> Feed
receiveNextProduct feed =
    case feed.pendingProducts of
        nextProduct :: remainingProducts ->
            { visibleProducts = feed.visibleProducts ++ [ nextProduct ]
            , pendingProducts = remainingProducts
            }

        [] ->
            feed
