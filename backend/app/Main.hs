{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Aeson (object, (.=))
import Data.Maybe (fromMaybe)
import Network.Wai.Middleware.Cors (simpleCors)
import ProductSource (allProducts)
import System.Environment (lookupEnv)
import Text.Read (readMaybe)
import Web.Scotty (get, json, middleware, scotty)

main :: IO ()
main = do
    port <- getPort
    corsEnabled <- getCorsEnabled

    scotty port $ do
        if corsEnabled then
            middleware simpleCors

        else
            pure ()

        get "/health" $
            json (object ["status" .= ("healthy" :: String)])

        get "/products" $
            json allProducts

getPort :: IO Int
getPort = do
    maybePort <- lookupEnv "PORT"
    pure (fromMaybe 8080 (maybePort >>= readMaybe))

getCorsEnabled :: IO Bool
getCorsEnabled = do
    maybeValue <- lookupEnv "APP_ENABLE_CORS"
    pure (fromMaybe True (fmap (/= "false") maybeValue))
