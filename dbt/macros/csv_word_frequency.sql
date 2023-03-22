{% macro word_count(source, column) %}
  
-- Select the unique words from the heating_features column
WITH unique_words AS (
  SELECT DISTINCT {{ column }}
  FROM {{ source }}
),
-- Split the heating_features column into individual words
split_words AS (
  SELECT heating_features, regexp_split_to_table({{ column }}, ',\s*') AS word
  FROM {{ source }}
),

-- Count the frequency of each word
word_counts AS (
  SELECT word, COUNT(*) AS frequency
  FROM split_words
  GROUP BY word
)

-- Final select statement that outputs the word frequency summary
SELECT word, frequency
FROM word_counts
ORDER BY frequency DESC
  
{% endmacro %}
