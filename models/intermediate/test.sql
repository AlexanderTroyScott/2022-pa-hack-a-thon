--with source as (select * from {{ ref('stg_2023_advanced') }})
--,
-- Define a macro to split a comma-separated string into an array of strings
{% macro split_by_comma(column_name) %}
  SELECT ARRAY_AGG(DISTINCT TRIM(LOWER(UNNEST(SPLIT({{ column_name }}, ','))))) AS {{ column_name }}_array
{% endmacro %}

-- Use the macro to split the "hashtags" column and create a new table with binary columns for each unique hashtag
SELECT 
  *,
  {% for hashtag in ref('int_2023_data') %} 
    CASE WHEN '{{ hashtag }}' IN UNNEST(hashtags_array) THEN 1 ELSE 0 END AS {{ hashtag }}_binary{% if not loop.last %},{% endif %}
  {% endfor %}
FROM (
  SELECT 
    *,
    {% raw %}{{ split_by_comma('hashtags') }}{% endraw %}
  FROM {{ ref('int_2023_data') }}
) subquery
