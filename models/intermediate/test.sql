-- Set up the input table
{{
  config(
    materialized='table',
    schema='hackathons'
  )
}}

-- Split the input column by commas and select the unique values
WITH split_values AS (
  SELECT DISTINCT LOWER(SPLIT_PART(my_column, ',', num)) AS value
  FROM {{ ref('int_2023_data') }}
  CROSS JOIN generate_series(1, 500) num -- Replace 100 with a larger number if needed
  WHERE SPLIT_PART(my_column, ',', num) <> ''
),

-- Create a separate column for each unique value
-- and populate it with 1 if the value is present in the input column,
-- and 0 if it is not
value_columns AS (
  SELECT
    ARRAY_AGG(CASE WHEN LOWER(SPLIT_PART(my_column, ',', num)) = sv.value THEN 1 ELSE 0 END ORDER BY num) AS value_{{ sv.value }}
  FROM {{ ref('int_2023_data') }}
  CROSS JOIN split_values as sv
  CROSS JOIN generate_series(1, 500) num -- Replace 100 with a larger number if needed
  GROUP BY my_column
),

-- Combine the value columns into a single output table
output_table AS (
  SELECT *
  FROM value_columns
)
