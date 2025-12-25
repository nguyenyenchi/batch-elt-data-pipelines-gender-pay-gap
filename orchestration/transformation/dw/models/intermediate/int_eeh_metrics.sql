with int_eeh as (
    select *
    from {{ ref('int_eeh_filtered') }} as eeh

)

select
    year,
    occupation_code,
    gender,
    avg_weekly_total_cash_earnings as avg_weekly_earnings,
    avg_weekly_total_hours_paid_for,
    avg_hourly_total_cash_earnings,

    lag(avg_weekly_earnings) over (
          partition by occupation_code, gender
          order by year
      ) as avg_weekly_earnings_last_year,

    -- absolute change
    avg_weekly_earnings
      - lag(avg_weekly_earnings) over (
          partition by occupation_code, gender
          order by year
      ) as earnings_yoy_change,

    -- percentage change
    case
        when lag(avg_weekly_earnings) over (
               partition by occupation_code, gender
               order by year
             ) is null then null
        else
             ROUND((avg_weekly_earnings
              - lag(avg_weekly_earnings) over (
                  partition by occupation_code, gender
                  order by year
                )
             )
             / lag(avg_weekly_earnings) over (
                  partition by occupation_code, gender
                  order by year
               ), 2)

    end as earnings_yoy_growth_pct

from int_eeh
order by occupation_code, gender, year
