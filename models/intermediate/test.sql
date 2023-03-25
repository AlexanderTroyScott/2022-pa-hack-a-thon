{{ config(materialized='table') }}

{{ binarize_column('hashtags', 'hashtag') }}

