# Haskell SCDMA PoC
An interesting usecase for functional programming.

This project uses Cabal for building and running the executable. \
Install Cabal here: https://www.haskell.org/cabal/

## Run Simulator
Runs a simulator that multiplexes and then demultiplexes messages for multiple senders, see [here](app/Main.hs).
Outputs some intermediate results to the console.

The input file should have a list of messages for the senders.
One line = One message, i.e. one sender.

Usage:
Go to the project root, then execute the following commands with cabal installed:
- `cabal build multiplexer`
- Run on file: `cabal run multiplexer -- -f <filepath>`
- Run on the included test file: `cabal run multiplexer -- -f "./test/test-messages"`
