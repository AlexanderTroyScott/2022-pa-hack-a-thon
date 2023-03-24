
with select * from int_2023_data,
-- define the macro to split and lowercase the column
{% macro split_and_lowercase(column_name) %}
  select distinct lower(trim(unnest(regexp_split_to_array({{ hashtags }}, ',')))) as value
{% endmacro %}

-- define the model to transform the data
{{

  config(
    materialized='table',
    unique_key='id',
  )

}}

select
  id,
  lower(hackathons) as column_name,
  {% for value in run_macro('split_and_lowercase', args=[ref('int_2023_data.hashtags')]) %}
    case when lower(hashtags) like '%{{ value.value }}%' then 1 else 0 end as {{ value.value }}
    {% if not loop.last %},{% endif %}
  {% endfor %}
from {{ ref('int_2023_data') }}
