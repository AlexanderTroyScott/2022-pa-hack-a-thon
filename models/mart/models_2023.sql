{{
    config(
        materialized='table',
        alias = 'models_2023'
    )
}}
with source as ( 
select source               TEXT NOT NULL    as source
    ,screen_name           TEXT NOT NULL    as screen_name
    ,created_at                 as created_at
 --   ,full_text                  as full_text
    ,display_text_range      INT NOT NULL    as display_text_range
    ,in_reply_to_screen_name  TEXT NOT NULL  as in_reply_to_screen_name
    ,is_quote_status         BOOLEAN NOT NULL   as is_quote_status
    ,includes_media          BOOLEAN NOT NULL   as includes_media
  --  ,hashtags                   as hashtags
    ,user_mentions         TEXT NOT NULL     as user_mentions
 --   ,urls                       as urls
    ,emoji_rocket         BOOLEAN NOT NULL      as emoji_rocket
    ,target                INT NOT NULL     as target
from 
{{ ref('int_2023_data') }}
)
select * from source
