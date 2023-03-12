using Pkg
Pkg.add("SplitApplyCombine")
Pkg.add("StatsBase")

using CSV, DataFrames

# Read CSV file into a DataFrame
df_train = CSV.read("advanced_train.csv", DataFrame)

# Display the first 10 rows of the DataFrame
first(df_train, 3)

#Replace field spaces with underscores
function replace_spaces_with_underscores(df::DataFrame)
    new_names = Symbol.(replace.(string.(names(df)), " " => "_"))
    rename!(df, names(df) .=> new_names)
    return df
end
df_train = replace_spaces_with_underscores(df_train)

# remove missing values
df_train = df_train[.!ismissing.(df_train.Sold_Price), :]

#Create target variable, the difference between logs of sale price and listed price
df_train.🎯 = log.(df_train.Sold_Price)-log.(df_train.Listed_Price)

using TextAnalysis

function clean_text(text)
    text = coalesce(text,"")
    text = StringDocument(text)
    prepare!(text, strip_numbers| strip_non_letters| strip_frequent_terms)
    #stem!(text)
    return text
end

df_train.Heating2 = map(text,map(clean_text, df_train.Heating))
