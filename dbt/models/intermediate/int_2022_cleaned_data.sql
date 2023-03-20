{{
    config(
        materialized='table',
        alias = 'int_2022_cleaned_data'
    )
}}
select * from {{ ref('stg_2022_advanced') }}
