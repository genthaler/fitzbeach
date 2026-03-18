module Book exposing (SharedState, main)

import Book.Fixtures
import Book.MotorcycleChapter
import Book.RobotChapter
import Book.ThemeChapter
import Element exposing (toRgb)
import ElmBook exposing (withChapterGroups, withStatefulOptions)
import ElmBook.ElmUI exposing (Book, book)
import ElmBook.StatefulOptions
import ElmBook.ThemeOptions
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
              , [ Book.ThemeChapter.chapter ]
              )
            , ( "Pages"
              , [ Book.MotorcycleChapter.chapter
                , Book.RobotChapter.chapter
                ]
              )
            ]


bookThemeOptions : List (ElmBook.ThemeOptions.ThemeOption html)
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
