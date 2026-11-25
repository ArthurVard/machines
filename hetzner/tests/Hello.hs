-- For the CI check of the role "haskell" (tests/check-haskell.sh): GHC builds and runs it, and HLS checks it.
module Main (main) where

main :: IO ()
main = putStrLn "Hello from GHC"
