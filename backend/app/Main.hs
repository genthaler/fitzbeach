{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import BackendApp (app, getCorsEnabled, getPort, withOptionalCors)
import Network.Wai.Handler.Warp (run)

main :: IO ()
main = do
    port <- getPort
    corsEnabled <- getCorsEnabled
    run port (withOptionalCors corsEnabled app)
