module MainTest exposing (tests)

import Expect
import Main exposing (initModel)
import Test exposing (Test, describe, test)
import View


tests : Test
tests =
    describe "Main"
        [ test "initModel starts on the motorcycle page" <|
            \_ ->
                Expect.equal View.MotorcyclePage initModel.currentPage
        ]
