{% macro binarize_column_by_unique_values(table_name, column_name, new_column_prefix) %}

{% set quoted_table_name = ref(table_name).name %}

with data as (
    select {{ column_name }},
           lower(trim(unnest(string_to_array({{ column_name }}::text, ',')))) as value
    from {{ quoted_table_name }}
)

{% set unique_values = run_query("select distinct value from data") %}

{% for value in unique_values %}
    {% set value_str = value["value"] %}
    {% set binary_column_name = new_column_prefix + "_" + value_str %}
    alter table {{ quoted_table_name }} add column {{ binary_column_name }} int default 0
{% endfor %}

{% set column_names = ["'" + value["value"].replace("'", "''") + "'" for value in unique_values %]}

update {{ quoted_table_name }}
set {% for value in unique_values %}
        {{ new_column_prefix + "_" + value["value"] }} = 1{% if not loop.last %},{% endif %}
    {% endfor %}
where lower(trim(unnest(string_to_array({{ column_name }}::text, ',')))) in ({{ column_names | join(",") }})

{% endmacro %}
