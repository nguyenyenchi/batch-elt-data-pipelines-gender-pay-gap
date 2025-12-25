{{
    config(
        materialized='incremental',
        incremental_strategy="append",
    )
}}

WITH raw_eeh AS (
	select *
	from {{ source('raw', 'eeh_test') }}
)

select
    CASE WHEN REGEXP_LIKE(SUBSTRING(TRIM("OCCUPATION"), 1, 3), '[0-9]{3}')
        THEN SUBSTRING(TRIM("OCCUPATION"), 1, 3)
        ELSE NULL
    END AS occupation_code,
    TRIM(SUBSTRING("OCCUPATION", 4)) AS occupation,
    TRIM("GENDER") as gender,
    CAST("YEAR" AS INTEGER) AS year
from raw_eeh
{% if is_incremental() %}
    where year > (select max(year) from {{ this }} )
{% endif %}