{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module BackendApp
    ( app
    , getCorsEnabled
    , getPort
    , server
    , withOptionalCors
    ) where

import Api (API, HealthResponse (HealthResponse), api)
import Data.Maybe (fromMaybe)
import Network.Wai (Application, Middleware)
import Network.Wai.Middleware.Cors (simpleCors)
import Product (Product)
import ProductSource (allProducts)
import Servant ((:<|>) ((:<|>)), Handler, Server, serve)
import System.Environment (lookupEnv)
import Text.Read (readMaybe)

app :: Application
app =
    serve api server

server :: Server API
server =
    healthHandler :<|> productsHandler

healthHandler :: Handler HealthResponse
healthHandler =
    pure (HealthResponse "healthy")

productsHandler :: Handler [Product]
productsHandler =
    pure allProducts

withOptionalCors :: Bool -> Middleware
withOptionalCors corsEnabled =
    if corsEnabled then
        simpleCors

    else
        id

getPort :: IO Int
getPort = do
    maybePort <- lookupEnv "PORT"
    pure (fromMaybe 8080 (maybePort >>= readMaybe))

getCorsEnabled :: IO Bool
getCorsEnabled = do
    maybeValue <- lookupEnv "APP_ENABLE_CORS"
    pure (fromMaybe True (fmap (/= "false") maybeValue))
