SELECT datname
FROM pg_database
WHERE datistemplate = false;

SELECT current_database();

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE'
ORDER BY table_schema, table_name;

SELECT tablename
FROM pg_tables
WHERE schemaname = 'public';
