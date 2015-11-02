{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Database.Couch.Schema where

import           Control.Monad                (return)
import           Control.Monad.IO.Class       (liftIO)
import           Control.Monad.Trans.Resource (MonadResource)
import           Data.Aeson                   (Value (Object), json)
import           Data.Conduit                 (Sink, awaitForever, ($$))
import           Data.Conduit.Attoparsec      (sinkParserEither)
import           Data.Conduit.Combinators     (sourceFile)
import           Data.Either                  (Either (Left, Right))
import           Data.Function                (($))
import           Data.JsonSchema              (RawSchema (..), isValidSchema)
import           Data.List                    (map, unlines, (++))
import           Data.Maybe                   (Maybe (Nothing))
import           GHC.Err                      (error)
import           System.FilePath              (FilePath)
import           System.IO                    (putStrLn)
import           Text.Show                    (show)

validate :: MonadResource m => Sink FilePath m ()
validate =
  awaitForever $ \file -> do
    liftIO $ putStrLn $ "Processing file " ++ show file
    content <- sourceFile file $$ sinkParserEither json
    case content of
      Right (Object o) ->
        case isValidSchema RawSchema { _rsURI = Nothing, _rsData = o } of
          [] -> return ()
          e -> error $ unlines $ (map show) e
      Right v          -> error $ "Not a schema object: " ++ show v
      Left e           -> error $ "Couldn't decode " ++ show e
