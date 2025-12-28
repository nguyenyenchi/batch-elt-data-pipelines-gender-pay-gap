#!/usr/bin/env bash
set -eu # exit 1 when an exception is detected

main() {
    export TOP_DIR=$(git rev-parse --show-toplevel) # gets the root of the repo

    # Setup dbt
    dbt deps --project-dir "${TOP_DIR}/transformation/dw"

    # Sqlfluff on dbt
    # sqlfluff lint "${TOP_DIR}/transformation/dw"

    # Keep using --config to point exactly at the file that sets templater = dbt
    sqlfluff fix --config "${TOP_DIR}/transformation/.sqlfluff" "${TOP_DIR}/transformation/dw/models"
}

main
