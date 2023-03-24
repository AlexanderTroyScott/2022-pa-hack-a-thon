{{
    config(
        materialized='table',
        alias = '2023_training'
    )
}}
with source as ( 
select screen_name              as screen_name
    ,created_at                 as created_at
    ,full_text                  as full_text
    ,display_text_range         as display_text_range
    ,in_reply_to_screen_name    as in_reply_to_screen_name
    ,is_quote_status            as is_quote_status
    ,includes_media             as includes_media
    ,hashtags                   as hashtags
    ,user_mentions              as user_mentions
    ,urls                       as urls
    ,target                     as target
from 
{{ ref('int_2023_data') }}
)
select * from source
