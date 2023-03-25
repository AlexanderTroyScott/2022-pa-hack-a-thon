{% macro binarize_column(column, prefix) %}
WITH split_data AS (
  SELECT *
  {% for element in string_to_array(hashtags, ',') %}
      ,1
      END AS {{ prefix }}_{{ element }}
    {% endfor %}
  FROM (select tweet_id, lower(REPLACE({{column}}, ' ', '')) as {{column}} from {{ ref('int_2023_data') }}) as subquery
  where {{ column }} is not NULL and tweet_id between 100001 and 100010
)
select * from split_data
{% endmacro %}
