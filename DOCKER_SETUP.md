# Docker Setup Guide for Ahl Quran

## Quick Start

### For Developers (with sample data)

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ahl_quran
   ```

2. **Start the application with sample data**
   ```bash
   docker-compose up -d
   ```
   
   This will:
   - Create and start the PostgreSQL database
   - Run Alembic migrations to create the schema
   - Load sample data from `database_backup.sql`
   - Start the backend API

3. **Access the application**
   - Backend API: http://localhost:8000
   - API Documentation: http://localhost:8000/docs
   - Database: localhost:5433

### For Production (without sample data)

1. **Copy and modify the docker-compose file**
   ```bash
   cp docker-compose.yml docker-compose.prod.yml
   ```

2. **Edit `docker-compose.prod.yml`**
   - Change `LOAD_SAMPLE_DATA=false`
   - Update passwords and secrets
   - Remove the database_backup.sql volume mount

3. **Start production**
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

## Configuration

### Environment Variables

Edit `docker-compose.yml` to configure:

**Database Settings:**
- `DB_HOST`: Database host (default: db)
- `DB_PORT`: Database port (default: 5432)
- `DB_USER`: Database username
- `DB_PASSWORD`: Database password
- `DB_NAME`: Database name

**Application Settings:**
- `SECRET_KEY`: JWT secret key (change in production!)
- `ALGORITHM`: JWT algorithm (default: HS256)
- `ACCESS_TOKEN_EXPIRE_MINUTES`: Token expiration time

**Sample Data:**
- `LOAD_SAMPLE_DATA`: Set to `true` to load sample data, `false` to skip

## How Sample Data Loading Works

1. The backend container starts and waits for the database to be healthy
2. Alembic migrations run automatically (via `app.main:app` startup)
3. The `init-db.sh` script checks if `LOAD_SAMPLE_DATA=true`
4. If enabled, it restores `database_backup.sql` into the database
5. The application starts normally

## Useful Commands

### View logs
```bash
# All services
docker-compose logs -f

# Backend only
docker-compose logs -f backend

# Database only
docker-compose logs -f db
```

### Stop services
```bash
docker-compose down
```

### Stop and remove data
```bash
docker-compose down -v
```

### Rebuild containers
```bash
docker-compose up -d --build
```

### Access database directly
```bash
docker exec -it ahlquran_db psql -U ahlquran_user -d ahlquran_db
```

### Run migrations manually
```bash
docker exec -it ahlquran_backend alembic upgrade head
```

### Create a new database backup
```bash
docker exec -it ahlquran_db pg_dump -U ahlquran_user ahlquran_db > ahlQuran_Back/database_backup.sql
```

## Troubleshooting

### Sample data not loading
1. Check if `LOAD_SAMPLE_DATA=true` in docker-compose.yml
2. Verify `database_backup.sql` exists in `ahlQuran_Back/`
3. Check backend logs: `docker-compose logs backend`

### Database connection errors
1. Ensure database is healthy: `docker-compose ps`
2. Check database logs: `docker-compose logs db`
3. Verify credentials match in docker-compose.yml

### Port conflicts
If port 5433 or 8000 is already in use:
1. Edit `docker-compose.yml`
2. Change the port mapping (e.g., `5434:5432` or `8001:8000`)

## File Structure

```
ahl_quran/
├── docker-compose.yml              # Main docker compose configuration
├── DOCKER_SETUP.md                 # This file
├── ahlQuran_Back/
│   ├── Dockerfile                  # Backend container definition
│   ├── init-db.sh                  # Database initialization script
│   ├── database_backup.sql         # Sample data (for development)
│   ├── requirements.txt            # Python dependencies
│   └── app/                        # Application code
└── ahlQuran_Front/                 # Frontend (if applicable)
```

## Security Notes

⚠️ **Important for Production:**
1. Change all default passwords
2. Use strong `SECRET_KEY`
3. Set `LOAD_SAMPLE_DATA=false`
4. Don't expose database port publicly
5. Use environment files instead of hardcoded values
6. Enable SSL/TLS for database connections
