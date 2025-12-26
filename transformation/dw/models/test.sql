select 
    name,
    age,
    hello,
    count(*) as count,
    sum(salary) as total_salary
from {{ ref('dim_employee') }}