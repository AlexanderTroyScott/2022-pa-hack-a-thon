WITH heating_word_counts AS (
  {{ word_count(source=ref('int_2022_cleaned_data'), column='heating_features') }}
),
cooling_word_counts AS (
  {{ word_count(source=ref('int_2022_cleaned_data'), column='cooling_features') }}
),
parking_word_counts AS (
  {{ word_count(source=ref('int_2022_cleaned_data'), column='parking_features') }}
)
SELECT *
FROM heating_word_counts
JOIN cooling_word_counts ON heating_word_counts.word = cooling_word_counts.word
JOIN parking_word_counts ON heating_word_counts.word = parking_word_counts.word
