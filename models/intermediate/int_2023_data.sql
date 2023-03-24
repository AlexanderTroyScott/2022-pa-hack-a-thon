{{
    config(
        materialized='table',
        alias = 'int_2023_data'
    )
}}
with source as (select * from {{ ref('stg_2023_advanced') }})


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
,CASE
    WHEN full_text LIKE '%🚀%' then 1
    ELSE 0
    END                                         as emoji_rocket
from source as int_2023_data,

{% set hashtags = run_query("SELECT array_agg(hashtag) AS hashtag_array FROM (SELECT DISTINCT TRIM(LOWER(regexp_split_to_table(hashtags, ','))) AS hashtag FROM {{ ref('int_2023_data') }}) subquery").rows[0]['hashtag_array'] %}

{% if hashtags %}
{% for h in hashtags %}
  EXECUTE 'ALTER TABLE int_2023_data ADD COLUMN hashtag_' || h || ' BOOLEAN DEFAULT FALSE';
  UPDATE int_2023_data SET hashtag_' || h || ' = TRUE WHERE LOWER(hashtags) LIKE ''%' || h || '%''';
{% endfor %}
{% endif %}

select * from int_2023_data
