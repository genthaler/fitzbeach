{-# LANGUAGE TypeApplications #-}

module Codegen.Elm.Definitions
    ( definitions
    ) where

import Api (HealthResponse)
import Codegen.Elm.HealthResponse ()
import Codegen.Elm.Product ()
import qualified Language.Elm.Definition as Elm
import Language.Haskell.To.Elm (jsonDefinitions)
import Product (Product)

definitions :: [Elm.Definition]
definitions =
    jsonDefinitions @Product
        ++ jsonDefinitions @HealthResponse
