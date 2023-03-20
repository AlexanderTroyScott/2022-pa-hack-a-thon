-- stg_advanced_2022.sql
{{
    config(
        materialized='table',
        alias = 'AAAAA'
    )
}}
with

source as (

    select * from {{ source('raw_data','2022_advanced_test') }}

),

renamed as (

    select
   *

    from source

)

select * from renamed
