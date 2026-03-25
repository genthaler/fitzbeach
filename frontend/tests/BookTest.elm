module BookTest exposing (tests)

import Book exposing (initialState, syncThemeMode)
import Book.Fixtures
import Expect
import Test exposing (Test, describe, test)
import View.Theme as Theme


tests : Test
tests =
    describe "Book"
        [ test "initialState starts with the light theme and initial robot demo" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal Theme.Light initialState.themeMode
                    , \_ -> Expect.equal Book.Fixtures.initialRobotDemo initialState.robotDemo
                    ]
                    ()
        , test "syncThemeMode follows ElmBook dark mode without changing the robot demo" <|
            \_ ->
                let
                    darkState =
                        syncThemeMode True initialState

                    lightState =
                        syncThemeMode False darkState
                in
                Expect.all
                    [ \_ -> Expect.equal Theme.Dark darkState.themeMode
                    , \_ -> Expect.equal initialState.robotDemo darkState.robotDemo
                    , \_ -> Expect.equal Theme.Light lightState.themeMode
                    , \_ -> Expect.equal initialState.robotDemo lightState.robotDemo
                    ]
                    ()
        ]
