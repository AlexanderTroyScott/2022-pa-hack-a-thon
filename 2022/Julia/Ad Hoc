

function summarize_by_frequency(column::AbstractVector{String})
    word_counts = Dict{String, Int}()
    for str in column
        words = split(str)
        for word in words
            word_counts[word] = get(word_counts, word, 0) + 1
        end
    end
    sorted_counts = sort(collect(word_counts), by=x->x[2], rev=true)
    return sorted_counts
end
summarize_by_frequency(df_train.Heating2)
