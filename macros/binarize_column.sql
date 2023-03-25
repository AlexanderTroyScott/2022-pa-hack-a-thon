{% macro binarize_column(column, prefix) %}

WITH split_data AS (
  SELECT
    LOWER({{ column }}) AS {{ column }},
    REGEXP_SPLIT_TO_TABLE(LOWER({{ column }}), ',') AS split_column
  FROM {{ ref('int_2023_data') }}
  where {{ column }} is not NULL
)

{% endmacro %}
