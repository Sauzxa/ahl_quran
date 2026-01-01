# 🐳 Docker Quick Start for Ahl Quran

## TL;DR - Get Started in 2 Minutes

```bash
# 1. Clone and enter directory
git clone <your-repo-url>
cd ahl_quran

# 2. Start everything with sample data
docker-compose up -d

# 3. Access the app
# API: http://localhost:8000
# Docs: http://localhost:8000/docs
```

That's it! The database will be created, migrations will run, and sample data will be loaded automatically.

---

## What Happens Automatically?

When you run `docker-compose up -d`:

1. ✅ PostgreSQL database starts
2. ✅ Database schema is created via Alembic migrations
3. ✅ Sample data is loaded from `database_backup.sql` (because `LOAD_SAMPLE_DATA=true`)
4. ✅ Backend API starts and is ready to use

## Configuration Options

### Load Sample Data (Default: ON)

**To enable sample data** (default for development):
```yaml
# In docker-compose.yml
environment:
  - LOAD_SAMPLE_DATA=true
```

**To disable sample data** (for production or fresh start):
```yaml
# In docker-compose.yml
environment:
  - LOAD_SAMPLE_DATA=false
```

### Change Database Credentials

Edit `docker-compose.yml`:
```yaml
services:
  db:
    environment:
      - POSTGRES_USER=your_username
      - POSTGRES_PASSWORD=your_password
      - POSTGRES_DB=your_database
  
  backend:
    environment:
      - DB_USER=your_username
      - DB_PASSWORD=your_password
      - DB_NAME=your_database
      - DATABASE_URL=postgresql://your_username:your_password@db:5432/your_database
```

## Common Commands

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Restart with fresh data
docker-compose down -v && docker-compose up -d

# Rebuild after code changes
docker-compose up -d --build
```

## Troubleshooting

### "Sample data not loading"
- Check: `docker-compose logs backend | grep "Sample data"`
- Verify: `ahlQuran_Back/database_backup.sql` exists
- Ensure: `LOAD_SAMPLE_DATA=true` in docker-compose.yml

### "Port already in use"
Change ports in `docker-compose.yml`:
```yaml
ports:
  - "8001:8000"  # Change 8000 to 8001
  - "5434:5432"  # Change 5433 to 5434
```

### "Database connection failed"
```bash
# Check if database is running
docker-compose ps

# Check database logs
docker-compose logs db
```

## For More Details

See [DOCKER_SETUP.md](./DOCKER_SETUP.md) for comprehensive documentation.
