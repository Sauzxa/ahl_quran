# Clean Achievement Data Instructions

## Run the cleanup script inside Docker:

```bash
# From the ahlQuran_Back directory, run:
docker-compose exec web python clean_achievements.py
```

This will delete all achievement records from the database.

## Alternative: Direct SQL approach

If you prefer to use SQL directly:

```bash
# Connect to the database
docker-compose exec db psql -U ahl_quran_user -d ahl_quran_db

# Then run:
DELETE FROM achievements;

# Exit psql
\q
```

## Verify the cleanup

After running the cleanup, you can verify by checking the count:

```bash
docker-compose exec db psql -U ahl_quran_user -d ahl_quran_db -c "SELECT COUNT(*) FROM achievements;"
```

It should return 0.
