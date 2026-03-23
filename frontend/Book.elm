module Book exposing (SharedState, initialState, main, syncThemeMode)

import Book.Fixtures
import Book.MotorcycleChapter
import Book.ProductPanelChapter
import Book.RobotChapter
import Book.RobotControlButtonChapter
import Book.ThemeChapter
import Element exposing (Element)
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
            , ElmBook.StatefulOptions.onDarkModeChange syncThemeMode
            ]
        |> withChapterGroups
            [ ( "Foundations"
              , [ Book.ThemeChapter.chapter
                , Book.ProductPanelChapter.chapter
                , Book.RobotControlButtonChapter.chapter
                ]
              )
            , ( "Pages"
              , [ Book.MotorcycleChapter.chapter
                , Book.RobotChapter.chapter
                ]
              )
            ]


syncThemeMode : Bool -> SharedState -> SharedState
syncThemeMode darkMode state =
    { state
        | themeMode =
            if darkMode then
                Theme.Dark

            else
                Theme.Light
    }


bookThemeOptions : List (ElmBook.ThemeOptions.ThemeOption (Element msg))
bookThemeOptions =
    let
        colors : Theme.Palette
        colors =
            Theme.palette Theme.Light
    in
    [ ElmBook.ThemeOptions.subtitle "Calm component catalogue"
    , ElmBook.ThemeOptions.background (Theme.toCssColor colors.appBackground)
    , ElmBook.ThemeOptions.accent (Theme.toCssColor colors.bodyText)
    , ElmBook.ThemeOptions.navBackground (Theme.toCssColor colors.panelBackground)
    , ElmBook.ThemeOptions.navAccent (Theme.toCssColor colors.detailText)
    , ElmBook.ThemeOptions.navAccentHighlight (Theme.toCssColor colors.bodyText)
    , ElmBook.ThemeOptions.globals [ darkModeThemeOverride ]
    ]


darkModeThemeOverride : Element msg
darkModeThemeOverride =
    let
        colors : Theme.Palette
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
                    ++ Theme.toCssColor colors.appBackground
                    ++ """;
                    --elm-book-accent: """
                    ++ Theme.toCssColor colors.bodyText
                    ++ """;
                    --elm-book-nav-background: """
                    ++ Theme.toCssColor colors.panelBackground
                    ++ """;
                    --elm-book-nav-accent: """
                    ++ Theme.toCssColor colors.detailText
                    ++ """;
                    --elm-book-nav-accent-highlight: """
                    ++ Theme.toCssColor colors.bodyText
                    ++ """;
                }
                """
            ]
