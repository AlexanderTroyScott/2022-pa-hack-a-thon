{% macro binarize_column(column, prefix) %}
(
  SELECT
    {{ column }},
    {% for row in (
  SELECT DISTINCT split_column
  FROM (
  SELECT
    LOWER({{ column }}) AS {{ column }},
    REGEXP_SPLIT_TO_TABLE(LOWER({{ column }}), ',') AS split_column
  FROM {{ ref('int_2023_data') }}
  where {{ column }} is not NULL
)
) %}
      CASE
        WHEN {{ row.split_column }} IS NOT NULL THEN 1
        ELSE 0
      END AS {{ prefix }} || '_' || {{ row.split_column }}
      {% if not loop.last %},{% endif %}
    {% endfor %}
  FROM (
  SELECT
    LOWER({{ column }}) AS {{ column }},
    REGEXP_SPLIT_TO_TABLE(LOWER({{ column }}), ',') AS split_column
  FROM {{ ref('int_2023_data') }}
  where {{ column }} is not NULL
)
)
 

{% endmacro %}
