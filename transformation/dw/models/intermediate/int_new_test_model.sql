
select occupation
from {{ ref('stg_eeh') }}
limit 3