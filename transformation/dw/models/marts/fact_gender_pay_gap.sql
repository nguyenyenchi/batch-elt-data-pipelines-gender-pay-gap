select *,
    {{ dbt_utils.generate_surrogate_key(['occupation_code', 'year']) }} as gender_pay_gap_key,
    {{ dbt_utils.generate_surrogate_key(['occupation_code']) }} as occupation_key
from {{ ref('int_gender_pay_gap') }}
order by occupation_code, year