version: 2

# Define the macro to split the column by comma and binarize the results
{{- macro binarize_column(column_name) -}}
  SELECT 
    {% for value in ref('int_2023_data').column(hashtags).distinct().execute() %}
      CASE WHEN '{{ value }}' IN ({{ ref('int_2023_data').column(hashtags).execute()|join("', '") }}') THEN 1 ELSE 0 END AS {{ hashtags }}_{{ value }},
    {% endfor %}
    {{ ref('int_2023_data').column(hashtags) }}
  FROM {{ ref('int_2023_data') }}
  GROUP BY 1, 2
{% endmacro %}
