{% macro binarize_column(column, prefix) %}
WITH split_data AS (
  SELECT *
  {% for element in ["bank_transfer", "credit_card", "gift_card"] %}
      ,1 AS {{ prefix }}_{{ element }}
    {% endfor %}
  FROM (select tweet_id,  split_part({{column}}, ',', generate_series(1, array_length(string_to_array({{column}}, ','), 1))) as {{column}} from {{ ref('int_2023_data') }}) as subquery
  where {{ column }} is not NULL and tweet_id between 100001 and 100010
)
select * from split_data
{% endmacro %}
