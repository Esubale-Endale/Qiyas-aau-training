# Creating a New User in PostgreSQL

In PostgreSQL, users are called **roles**. You can create a new user with either the `CREATE USER` or `CREATE ROLE` command.

## Create a User

```sql
CREATE USER myuser
WITH PASSWORD 'StrongPassword123';
```

Or equivalently:

```sql
CREATE ROLE myuser
LOGIN
PASSWORD 'StrongPassword123';
```

## Grant Database Access

If you already have a database named `TrainingDb`:

```sql
GRANT CONNECT ON DATABASE "TrainingDb" TO myuser;
```

## Grant Privileges on the Database

```sql
GRANT ALL PRIVILEGES ON DATABASE "TrainingDb" TO myuser;
```

## Make the User the Owner of a Database

```sql
ALTER DATABASE "TrainingDb" OWNER TO myuser;
```

## Create a Database Owned by the User

```sql
CREATE DATABASE "TrainingDb"
OWNER myuser;
```

## Create a Superuser (Development Only)

```sql
CREATE USER myuser
WITH PASSWORD 'StrongPassword123'
SUPERUSER;
```

> Avoid using `SUPERUSER` in production unless absolutely necessary.

## Connect Using the New User

Example connection string:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=TrainingDb;Username=myuser;Password=StrongPassword123"
  }
}
```

## Using psql

Connect as the PostgreSQL admin user:

```bash
psql -U postgres
```

Then run the SQL commands above.

## Useful Commands

List all users/roles:

```sql
\du
```

List all databases:

```sql
\l
```
