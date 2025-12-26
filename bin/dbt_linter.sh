#!/usr/bin/env bash
set -eu # exit 1 when a exception is detected

main() {
    export TOP_DIR=$(git rev-parse --show-toplevel) # gets the root of the repo

    # Setup dbt
    dbt deps --project-dir "${TOP_DIR}/transformation/dw"

    # Sqlfluff on dbt
    sqlfluff lint "${TOP_DIR}/transformation/dw"
}

main
