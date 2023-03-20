-- stg_2022_advanced_train.sql
{{
    config(
        materialized='table',
        alias = 'stg_2022_advanced_train'
    )
}}
with

source as (

    select * from {{ source('public','2022_advanced_train') }}

),

renamed as (

    select
   *

    from source

)

select * from renamed
