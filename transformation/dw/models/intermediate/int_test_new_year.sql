
-- should return 3 rows
select count(*)
from {{ ref('stg_eeh') }}
where year = 2025