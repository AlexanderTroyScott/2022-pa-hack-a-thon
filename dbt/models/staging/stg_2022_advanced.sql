{{
    config(
        materialized='table',
        alias = '2022_advanced'
    )
}}
{{ dbt_utils.union_relations(
    relations=[source('raw_data', '2022_advanced_train'), source('raw_data', '2022_advanced_test')]
) }}
