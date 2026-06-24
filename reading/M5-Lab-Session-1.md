📘 M5 Lab Session 2: Design the Schema

Module: M5 – Entity Framework Core 10 and PostgreSQL
Focus: Schema design, LINQ aggregation, configuration patterns, relationships
Exercises: 3, 4, 5

🧠 Prerequisites Check

Before starting, ensure your project has:

A working TmsDbContext
PostgreSQL configured with UseNpgsql
A valid TmsDatabase connection string
InitialCreate migration applied (dotnet ef migrations list)
SQL logging enabled (you should see queries in console)
Entities:
Student
Course
Enrollment

⚠️ If any are missing, return to Session 1.

🎯 What This Session Is About

In Session 1, you proved the database works.

In Session 2, you design how it behaves.

You will learn:

How to push pagination into SQL
How to use GroupBy + aggregation in the database
How to structure EF Core using IEntityTypeConfiguration
How to design relationships intentionally
🧪 Exercise 3: GroupBy, Aggregates & Pagination
🎯 Goal

Make the database handle:

Pagination (LIMIT / OFFSET)
Aggregation (GROUP BY)
Sorting (ORDER BY)
📌 Task 1: Paginated Students

Implement:

Page size: 20
Page number: parameter
Stable ordering: OrderBy(Name) BEFORE paging
Expected logic:
var students = await context.Students
    .OrderBy(s => s.Name)
    .Skip((page - 1) * 20)
    .Take(20)
    .ToListAsync(cancellationToken);
📌 Task 2: Top 5 Courses by Enrollment
Requirement:

Return:

Course title
Enrollment count
Top 5 courses
var topCourses = await context.Courses
    .Select(c => new
    {
        c.Title,
        Count = c.Enrollments.Count
    })
    .OrderByDescending(x => x.Count)
    .Take(5)
    .ToListAsync();
✅ Checkpoint

You should see:

LIMIT / OFFSET in SQL logs
GROUP BY or COUNT translation in SQL
⚠️ Common Issues
❌ Client-side evaluation error

Avoid custom methods inside queries.

❌ Wrong pagination results

Always use OrderBy BEFORE Skip/Take.

❌ Empty results

Check seed data exists.

🧪 Exercise 4: IEntityTypeConfiguration
🎯 Goal

Move configuration out of DbContext.

📁 Step 1: Create Configuration Classes

Create:

StudentConfiguration
CourseConfiguration
EnrollmentConfiguration

Each implements:

IEntityTypeConfiguration<T>
📌 Step 2: Move Mapping Logic

Move:

Required fields
Length constraints
Relationships

into Fluent API.

📌 Step 3: Register Configurations

In TmsDbContext:

modelBuilder.ApplyConfigurationsFromAssembly(
    typeof(TmsDbContext).Assembly);
📌 Step 4: Migration

Run:

dotnet ef migrations add RefineTmsModel

Then inspect before applying:

dotnet ef database update
⚠️ Common Issues
❌ No primary key

Ensure:

builder.HasKey(e => e.Id);
❌ Migration drops tables unexpectedly

You renamed entities → EF thinks it's a new table.

✅ Checkpoint

You must have:

3 configuration classes
Clean OnModelCreating
Migration reflecting schema refinements
🧪 Exercise 5: Model the Relationship Graph
🎯 Goal

Define relationships explicitly:

Student → Enrollments (1-to-many)
Course → Enrollments (1-to-many)
📌 Step 1: Relationship Setup

Example:

builder.HasOne(e => e.Student)
    .WithMany(s => s.Enrollments)
    .HasForeignKey(e => e.StudentId);
builder.HasOne(e => e.Course)
    .WithMany(c => c.Enrollments)
    .HasForeignKey(e => e.CourseId);
📌 Step 2: Decide Delete Behavior

Example:

.OnDelete(DeleteBehavior.Restrict);
🧠 Why this matters
Prevents accidental cascade deletes
Forces explicit handling of dependent data
⚠️ Common Issues
❌ Cascade cycle error

Use DeleteBehavior.Restrict

❌ Navigation properties null

