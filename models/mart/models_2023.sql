{{
    config(
        materialized='table',
        alias = 'models_2023'
    )
}}
with source as ( 
select source                                    as source
    ,screen_name                                 as screen_name 
 --   ,created_at                                  as created_at
    ,extract( YEAR from created_at)                            as created_year
    ,extract( month from created_at)                           as created_month
    ,CASE 
        WHEN EXTRACT(HOUR FROM created_at) 
            BETWEEN 7 and 21 then TRUE
        ELSE 'FALSE'                                END AS created_time_between_7am_9pm
    ,full_text                                   as full_text
    ,display_text_range                          as display_text_range
    ,case
        when in_reply_to_screen_name = 'NA' then FALSE
        else TRUE                       end as in_reply_to_screen_name
   --coalesce(in_reply_to_screen_name,FALSE)     as in_reply_to_screen_name
    ,is_quote_status                             as is_quote_status
  --  ,includes_media                             as includes_media
    ,hashtags                                    as hashtags
    --,user_mentions                                as user_mentions
    ,Case 
        When user_mentions = '' then FALSE
        else TRUE end                               as user_mentions
    ,case
        when urls LIKE '%video%' then 'video'
        when urls LIKE '%photo%' then 'photo'
        else 'other'        end             as urls
    ,emoji_rocket                           as emoji_rocket
    ,Case
        when target is Null 
          or target = 0     then 0
    else log(target) end                    as target
from 
{{ ref('int_2023_data') }}
)
select * from source
