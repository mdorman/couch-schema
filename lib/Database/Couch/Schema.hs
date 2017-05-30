{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Database.Couch.Schema where

import           Control.Monad                (return)
import           Control.Monad.IO.Class       (liftIO)
import           Control.Monad.Trans.Resource (MonadResource)
import           Data.Conduit                 (Sink, awaitForever)
import           Data.Either                  (Either (Left, Right))
import           Data.Function                (($))
import           Data.List                    ((++))
import           Data.Maybe                   (Maybe (Just))
import           Data.Text                    (pack)
import           GHC.Err                      (error)
import           JSONSchema.Draft4            (SchemaWithURI (..), checkSchema,
                                               emptySchema,
                                               referencesViaFilesystem,
                                               _schemaRef)
import           System.FilePath              (FilePath, takeFileName)
import           System.IO                    (putStrLn)
import           Text.Show                    (show)

validate :: MonadResource m => Sink FilePath m ()
validate =
  awaitForever $ \file -> do
    liftIO $ putStrLn $ "Processing file " ++ show file
    let uri = Just $ pack file
        schema = SchemaWithURI { _swSchema = emptySchema {_schemaRef = uri}, _swURI = Just $ pack $ takeFileName file}
    res <- liftIO $ referencesViaFilesystem schema
    case res of
      Left e -> error $ "Couldn't fetch referenced schema" ++ show e
      Right references ->
        case checkSchema references schema of
          Left e           -> error $ "Couldn't decode " ++ show e
          Right _          -> return ()
