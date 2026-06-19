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

-- Create a user
CREATE USER esubale
WITH PASSWORD 'esuuse#123';

-- Grant database access
GRANT CONNECT ON DATABASE "TmsDb" TO esubale;

-- Grant privileges on the database
GRANT ALL PRIVILEGES ON DATABASE "TmsDb" TO esubale;

-- Make the user the owner of a database
ALTER DATABASE "TrainingDb" OWNER TO myuser;

-- Create a Database Owned by the User
CREATE DATABASE "TrainingDb"
OWNER myuser;

-- Create a Superuser (Development Only)
CREATE USER myuser
WITH PASSWORD 'StrongPassword123'
SUPERUSER;

-- Connect Using the New User
-- Example connection string:
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=TrainingDb;Username=myuser;Password=StrongPassword123"
  }
}

