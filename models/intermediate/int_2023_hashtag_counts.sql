WITH hashtags AS (
  {{ word_count(source=ref('int_2023_data'), column='hashtags') }}
)
select * from hashtags
