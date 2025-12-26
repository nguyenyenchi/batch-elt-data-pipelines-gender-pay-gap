select 
    name,
    age,
    hello,
    count(*) as count
from {{ ref('dim_employee') }}