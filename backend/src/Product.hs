{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE NoFieldSelectors #-}

module Product
    ( Product(..)
    ) where

import Data.Aeson (FromJSON, ToJSON)
import Data.Text (Text)
import GHC.Generics (Generic)

data Product = Product
    { id :: Int
    , name :: Text
    , category :: Text
    , priceCents :: Int
    , currency :: Text
    , imageUrl :: Text
    }
    deriving (Eq, Show, Generic)

instance ToJSON Product
instance FromJSON Product
