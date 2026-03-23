{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}

module Api
    ( API
    , HealthResponse (..)
    , api
    ) where

import Data.Aeson (FromJSON, ToJSON)
import Data.Aeson (Value)
import qualified Data.Aeson as Aeson
import Data.Proxy (Proxy (Proxy))
import Data.Text (Text, pack)
import GHC.Generics (Generic)
import qualified Generics.SOP as SOP
import Language.Elm.Name (Qualified (Qualified))
import Language.Haskell.To.Elm
    ( HasElmDecoder (..)
    , HasElmEncoder (..)
    , HasElmType (..)
    , defaultOptions
    , deriveElmJSONDecoder
    , deriveElmJSONEncoder
    , deriveElmTypeDefinition
    )
import Product (Product)
import Servant ((:<|>), (:>), Get, JSON)

data HealthResponse = HealthResponse
    { status :: Text
    }
    deriving stock (Eq, Show, Generic)
    deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo)

instance ToJSON HealthResponse
instance FromJSON HealthResponse

instance HasElmType HealthResponse where
    elmDefinition =
        Just (deriveElmTypeDefinition @HealthResponse defaultOptions (Qualified generatedModule (pack "HealthResponse")))

instance HasElmDecoder Value HealthResponse where
    elmDecoderDefinition =
        Just (deriveElmJSONDecoder @HealthResponse defaultOptions Aeson.defaultOptions (Qualified generatedModule (pack "healthResponseDecoder")))

instance HasElmEncoder Value HealthResponse where
    elmEncoderDefinition =
        Just (deriveElmJSONEncoder @HealthResponse defaultOptions Aeson.defaultOptions (Qualified generatedModule (pack "healthResponseEncoder")))

generatedModule :: [Text]
generatedModule =
    map pack [ "Generated", "Api", "HealthResponse" ]

type API =
       "health" :> Get '[JSON] HealthResponse
  :<|> "products" :> Get '[JSON] [Product]

api :: Proxy API
api = Proxy
