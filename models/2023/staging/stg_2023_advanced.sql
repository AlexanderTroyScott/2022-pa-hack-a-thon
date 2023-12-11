{{
    config(
        materialized='table',
        alias = 'stg_2023_advanced'
    )
}}
{{ dbt_utils.union_relations(
   
    relations=[source('hackathons', '2023_expert_training'), source('hackathons', '2023_expert_testing')]
) }}
