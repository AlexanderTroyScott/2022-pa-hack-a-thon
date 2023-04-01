{{ config(materialized='table') }}

{{ binarize_column('int_2023_data', 'hashtags', 'ht', 100001, 100010) }}
