# Achievement Feature Implementation Guide

## Overview
This guide explains the new achievement tracking feature that allows tracking student memorization and review progress in the "Track and Memorize" page.

## Features Implemented

### 1. Backend Changes

#### Database Model Updates
- **File**: `app/models/acheivements.py`
- Added `achievement_type` field with enum values: `normal`, `small`, `big`
  - `normal`: Regular memorization (حفظ)
  - `small`: Small review (مراجعة صغرى)
  - `big`: Big review (مراجعة كبرى)

#### API Schema Updates
- **File**: `app/schemas/achievement.py`
- Added `AchievementType` enum
- Updated `AchievementBase`, `AchievementCreate`, and `AchievementUpdate` schemas to include `achievement_type`

#### API Endpoint Updates
- **File**: `app/api/v1/routes/student.py`
- Updated `list_students` endpoint to accept optional `lecture_id` query parameter for filtering students by lecture
- Updated achievement creation to include `achievement_type`

### 2. Frontend Changes

#### New Models
- **File**: `lib/system/new_models/achievement.dart`
- Created `Achievement` model with fields:
  - `id`, `studentId`, `fromSurah`, `toSurah`, `fromVerse`, `toVerse`
  - `note`, `achievementType`, `createdAt`, `updatedAt`

#### New Dialog Widget
- **File**: `lib/system/widgets/dialogs/achievement.dart`
- Created comprehensive achievement dialog with:
  - Three tabs: حفظ (Memorization), مراجعة صغرى (Small Review), مراجعة كبرى (Big Review)
  - CRUD operations for achievements
  - Surah and verse dropdowns using Quran data
  - Add, delete, and delete all functionality

#### Screen Updates
- **File**: `lib/system/screens/track_memorize_students_screen.dart`
- Updated to filter students by selected lecture
- Added achievement dialog trigger when clicking "الإنجاز" button
- Students now only show those registered in the selected lecture

## Database Migration

### Running the Migration

**Inside Docker:**
```bash
# Option 1: Use the provided batch file
run_achievement_migration.bat

# Option 2: Manual command
docker-compose exec web alembic upgrade head
```

**Direct (if not using Docker):**
```bash
cd ahlQuran_Back
alembic upgrade head
```

### Migration Details
- **File**: `alembic/versions/add_achievement_type_field.py`
- Adds `achievement_type` column to `achievements` table
- Creates PostgreSQL ENUM type for achievement types
- Sets default value to 'normal'

## Usage Flow

1. **Navigate to Track and Memorize Page**
   - Select a lecture from the dropdown
   - Select a date
   - Click submit

2. **View Students**
   - Only students registered in the selected lecture will appear
   - Each student row has an "الإنجاز" (Achievement) button

3. **Manage Achievements**
   - Click "الإنجاز" button for a student
   - Dialog opens with three tabs:
     - **حفظ** (Memorization): Track new memorization
     - **مراجعة صغرى** (Small Review): Track small review sessions
     - **مراجعة كبرى** (Big Review): Track large review sessions

4. **Add Achievement**
   - Click "إضافة" (Add) button in any tab
   - Select starting surah and verse
   - Select ending surah and verse
   - Add optional note
   - Click "حفظ" (Save)

5. **Delete Achievement**
   - Click delete icon on any achievement card
   - Confirm deletion

6. **Delete All Achievements**
   - Click "حذف البيانات" (Delete Data) button
   - Confirms and deletes all achievements of that type for the student

## API Endpoints

### Get Students by Lecture
```
GET /api/v1/students/?lecture_id={lecture_id}
```

### Get Student Achievements
```
GET /api/v1/students/{student_id}/achievements
```

### Create Achievement
```
POST /api/v1/students/{student_id}/achievements
Body: {
  "student_id": 1,
  "from_surah": "سُورَةُ البَقَرَةِ",
  "to_surah": "سُورَةُ البَقَرَةِ",
  "from_verse": 1,
  "to_verse": 10,
  "note": "Good memorization",
  "achievement_type": "normal"
}
```

### Delete Achievement
```
DELETE /api/v1/students/{student_id}/achievements/{achievement_id}
```

## Data Structure

### Achievement Types
- `normal`: Regular memorization (حفظ)
- `small`: Small review (مراجعة صغرى)
- `big`: Big review (مراجعة كبرى)

### Quran Data
- All 114 surahs with Arabic names and verse counts
- Helper functions in `lib/data/quran_data.dart`:
  - `getSurahByNumber(int number)`
  - `getSurahByName(String name)`
  - `getMeccanSurahs()`
  - `getMedinanSurahs()`

## Testing Checklist

- [ ] Run database migration successfully
- [ ] Restart backend server
- [ ] Select lecture and date in Track and Memorize page
- [ ] Verify only students from selected lecture appear
- [ ] Click achievement button for a student
- [ ] Add achievement in each tab (حفظ, مراجعة صغرى, مراجعة كبرى)
- [ ] Verify achievements are saved and displayed correctly
- [ ] Delete individual achievement
- [ ] Delete all achievements in a tab
- [ ] Verify data persists after page reload

## Troubleshooting

### Migration Issues
If migration fails:
1. Check if Docker container is running: `docker ps`
2. Check database connection
3. Review migration logs: `docker-compose logs web`

### Frontend Issues
If dialog doesn't open:
1. Check browser console for errors
2. Verify student has valid `personalInfo.studentId`
3. Check API endpoint connectivity

### Backend Issues
If API returns errors:
1. Check backend logs: `docker-compose logs web`
2. Verify database has `achievement_type` column
3. Check enum type exists in PostgreSQL

## Notes
- Achievement type defaults to 'normal' if not specified
- All achievements are linked to a specific student
- Deleting a student cascades to delete all their achievements
- Surah names are stored in Arabic for consistency
