{% macro word_count(source, column) %}

  {{ config(materialized='incremental') }}

  WITH split_values AS (
    SELECT DISTINCT {{ column }},
           regexp_split_to_table({{ column }}, ',') AS word
    FROM {{ source }}
  ),
  word_counts AS (
    SELECT word, count(*) AS frequency
    FROM split_values
    GROUP BY word
  )
  SELECT word, frequency
  FROM word_counts
  ORDER BY count DESC

{% endmacro %}
