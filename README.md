# Predictive Analytics Hack-a-thons

This repository contains work/models utilized in the joint actuarial hackathons for years 2022+

Two folders contain files:
- Kaggle - Folder containing the downloaded source files without any modification
- Jupyter - Folder containing the code that was run on a jupyter server for modeling

Three folders are for docker services
- Postgres - Runs a postgres database service for the source data and dbt runs and accessed through adminer
- dbt - SQL transformation layer to clean and transform the data for modeling
- Lightdash - Dashboard that connects to the postgres database and dbt for model exploration and validation

## Postgres
Environment variables:


Run the Service
> docker stack deploy -c postgres/postgres.yaml analytics_db

Login to database by connecting to the host IP in a web browser

Load source data to the database.

## DBT

## Lightdash

## Jupyter
