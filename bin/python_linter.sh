#!/usr/bin/env bash
set -eu # exit 1 when a exception is detected

main() {
    export TOP_DIR=$(git rev-parse --show-toplevel) # gets the root of the repo

    # Run Ruff 
    ruff check "${TOP_DIR}/orchestration/analytics" # run checks only on analytics folder

}

main
