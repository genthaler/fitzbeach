module Motorcycle exposing (productPanel, view)

import Element exposing (Element, alignBottom, clip, column, el, fill, height, image, padding, paragraph, px, spacing, text, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Motorcycle.Model as MotorcycleModel exposing (Product, ProductState(..))
import String
import View.Theme as Theme


view : Bool -> Theme.Palette -> ProductState -> Element msg
view compactLayout colors productState =
    column
        [ width fill
        , spacing 28
        , Element.paddingEach { top = 24, right = 0, bottom = 0, left = 0 }
        ]
        [ pageHeading compactLayout colors "Motorcycle"
        , statusPanel compactLayout colors productState
        , productPanelLayout compactLayout colors productState
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


statusPanel : Bool -> Theme.Palette -> ProductState -> Element msg
statusPanel compactLayout colors productState =
    let
        message : String
        message =
            case productState of
                Loading ->
                    "Loading products from the local service."

                Loaded loadedProducts ->
                    "Collection loaded. "
                        ++ String.fromInt (List.length loadedProducts)
                        ++ " products available."

                Failed reason ->
                    "Product service unavailable. " ++ reason
    in
    el
        [ Font.size 14
        , Font.color colors.detailText
        , width fill
        , Background.color colors.panelBackground
        , Border.width 1
        , Border.rounded 18
        , Border.color colors.panelBorder
        , padding
            (if compactLayout then
                18

             else
                20
            )
        ]
        (text message)


productPanelLayout : Bool -> Theme.Palette -> ProductState -> Element msg
productPanelLayout compactLayout colors productState =
    let
        panels : List (Element msg)
        panels =
            case productState of
                Loaded loadedProducts ->
                    List.map (productPanel compactLayout colors) loadedProducts

                Loading ->
                    []

                Failed _ ->
                    []
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
        panelHeight : Int
        panelHeight =
            if compactLayout then
                396

            else
                452

        imageHeight : Int
        imageHeight =
            if compactLayout then
                188

            else
                236

        panelWidth : Element.Length
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
            , clip
            , Border.rounded 18
            ]
            (image
                [ width fill
                , height fill
                ]
                { src = panel.imageUrl
                , description = panel.name
                }
            )
        , el
            [ Font.size 13
            , Font.color colors.detailText
            ]
            (text panel.category)
        , paragraph
            [ Font.size 24
            , Font.color colors.bodyText
            , width fill
            , Element.spacing 6
            ]
            [ text panel.name ]
        , paragraph
            [ Font.size 15
            , Font.color colors.bodyText
            , width fill
            , Element.spacing 6
            ]
            [ text (MotorcycleModel.priceLabel panel) ]
        , el
            [ alignBottom
            , Font.size 13
            , Font.color colors.detailText
            ]
            (text ("Product #" ++ String.fromInt panel.id))
        ]
