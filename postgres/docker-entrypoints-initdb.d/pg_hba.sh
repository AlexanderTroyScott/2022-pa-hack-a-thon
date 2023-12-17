#!/bin/bash
set -e

# Append new rules to pg_hba.conf for DBT CLOUD
echo "host all  all    52.45.144.63/32  md5" >> /var/lib/postgresql/data/pg_hba.conf
echo "host all  all    54.81.134.249/32  md5" >> /var/lib/postgresql/data/pg_hba.conf
echo "host all  all    52.22.161.231/32  md5" >> /var/lib/postgresql/data/pg_hba.conf

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER docker;
	CREATE DATABASE docker;
	GRANT ALL PRIVILEGES ON DATABASE docker TO docker;
EOSQL
