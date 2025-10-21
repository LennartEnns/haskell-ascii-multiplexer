module Converter.AsciiConverter (stringToBytes, bytesToString) where

import Data.Char (ord, chr)
import Data.Int (Int8)

-- ASCII string to list of bytes ([Int8])
stringToBytes :: String -> [Int8]
stringToBytes = map (fromIntegral . ord)

-- List of bytes ([Int8]) to ASCII string
bytesToString :: [Int8] -> String
bytesToString = map (chr . fromIntegral)
