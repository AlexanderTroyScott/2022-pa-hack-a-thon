{% macro binarize_column(column, prefix) %}
WITH hashtag_data AS (
  SELECT tweet_id, STRING_TO_ARRAY(hashtags, ',') AS hashtags
  FROM {{ ref('int_2023_data') }}
  WHERE {{ column }} IS NOT NULL AND tweet_id BETWEEN 100001 AND 100010
),
unique_hashtags AS (
  SELECT DISTINCT LOWER(UNNEST(hashtags)) AS hashtag
  FROM hashtag_data
)
SELECT * FROM unique_hashtags
{% endmacro %}
