{{ materialized="table" }}
select * 
from {{ source('my_source', 'advanced_2022_raw') }}
limit 1
