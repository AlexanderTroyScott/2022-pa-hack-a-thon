-- stg_advanced_2022.sql
{{
    config(
        materialized='table',
        alias = 'AAAAA'
    )
}}
with

source as (

    select * from {{ source('raw_data','advanced_2022') }}

),

renamed as (

    select
   *

    from source

)

select * from renamed
