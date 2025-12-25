with int_eeh as (
    select *
    from {{ ref('int_eeh_filtered') }} as eeh

),
pivoted as(

select
    occupation_code,
    occupation,
    year,

    max(case when gender = 'Females'
        then avg_weekly_total_cash_earnings end) as female_weekly_earnings,

    max(case when gender = 'Males'
        then avg_weekly_total_cash_earnings end) as male_weekly_earnings

from int_eeh
group by
    occupation_code,
    occupation,
    year
),

calc_pay_gap as (
select *,

    -- Weekly gap
    male_weekly_earnings - female_weekly_earnings
        as weekly_earnings_gap,

    ROUND((male_weekly_earnings - female_weekly_earnings)
        / nullif(male_weekly_earnings, 0), 2)
        as weekly_gender_pay_gap_pct

from pivoted
)

select *
from calc_pay_gap
