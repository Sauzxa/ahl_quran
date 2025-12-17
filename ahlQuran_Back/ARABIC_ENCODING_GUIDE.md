# Arabic Text Encoding Guide

This guide ensures your PostgreSQL database properly supports Arabic characters.

## Current Configuration

The system is configured to support Arabic text with:

1. **Database Encoding**: UTF-8
2. **Client Encoding**: UTF-8
3. **Locale**: en_US.UTF-8

## Verification

### Quick Check

Run the verification script to check your database encoding:

```bash
cd ahlQuran_Back
python verify_db_encoding.py
```

This will:
- Display current encoding settings
- Test Arabic text storage and retrieval
- Confirm if the database is properly configured

### Manual Check

Connect to PostgreSQL and run:

```sql
-- Check database encoding
SELECT pg_encoding_to_char(encoding) FROM pg_database WHERE datname = current_database();

-- Should return: UTF8

-- Test Arabic text
SELECT 'أحمد محمد' as test;

-- Should display Arabic correctly
```

## Configuration Files

### 1. Docker Compose (`docker-compose.yml`)

The PostgreSQL container is configured with:

```yaml
environment:
  POSTGRES_INITDB_ARGS: "--encoding=UTF8 --locale=en_US.UTF-8"
  LANG: en_US.UTF-8
  LC_ALL: en_US.UTF-8
```

### 2. Database URL (`.env`)

The connection string includes UTF-8 encoding:

```
DATABASE_URL=postgresql+asyncpg://user:pass@db:5432/ahl_quran_db?client_encoding=utf8
```

### 3. SQLAlchemy Models

All string fields use `String()` type which automatically supports UTF-8:

```python
first_name: Mapped[str] = mapped_column(String(100), nullable=False)
last_name: Mapped[str] = mapped_column(String(100), nullable=False)
```

## Troubleshooting

### Issue: Arabic text appears as ??? or boxes

**Solution 1**: Verify database encoding
```bash
python verify_db_encoding.py
```

**Solution 2**: Set client encoding in your SQL client
```sql
SET client_encoding = 'UTF8';
```

**Solution 3**: Check your terminal/console encoding
- Ensure your terminal supports UTF-8
- On Windows: Use `chcp 65001` to set UTF-8 code page

### Issue: Need to recreate database with proper encoding

⚠️ **WARNING**: This will delete all data!

```bash
# Stop the containers
docker-compose down

# Remove the volume
docker volume rm ahlquran_back_postgres_data

# Start fresh
docker-compose up -d

# Run migrations
alembic upgrade head
```

## Testing Arabic Input

### From Python/FastAPI

```python
# This should work automatically
guardian_data = {
    "first_name": "أحمد",
    "last_name": "محمد",
    "relationship": "أب"
}
```

### From Flutter/Dart

```dart
// This should work automatically
final guardianInfo = GuardianInfoDialog()
  ..guardian.firstName = "أحمد"
  ..guardian.lastName = "محمد";
```

### From SQL

```sql
INSERT INTO guardians (first_name, last_name, relationship_to_student)
VALUES ('أحمد', 'محمد', 'أب');

SELECT * FROM guardians WHERE first_name = 'أحمد';
```

## Best Practices

1. **Always use UTF-8**: Ensure all layers (database, backend, frontend) use UTF-8
2. **Test early**: Test Arabic input/output during development
3. **Verify encoding**: Run `verify_db_encoding.py` after setup
4. **Consistent configuration**: Keep encoding settings consistent across all environments

## Additional Resources

- [PostgreSQL Character Set Support](https://www.postgresql.org/docs/current/multibyte.html)
- [SQLAlchemy Unicode](https://docs.sqlalchemy.org/en/20/core/type_basics.html#sqlalchemy.types.String)
- [FastAPI Unicode](https://fastapi.tiangolo.com/advanced/custom-response/#use-orjsonresponse)

## Support

If you encounter encoding issues:

1. Run `python verify_db_encoding.py`
2. Check the output for any failures
3. Review the troubleshooting section above
4. Ensure your terminal/console supports UTF-8
