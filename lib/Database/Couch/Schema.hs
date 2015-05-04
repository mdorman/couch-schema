{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Database.Couch.Schema where

import           Control.Monad                (return)
import           Control.Monad.IO.Class       (liftIO)
import           Control.Monad.Trans.Resource (MonadResource)
import           Data.Aeson                   (Value (Object), json)
import           Data.Bool                    (otherwise)
import           Data.Conduit                 (Sink, awaitForever, ($$))
import           Data.Conduit.Attoparsec      (sinkParserEither)
import           Data.Conduit.Combinators     (sourceFile)
import           Data.Either                  (Either (Left, Right))
import           Data.Function                (($))
import           Data.JsonSchema              (RawSchema (..), isValidSchema)
import           Data.List                    ((++))
import           Data.Vector                  (null)
import           Filesystem.Path              (FilePath)
import           GHC.Err                      (error)
import           System.IO                    (putStrLn)
import           Text.Show                    (show)

validate :: MonadResource m => Sink FilePath m ()
validate =
  awaitForever $ \file -> do
    liftIO $ putStrLn $ "Processing file " ++ show file
    content <- sourceFile file $$ sinkParserEither json
    case content of
      Right (Object o) -> go $ isValidSchema RawSchema { _rsURI = "", _rsObject = o }
      Right _          -> error $ "Couldn't validate" ++ show content
      Left e           -> error $ "Couldn't decode " ++ show content ++ show e
  where
    go err
      | null err = return ()
      | otherwise = error $ show err
