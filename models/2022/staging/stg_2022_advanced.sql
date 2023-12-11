{{
    config(
        materialized='table',
        alias = 'stg_2022_advanced'
    )
}}
{{ dbt_utils.union_relations(
    relations=[source('seed_source', '2022_advanced_train'), source('seed_source', '2022_advanced_test')],
    include=["*"]
) }}
