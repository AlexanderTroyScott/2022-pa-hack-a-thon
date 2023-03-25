{{
    config(
        materialized='table',
        alias = 'models_2023'
    )
}}
with source as ( 
select source                  as source TEXT NOT NULL 
    ,screen_name               as screen_name TEXT NOT NULL
    ,created_at                 as created_at
 --   ,full_text                  as full_text
    ,display_text_range          as display_text_range INT NOT NULL
    ,in_reply_to_screen_name    as in_reply_to_screen_name TEXT NOT NULL
    ,is_quote_status            as is_quote_status BOOLEAN NOT NULL
    ,includes_media             as includes_media BOOLEAN NOT NULL
  --  ,hashtags                   as hashtags
    ,user_mentions            as user_mentions  TEXT NOT NULL 
 --   ,urls                       as urls
    ,emoji_rocket               as emoji_rocket BOOLEAN NOT NULL
    ,target                    as target  INT NOT NULL
from 
{{ ref('int_2023_data') }}
)
select * from source
