{{
    config(
        materialized='table',
        alias = 'models_2023'
    )
}}
with source as ( 
select source                               as source
    ,screen_name               as screen_name 
    ,created_at                 as created_at
   ,full_text                  as full_text
    ,display_text_range         as display_text_range
    ,in_reply_to_screen_name    as in_reply_to_screen_name
    ,is_quote_status          as is_quote_status
    ,includes_media           as includes_media
   ,hashtags                   as hashtags
    ,coalesce(user_mentions,'NONE')          as user_mentions
    ,urls                       as urls
    ,emoji_rocket          as emoji_rocket
    ,Case
        when Target is Null or target = 0 then 0
    else log(target) end            as target
from 
{{ ref('int_2023_data') }}
)
select * from source
