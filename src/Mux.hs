module Mux (multiplex) where

import Data.Int (Int8)
import Data.Bits (testBit)
import Converter.AsciiConverter (stringToBytes)
import Utils (opZipLists)

-- Represents the individual message through the given spreading codes
-- and sums them into a single signal of bytes
multiplex :: [(String, [Int8])] -> [Int8]
multiplex transmissions = opZipLists (+) signals
    where signals = map (uncurry transmitterSignalFlat) transmissions

-- Calculates the flat signal of a single transmitter from its message and code
transmitterSignalFlat :: String -> [Int8] -> [Int8]
transmitterSignalFlat str code = (concat . concat) bytesRepr
    where bytesRepr = map (encodeByte code) (stringToBytes str)

-- Encodes the byte with the given transmitter code
encodeByte :: [Int8] -> Int8 -> [[Int8]]
encodeByte code byte = map encodePos [7,6..0]
    where encodePos p = encodeBit code (testBit byte p)

-- Encodes the bit with the given transmitter code
encodeBit :: [Int8] -> Bool -> [Int8]
encodeBit code bit = if bit then code else map negate code
