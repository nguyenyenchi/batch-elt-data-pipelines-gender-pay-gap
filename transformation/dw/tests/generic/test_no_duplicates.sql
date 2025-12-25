{% test no_duplicates(model, column_names) %}

with grouped as (

    select
        {{ column_names | join(', ') }},
        count(*) as row_count
    from {{ model }}
    group by {{ column_names | join(', ') }}
    having count(*) > 1

)

select *
from grouped

{% endtest %}
