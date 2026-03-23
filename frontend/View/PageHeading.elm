module View.PageHeading exposing (view)

import Element exposing (Element, column, el, fill, height, none, px, spacing, text, width)
import Element.Background as Background
import Element.Font as Font
import View.Theme as Theme


view : Bool -> Theme.Palette -> String -> Element msg
view compactLayout colors labelText =
    column
        [ width fill
        , spacing 8
        ]
        [ el
            [ Font.size
                (if compactLayout then
                    30

                 else
                    36
                )
            ]
            (text labelText)
        , el
            [ width fill
            , height (px 1)
            , Background.color colors.panelBorder
            ]
            none
        ]
