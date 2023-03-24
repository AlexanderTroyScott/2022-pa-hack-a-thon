WITH source as (select * from {{ ref('int_2023_data') }})
SELECT distinct

    LOWER(regexp_split_to_table(hashtags, ',')) AS hashtag
  FROM source
