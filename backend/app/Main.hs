{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Aeson (object, (.=))
import Network.Wai.Middleware.Cors (simpleCors)
import ProductSource (allProducts)
import Web.Scotty (json, middleware, scotty, get)

main :: IO ()
main =
    scotty 8080 $ do
        middleware simpleCors

        get "/health" $
            json (object ["status" .= ("healthy" :: String)])

        get "/products" $
            json allProducts
