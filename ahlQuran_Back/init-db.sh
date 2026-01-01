#!/bin/bash
set -e

echo "🔍 Checking if database initialization is needed..."

# Check if we should load sample data
if [ "$LOAD_SAMPLE_DATA" = "true" ]; then
    echo "📦 LOAD_SAMPLE_DATA is enabled"
    
    # Wait a bit for migrations to complete
    sleep 5
    
    # Check if backup file exists
    if [ -f "/app/database_backup.sql" ]; then
        echo "📥 Found database backup file, restoring sample data..."
        
        # Use psql to restore the backup
        PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f /app/database_backup.sql
        
        echo "✅ Sample data loaded successfully!"
    else
        echo "⚠️  No backup file found at /app/database_backup.sql"
        echo "   Skipping sample data load."
    fi
else
    echo "ℹ️  LOAD_SAMPLE_DATA not enabled, skipping sample data load"
    echo "   Set LOAD_SAMPLE_DATA=true in docker-compose.yml to enable"
fi

echo "🚀 Starting application..."
exec "$@"
