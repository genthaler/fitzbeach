{-# LANGUAGE OverloadedStrings #-}

module SmokeSpec
    ( spec
    ) where

import BackendApp (app, withOptionalCors)
import Api (HealthResponse (..))
import Control.Monad.IO.Class (liftIO)
import Data.Aeson (eitherDecode)
import Network.HTTP.Types (methodGet)
import Network.Wai.Test (SResponse (simpleBody, simpleHeaders, simpleStatus))
import ProductSource (allProducts)
import Test.Hspec (Spec, describe, it, shouldBe)
import Test.Hspec.Wai
    ( get
    , request
    , with
    )
import Network.HTTP.Types.Status (status200, status404)

spec :: Spec
spec = do
    describe "app" $ with (pure app) $ do
        it "returns the health payload" $ do
            response <- get "/health"
            liftIO $ do
                simpleStatus response `shouldBe` status200
                eitherDecode (simpleBody response) `shouldBe` Right (HealthResponse "healthy")

        it "returns the seeded products" $ do
            response <- get "/products"
            liftIO $ do
                simpleStatus response `shouldBe` status200
                eitherDecode (simpleBody response) `shouldBe` Right allProducts

        it "returns 404 for missing routes" $ do
            response <- get "/missing"
            liftIO $
                simpleStatus response `shouldBe` status404

    describe "withOptionalCors enabled" $ with (pure (withOptionalCors True app)) $ do
        it "adds CORS headers when enabled" $ do
            response <- request methodGet "/health" [("Origin", "http://localhost:1234")] ""
            liftIO $
                lookup "Access-Control-Allow-Origin" (simpleHeaders response) `shouldBe` Just "*"

    describe "withOptionalCors disabled" $ with (pure (withOptionalCors False app)) $ do
        it "does not add CORS headers when disabled" $ do
            response <- request methodGet "/health" [("Origin", "http://localhost:1234")] ""
            liftIO $
                lookup "Access-Control-Allow-Origin" (simpleHeaders response) `shouldBe` Nothing
