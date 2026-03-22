{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module Api
    ( API
    , HealthResponse (..)
    , api
    ) where

import Data.Aeson (ToJSON)
import Data.Proxy (Proxy (Proxy))
import GHC.Generics (Generic)
import Product (Product)
import Servant ((:<|>), (:>), Get, JSON)

data HealthResponse = HealthResponse
    { status :: String
    }
    deriving (Eq, Show, Generic)

instance ToJSON HealthResponse

type API =
       "health" :> Get '[JSON] HealthResponse
  :<|> "products" :> Get '[JSON] [Product]

api :: Proxy API
api = Proxy
