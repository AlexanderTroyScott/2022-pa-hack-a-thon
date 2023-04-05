{% macro binarize_column(table_name, column, prefix, start_id, end_id) %}

--{% set table_name = table_name | ref %}

WITH hashtag_data AS (
  SELECT tweet_id, STRING_TO_ARRAY({{ column }}, ',') AS hashtags
  FROM {{ table_name }}
  WHERE {{ column }} IS NOT NULL AND tweet_id BETWEEN {{ start_id }} AND {{ end_id }}
),
unique_hashtags AS (
  SELECT DISTINCT LOWER(UNNEST(hashtags)) AS hashtag
  FROM hashtag_data
)

{% set results = run_query('SELECT * FROM unique_hashtags') %}
{% set unique_hashtags = results.columns[0].values() %}

SELECT
  tweet_id
  {% for hashtag in unique_hashtags %}
    ,CASE WHEN '{{ hashtag }}' = ANY(hashtags) THEN 1 ELSE 0 END AS {{ prefix }}_{{ hashtag }}
  {% endfor %}
FROM hashtag_data

{% endmacro %}
