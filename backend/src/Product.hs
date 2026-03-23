{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE NoFieldSelectors #-}

module Product
    ( Product(..)
    ) where

import Data.Aeson (ToJSON)
import Data.Aeson (FromJSON)
import GHC.Generics (Generic)

data Product = Product
    { id :: Int
    , name :: String
    , category :: String
    , priceCents :: Int
    , currency :: String
    , imageUrl :: String
    }
    deriving (Eq, Show, Generic)

instance ToJSON Product
instance FromJSON Product
