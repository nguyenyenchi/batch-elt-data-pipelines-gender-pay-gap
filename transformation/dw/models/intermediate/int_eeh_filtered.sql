-- Filter to only rows where values are not 0 - error from excel to csv conversion where null values become 0
-- Filter to only rows for males and females

with stg_eeh as (
    select
        eeh.occupation,
        eeh.gender,
        eeh.year,
        eeh.avg_weekly_total_cash_earnings,
        eeh.avg_weekly_total_hours_paid_for,
        eeh.avg_hourly_total_cash_earnings,
        eeh.avg_weekly_ordinary_time_hours_paid_for,
        eeh.avg_weekly_ordinary_time_cash_earnings,
        eeh.avg_hourly_ordinary_time_cash_earnings,
        CAST(occupation_code as INTEGER) as occupation_code

    from {{ ref('stg_eeh') }} as eeh
    where
        eeh.gender != 'Persons'
        and eeh.avg_weekly_total_hours_paid_for != 0
        and eeh.avg_weekly_total_cash_earnings != 0
        and eeh.avg_weekly_ordinary_time_hours_paid_for != 0
        and eeh.avg_weekly_ordinary_time_cash_earnings != 0
        and eeh.avg_hourly_total_cash_earnings != 0
        and eeh.avg_hourly_ordinary_time_cash_earnings != 0
)

select *
from stg_eeh
order by occupation_code, gender, year
