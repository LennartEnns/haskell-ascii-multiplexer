module CodeGenerator (generateCodes) where

import System.Random (randomRIO)
import Data.Int (Int8)

-- Generate a Hadamard matrix of order 2^n
hadamard :: Int -> [[Int8]]
hadamard 0 = [[1]]
hadamard n =
    let h = hadamard (n - 1)
    in [a ++ a | a <- h] ++ [a ++ map negate a | a <- h]

-- Generate CDMA codes for a given number of transmitters
cdmaCodes :: Int -> [[Int8]]
cdmaCodes n
    | n <= 0    = []
    | otherwise = take n $ hadamard k
  where
    -- Smallest k such that 2^k >= n
    k = ceiling (logBase 2 (fromIntegral n) :: Double)

-- Randomize the hadamard matrix, preserving orthogonality
randomizeHadamard :: [[Int8]] -> IO [[Int8]]
randomizeHadamard codes = do
    perm <- randomPermutation (length codes)
    flips <- mapM (const randomSign) [1..length codes]
    let permuted = map (codes !!) perm
    return [ map (* s) c | (c, s) <- zip permuted flips ]
  where
    randomSign = do b <- randomRIO (0 :: Int8, 1); return (if b == 0 then 1 else -1)

-- Helper function for a random permutation of length n
randomPermutation :: Int -> IO [Int]
randomPermutation 0 = return []
randomPermutation n = do
    i <- randomRIO (0, n - 1)
    rest <- randomPermutation (n - 1)
    return (insertAt i (n - 1) rest)
  where
    insertAt i x xs = let (a, b) = splitAt i xs in a ++ [x] ++ b

generateCodes :: Int -> IO [[Int8]]
generateCodes n = do
    let codes = cdmaCodes n
    randomizeHadamard codes
