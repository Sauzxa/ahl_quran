@echo off
echo ========================================
echo Database Import Script
echo ========================================
echo.

REM Check if backup file is provided
if "%~1"=="" (
    echo ERROR: Please provide the backup file!
    echo Usage: import_database.bat backup.sql
    echo.
    echo Or drag and drop the .sql file onto this script.
    pause
    exit /b 1
)

set BACKUP_FILE=%~1

if not exist "%BACKUP_FILE%" (
    echo ERROR: File not found: %BACKUP_FILE%
    pause
    exit /b 1
)

REM Find the container name
echo Finding PostgreSQL container...
for /f "tokens=*" %%i in ('docker ps --filter "ancestor=postgres:15-alpine" --format "{{.Names}}"') do set CONTAINER_NAME=%%i

if "%CONTAINER_NAME%"=="" (
    echo ERROR: PostgreSQL container not found!
    echo Make sure docker-compose is running: docker-compose up -d
    pause
    exit /b 1
)

echo Found container: %CONTAINER_NAME%
echo.

echo WARNING: This will replace your current database!
echo Press Ctrl+C to cancel, or
pause

echo.
echo Importing database from: %BACKUP_FILE%
docker exec -i %CONTAINER_NAME% psql -U Rahim ahl_quran_db < "%BACKUP_FILE%"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo SUCCESS! Database imported successfully!
    echo ========================================
) else (
    echo.
    echo ERROR: Import failed!
    echo Check if the backup file is valid.
)

pause
