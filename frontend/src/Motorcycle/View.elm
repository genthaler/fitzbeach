module Motorcycle.View exposing (productPanel, view)

import Element exposing (Element, alignBottom, clip, column, el, fill, height, padding, paragraph, px, spacing, text, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Generated.Api.Product exposing (Product)
import Html
import Html.Attributes as HtmlAttributes
import Motorcycle.Model as MotorcycleModel exposing (ProductState(..))
import ServiceHealth exposing (ServiceHealth(..))
import String
import View.PageHeading as PageHeading
import View.Theme as Theme


view : Bool -> Theme.Palette -> ServiceHealth -> ProductState -> Element msg
view compactLayout colors serviceHealth productState =
    column
        [ width fill
        , spacing 28
        , Element.paddingEach { top = 24, right = 0, bottom = 0, left = 0 }
        ]
        [ PageHeading.view compactLayout colors "Motorcycle"
        , statusPanel compactLayout colors serviceHealth productState
        , productPanelLayout compactLayout colors productState
        ]


statusPanel : Bool -> Theme.Palette -> ServiceHealth -> ProductState -> Element msg
statusPanel compactLayout colors serviceHealth productState =
    let
        healthMessage : String
        healthMessage =
            case serviceHealth of
                Checking ->
                    "Health check in progress."

                Available status ->
                    "Service status: " ++ status ++ "."

                Unavailable reason ->
                    "Health check failed. " ++ reason

        productsMessage : String
        productsMessage =
            case productState of
                Loading ->
                    " Loading products from the local service."

                Loaded loadedProducts ->
                    " Collection loaded. "
                        ++ String.fromInt (List.length loadedProducts)
                        ++ " products available."

                Failed reason ->
                    " Product service unavailable. " ++ reason
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
        (text (healthMessage ++ productsMessage))


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
            (Element.html
                (Html.img
                    [ HtmlAttributes.src panel.imageUrl
                    , HtmlAttributes.alt panel.name
                    , HtmlAttributes.style "width" "100%"
                    , HtmlAttributes.style "height" "100%"
                    , HtmlAttributes.style "display" "block"
                    , HtmlAttributes.style "object-fit" "cover"
                    , HtmlAttributes.style "object-position" "center"
                    ]
                    []
                )
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
