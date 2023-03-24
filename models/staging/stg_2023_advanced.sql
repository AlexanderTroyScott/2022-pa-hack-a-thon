{{
    config(
        materialized='table',
        alias = 'stg_2023_advanced'
    )
}}
{{ dbt_utils.union_relations(
    relations=[source('raw_data', '2023_expert_training'), source('raw_data', '2023_expert_testing')]
) }}
