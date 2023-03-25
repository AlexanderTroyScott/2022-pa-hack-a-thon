{% macro binarize_column(column, prefix) %}


WITH split_data AS (
  SELECT *
  {% for array in  hashtags %}
    {% for element in array %}
      ,1 AS {{ prefix }}_{{ element }}
    {% endfor %}
  {% endfor %}
  FROM (select tweet_id,   array_agg(string_to_array(lower(replace({{column}},' ','')), ',')) as {{column}} from {{ ref('int_2023_data') }}) as subquery
  where {{ column }} is not NULL and tweet_id between 100001 and 100010
)
select * from split_data
{% endmacro %}
