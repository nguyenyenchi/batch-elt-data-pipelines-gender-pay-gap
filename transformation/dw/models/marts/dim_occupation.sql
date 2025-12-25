with dim_occupation as (
    select
        emp.anzsco_level,
        emp.nfd_indicator,
        cast(emp.occupation_code as integer) as occupation_code,
        emp.occupation,
    from {{ ref('stg_emp') }} as emp
    where emp.anzsco_level in (1,2,3,4)
)


select *,
    {{ dbt_utils.generate_surrogate_key(['occupation_code']) }} as occupation_key

from dim_occupation