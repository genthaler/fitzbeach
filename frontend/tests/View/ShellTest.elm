module View.ShellTest exposing (tests)

import Expect
import Test exposing (Test, describe, test)
import View.Shell exposing (isCompact)


tests : Test
tests =
    describe "View.Shell"
        [ test "isCompact keeps the initial zero-width viewport on the non-compact path" <|
            \_ ->
                Expect.equal False (isCompact 0)
        , test "isCompact enables compact layout below the shell breakpoint" <|
            \_ ->
                Expect.equal True (isCompact 759)
        , test "isCompact disables compact layout at and above the shell breakpoint" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal False (isCompact 760)
                    , \_ -> Expect.equal False (isCompact 1180)
                    ]
                    ()
        ]
