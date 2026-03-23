{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoFieldSelectors #-}
{-# LANGUAGE TypeApplications #-}

module Product
    ( Product(..)
    ) where

import Data.Aeson (FromJSON, ToJSON, Value)
import qualified Data.Aeson as Aeson
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

data Product = Product
    { id :: Int
    , name :: Text
    , category :: Text
    , priceCents :: Int
    , currency :: Text
    , imageUrl :: Text
    }
    deriving stock (Eq, Show, Generic)
    deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo)

instance ToJSON Product
instance FromJSON Product

instance HasElmType Product where
    elmDefinition =
        Just (deriveElmTypeDefinition @Product defaultOptions (Qualified generatedModule (pack "Product")))

instance HasElmDecoder Value Product where
    elmDecoderDefinition =
        Just (deriveElmJSONDecoder @Product defaultOptions Aeson.defaultOptions (Qualified generatedModule (pack "productDecoder")))

instance HasElmEncoder Value Product where
    elmEncoderDefinition =
        Just (deriveElmJSONEncoder @Product defaultOptions Aeson.defaultOptions (Qualified generatedModule (pack "productEncoder")))

generatedModule :: [Text]
generatedModule =
    map pack [ "Generated", "Api", "Product" ]
