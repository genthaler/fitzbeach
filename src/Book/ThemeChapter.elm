module Book.ThemeChapter exposing (SharedState, chapter)

import Element exposing (column, spacing, text)
import Element.Font as Font
import ElmBook.Actions exposing (updateState)
import ElmBook.Chapter exposing (renderStatefulComponent)
import ElmBook.ElmUI exposing (Chapter)
import View.Theme as Theme
import View.ThemeToggle as ThemeToggle


type alias SharedState x =
    { x | themeMode : Theme.Mode }


chapter : Chapter (SharedState x)
chapter =
    ElmBook.Chapter.chapter "Theme Toggle"
        |> renderStatefulComponent
            (\state ->
                let
                    colors =
                        Theme.palette state.themeMode
                in
                column
                    [ spacing 16 ]
                    [ ThemeToggle.view colors state.themeMode (updateState toggleTheme)
                    , Element.el
                        [ Font.size 14
                        , Font.color colors.detailText
                        ]
                        (text (ThemeToggle.themeToggleDescription (ThemeToggle.toggleThemeMode state.themeMode)))
                    ]
            )


toggleTheme : SharedState x -> SharedState x
toggleTheme state =
    { state | themeMode = ThemeToggle.toggleThemeMode state.themeMode }
