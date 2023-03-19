{{ config(
    materialized='table',
    schema='hackathons'
) }}

SELECT CAST('Year built' AS int)        as 'Year built'
  ,case
    when '"Sold Price"' is null then 'Yes'
    else 'No'
  end                                   as target
FROM from {{ source('raw_data', 'advanced_2022') }}

{{ ref('explore_2022') }}
