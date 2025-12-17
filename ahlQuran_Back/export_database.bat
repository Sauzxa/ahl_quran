@echo off
echo ========================================
echo Database Export Script
echo ========================================
echo.

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

REM Create backup filename with timestamp
set TIMESTAMP=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set BACKUP_FILE=backup_%TIMESTAMP%.sql

echo Exporting database to: %BACKUP_FILE%
docker exec %CONTAINER_NAME% pg_dump -U Rahim ahl_quran_db > %BACKUP_FILE%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo SUCCESS! Database exported to:
    echo %BACKUP_FILE%
    echo ========================================
    echo.
    echo You can now send this file to your friend.
) else (
    echo.
    echo ERROR: Export failed!
)

pause
