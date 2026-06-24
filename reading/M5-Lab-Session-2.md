# M5 Lab Session 2: Design the Schema

**Module:** M5 – Entity Framework Core 10 & PostgreSQL  
**Session:** 2 of 3  
**Theme:** Schema design, configuration, and relationships

---

## Prerequisites Check

Before you start, ensure:

- Working `TmsDbContext` with PostgreSQL connection
- Initial migration applied (`InitialCreate`)
- SQL logging enabled (you can see generated SQL)
- Entities exist:
  - Student
  - Course
  - Enrollment

If missing → go back to Session 1.

---

# What This Session Is About

In Session 1, you proved the database works.

In Session 2, you design how it behaves:

- Queries must execute in SQL (not memory)
- Entity configuration must be separated cleanly
- Relationships must be explicit and intentional

---

# Exercise 3: Pagination + Aggregation

## Task 1: Paginated Students

- Page size: 20
- Input: page number
- Must use stable ordering

```csharp
var students = await context.Students
    .OrderBy(s => s.Name)
    .Skip((page - 1) * 20)
    .Take(20)
    .ToListAsync();
```

### Rules
- ALWAYS use `OrderBy` before `Skip/Take`

---

## Task 2: Top 5 Courses by Enrollment

```csharp
var topCourses = await context.Courses
    .Select(c => new
    {
        c.Title,
        EnrollmentCount = c.Enrollments.Count
    })
    .OrderByDescending(x => x.EnrollmentCount)
    .Take(5)
    .ToListAsync();
```

---

## Checkpoint

- SQL shows `LIMIT` and `OFFSET`
- SQL shows `GROUP BY` / aggregation behavior

---

## Common Issues

- Wrong paging → missing OrderBy
- Client-side evaluation → using unsupported methods inside Select

---

# Exercise 4: IEntityTypeConfiguration

## Goal

Move all configuration out of `OnModelCreating`.

---

## Steps

Create:

- StudentConfiguration
- CourseConfiguration
- EnrollmentConfiguration

Each implements:

```csharp
IEntityTypeConfiguration<T>
```

---

## Example Structure

```csharp
public class StudentConfiguration : IEntityTypeConfiguration<Student>
{
    public void Configure(EntityTypeBuilder<Student> builder)
    {
        builder.HasKey(x => x.Id);

        builder.Property(x => x.Name)
            .IsRequired()
            .HasMaxLength(100);
    }
}
```

---

## Register Configurations

```csharp
modelBuilder.ApplyConfigurationsFromAssembly(typeof(TmsDbContext).Assembly);
```

---

## Checkpoint

- No heavy logic in `OnModelCreating`
- 3 configuration classes exist
- Migration reflects configuration changes

---

# Exercise 5: Relationships Design

## Relationships

- Student → Enrollment (1-to-many)
- Course → Enrollment (1-to-many)
- Enrollment → Student + Course (many-to-1)

---

## Fluent API Example

```csharp
builder.HasOne(e => e.Student)
    .WithMany(s => s.Enrollments)
    .HasForeignKey(e => e.StudentId);
```

```csharp
builder.HasOne(e => e.Course)
    .WithMany(c => c.Enrollments)
    .HasForeignKey(e => e.CourseId);
```

---

## Delete Behavior Decision

Example:

```csharp
.OnDelete(DeleteBehavior.Restrict);
```

---

## Why Restrict?

- Prevent accidental cascade deletion
- Protect enrollment history
- Force explicit cleanup logic

---

## Checkpoint

- Relationships clearly defined
- Delete behavior explicitly set
- Navigation properties exist

---

# Final Session 2 Checklist

- [ ] Pagination uses OrderBy + Skip + Take
- [ ] Top 5 courses query uses aggregation
- [ ] 3 IEntityTypeConfiguration classes exist
- [ ] OnModelCreating is minimal
- [ ] Relationships are explicitly configured
- [ ] OnDelete behavior is defined
- [ ] SQL logs confirm server-side execution

---

# Key Idea

Session 2 is about **making EF Core behave predictably at scale**:

- SQL must do the work
- Configuration must be structured
- Relationships must be intentional
