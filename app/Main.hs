module Main where

import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)
import Data.List.Split (splitOn)
import qualified Data.Text as T

import CodeGenerator (generateCodes)
import Mux (multiplex)
import Demux (demultiplex)

strip :: String -> String
strip s = T.unpack (T.strip (T.pack s))

main :: IO ()
main = do
    args <- getArgs
    case args of
        ["-f", fileName] -> do
            content <- readFile fileName
            let msgs = splitOn "\n" (strip content)
            let numTrans = length msgs
            transCodes <- generateCodes numTrans
            let muxSignal = multiplex (zip msgs transCodes)
            let demuxMsgs = demultiplex muxSignal transCodes

            putStrLn ("Messages before transmission: " ++ show msgs ++ "\n")
            putStrLn ("Randomized transmitter codes: " ++ show transCodes ++ "\n")
            putStrLn ("Multiplexed signal: " ++ show muxSignal ++ "\n")
            putStrLn ("Demuxed messages: " ++ show demuxMsgs)
            exitSuccess
        _ -> do
            putStrLn "Usage:"
            putStrLn "  myprog -f <messages-file>"
            exitFailure