You forgot .Include() in queries

✅ Checkpoint

You should be able to:

Explain delete behavior choice
Show FK relationships in migration
Load navigation properties with Include
🏁 Session 2 Summary

By the end of this session:

✔ Database is doing real work
Pagination runs in SQL
Aggregation runs in SQL
✔ Clean architecture achieved
DbContext is minimal
Configuration is separated per entity
✔ Relationships are intentional
No accidental cascade deletes
Explicit FK design
🚀 Next: Session 3

You will:

Fix N+1 problems
Add audit fields
Implement concurrency control
Perform bulk updates
Apply soft delete filters

If you want, I can next:

✅ Convert Session 1 → Markdown
✅ Convert Session 3 → Markdown
✅ Or generate a full “M5 Study Pack” (all sessions combined cleanly)


<!-- --------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------- -->

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
2. .NET 10 SDK Installed
dotnet --version
3. Required EF Core Packages
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL
dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Microsoft.EntityFrameworkCore.Tools
📦 EF Core Tooling

Check EF CLI:

dotnet ef --version

If missing:

dotnet tool install --global dotnet-ef
🧱 Exercise 1: Configure DbContext & First Migration
Entities

You model a simple TMS system:

Student
Course
Enrollment
Assessment (future use)
Certificate (future use)
Example Entity: Student
public class Student
{
    public int Id { get; set; }
    public required string RegistrationNumber { get; set; }
    public required string Name { get; set; }
    public decimal GPA { get; set; }
    public bool IsActive { get; set; } = true;

    public ICollection<Enrollment> Enrollments { get; set; } = new List<Enrollment>();
}
DbContext
public class TmsDbContext : DbContext
{
    public DbSet<Student> Students => Set<Student>();
    public DbSet<Course> Courses => Set<Course>();
    public DbSet<Enrollment> Enrollments => Set<Enrollment>();
}
Register DbContext
builder.Services.AddDbContext<TmsDbContext>(options =>
    options.UseNpgsql(
        builder.Configuration.GetConnectionString("TmsDatabase")));
Connection String
"ConnectionStrings": {
  "TmsDatabase": "Host=localhost;Database=TmsDb;Username=postgres;Password=your_password"
}
First Migration
dotnet ef migrations add InitialCreate
dotnet ef database update
🧾 Key Concept: Migration Files

Each migration contains:

Up() → applies changes
Down() → rolls back changes
🧪 Exercise 2: LINQ & SQL Translation
Enable SQL Logging
options
  .LogTo(Console.WriteLine, LogLevel.Information)
  .EnableSensitiveDataLogging();
Deferred Execution Example
var query = context.Students.Where(s => s.GPA >= 3.0m);
var ordered = query.OrderBy(s => s.Name);
var results = ordered.ToList(); // execution happens here
Translation Failure Example
.Where(s => IsHonorRoll(s.GPA)) // ❌ not translatable

Fix:

.Where(s => s.GPA >= 3.5m)
📊 Registrar Queries
1. Active students count
context.Students
.Where(s => s.IsActive && s.GPA >= 3.0m)
.CountAsync();
2. Courses by enrollment
context.Courses
.Select(c => new {
    c.Title,
    EnrollmentCount = c.Enrollments.Count
})
.OrderByDescending(x => x.EnrollmentCount);
3. Average GPA per course
context.Enrollments
.GroupBy(e => e.Course.Title)
.Select(g => new {
    Course = g.Key,
    AverageGPA = g.Average(e => e.Student.GPA)
});
4. Students with zero enrollments
context.Students
.Where(s => !s.Enrollments.Any())
🧠 Key Lessons
LINQ is translated to SQL
Execution happens at .ToList() or .Count()
Bad expressions fail translation
EF Core only discovers tables via DbSet or navigation
🏁 Session 1 Checklist
 Migration applied successfully
 SQL logs visible
 LINQ executes in database (not memory)
 Can explain Up vs Down migration
 Understand deferred execution

---

If you say **“continue”**, I’ll generate:

👉 `M5-Lab-Session-2.md` (Design the Schema — Fluent API, pagination, relationships)