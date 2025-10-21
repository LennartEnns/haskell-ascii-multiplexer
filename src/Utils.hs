module Utils (opZipLists, normalizedDotProduct, unflatten) where

import Data.Int (Int8)

-- Applies the given binary operator to the elements of the lists which have the same index
opZipLists :: Num a => (a -> a -> a) -> [[a]] -> [a]
opZipLists op = foldl combine []
  where
    combine [] ys = ys
    combine xs [] = xs
    combine (x:xs) (y:ys) = op x y : combine xs ys

-- Calculates a normalized dot product (divided by vector dimension)
normalizedDotProduct :: [Int8] -> [Int8] -> Int
normalizedDotProduct a b = fromIntegral (dotProduct a b) `quot` n
  where n = max (length a) (length b)

-- Calculates a dot product
dotProduct :: Num a => [a] -> [a] -> a
dotProduct [] _ = 0
dotProduct _ [] = 0
dotProduct (x:xs) (y:ys) = x * y + dotProduct xs ys

-- Puts every n elements of the list into a sublist, returns the list of the sublists
unflatten :: Int -> [a] -> [[a]]
unflatten _ [] = []
unflatten n xs = take n xs : unflatten n (drop n xs)
