{% macro binarize_column(column, prefix) %}

{% set column_values =  string_to_array(hashtags, ',') %}
WITH split_data AS (
  SELECT *
  {% for element in  column_values %}
      ,1 AS {{ prefix }}_{{ element }}
    {% endfor %}
  FROM (select tweet_id,  {{column}} from {{ ref('int_2023_data') }}) as subquery
  where {{ column }} is not NULL and tweet_id between 100001 and 100010
)
select * from split_data
{% endmacro %}
