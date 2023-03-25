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
    ,year(cast(created_at as datetime))                            as created_year
    ,month(cast(created_at as datetime))                           as created_month
    ,CASE 
        WHEN DATEPART(hour, your_datetime_column) >= 7 AND DATEPART(hour, your_datetime_column) <= 21 THEN 'TRUE' 
        ELSE 'FALSE' END                         AS created_time_between_7am_9pm
    ,full_text                                   as full_text
    ,display_text_range                          as display_text_range
    ,case
        when in_reply_to_screen_name = 'NA' then FALSE
        else TRUE                       end as in_reply_to_screen_name
   --coalesce(in_reply_to_screen_name,FALSE)     as in_reply_to_screen_name
    ,is_quote_status                             as is_quote_status
  --  ,includes_media                             as includes_media
    ,hashtags                                    as hashtags
    ,coalesce(user_mentions,'NONE')              as user_mentions
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
