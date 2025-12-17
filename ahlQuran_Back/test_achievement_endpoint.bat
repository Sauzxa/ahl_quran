@echo off
echo Testing Achievement Endpoint...
echo.
echo 1. Checking if backend is running...
curl -X GET http://localhost:8000/ 2>nul
if errorlevel 1 (
    echo ERROR: Backend is not running!
    echo Please start the backend with: docker-compose up -d
    pause
    exit /b 1
)
echo.
echo 2. Testing GET achievements endpoint...
curl -X GET http://localhost:8000/api/v1/students/3/achievements
echo.
echo.
echo 3. If you see "Not Found" or connection errors, you need to:
echo    - Run the migration: run_achievement_migration.bat
echo    - Restart backend: docker-compose restart web
echo.
pause
