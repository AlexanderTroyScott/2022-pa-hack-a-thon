{{ config(materialized='table') }}

WITH int_2023_data AS (
  {{ binarize_column('hashtags', 'hashtag') }}
)

SELECT * 
FROM int_2023_data
