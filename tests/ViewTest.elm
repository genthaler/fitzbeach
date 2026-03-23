module ViewTest exposing (tests)

import Expect
import Test exposing (Test, describe, test)
import View.Theme as Theme
import View.ThemeToggle as ThemeToggle


tests : Test
tests =
    describe "View"
        [ test "toggleThemeMode flips between light and dark" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal Theme.Dark (ThemeToggle.toggleThemeMode Theme.Light)
                    , \_ -> Expect.equal Theme.Light (ThemeToggle.toggleThemeMode Theme.Dark)
                    ]
                    ()
        , test "themeToggleDescription describes the next theme action" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal "Switch to light theme" (ThemeToggle.themeToggleDescription Theme.Light)
                    , \_ -> Expect.equal "Switch to dark theme" (ThemeToggle.themeToggleDescription Theme.Dark)
                    ]
                    ()
        ]
