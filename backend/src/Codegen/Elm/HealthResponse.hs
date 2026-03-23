{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Codegen.Elm.HealthResponse () where

import Api (HealthResponse)
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

deriving anyclass instance SOP.Generic HealthResponse
deriving anyclass instance SOP.HasDatatypeInfo HealthResponse

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
