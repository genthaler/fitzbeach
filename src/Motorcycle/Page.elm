module Motorcycle.Page exposing (ProductPanel, productPanel, view)

import Element exposing (Element, alignBottom, column, el, fill, height, padding, paragraph, px, spacing, text, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import View.Theme as Theme


view : Theme.Palette -> Element msg
view colors =
    column
        [ width fill
        , spacing 28
        , Element.paddingEach { top = 24, right = 0, bottom = 0, left = 0 }
        ]
        [ pageHeading colors "Motorcycle"
        , wrappedRow
            [ width fill
            , spacing 20
            ]
            (List.map (productPanel colors) productPanels)
        ]


pageHeading : Theme.Palette -> String -> Element msg
pageHeading colors labelText =
    column
        [ width fill
        , spacing 8
        ]
        [ el [ Font.size 36 ] (text labelText)
        , el
            [ width fill
            , height (px 1)
            , Background.color colors.panelBorder
            ]
            Element.none
        ]


type alias ProductPanel =
    { name : String
    , price : String
    , description : String
    }


productPanels : List ProductPanel
productPanels =
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


productPanel : Theme.Palette -> ProductPanel -> Element msg
productPanel colors panel =
    column
        [ width (px 280)
        , height (px 452)
        , spacing 28
        , padding 28
        , Background.color colors.panelBackground
        , Border.width 1
        , Border.rounded 24
        , Border.color colors.panelBorder
        ]
        [ el
            [ width fill
            , height (px 236)
            , Background.color colors.appBackground
            , Border.width 1
            , Border.rounded 18
            , Border.color colors.panelBorder
            ]
            Element.none
        , el
            [ Font.size 14
            , Font.color colors.bodyText
            ]
            (text panel.name)
        , paragraph
            [ Font.size 15
            , Font.color colors.detailText
            , width fill
            , Element.spacing 6
            ]
            [ text panel.price ]
        , el
            [ alignBottom
            , Font.size 13
            , Font.color colors.detailText
            ]
            (text panel.description)
        ]
