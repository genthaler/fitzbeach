module Main where

import Codegen.Elm.Definitions (definitions)
import Control.Monad (filterM, forM_)
import qualified Data.HashMap.Strict as HashMap
import qualified Language.Elm.Simplification as Simplification
import qualified Language.Elm.Pretty as Pretty
import Prettyprinter (defaultLayoutOptions, layoutPretty)
import Prettyprinter (Doc)
import Prettyprinter.Render.Text (renderStrict)
import System.Directory (createDirectoryIfMissing, doesDirectoryExist, removePathForcibly)
import System.FilePath ((<.>), joinPath)
import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import System.Exit (die)

main :: IO ()
main = do
    frontendRoot <- findFrontendRoot
    let outputDir = joinPath [frontendRoot, "src", "Generated", "Api"]
        modules =
            Pretty.modules
                (Simplification.simplifyDefinition <$> definitions)

    outputDirExists <- doesDirectoryExist outputDir
    if outputDirExists then
        removePathForcibly outputDir

    else
        pure ()
    createDirectoryIfMissing True outputDir
    forM_ (HashMap.toList modules) (uncurry (writeGeneratedModule frontendRoot))

findFrontendRoot :: IO FilePath
findFrontendRoot = do
    let candidates =
            [ joinPath ["..", "frontend"]
            , "frontend"
            ]
    existing <- filterM doesDirectoryExist candidates
    case existing of
        frontendRoot : _ ->
            pure frontendRoot

        [] ->
            die "Could not find frontend workspace from the current directory."

writeGeneratedModule :: FilePath -> [Text.Text] -> Doc ann -> IO ()
writeGeneratedModule frontendRoot moduleName moduleContents = do
    let path =
            joinPath (frontendRoot : "src" : map Text.unpack moduleName) <.> "elm"
    Text.writeFile path (renderStrict (layoutPretty defaultLayoutOptions moduleContents))
