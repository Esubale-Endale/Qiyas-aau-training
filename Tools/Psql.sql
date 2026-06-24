-- Create a user
CREATE USER esubale
WITH PASSWORD 'esuuse#123';

-- Grant database access
GRANT CONNECT ON DATABASE "EsuTmsDb" TO esubale;

-- Grant privileges on the database
GRANT ALL PRIVILEGES ON DATABASE "EsuTmsDb" TO esubale;

-- Make the user the owner of a database
ALTER DATABASE "EsuTmsDb" OWNER TO esubale;

-- Create a Database Owned by the User
CREATE DATABASE "EsuTmsDb"
OWNER esubale;

-- Create a Superuser (Development Only)
CREATE USER EsuSuperUser
WITH PASSWORD 'EsuSuper#123'
SUPERUSER;

-- Connect Using the New User
-- Example connection string:
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=EsuTmsDb;Username=esubale;Password=esuuse#123;"
  }
}

