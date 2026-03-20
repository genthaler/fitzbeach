module Motorcycle.Page exposing (productPanel, view)

import Element exposing (Element, alignBottom, column, el, fill, height, padding, paragraph, px, spacing, text, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Motorcycle.Model exposing (Product)
import View.Theme as Theme


view : Bool -> Theme.Palette -> Int -> List Product -> Bool -> Element msg
view compactLayout colors totalProducts loadedProducts isLoading =
    column
        [ width fill
        , spacing 28
        , Element.paddingEach { top = 24, right = 0, bottom = 0, left = 0 }
        ]
        [ pageHeading compactLayout colors "Motorcycle"
        , loadingStatus colors totalProducts loadedProducts isLoading
        , productPanelLayout compactLayout colors loadedProducts
        ]


pageHeading : Bool -> Theme.Palette -> String -> Element msg
pageHeading compactLayout colors labelText =
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
            Element.none
        ]


loadingStatus : Theme.Palette -> Int -> List Product -> Bool -> Element msg
loadingStatus colors totalCount loadedProducts isLoading =
    el
        [ Font.size 14
        , Font.color colors.detailText
        ]
        (text
            (if isLoading then
                "Loading products... "
                    ++ String.fromInt (List.length loadedProducts)
                    ++ " of "
                    ++ String.fromInt totalCount

             else
                "Collection loaded. "
                    ++ String.fromInt totalCount
                    ++ " products available."
            )
        )


productPanelLayout : Bool -> Theme.Palette -> List Product -> Element msg
productPanelLayout compactLayout colors loadedProducts =
    let
        panels =
            List.map (productPanel compactLayout colors) loadedProducts
    in
    if compactLayout then
        column
            [ width fill
            , spacing 20
            ]
            panels

    else
        wrappedRow
            [ width fill
            , spacing 20
            ]
            panels


productPanel : Bool -> Theme.Palette -> Product -> Element msg
productPanel compactLayout colors panel =
    let
        panelHeight =
            if compactLayout then
                396

            else
                452

        imageHeight =
            if compactLayout then
                188

            else
                236

        panelWidth =
            if compactLayout then
                fill

            else
                px 280
    in
    column
        [ width panelWidth
        , height (px panelHeight)
        , spacing 28
        , padding 28
        , Background.color colors.panelBackground
        , Border.width 1
        , Border.rounded 24
        , Border.color colors.panelBorder
        ]
        [ el
            [ width fill
            , height (px imageHeight)
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
