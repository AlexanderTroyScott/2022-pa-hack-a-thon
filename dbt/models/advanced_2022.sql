SELECT CAST('Year built' AS int) as 'Year built'
,ifc('Sold Price' = NULL,'Yes','No') as 'Target'
FROM advanced_2022
