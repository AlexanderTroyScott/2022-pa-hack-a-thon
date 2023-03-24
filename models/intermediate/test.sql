WITH binarize_hash AS (
  {{ binarize_column_by_unique_values(ref('int_2023_data'), 'hashtag', 'hash_is_') }}
)
select * from binarize_hash
