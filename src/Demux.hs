module Demux (demultiplex) where

import Data.Int (Int8)
import Data.Maybe (isNothing, fromJust)
import Utils (normalizedDotProduct, unflatten)
import Converter.AsciiConverter (bytesToString)

-- Takes in a flat (multiplexed) signal and sender codes,
-- then reconstructs the individual messages
demultiplex :: [Int8] -> [[Int8]] -> [String]
demultiplex _ [] = []
demultiplex signal codes = demultiplexUnflattened unflattened codes
    where
        codeLength = length (head codes)
        -- First group into spreading code sums, then again into bytes
        unflattened = (unflatten 8 . unflatten codeLength) signal

demultiplexUnflattened :: [[[Int8]]] -> [[Int8]] -> [String]
demultiplexUnflattened signal = map (bytesToString . decodeSenderBytes signal)

-- Takes in the unflattened signal and decodes it to bytes based on the given sender code
-- Only decodes bytes until an invalid byte is encountered
decodeSenderBytes :: [[[Int8]]] -> [Int8] -> [Int8]
decodeSenderBytes [] _ = []
decodeSenderBytes (byte:bytes) code = maybe [] (\b -> b : decodeSenderBytes bytes code) maybeByte
    where
        decodedBits = map (normalizedDotProduct code) byte
        maybeByte = bitsToByte decodedBits

-- Converts a list of bits (-1 = 0, 0 = Nothing, 1 = 1) to a Maybe Int8 (byte)
-- If one of the values is 0, the whole byte will be Nothing
bitsToByte :: [Int8] -> Maybe Int8
bitsToByte = maybeBitsToByte . map maybeBitFromEncoded

maybeBitsToByte :: [Maybe Bool] -> Maybe Int8
maybeBitsToByte [] = Just 0
maybeBitsToByte xs = if invalid then Nothing else Just (fromJust resInit * 2 + fromJust resLast)
    where
        -- Compute resLast first for efficient lazy computation
        invalid = isNothing resLast || isNothing resInit
        resLast = fmap boolToNum (last xs)
        resInit = maybeBitsToByte (init xs)

-- Converts an encoded bit (-1 = 0, 0 = Nothing, 1 = 1) to a Maybe Bool (bit)
maybeBitFromEncoded :: Int8 -> Maybe Bool
maybeBitFromEncoded 1 = Just True
maybeBitFromEncoded (-1) = Just False
maybeBitFromEncoded _ = Nothing

boolToNum :: Bool -> Int8
boolToNum x = if x then 1 else 0
