{% macro binarize_column(column, prefix) %}
WITH split_data AS (
  SELECT
    {{ column }} AS {{ column }}
    {% for element in STRING_SPLIT(hashtags, ',') %}
      ,CASE
        WHEN {{ element }} IS NOT NULL THEN 1
        ELSE 0
      END AS {{ prefix }}_{{ element }}
    {% endfor %}
  FROM (select lower(REPLACE(hashtags, ' ', '')) as hashtags from {{ ref('int_2023_data') }}) as subquery
  where {{ column }} is not NULL and tweet_id between 100001 and 100010
)
select * from split_data
{% endmacro %}
