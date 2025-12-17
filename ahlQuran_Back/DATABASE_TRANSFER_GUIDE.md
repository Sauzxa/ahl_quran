# 📦 Database Transfer Guide

This guide explains how to export and import database data between different instances of the Ahl Quran project.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Method 1: Using Automated Scripts (Recommended)](#method-1-using-automated-scripts-recommended)
- [Method 2: Manual Commands](#method-2-manual-commands)
- [Viewing Database Contents](#viewing-database-contents)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

**Database Transfer** allows you to:
- Share data between team members
- Backup your database
- Migrate data between environments
- Clone production data for testing

**What gets transferred:**
- ✅ All users (admins, presidents, supervisors, teachers, students)
- ✅ All presidents with school information
- ✅ All supervisors and their relationships
- ✅ All teachers with their riwaya
- ✅ All students with parent information
- ✅ All lectures and sessions
- ✅ All relationships and foreign keys

---

## ⚙️ Prerequisites

Before starting, ensure:

1. **Docker is running** on both machines
2. **Docker containers are up**:
   ```bash
   docker-compose up -d
   ```
3. **Database is accessible** (check with `docker ps`)

---

## 🚀 Method 1: Using Automated Scripts (Recommended)

We provide two Windows batch scripts that handle everything automatically.

### 📤 Exporting Database (Sender)

**Step 1:** Make sure Docker is running
```bash
docker-compose up -d
```

**Step 2:** Run the export script
- Double-click `export_database.bat`
- Or run from command line:
  ```bash
  export_database.bat
  ```

**Step 3:** Find the generated file
- The script creates a file like: `backup_20251214_143022.sql`
- Located in the `ahlQuran_Back` folder

**Step 4:** Send the file
- Share via email, Google Drive, USB, or any file transfer method

---

### 📥 Importing Database (Receiver)

**Step 1:** Receive the backup file
- Place the `.sql` file in the `ahlQuran_Back` folder

**Step 2:** Make sure Docker is running
```bash
docker-compose up -d
```

**Step 3:** Run the import script
- **Option A:** Drag and drop the `.sql` file onto `import_database.bat`
- **Option B:** Run from command line:
  ```bash
  import_database.bat backup.sql
  ```

**Step 4:** Confirm the import
- The script will warn you that it will replace your current database
- Press any key to continue, or Ctrl+C to cancel

**Done!** Your database now has all the data from the backup file.

---

## 🛠️ Method 2: Manual Commands

If you prefer manual control or the scripts don't work:

### 📤 Exporting (Manual)

```bash
# Find your container name
docker ps

# Export the database
docker exec <container_name> pg_dump -U Rahim ahl_quran_db > backup.sql
```

Example:
```bash
docker exec ahlquran_back-db-1 pg_dump -U Rahim ahl_quran_db > backup.sql
```

---

### 📥 Importing (Manual)

**Option A: Clean Import (Recommended)**

This completely replaces your database:

```bash
# Stop the web container
docker-compose stop web

# Drop the old database
docker exec ahlquran_back-db-1 psql -U Rahim -d postgres -c "DROP DATABASE ahl_quran_db;"

# Create a fresh database
docker exec ahlquran_back-db-1 psql -U Rahim -d postgres -c "CREATE DATABASE ahl_quran_db;"

# Import the backup
docker exec -i ahlquran_back-db-1 psql -U Rahim ahl_quran_db < backup.sql

# Restart the web container
docker-compose start web
```

**Option B: Merge Import (Advanced)**

This attempts to merge data (may cause conflicts):

```bash
docker exec -i ahlquran_back-db-1 psql -U Rahim ahl_quran_db < backup.sql
```

⚠️ **Warning:** Merging may fail if there are duplicate IDs or emails.

---

## 👀 Viewing Database Contents

After importing, you can view what's in your database:

### Using the Python Script

```bash
cd ahlQuran_Back
python show_users.py
```

This displays:
- All presidents with their status (approved/pending)
- All supervisors with who created them
- Total counts

### Example Output

```
================================================================================
📋 PRESIDENTS (المشرفون العامون)
================================================================================

+------+-------------+-------------------+---------------+---------+------------+------------+
|   ID | Name        | Email             | School        | Phone   | Status     | Created    |
+======+=============+===================+===============+=========+============+============+
|    1 | raouf fer   | raoufer@gmail.com | سلمان الفارسي | N/A     | ✅ Approved | 2025-12-12 |
+------+-------------+-------------------+---------------+---------+------------+------------+

Total Presidents: 1

================================================================================
📋 SUPERVISORS (المشرفون)
================================================================================

+------+--------------+-----------------+----------+--------------+------------+
|   ID | Name         | Email           | Status   | Created By   | Created    |
+======+==============+=================+==========+==============+============+
|    2 | amine youcef | amine@gmail.com | ✅ Active | raouf fer    | 2025-12-12 |
+------+--------------+-----------------+----------+--------------+------------+

Total Supervisors: 1
```

---

## 🔧 Troubleshooting

### Problem: "Container not found"

**Solution:**
```bash
# Check if containers are running
docker ps

# If not running, start them
docker-compose up -d
```

---

### Problem: "Database is being accessed by other users"

**Solution:**
```bash
# Stop the web container first
docker-compose stop web

# Then try the import again
docker exec -i ahlquran_back-db-1 psql -U Rahim ahl_quran_db < backup.sql

# Restart web container
docker-compose start web
```

---

### Problem: "Duplicate key errors" during import

**Cause:** You're trying to merge data with existing IDs

**Solution:** Use the clean import method (drop and recreate database)

---

### Problem: "Module 'asyncpg' not found" when running show_users.py

**Solution:**
```bash
pip install asyncpg tabulate
```

---

### Problem: Export file is empty or very small

**Possible causes:**
- Database is empty
- Wrong database name
- Container not running

**Solution:**
```bash
# Check if database has data
docker exec ahlquran_back-db-1 psql -U Rahim ahl_quran_db -c "SELECT COUNT(*) FROM users;"
```

---

## 📊 Understanding the Backup File

The `.sql` file contains:
- SQL commands to create all tables
- SQL commands to insert all data
- SQL commands to set up relationships
- Sequence resets for auto-increment IDs

**File size indicators:**
- Empty database: ~5-10 KB
- Small dataset (10-50 users): ~20-50 KB
- Medium dataset (100-500 users): ~100-500 KB
- Large dataset (1000+ users): 1+ MB

---

## 🔐 Security Notes

⚠️ **Important:**
- Backup files contain **all user data** including hashed passwords
- **Do not share** backup files publicly
- **Do not commit** backup files to Git (they're in `.gitignore`)
- Use secure channels (encrypted email, private cloud storage) for transfers

---

## 📝 Best Practices

1. **Regular Backups:** Export your database weekly
2. **Naming Convention:** Use timestamps in backup filenames
3. **Test Imports:** Test on a development environment first
4. **Document Changes:** Keep notes of what data was imported and when
5. **Verify After Import:** Always run `show_users.py` to verify the import

---

## 🆘 Need Help?

If you encounter issues:

1. Check the [Troubleshooting](#troubleshooting) section
2. Verify Docker containers are running: `docker ps`
3. Check Docker logs: `docker-compose logs`
4. Ensure database credentials match in `.env` file

---

## 📚 Related Files

- `export_database.bat` - Automated export script
- `import_database.bat` - Automated import script
- `show_users.py` - View database contents
- `.env` - Database credentials
- `docker-compose.yml` - Docker configuration

---

**Last Updated:** December 14, 2025
