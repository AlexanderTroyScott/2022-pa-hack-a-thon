{{ config(
    materialized='table',
    schema='my_schema'
) }}

CREATE TABLE {{ ref('my_schema.new_table') }} (
  column1 VARCHAR(255),
  column2 INTEGER
);

INSERT INTO {{ ref('my_schema.new_table') }} (column1, column2)
VALUES ('value1', 1), ('value2', 2), ('value3', 3);
