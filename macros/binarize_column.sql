version: 2

# Define the macro to split the column by comma and binarize the results
{{- macro binarize_column(column_name) -}}
  SELECT 
    {% for value in ref('my_source_data').column(column_name).distinct().execute() %}
      CASE WHEN '{{ value }}' IN ({{ ref('int_2023_data').column(hashtags).execute()|join("', '") }}') THEN 1 ELSE 0 END AS {{ hashtags }}_{{ value }},
    {% endfor %}
    {{ ref('int_2023_data').column(hashtags) }}
  FROM {{ ref('int_2023_data') }}
  GROUP BY 1, 2
{% endmacro %}

# Define the model that uses the macro to binarize the column
models:
  - name: my_binarized_data
    description: "Binarized version of my_source_data"
    columns:
      {% for value in ref('int_2023_data').column('hashtags').distinct().execute() %}
        - name: hashtags_{{ value }}
          description: "1 if my_column contains {{ value }}, 0 otherwise"
          tests:
            - not_null
            - unique
      {% endfor %}
    pre-hook: |
      DROP TABLE IF EXISTS {{ this }} CASCADE;
    materialized: table
    sql: |
      {{ binarize_column('hashtags') }}
