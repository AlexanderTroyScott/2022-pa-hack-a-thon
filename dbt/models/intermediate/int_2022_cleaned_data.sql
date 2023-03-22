{{
    config(
        materialized='table',
        alias = 'int_2022_cleaned_data'
    )
}}
with source as (
    select "Id"                     as id
    ,"Sold Price"                   as sold_price
    ,"Summary"                      as summary
    ,"Type"                         as type
    ,"Year built"                   as year_built
    ,"Heating"                      as heating
    ,"Cooling"                      as cooling
    ,"Parking"                      as parking
    ,"Lot"                          as lot
    ,"Bedrooms"                     as bedrooms
    ,"Bathrooms"                    as bathrooms
    ,"Full bathrooms"               as full_bathrooms
    ,"Total interior livable area"  as area
    ,"Total spaces"                 as living_spaces
    ,"Garage spaces"                as garage_spaces
    ,"Region"                       as region
    ,"Elementary School"            as elementary_school
    ,"Elementary School Score"      as elementary_school_score
    ,"Elementary School Distance"   as elementary_school_distance
    ,"Middle School"                as middle_school
    ,"Middle School Score"          as middle_school_score
    ,"Middle School Distance"       as middle_school_distance
    ,"High School"                  as high_school
    ,"High School Score"            as high_school_score
    ,"High School Distance"         as high_school_distance
    ,"Flooring"                     as flooring
    ,"Heating features"             as heating_features
    ,"Cooling features"             as cooling_features
    ,"Appliances included"          as appliances
    ,"Laundry features"             as laundry_features
    ,"Parking features"             as parking_features
    ,"Tax assessed value"           as tax_assessed_value
    ,"Annual tax amount"            as annual_tax_amount
    ,"Listed On"                    as listed_on
    ,"Listed Price"                 as listed_price
    ,"Last Sold On"                 as last_sold_on
    ,"Last Sold Price"              as last_sold_price
    ,"City"                         as city
    ,"Zip"                          as zip
    ,"State"                        as state
    from {{ ref('stg_2022_advanced') }}
    )
select * 
,CASE 
    WHEN sold_price is NULL THEN 'Test'
    ELSE 'Train'
    END                                         as source
,CASE 
    WHEN sold_price = 0 
        or listed_price = 0 THEN 0
    ELSE log(sold_price)-log(listed_price) 
    END                                         as target
,coalesce(listed_price/area, NULL)              as price_per_sqrft
from source

