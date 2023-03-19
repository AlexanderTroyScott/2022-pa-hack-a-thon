SELECT CAST('Year built' AS int)        as 'Year built'
  ,case
    when '"Sold Price"' is null then 'Yes'
    else 'No'
  end                                   as target
FROM username.public.advance_2022
