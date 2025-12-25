select 
    occupation_code, year, gender
from {{ ref('int_eeh_filtered') }}
group by 
    occupation_code, year, gender
having count(*) > 1