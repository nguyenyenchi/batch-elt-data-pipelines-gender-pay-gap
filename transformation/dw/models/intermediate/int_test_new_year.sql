

select count(*) as total_new_year_records
from {{ ref('stg_eeh') }}
where year = 2025