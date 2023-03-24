WITH user_mention_counts AS (
  {{ word_count(source=ref('int_2023_data'), column='user_mentions') }}
)
select * from user_mention_counts
