{{ config(materialized='incremental') }}

{% set hashtags = run_query("SELECT array_agg(hashtag) AS hashtag_array FROM (SELECT DISTINCT TRIM(LOWER(regexp_split_to_table(hashtags, ','))) AS hashtag FROM {{ ref('int_2023_data') }}) subquery").rows[0]['hashtag_array'] %}

{% if hashtags %}
{% for h in hashtags %}
  EXECUTE 'ALTER TABLE int_2023_data ADD COLUMN hashtag_' || h || ' BOOLEAN DEFAULT FALSE';
  UPDATE int_2023_data SET hashtag_' || h || ' = TRUE WHERE LOWER(hashtags) LIKE ''%' || h || '%''';
{% endfor %}
{% endif %}
