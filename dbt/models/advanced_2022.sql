SELECT CAST('Year built' AS int)        as 'Year built'
  ,case
    when '"Sold Price"' is null then 'Yes'
    else 'No'
  end                                   as 'Target'
FROM 'advanced_2022'
