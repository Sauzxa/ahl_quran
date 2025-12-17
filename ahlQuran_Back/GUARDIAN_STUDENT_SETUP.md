# Guardian-Student Relationship Setup

This guide explains how to set up the guardian-student relationship feature.

## What Changed

### Backend Changes

1. **Database Model** (`app/models/guardian.py`)
   - Added `student_id` field to link guardian to a student
   - Added `student` relationship for easy access

2. **API Schemas** (`app/schemas/guardian.py`)
   - Updated `GuardianCreate` to accept `student_id`
   - Updated `GuardianUpdate` to accept `student_id`
   - Updated `GuardianResponse` to return `student_id` and `student` info

3. **API Routes** (`app/api/v1/routes/guardian.py`)
   - Create guardian endpoint now accepts and stores `student_id`
   - Update guardian endpoint now accepts and updates `student_id`
   - Get guardian(s) endpoints now return student information

4. **Database Migration**
   - New migration file: `add_student_id_to_guardians.py`
   - Adds `student_id` column to `guardians` table
   - Creates foreign key constraint to `students` table
   - Adds index for better query performance

### Frontend Changes

1. **Guardian Form Model** (`guardian_form.dart`)
   - Added `studentId` field

2. **Guardian Dialog** (`guardian.dart`)
   - Added student dropdown with list of all students
   - Fetches students from API with proper UTF-8 encoding
   - Sends `student_id` when creating/updating guardian

3. **Guardian Management Screen** (`guardian_management_new.dart`)
   - Added "Student" column to guardians table
   - Displays student name for each guardian
   - Shows student info in guardian details dialog

## Setup Instructions

### Step 1: Run Database Migration

Since the application is dockerized, run the migration inside the Docker container:

**On Windows:**
```bash
cd ahlQuran_Back
run_migration.bat
```

**On Linux/Mac:**
```bash
cd ahlQuran_Back
chmod +x run_migration.sh
./run_migration.sh
```

**Or manually:**
```bash
docker-compose exec web alembic upgrade head
```

### Step 2: Restart Docker Containers

```bash
docker-compose restart
```

### Step 3: Verify the Setup

1. **Check Database:**
   ```bash
   docker-compose exec db psql -U Rahim -d ahl_quran_db -c "\d guardians"
   ```
   
   You should see the `student_id` column in the guardians table.

2. **Test API:**
   Create a guardian with a student:
   ```bash
   curl -X POST http://localhost:8000/api/v1/guardians/ \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     -d '{
       "guardian_info": {
         "first_name": "أحمد",
         "last_name": "محمد",
         "relationship": "أب",
         "phone_number": "0123456789",
         "email": "ahmad@example.com"
       },
       "account_info": {
         "username": "ahmad_guardian",
         "password": "password123"
       },
       "student_id": 1
     }'
   ```

3. **Test Frontend:**
   - Open the guardian management page
   - Click "Add Guardian"
   - You should see a student dropdown
   - Select a student and save
   - The student name should appear in the guardians table

## API Changes

### Create Guardian

**Endpoint:** `POST /api/v1/guardians/`

**Request Body:**
```json
{
  "guardian_info": {
    "first_name": "أحمد",
    "last_name": "محمد",
    "relationship": "أب",
    "date_of_birth": "1980-01-01",
    "phone_number": "0123456789",
    "email": "ahmad@example.com",
    "job": "مهندس",
    "address": "الرياض"
  },
  "account_info": {
    "username": "ahmad_guardian",
    "password": "password123"
  },
  "student_id": 1
}
```

**Response:**
```json
{
  "id": 1,
  "user_id": 10,
  "first_name": "أحمد",
  "last_name": "محمد",
  "relationship_to_student": "أب",
  "date_of_birth": "1980-01-01",
  "phone_number": "0123456789",
  "email": "ahmad@example.com",
  "job": "مهندس",
  "address": "الرياض",
  "username": "ahmad@example.com",
  "student_id": 1,
  "student": {
    "id": 1,
    "first_name_ar": "محمد",
    "last_name_ar": "أحمد"
  },
  "created_at": "2025-12-15T12:00:00Z"
}
```

### Update Guardian

**Endpoint:** `PUT /api/v1/guardians/{guardian_id}`

**Request Body:**
```json
{
  "guardian_info": {
    "first_name": "أحمد",
    "last_name": "محمد",
    "relationship": "أب"
  },
  "student_id": 2
}
```

### Get Guardians

**Endpoint:** `GET /api/v1/guardians/`

**Response:**
```json
{
  "guardians": [
    {
      "id": 1,
      "first_name": "أحمد",
      "last_name": "محمد",
      "student_id": 1,
      "student": {
        "id": 1,
        "first_name_ar": "محمد",
        "last_name_ar": "أحمد"
      },
      ...
    }
  ],
  "total": 1
}
```

## Troubleshooting

### Migration Fails

If the migration fails, check:

1. **Docker containers are running:**
   ```bash
   docker-compose ps
   ```

2. **Database is accessible:**
   ```bash
   docker-compose exec db psql -U Rahim -d ahl_quran_db -c "SELECT 1"
   ```

3. **Check migration history:**
   ```bash
   docker-compose exec web alembic current
   ```

4. **View migration logs:**
   ```bash
   docker-compose logs web
   ```

### Student Dropdown is Empty

If the student dropdown shows no students:

1. **Check if students exist:**
   ```bash
   docker-compose exec db psql -U Rahim -d ahl_quran_db -c "SELECT COUNT(*) FROM students"
   ```

2. **Check API response:**
   - Open browser DevTools (F12)
   - Go to Network tab
   - Create a guardian
   - Check the request to `/api/v1/students/`

3. **Check console for errors:**
   - Look for UTF-8 encoding errors
   - Look for authentication errors

### Student Not Saved

If the student selection doesn't save:

1. **Check browser console for errors**

2. **Check the API request:**
   - Open DevTools Network tab
   - Look at the POST request to `/api/v1/guardians/`
   - Verify `student_id` is in the request body

3. **Check backend logs:**
   ```bash
   docker-compose logs web | grep guardian
   ```

## Rollback

If you need to rollback the migration:

```bash
docker-compose exec web alembic downgrade -1
```

This will remove the `student_id` column from the guardians table.

## Notes

- The `student_id` field is **optional** - guardians can be created without a student
- When a student is deleted, the guardian's `student_id` is set to NULL (not deleted)
- Multiple guardians can be assigned to the same student
- The relationship is one-way: Guardian → Student (not bidirectional)
