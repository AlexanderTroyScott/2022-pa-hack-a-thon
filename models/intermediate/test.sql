{{ config(materialized='table') }}

WITH test AS (
  {{ binarize_column('hashtags', 'hashtag') }}
)

SELECT * 
FROM test
