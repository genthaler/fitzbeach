module MainTest exposing (tests)

import Expect
import Main exposing (Page(..), initModel, themeToggleDescription, toggleThemeMode)
import Test exposing (Test, describe, test)
import View.Theme as Theme


tests : Test
tests =
    describe "Main"
        [ test "toggleThemeMode flips between light and dark" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal Theme.Dark (toggleThemeMode Theme.Light)
                    , \_ -> Expect.equal Theme.Light (toggleThemeMode Theme.Dark)
                    ]
                    ()
        , test "themeToggleDescription describes the next theme action" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal "Switch to light theme" (themeToggleDescription Theme.Light)
                    , \_ -> Expect.equal "Switch to dark theme" (themeToggleDescription Theme.Dark)
                    ]
                    ()
        , test "initModel starts on the motorcycle page" <|
            \_ ->
                Expect.equal MotorcyclePage initModel.currentPage
        ]
