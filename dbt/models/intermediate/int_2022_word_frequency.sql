
{{ config(alias='word_count_heating_feature') }}
{{
    word_count(
        source=source('hackathons','int_2022_cleaned_data'),
        column='heating_feature'
    )
}}
