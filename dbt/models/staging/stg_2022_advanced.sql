 create  table "username"."hackathons"."stg_2022_advanced"
  as (




        (
            select
                cast('"username"."public"."2022_advanced_train"' as TEXT) as _dbt_source_relation,


                    cast("Id" as integer) as "Id" ,
                    cast("Sold Price" as integer) as "Sold Price" ,
                    cast("Summary" as text) as "Summary" ,
                    cast("Type" as text) as "Type" ,
                    cast("Year built" as integer) as "Year built" ,
                    cast("Heating" as text) as "Heating" ,
                    cast("Cooling" as text) as "Cooling" ,
                    cast("Parking" as text) as "Parking" ,
                    cast("Lot" as double precision) as "Lot" ,
                    cast("Bedrooms" as text) as "Bedrooms" ,
                    cast("Bathrooms" as integer) as "Bathrooms" ,
                    cast("Full bathrooms" as integer) as "Full bathrooms" ,
                    cast("Total interior livable area" as integer) as "Total interior livable area" ,
                    cast("Total spaces" as integer) as "Total spaces" ,
                    cast("Garage spaces" as integer) as "Garage spaces" ,
                    cast("Region" as text) as "Region" ,
                    cast("Elementary School" as text) as "Elementary School" ,
                    cast("Elementary School Score" as integer) as "Elementary School Score" ,
                    cast("Elementary School Distance" as double precision) as "Elementary School Distance" ,
                    cast("Middle School" as text) as "Middle School" ,
                    cast("Middle School Score" as integer) as "Middle School Score" ,
                    cast("Middle School Distance" as double precision) as "Middle School Distance" ,
                    cast("High School" as text) as "High School" ,
                    cast("High School Score" as integer) as "High School Score" ,
                    cast("High School Distance" as double precision) as "High School Distance" ,
                    cast("Flooring" as text) as "Flooring" ,
                    cast("Heating features" as text) as "Heating features" ,
                    cast("Cooling features" as text) as "Cooling features" ,
                    cast("Appliances included" as text) as "Appliances included" ,
                    cast("Laundry features" as text) as "Laundry features" ,
                    cast("Parking features" as text) as "Parking features" ,
                    cast("Tax assessed value" as text) as "Tax assessed value" ,
                    cast("Annual tax amount" as text) as "Annual tax amount" ,
                    cast("Listed On" as text) as "Listed On" ,
                    cast("Listed Price" as integer) as "Listed Price" ,
                    cast("Last Sold On" as text) as "Last Sold On" ,
                    cast("Last Sold Price" as integer) as "Last Sold Price" ,
                    cast("City" as text) as "City" ,
                    cast("Zip" as integer) as "Zip" ,
                    cast("State" as text) as "State"

            from "username"."public"."2022_advanced_train"


        )

        union all


        (
            select
                cast('"username"."public"."2022_advanced_test"' as TEXT) as _dbt_source_relation,


                    cast("Id" as integer) as "Id" ,
                    cast(null as integer) as "Sold Price" ,
                    cast("Summary" as text) as "Summary" ,
                    cast("Type" as text) as "Type" ,
                    cast("Year built" as integer) as "Year built" ,
                    cast("Heating" as text) as "Heating" ,
                    cast("Cooling" as text) as "Cooling" ,
                    cast("Parking" as text) as "Parking" ,
                    cast("Lot" as double precision) as "Lot" ,
                    cast("Bedrooms" as text) as "Bedrooms" ,
                    cast("Bathrooms" as integer) as "Bathrooms" ,
                    cast("Full bathrooms" as integer) as "Full bathrooms" ,
                    cast("Total interior livable area" as integer) as "Total interior livable area" ,
                    cast("Total spaces" as integer) as "Total spaces" ,
                    cast("Garage spaces" as integer) as "Garage spaces" ,
                    cast("Region" as text) as "Region" ,
                    cast("Elementary School" as text) as "Elementary School" ,
                    cast("Elementary School Score" as integer) as "Elementary School Score" ,
                    cast("Elementary School Distance" as double precision) as "Elementary School Distance" ,
                    cast("Middle School" as text) as "Middle School" ,
                    cast("Middle School Score" as integer) as "Middle School Score" ,
                    cast("Middle School Distance" as double precision) as "Middle School Distance" ,
                    cast("High School" as text) as "High School" ,
                    cast("High School Score" as integer) as "High School Score" ,
                    cast("High School Distance" as double precision) as "High School Distance" ,
                    cast("Flooring" as text) as "Flooring" ,
                    cast("Heating features" as text) as "Heating features" ,
                    cast("Cooling features" as text) as "Cooling features" ,
                    cast("Appliances included" as text) as "Appliances included" ,
                    cast("Laundry features" as text) as "Laundry features" ,
                    cast("Parking features" as text) as "Parking features" ,
                    cast("Tax assessed value" as text) as "Tax assessed value" ,
                    cast("Annual tax amount" as text) as "Annual tax amount" ,
                    cast("Listed On" as text) as "Listed On" ,
                    cast("Listed Price" as integer) as "Listed Price" ,
                    cast("Last Sold On" as text) as "Last Sold On" ,
                    cast("Last Sold Price" as integer) as "Last Sold Price" ,
                    cast("City" as text) as "City" ,
                    cast("Zip" as integer) as "Zip" ,
                    cast("State" as text) as "State"

            from "username"."public"."2022_advanced_test"


        )


  )
