{% macro binarize_column(column, prefix) %}

WITH hashtag_data AS (
  SELECT tweet_id, STRING_TO_ARRAY(hashtags, ',') AS hashtags
  FROM {{ ref('int_2023_data') }}
  WHERE {{ column }} IS NOT NULL AND tweet_id BETWEEN 100001 AND 100010
),
split_data AS (
  SELECT tweet_id, LOWER(UNNEST(hashtags)) AS hashtag
  FROM hashtag_data
)
SELECT 
  tweet_id, 
  {% for element in ["category_a", "category_b", "category_c"] %}
    CASE WHEN hashtag = '{{ element }}' THEN 1 ELSE 0 END AS {{ element }}
    {% if not loop.last %},{% endif %}
  {% endfor %}
FROM split_data
{% endmacro %}
