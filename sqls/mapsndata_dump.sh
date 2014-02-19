pg_dump -s mapsndata > mapsndata_schema.sql
pg_dump --column-inserts mapsndata > mapsndata.sql
