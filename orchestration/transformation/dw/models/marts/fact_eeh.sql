select *,
    {{ dbt_utils.generate_surrogate_key(['occupation_code', 'gender', 'year']) }} as occupation_gender_key,
    {{ dbt_utils.generate_surrogate_key(['occupation_code']) }} as occupation_key,
from {{ ref('int_eeh_metrics') }}
order by occupation_code, gender, year

