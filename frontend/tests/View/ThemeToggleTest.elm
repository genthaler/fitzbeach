module View.ThemeToggleTest exposing (tests)

import Expect
import Test exposing (Test, describe, test)
import View.Theme as Theme
import View.ThemeToggle exposing (Icon(..), config)


tests : Test
tests =
    describe "View.ThemeToggle"
        [ test "light mode toggle config targets dark mode with the moon icon" <|
            \_ ->
                let
                    toggleConfig =
                        config Theme.Light
                in
                Expect.all
                    [ \_ -> Expect.equal Theme.Dark toggleConfig.nextMode
                    , \_ -> Expect.equal "Switch to dark theme" toggleConfig.description
                    , \_ -> Expect.equal Moon toggleConfig.icon
                    ]
                    ()
        , test "dark mode toggle config targets light mode with the sun icon" <|
            \_ ->
                let
                    toggleConfig =
                        config Theme.Dark
                in
                Expect.all
                    [ \_ -> Expect.equal Theme.Light toggleConfig.nextMode
                    , \_ -> Expect.equal "Switch to light theme" toggleConfig.description
                    , \_ -> Expect.equal Sun toggleConfig.icon
                    ]
                    ()
        ]
