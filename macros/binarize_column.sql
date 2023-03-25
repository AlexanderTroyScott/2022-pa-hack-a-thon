{% macro binarize_column(column, prefix) %}

WITH split_data AS (
  SELECT
    LOWER({{ column }}) AS {{ column }},
    {% for element in REGEXP_SPLIT_TO_TABLE(column, ',') %}
      ,CASE
        WHEN {{ element }} IS NOT NULL THEN 1
        ELSE 0
      END AS {{ prefix }}_{{ element }}
    {% endfor %}
  FROM {{ ref('int_2023_data') }}
  where {{ column }} is not NULL and tweet_id between 100001 and 100010
)
{% endmacro %}
