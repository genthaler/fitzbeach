module Main where

import Codegen.Elm.Definitions (definitions)
import qualified Data.HashMap.Strict as HashMap
import qualified Language.Elm.Simplification as Simplification
import qualified Language.Elm.Pretty as Pretty
import Prettyprinter (defaultLayoutOptions, layoutPretty)
import Prettyprinter (Doc)
import Prettyprinter.Render.Text (renderStrict)
import Control.Monad (forM_)
import System.Directory (createDirectoryIfMissing, doesDirectoryExist, removePathForcibly)
import System.FilePath ((<.>), joinPath)
import qualified Data.Text as Text
import qualified Data.Text.IO as Text

main :: IO ()
main = do
    let outputDir = joinPath ["src", "Generated", "Api"]
        modules =
            Pretty.modules
                (Simplification.simplifyDefinition <$> definitions)

    outputDirExists <- doesDirectoryExist outputDir
    if outputDirExists then
        removePathForcibly outputDir

    else
        pure ()
    createDirectoryIfMissing True outputDir
    forM_ (HashMap.toList modules) (uncurry writeGeneratedModule)

writeGeneratedModule :: [Text.Text] -> Doc ann -> IO ()
writeGeneratedModule moduleName moduleContents = do
    let path =
            joinPath ("src" : map Text.unpack moduleName) <.> "elm"
    Text.writeFile path (renderStrict (layoutPretty defaultLayoutOptions moduleContents))
