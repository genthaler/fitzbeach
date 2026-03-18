module Book exposing (SharedState, main)

import Book.Fixtures
import Book.MotorcycleChapter
import Book.RobotChapter
import Book.ThemeChapter
import ElmBook exposing (withChapterGroups, withStatefulOptions)
import ElmBook.ElmUI exposing (Book, book)
import ElmBook.StatefulOptions
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
