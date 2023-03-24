{% macro binarize_columns(table, column, prefix) %}

    {% set prefix_length = prefix | length %}
    {% set field_names = [] %}

    {# create a list of unique field names without prefix #}
    {% for field in column.lower().split(',') %}
        {% if prefix == field[0:prefix_length] %}
            {% set field_name = field[prefix_length:] %}
            {% if field_name not in field_names %}
                {% do field_names.append(field_name) %}
            {% endif %}
        {% endif %}
    {% endfor %}

    SELECT
        {% for field_name in field_names %}
            CASE WHEN {{ column }} ILIKE '{{ prefix }}{{ field_name }}%'
            THEN 1 ELSE 0 END as {{ prefix }}{{ field_name }},
        {% endfor %}
        *
    FROM {{ table }}

{% endmacro %}
