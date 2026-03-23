module Main where

import Test.Hspec (hspec)
import qualified SmokeSpec

main :: IO ()
main =
    hspec SmokeSpec.spec
