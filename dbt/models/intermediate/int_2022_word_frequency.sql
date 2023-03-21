{{ dbt_utils.generate_alias('word_count', 'heating_feature') }}
{{
    word_count(
        source=ref('int_2022_cleaned_data'),
        column='heating_feature'
    )
}}
