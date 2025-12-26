{{
    config(
        materialized="incremental",
        incremental_strategy="append",
    )
}}

WITH raw_eeh AS (
    SELECT *
    FROM {{ source('raw', 'eeh') }}
)

SELECT
    CASE
        WHEN REGEXP_LIKE(SUBSTRING(TRIM("OCCUPATION"), 1, 3), '[0-9]{3}')
            THEN SUBSTRING(TRIM("OCCUPATION"), 1, 3)
    END AS occupation_code,
    TRIM(SUBSTRING("OCCUPATION", 4)) AS occupation,
    TRIM("GENDER") AS gender,
    CAST("YEAR" AS INTEGER) AS year,
    CAST("AVERAGE WEEKLY TOTAL HOURS PAID FOR" AS NUMBER (10, 1)) AS avg_weekly_total_hours_paid_for,
    CAST("AVERAGE WEEKLY TOTAL CASH EARNINGS" AS NUMBER (10, 1)) AS avg_weekly_total_cash_earnings,
    CAST("AVERAGE WEEKLY ORDINARY TIME HOURS PAID FOR" AS NUMBER (10, 1)) AS avg_weekly_ordinary_time_hours_paid_for,
    CAST("AVERAGE WEEKLY ORDINARY TIME CASH EARNINGS" AS NUMBER (10, 1)) AS avg_weekly_ordinary_time_cash_earnings,
    CAST("AVERAGE HOURLY TOTAL CASH EARNINGS" AS NUMBER (10, 1)) AS avg_hourly_total_cash_earnings,
    CAST("AVERAGE HOURLY ORDINARY TIME CASH EARNINGS" AS NUMBER (10, 1)) AS avg_hourly_ordinary_time_cash_earnings
FROM raw_eeh
{% if is_incremental() %}
    where year > (select max(year) from {{ this }} )
{% endif %}
