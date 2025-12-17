@echo off
echo Running achievement type migration...
docker-compose exec web alembic upgrade head
echo Migration completed!
pause
