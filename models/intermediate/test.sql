{{ config(materialized='table') }}

WITH int_2023_data AS (
  {{ binarize_column('hashtags', 'hashtag_') }}
)

SELECT * 
FROM int_2023_data
