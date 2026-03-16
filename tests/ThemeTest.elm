module ThemeTest exposing (tests)

import Element exposing (toRgb)
import Expect
import Test exposing (Test, describe, test)
import View.Theme as Theme


tests : Test
tests =
    describe "View.Theme"
        [ test "light and dark palettes use different app backgrounds" <|
            \_ ->
                Expect.notEqual
                    (toRgb (Theme.palette Theme.Light).appBackground)
                    (toRgb (Theme.palette Theme.Dark).appBackground)
        , test "light and dark palettes use different button text colors" <|
            \_ ->
                Expect.notEqual
                    (toRgb (Theme.palette Theme.Light).buttonText)
                    (toRgb (Theme.palette Theme.Dark).buttonText)
        , test "palette preserves warm robot accent values per theme" <|
            \_ ->
                Expect.all
                    [ \_ ->
                        Expect.equal
                            ( 78, 91, 86 )
                            (rgbTuple (Theme.palette Theme.Light).robotAccent)
                    , \_ ->
                        Expect.equal
                            ( 96, 110, 104 )
                            (rgbTuple (Theme.palette Theme.Dark).robotAccent)
                    ]
                    ()
        ]


rgbTuple : Element.Color -> ( Int, Int, Int )
rgbTuple color =
    let
        rgba =
            toRgb color
    in
    ( round (rgba.red * 255)
    , round (rgba.green * 255)
    , round (rgba.blue * 255)
    )
