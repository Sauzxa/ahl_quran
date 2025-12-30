@echo off
REM Database Backup Script for Ahl Quran System (Windows)
REM This script creates a backup of the PostgreSQL database

echo ==========================================
echo Ahl Quran Database Backup
echo ==========================================

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

REM Create backup filename with timestamp
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set TIMESTAMP=%datetime:~0,8%_%datetime:~8,6%
set BACKUP_FILE=backupdata_%TIMESTAMP%.sql

echo Backup file: %BACKUP_FILE%
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

REM Create backup using pg_dump inside the Docker container
echo Creating backup...
docker-compose exec -T db pg_dump -U %POSTGRES_USER% -d %POSTGRES_DB% --clean --if-exists --create --encoding=UTF8 --no-owner --no-privileges > %BACKUP_FILE%

if errorlevel 1 (
    echo X Backup failed!
    exit /b 1
)

echo + Backup created successfully: %BACKUP_FILE%

REM Get file size
for %%A in (%BACKUP_FILE%) do set SIZE=%%~zA

REM Convert bytes to KB/MB
set /a SIZE_KB=%SIZE%/1024
if %SIZE_KB% GTR 1024 (
    set /a SIZE_MB=%SIZE_KB%/1024
    echo + Backup size: %SIZE_MB% MB
) else (
    echo + Backup size: %SIZE_KB% KB
)

REM Create a copy as backupdata.sql (latest backup)
copy /Y %BACKUP_FILE% backupdata.sql >nul
echo + Latest backup saved as: backupdata.sql

echo ==========================================
echo Backup completed successfully!
echo ==========================================
