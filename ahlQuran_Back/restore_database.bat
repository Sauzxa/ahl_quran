@echo off
REM Database Restore Script for Ahl Quran System (Windows)
REM This script restores the PostgreSQL database from a backup file

echo ==========================================
echo Ahl Quran Database Restore
echo ==========================================

REM Check if backup file is provided as argument
if "%~1"=="" (
    set BACKUP_FILE=backupdata.sql
    echo No backup file specified, using default: backupdata.sql
) else (
    set BACKUP_FILE=%~1
    echo Using backup file: %BACKUP_FILE%
)

REM Check if backup file exists
if not exist "%BACKUP_FILE%" (
    echo Error: Backup file '%BACKUP_FILE%' not found!
    echo.
    echo Available backup files:
    dir /b backupdata*.sql 2>nul
    echo.
    echo Usage: restore_database.bat [backup_file.sql]
    exit /b 1
)

REM Load environment variables from .env file
if exist .env (
    for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
        if not "%%a"=="" if not "%%b"=="" (
            set %%a=%%b
        )
    )
)

REM Set default values if not provided in .env
if not defined POSTGRES_USER set POSTGRES_USER=ahl_quran_user
if not defined POSTGRES_PASSWORD set POSTGRES_PASSWORD=ahl_quran_password
if not defined POSTGRES_DB set POSTGRES_DB=ahl_quran_db

echo Database: %POSTGRES_DB%
echo User: %POSTGRES_USER%
echo ==========================================

REM Check if Docker is running
docker ps >nul 2>&1
if errorlevel 1 (
    echo Error: Docker is not running!
    echo Please start Docker Desktop
    exit /b 1
)

REM Check if database container is running
docker-compose ps | findstr /C:"db" | findstr /C:"Up" >nul
if errorlevel 1 (
    echo Error: Database container is not running!
    echo Please start the containers with: docker-compose up -d
    exit /b 1
)

echo.
echo WARNING: This will replace all data in the database!
echo Press Ctrl+C to cancel, or
pause

REM Stop the web container to prevent connections during restore
echo Stopping web container...
docker-compose stop web

REM Restore database using psql inside the Docker container
echo Restoring database from %BACKUP_FILE%...
type "%BACKUP_FILE%" | docker-compose exec -T db psql -U %POSTGRES_USER% -d postgres

if errorlevel 1 (
    echo X Restore failed!
    echo Starting web container...
    docker-compose start web
    exit /b 1
)

echo + Database restored successfully!

REM Start the web container again
echo Starting web container...
docker-compose start web

echo ==========================================
echo Restore completed successfully!
echo ==========================================
