module View exposing (Page(..), themeToggleDescription, toggleThemeMode, view)

import Element exposing (Element, centerX, centerY, column, el, fill, height, layout, maximum, paddingEach, paddingXY, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Motorcycle.Page as MotorcyclePage
import Robot.Logic as RobotLogic
import Robot.Model as Robot
import Robot.View
import View.Theme as Theme
import View.ThemeToggle as ThemeToggle


type Page
    = MotorcyclePage
    | RobotPage


type alias Config msg =
    { selectPage : Page -> msg
    , setTheme : Theme.Mode -> msg
    , robotControls : Robot.View.Controls msg
    }


view :
    { a
        | motorcycleFeed :
            { visibleProducts : List MotorcyclePage.Product
            , pendingProducts : List MotorcyclePage.Product
            }
        , robot : Robot.Robot
        , history : List RobotLogic.HistoryEntry
        , themeMode : Theme.Mode
        , currentPage : Page
        , viewport : { width : Int, height : Int }
    }
    -> Config msg
    -> Html.Html msg
view model config =
    layout
        []
        (page model config)


page :
    { a
        | motorcycleFeed :
            { visibleProducts : List MotorcyclePage.Product
            , pendingProducts : List MotorcyclePage.Product
            }
        , robot : Robot.Robot
        , history : List RobotLogic.HistoryEntry
        , themeMode : Theme.Mode
        , currentPage : Page
        , viewport : { width : Int, height : Int }
    }
    -> Config msg
    -> Element msg
page model config =
    let
        colors =
            Theme.palette model.themeMode

        compactLayout =
            isCompact model.viewport.width

        horizontalPadding =
            if compactLayout then
                20

            else
                40

        verticalPadding =
            if compactLayout then
                24

            else
                40
    in
    el
        [ width fill
        , height fill
        , Background.color colors.appBackground
        , Font.color colors.bodyText
        ]
        (column
            [ width (maximum 1180 fill)
            , height fill
            , centerX
            , spacing 40
            , paddingXY horizontalPadding verticalPadding
            ]
            [ siteHeader compactLayout colors model.currentPage model.themeMode config
            , pageBody compactLayout colors model config.robotControls
            ]
        )


siteHeader : Bool -> Theme.Palette -> Page -> Theme.Mode -> Config msg -> Element msg
siteHeader compactLayout colors currentPage themeMode config =
    if compactLayout then
        column
            [ width fill
            , spacing 20
            , paddingEach { top = 8, right = 0, bottom = 8, left = 0 }
            ]
            [ row
                [ width fill ]
                [ el
                    [ Font.size 20
                    , Font.semiBold
                    , centerY
                    ]
                    (text "Fitzbeach")
                , el [ width fill ] Element.none
                , ThemeToggle.view colors themeMode (config.setTheme (ThemeToggle.toggleThemeMode themeMode))
                ]
            , row
                [ spacing 24
                , centerY
                ]
                [ menuButton colors currentPage MotorcyclePage "Motorcycle" config
                , menuButton colors currentPage RobotPage "Robot" config
                ]
            ]

    else
        row
            [ width fill
            , paddingEach { top = 8, right = 0, bottom = 8, left = 0 }
            ]
            [ row
                [ spacing 32
                , centerY
                ]
                [ el
                    [ Font.size 20
                    , Font.semiBold
                    , centerY
                    ]
                    (text "Fitzbeach")
                , row
                    [ spacing 24
                    , centerY
                    ]
                    [ menuButton colors currentPage MotorcyclePage "Motorcycle" config
                    , menuButton colors currentPage RobotPage "Robot" config
                    ]
                ]
            , el [ width fill ] Element.none
            , ThemeToggle.view colors themeMode (config.setTheme (ThemeToggle.toggleThemeMode themeMode))
            ]


menuButton : Theme.Palette -> Page -> Page -> String -> Config msg -> Element msg
menuButton colors currentPage targetPage label config =
    Input.button
        [ Background.color colors.appBackground
        , Border.widthEach
            { top = 0, right = 0, bottom = 1, left = 0 }
        , Border.color
            (if currentPage == targetPage then
                colors.bodyText

             else
                colors.panelBorder
            )
        , paddingEach { top = 6, right = 0, bottom = 8, left = 0 }
        , Font.size 15
        , Font.color
            (if currentPage == targetPage then
                colors.bodyText

             else
                colors.detailText
            )
        ]
        { onPress = Just (config.selectPage targetPage)
        , label = text label
        }


pageBody :
    Bool
    -> Theme.Palette
    ->
        { a
            | motorcycleFeed :
                { visibleProducts : List MotorcyclePage.Product
                , pendingProducts : List MotorcyclePage.Product
                }
            , robot : Robot.Robot
            , history : List RobotLogic.HistoryEntry
            , currentPage : Page
        }
    -> Robot.View.Controls msg
    -> Element msg
pageBody compactLayout colors model robotControls =
    case model.currentPage of
        MotorcyclePage ->
            MotorcyclePage.view
                compactLayout
                colors
                model.motorcycleFeed.visibleProducts
                (not (List.isEmpty model.motorcycleFeed.pendingProducts))

        RobotPage ->
            Robot.View.page compactLayout colors model robotControls


isCompact : Int -> Bool
isCompact viewportWidth =
    viewportWidth /= 0 && viewportWidth < 760


toggleThemeMode : Theme.Mode -> Theme.Mode
toggleThemeMode =
    ThemeToggle.toggleThemeMode


themeToggleDescription : Theme.Mode -> String
themeToggleDescription =
    ThemeToggle.themeToggleDescription
