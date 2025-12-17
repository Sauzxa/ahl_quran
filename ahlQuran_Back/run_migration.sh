#!/bin/bash
# Script to run Alembic migrations in Docker container

echo "Running database migrations..."
docker-compose exec web alembic upgrade head

if [ $? -eq 0 ]; then
    echo "✅ Migrations completed successfully!"
else
    echo "❌ Migration failed!"
    exit 1
fi
