# M5 Lab Session 3: Operate the Schema

**Module:** M5 – Entity Framework Core 10 & PostgreSQL  
**Session:** 3 of 3  
**Theme:** Production-ready schema operations

---

## Prerequisites Check

Before starting, your project must have:

- A working `TmsDbContext` connected to PostgreSQL  
- At least one applied migration (`InitialCreate`)
- Three `IEntityTypeConfiguration` classes:
  - StudentConfiguration
  - CourseConfiguration
  - EnrollmentConfiguration
- Explicit relationships:
  - Student ↔ Enrollment
  - Course ↔ Enrollment
- Pagination + GroupBy queries producing SQL (`LIMIT/OFFSET`, `GROUP BY`)

---

# Exercise 6: Migration Discipline

## Tasks

1. Create a migration or modify schema (e.g. IsArchived, Year, RowVersion)
2. Explain Up() and Down()
3. Rollback (dev only)

```bash
dotnet ef database update PreviousMigrationName
```

## Checkpoint
- At least 2 migrations exist
- Can explain Down()

---

# Exercise 7: N+1 Problem

## BAD (N+1)

```csharp
var students = await db.Students.ToListAsync();

foreach (var s in students)
{
    var count = await db.Enrollments.CountAsync(e => e.StudentId == s.Id);
}
```

## GOOD FIX

```csharp
var report = await db.Students
    .Select(s => new
    {
        s.Name,
        EnrollmentCount = s.Enrollments.Count
    })
    .ToListAsync();
```

## Checkpoint
- BAD = 1 + N queries
- GOOD = 1 query

---

# Exercise 8: Audit + Concurrency

## Shadow Property

```csharp
builder.Property<DateTime>("LastUpdated");
```

## Migration

```bash
dotnet ef migrations add AddStudentLastUpdated
dotnet ef database update
```

## Concurrency

```csharp
builder.Property(s => s.Version).IsRowVersion();
```

Expected:
- DbUpdateConcurrencyException on conflict

---

# Exercise 9: Bulk Update + Soft Delete

## Soft Delete

```csharp
builder.HasQueryFilter(s => !s.IsDeleted);
```

## Bulk Update

```csharp
await db.Enrollments
    .Where(e => e.EnrolledAt < cutoff)
    .ExecuteUpdateAsync(s => s.SetProperty(e => e.IsArchived, true));
```

## Checkpoint
- One SQL UPDATE only
- No loops

---

# Final Checklist

- 2+ migrations exist
- Can explain Up/Down
- N+1 fixed
- LastUpdated exists
- Concurrency works
- Bulk update works
- Soft delete works
- SQL logs show real translation
