{{
    config(
        materialized='table',
        alias = '2022_advanced'
    )
}}

with source as 
( select * from
{{ dbt_utils.union_relations(
    relations=[source('raw_data', '2022_advanced_train'), source('raw_data', '2022_advanced_test')]
) }} as subquery
)
select * from source
