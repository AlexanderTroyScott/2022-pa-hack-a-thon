SELECT CAST('Year built' AS int)        as 'Year built'
  ,case
    when '"Sold Price"' is null then 'Yes'
    else 'No'
  end                                   as target
FROM {{ ref('username.public.advance_2022') }}
