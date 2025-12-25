{% test is_between(model, column_name, bottom_number, top_number) %}

with validation as (

    select
        {{ column_name }} as field_to_test

    from {{ model }}

),

validation_errors as (

    select
        field_to_test

    from validation
    where field_to_test > {{ top_number }} or field_to_test < {{ bottom_number }}

)

select *
from validation_errors

{% endtest %}