#!/bin/bash

# Database Backup Script for Ahl Quran System
# This script creates a backup of the PostgreSQL database

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Set default values if not provided in .env
POSTGRES_USER=${POSTGRES_USER:-ahl_quran_user}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-ahl_quran_password}
POSTGRES_DB=${POSTGRES_DB:-ahl_quran_db}

# Create backup filename with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="backupdata_${TIMESTAMP}.sql"

echo "=========================================="
echo "Ahl Quran Database Backup"
echo "=========================================="
echo "Database: $POSTGRES_DB"
echo "User: $POSTGRES_USER"
echo "Backup file: $BACKUP_FILE"
echo "=========================================="

# Check if Docker container is running
if ! docker-compose ps | grep -q "db.*Up"; then
    echo "Error: Database container is not running!"
    echo "Please start the containers with: docker-compose up -d"
    exit 1
fi

# Create backup using pg_dump inside the Docker container
echo "Creating backup..."
docker-compose exec -T db pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
    --clean \
    --if-exists \
    --create \
    --encoding=UTF8 \
    --no-owner \
    --no-privileges > "$BACKUP_FILE"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "✓ Backup created successfully: $BACKUP_FILE"
    
    # Get file size
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "✓ Backup size: $SIZE"
    
    # Create a copy as backupdata.sql (latest backup)
    cp "$BACKUP_FILE" "backupdata.sql"
    echo "✓ Latest backup saved as: backupdata.sql"
    
    echo "=========================================="
    echo "Backup completed successfully!"
    echo "=========================================="
else
    echo "✗ Backup failed!"
    exit 1
fi
