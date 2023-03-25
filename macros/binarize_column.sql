{% macro binarize_column(column, prefix) %}

WITH split_data AS (
  SELECT
    LOWER({{ column }}) AS {{ column }},
    REGEXP_SPLIT_TO_TABLE(LOWER({{ column }}), ',') AS split_column
  FROM {{ ref('int_2023_data') }}
  where {{ column }} is not NULL and tweet_id between 100001 and 100010
),

unique_data AS (
  SELECT DISTINCT split_column
  FROM split_data
)


SELECT * from unique_data


{% endmacro %}
