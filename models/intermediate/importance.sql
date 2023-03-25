{{
    config(
        materialized='table',
        alias = 'importance'
    )
}}
with source as (select * from {{ ref('int_2023_data') }})


select coalesce(T1.screen_name,T2.screen_name)                as screen_name
    ,T1.count as count_train
    ,T2.count as count_test
    ,T1.    as target
    from (select screen_name, sum(1) as count, sum(target) as target from source group by screen_name where source='Train') as T1
    left join (select screen_name, sum(1) as count from source group by screen_name where source='Test') as T2
    on T1.screen_name = T2.screen_name
