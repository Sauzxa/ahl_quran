#!/bin/bash

# Database Restore Script for Ahl Quran System
# This script restores the PostgreSQL database from a backup file

# Check if backup file is provided as argument
if [ -z "$1" ]; then
    BACKUP_FILE="backupdata.sql"
    echo "No backup file specified, using default: backupdata.sql"
else
    BACKUP_FILE="$1"
    echo "Using backup file: $BACKUP_FILE"
fi

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file '$BACKUP_FILE' not found!"
    echo ""
    echo "Available backup files:"
    ls -lh backupdata*.sql 2>/dev/null || echo "No backup files found"
    echo ""
    echo "Usage: ./restore_database.sh [backup_file.sql]"
    exit 1
fi

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Set default values if not provided in .env
POSTGRES_USER=${POSTGRES_USER:-ahl_quran_user}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-ahl_quran_password}
POSTGRES_DB=${POSTGRES_DB:-ahl_quran_db}

echo "=========================================="
echo "Ahl Quran Database Restore"
echo "=========================================="
echo "Database: $POSTGRES_DB"
echo "User: $POSTGRES_USER"
echo "=========================================="

# Check if Docker container is running
if ! docker-compose ps | grep -q "db.*Up"; then
    echo "Error: Database container is not running!"
    echo "Please start the containers with: docker-compose up -d"
    exit 1
fi

echo ""
echo "WARNING: This will replace all data in the database!"
echo "Press Ctrl+C to cancel, or press Enter to continue..."
read

# Stop the web container to prevent connections during restore
echo "Stopping web container..."
docker-compose stop web

# Restore database using psql inside the Docker container
echo "Restoring database from $BACKUP_FILE..."
cat "$BACKUP_FILE" | docker-compose exec -T db psql -U "$POSTGRES_USER" -d postgres

# Check if restore was successful
if [ $? -eq 0 ]; then
    echo "✓ Database restored successfully!"
    
    # Start the web container again
    echo "Starting web container..."
    docker-compose start web
    
    echo "=========================================="
    echo "Restore completed successfully!"
    echo "=========================================="
else
    echo "✗ Restore failed!"
    
    # Start the web container again
    echo "Starting web container..."
    docker-compose start web
    
    exit 1
fi
