@echo off
echo Fixing migration heads and upgrading database...
echo.
echo Step 1: Checking current migration status...
docker-compose exec web alembic current
echo.
echo Step 2: Showing all heads...
docker-compose exec web alembic heads
echo.
echo Step 3: Upgrading to latest (this will merge heads)...
docker-compose exec web alembic upgrade heads
echo.
echo Step 4: Verifying final state...
docker-compose exec web alembic current
echo.
echo Migration complete!
echo.
echo Now restart the backend:
echo docker-compose restart web
echo.
pause
