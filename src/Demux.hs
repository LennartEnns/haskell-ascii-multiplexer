module Demux (demultiplex) where

import Data.Int (Int8)
import Data.Bits (testBit)
import Converter.AsciiConverter (bytesToString)
import Utils (opZipLists)

-- Takes in a multiplexed signal and the sender codes,
-- then reconstructs the individual messages
demultiplex :: [[Int8]] -> [Int8] -> [String]
demultiplex codes signal
