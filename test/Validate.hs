{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Monad.Trans.Resource (runResourceT)
import           Data.Bool                    (Bool (False))
import           Data.Conduit                 (($$))
import           Data.Conduit.Combinators     (sourceDirectoryDeep)
import           Data.Function                (($))
import qualified Database.Couch.Schema        as Schema (validate)
import           System.IO                    (IO)

main :: IO ()
main = runResourceT $ sourceDirectoryDeep False "schema" $$ Schema.validate
