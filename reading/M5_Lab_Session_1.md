# Module 5 Lab Session 1: Make the Database Talk

## Overview

**Module:** M5 – Entity Framework Core 10 and PostgreSQL  
**Session:** 1 of 3  
**Focus:** Database setup, migrations, LINQ execution, and query translation

---

## 🚀 Welcome to the Persistence Layer Sprint

In earlier modules, the TMS API used **in-memory storage**. This meant:

- Data disappeared after restart
- No persistence across sessions
- No real database behavior

In this session, we replace that with a real database using:

- PostgreSQL
- Entity Framework Core 10

You will:

- Connect ASP.NET Core to PostgreSQL
- Define entity models
- Create and apply migrations
- Inspect generated SQL
- Understand LINQ translation

---

## 🧰 Prerequisites

Ensure the following before starting:

### 1. PostgreSQL Installed
```bash
psql --version