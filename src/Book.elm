module Book exposing (SharedState, main)

import Book.Fixtures
import Book.MotorcycleChapter
import Book.ProductPanelChapter
import Book.RobotChapter
import Book.ThemeChapter
import Element exposing (Element, toRgb)
import ElmBook exposing (withChapterGroups, withStatefulOptions)
import ElmBook.ElmUI exposing (Book, book)
import ElmBook.StatefulOptions
import ElmBook.ThemeOptions
import Html
import View.Theme as Theme


type alias SharedState =
    { themeMode : Theme.Mode
    , robotDemo : Book.Fixtures.RobotDemo
    }


initialState : SharedState
initialState =
    { themeMode = Theme.Light
    , robotDemo = Book.Fixtures.initialRobotDemo
    }


main : Book SharedState
main =
    book "Fitzbeach"
        |> ElmBook.withThemeOptions bookThemeOptions
        |> withStatefulOptions
            [ ElmBook.StatefulOptions.initialState initialState
            , ElmBook.StatefulOptions.onDarkModeChange
                (\darkMode state ->
                    { state
                        | themeMode =
                            if darkMode then
                                Theme.Dark

                            else
                                Theme.Light
                    }
                )
            ]
        |> withChapterGroups
            [ ( "Foundations"
              , [ Book.ThemeChapter.chapter
                , Book.ProductPanelChapter.chapter
                ]
              )
            , ( "Pages"
              , [ Book.MotorcycleChapter.chapter
                , Book.RobotChapter.chapter
                ]
              )
            ]


bookThemeOptions : List (ElmBook.ThemeOptions.ThemeOption (Element msg))
bookThemeOptions =
    let
        colors =
            Theme.palette Theme.Light
    in
    [ ElmBook.ThemeOptions.subtitle "Calm component catalogue"
    , ElmBook.ThemeOptions.background (cssColor colors.appBackground)
    , ElmBook.ThemeOptions.accent (cssColor colors.bodyText)
    , ElmBook.ThemeOptions.navBackground (cssColor colors.panelBackground)
    , ElmBook.ThemeOptions.navAccent (cssColor colors.detailText)
    , ElmBook.ThemeOptions.navAccentHighlight (cssColor colors.bodyText)
    , ElmBook.ThemeOptions.globals [ darkModeThemeOverride ]
    ]


darkModeThemeOverride : Element msg
darkModeThemeOverride =
    let
        colors =
            Theme.palette Theme.Dark
    in
    Element.html <|
        Html.node "style"
            []
            [ Html.text <|
                """
                .elm-book-dark-mode .elm-book--wrapper {
                    --elm-book-background: """
                    ++ cssColor colors.appBackground
                    ++ """;
                    --elm-book-accent: """
                    ++ cssColor colors.bodyText
                    ++ """;
                    --elm-book-nav-background: """
                    ++ cssColor colors.panelBackground
                    ++ """;
                    --elm-book-nav-accent: """
                    ++ cssColor colors.detailText
                    ++ """;
                    --elm-book-nav-accent-highlight: """
                    ++ cssColor colors.bodyText
                    ++ """;
                }
                """
            ]


cssColor : Element.Color -> String
cssColor color =
    let
        rgba =
            toRgb color
    in
    "rgba("
        ++ String.fromInt (round (rgba.red * 255))
        ++ ", "
        ++ String.fromInt (round (rgba.green * 255))
        ++ ", "
        ++ String.fromInt (round (rgba.blue * 255))
        ++ ", "
        ++ String.fromFloat rgba.alpha
        ++ ")"
