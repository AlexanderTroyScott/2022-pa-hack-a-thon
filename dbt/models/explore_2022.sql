{{ config(
    materialized='table',
    schema='hackathons'
) }}

SELECT CAST('Year built' AS int)        as 'Year built'
  ,case
    when '"Sold Price"' is null then 'Yes'
    else 'No'
  end                                   as target
FROM {{ source('raw_data', 'advanced_2022') }}
