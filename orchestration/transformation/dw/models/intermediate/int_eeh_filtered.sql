-- Filter to only rows where values are not 0 - error from excel to csv conversion where null values become 0
-- Filter to only rows for males and females

with stg_eeh as (
    select
        CAST(occupation_code AS INTEGER) AS occupation_code,
        occupation,
        gender,
        year,
        avg_weekly_total_cash_earnings,
        avg_weekly_total_hours_paid_for,
        avg_hourly_total_cash_earnings,
        avg_weekly_ordinary_time_hours_paid_for,
        avg_weekly_ordinary_time_cash_earnings,
        avg_hourly_ordinary_time_cash_earnings

    from {{ ref('stg_eeh') }} as eeh
    where eeh.gender != 'Persons' and
          avg_weekly_total_hours_paid_for != 0 and
          avg_weekly_total_cash_earnings != 0 and
          avg_weekly_ordinary_time_hours_paid_for != 0 and
          avg_weekly_ordinary_time_cash_earnings != 0 and
          avg_hourly_total_cash_earnings != 0 and
          avg_hourly_ordinary_time_cash_earnings != 0
)

select *
from stg_eeh
order by occupation_code, gender, year
