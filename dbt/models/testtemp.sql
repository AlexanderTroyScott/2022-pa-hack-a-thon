-- Define the model name and schema
{{  config(
    schema='my_schema',
    materialized='table',
    unique_key='id'
    )
}}

-- Define the SQL query to create the new table
SELECT 
  id,
  name,
  age,
  gender
INTO {{ ref('my_schema.new_table') }}
FROM (
  VALUES 
    (1, 'John', 25, 'Male'),
    (2, 'Jane', 30, 'Female'),
    (3, 'Bob', 45, 'Male')
) AS t(id, name, age, gender);
