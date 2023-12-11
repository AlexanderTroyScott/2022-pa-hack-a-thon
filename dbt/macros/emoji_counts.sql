{% macro count_emojis(text_column) %}
WITH emoji_counts AS (
  SELECT REGEXP_REPLACE(emoji_char, '[:;*#)(}{\[\]\\/]', '') AS emoji, COUNT(*) AS count
  FROM regexp_split_to_table({{ text_column }}, '') AS t(emoji_char)
  WHERE emoji_char ~ '^[\u2600-\u27ff]'
  GROUP BY emoji
  ORDER BY count DESC
)
SELECT * FROM emoji_counts;
{% endmacro %}
