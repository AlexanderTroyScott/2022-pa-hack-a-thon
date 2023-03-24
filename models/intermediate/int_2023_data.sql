{{
    config(
        materialized='table',
        alias = 'int_2023_data'
    )
}}
with source as (select * from {{ ref('stg_2023_advanced') }})
, adjusted as
(
select tweet_id as tweet_id
    ,screen_name                as screen_name
    ,created_at::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'America/Los_Angeles' as created_at
    ,full_text                  as full_text
    ,display_text_range         as display_text_range
    ,in_reply_to_screen_name    as in_reply_to_screen_name
    ,is_quote_status            as is_quote_status
    ,includes_media             as includes_media
    ,hashtags                   as hashtags
    ,user_mentions              as user_mentions
    ,urls                       as urls
    ,engagement_count           as engagement_count
,CASE 
    WHEN engagement_count is NULL THEN 'Test'
    ELSE 'Train'
    END                                         as source
,engagement_count                               as target
,0                                              as emoji_rocket
from source
)
update adjusted where full_text LIKE '%🚀%' set emoji_rocket = 1
