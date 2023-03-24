WITH emoji_counts AS (
  {{ word_count(source=ref('int_2023_data'), column='full_text') }}
)
select * from emoji_counts
