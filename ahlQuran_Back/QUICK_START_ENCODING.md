# Quick Start: Verify Arabic Support

## Step 1: Check Current Setup

Run this command to verify your database supports Arabic:

```bash
cd ahlQuran_Back
python verify_db_encoding.py
```

Expected output:
```
✓ Database Encoding: UTF8
✓ Client Encoding: UTF8
✓ Server Encoding: UTF8
✓ Arabic text test PASSED: 'أحمد محمد'
✅ Database is properly configured for Arabic text!
```

## Step 2: If Issues Found

If the test fails, follow these steps:

### Option A: Restart with Fresh Database (Recommended)

```bash
# Stop containers
docker-compose down

# Remove old database volume
docker volume rm ahlquran_back_postgres_data

# Start with updated configuration
docker-compose up -d

# Wait for database to be ready (about 10 seconds)
sleep 10

# Run migrations
alembic upgrade head

# Verify again
python verify_db_encoding.py
```

### Option B: Manual SQL Fix (If you have data to preserve)

```bash
# Connect to database
docker exec -it ahlquran_back-db-1 psql -U Rahim -d ahl_quran_db

# Run the fix script
\i /app/fix_db_encoding.sql
```

## Step 3: Test Arabic Input

Try creating a guardian with Arabic name through the API or UI:

```bash
curl -X POST http://localhost:8000/api/v1/guardians/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "guardian_info": {
      "first_name": "أحمد",
      "last_name": "محمد",
      "relationship": "أب"
    },
    "account_info": {
      "username": "ahmad_test",
      "password": "test123"
    }
  }'
```

## What Was Changed

1. **docker-compose.yml**: Updated PostgreSQL initialization with proper UTF-8 locale
2. **.env**: Added `client_encoding=utf8` to database URL
3. **Models**: Already using String() which supports UTF-8 (no changes needed)

## Files Created

- `verify_db_encoding.py` - Script to verify database encoding
- `fix_db_encoding.sql` - SQL commands to check/fix encoding
- `ARABIC_ENCODING_GUIDE.md` - Detailed documentation
- `QUICK_START_ENCODING.md` - This file

## Need Help?

See `ARABIC_ENCODING_GUIDE.md` for detailed troubleshooting.
