@echo off
REM Script to run Alembic migrations in Docker container

echo Running database migrations...
docker-compose exec web alembic upgrade head

if %ERRORLEVEL% EQU 0 (
    echo ✅ Migrations completed successfully!
) else (
    echo ❌ Migration failed!
    exit /b 1
)
