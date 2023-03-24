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
