{% macro binarize_column(column, prefix) %}


WITH split_data AS (
  SELECT *
  {% set array = hashtags %}
  {% for element in  array %}
      ,1 AS {{ prefix }}_{{ element }}
  {% endfor %}
  FROM (select tweet_id, string_to_array(hashtags,',') as hashtags  from {{ ref('int_2023_data') }}) as subquery
  where {{ column }} is not NULL and tweet_id between 100001 and 100010
)
select * from split_data
{% endmacro %}
