{% macro binarize_column(column, prefix) %}

WITH split_data AS (
  SELECT
    LOWER({{ column }}) AS {{ column }},
    REGEXP_SPLIT_TO_TABLE(LOWER({{ column }}), ',') AS split_column
  FROM {{ ref('int_2023_data') }}
  where {{ column }} is not NULL and tweet_id = 100009
),

unique_data AS (
  SELECT DISTINCT split_column
  FROM split_data
),
binned_data AS (
  SELECT
    {{ column }},
    {% for row in unique_data %}
      CASE
        WHEN {{ row.split_column }} IS NOT NULL THEN 1
        ELSE 0
      END AS {{ prefix }}_{{ row.split_column }}
      {% if not loop.last %},{% endif %}
    {% endfor %}
  FROM split_data
)



SELECT * from binned_data


{% endmacro %}
