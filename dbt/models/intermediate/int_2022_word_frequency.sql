WITH heating_word_counts AS (
  {{ word_count(source=ref('int_2022_cleaned_data'), column='heating_features') }}
)
select * from heating_word_counts
