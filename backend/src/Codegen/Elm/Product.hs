{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Codegen.Elm.Product () where

import qualified Data.Aeson as Aeson
import Data.Aeson (Value)
import Data.Text (Text, pack)
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

deriving anyclass instance SOP.Generic Product
deriving anyclass instance SOP.HasDatatypeInfo Product

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
