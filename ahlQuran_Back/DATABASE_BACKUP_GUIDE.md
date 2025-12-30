# Database Backup and Restore Guide

This guide explains how to backup and restore the Ahl Quran database.

## Prerequisites

- Docker and Docker Compose must be installed and running
- Database containers must be running (`docker-compose up -d`)

## Backup Database

### Windows

Run the backup script:

```cmd
backup_database.bat
```

This will create two files:
- `backupdata_YYYYMMDD_HHMMSS.sql` - Timestamped backup
- `backupdata.sql` - Latest backup (overwrites previous)

### Linux/Mac

Make the script executable first:

```bash
chmod +x backup_database.sh
```

Then run it:

```bash
./backup_database.sh
```

## Restore Database

### Windows

To restore from the latest backup:

```cmd
restore_database.bat
```

To restore from a specific backup file:

```cmd
restore_database.bat backupdata_20241228_143022.sql
```

### Linux/Mac

Make the script executable first:

```bash
chmod +x restore_database.sh
```

To restore from the latest backup:

```bash
./restore_database.sh
```

To restore from a specific backup file:

```bash
./restore_database.sh backupdata_20241228_143022.sql
```

## Manual Backup (Alternative Method)

If you prefer to backup manually using Docker commands:

```bash
# Backup
docker-compose exec -T db pg_dump -U ahl_quran_user -d ahl_quran_db > backupdata.sql

# Restore
docker-compose stop web
type backupdata.sql | docker-compose exec -T db psql -U ahl_quran_user -d postgres
docker-compose start web
```

## Backup File Contents

The backup file includes:
- All database tables and data
- Table structures and constraints
- Indexes and sequences
- User data (students, teachers, supervisors, etc.)
- Attendance records
- Achievement records
- Lecture information

## Important Notes

⚠️ **Warning**: Restoring a backup will **replace all current data** in the database!

✅ **Best Practices**:
- Create regular backups (daily or weekly)
- Keep multiple backup versions
- Test restore process periodically
- Store backups in a safe location (external drive, cloud storage)

## Backup Schedule Recommendation

- **Daily**: Automatic backup at end of day
- **Weekly**: Keep weekly backups for 1 month
- **Monthly**: Keep monthly backups for 1 year
- **Before Updates**: Always backup before system updates

## Troubleshooting

### Error: Database container is not running

**Solution**: Start the containers first:
```bash
docker-compose up -d
```

### Error: Docker is not running

**Solution**: Start Docker Desktop

### Error: Permission denied

**Solution** (Linux/Mac): Make scripts executable:
```bash
chmod +x backup_database.sh restore_database.sh
```

### Backup file is empty or very small

**Solution**: Check if database has data:
```bash
docker-compose exec db psql -U ahl_quran_user -d ahl_quran_db -c "\dt"
```

## Viewing Backup Files

To see all available backup files:

**Windows**:
```cmd
dir backupdata*.sql
```

**Linux/Mac**:
```bash
ls -lh backupdata*.sql
```

## Automated Backups

### Windows Task Scheduler

1. Open Task Scheduler
2. Create Basic Task
3. Set trigger (e.g., Daily at 11:00 PM)
4. Action: Start a program
5. Program: `C:\path\to\ahlQuran_Back\backup_database.bat`

### Linux/Mac Cron Job

Add to crontab (`crontab -e`):

```bash
# Daily backup at 11:00 PM
0 23 * * * cd /path/to/ahlQuran_Back && ./backup_database.sh
```

## Support

For issues or questions, contact the system administrator.
