# Achievement Feature - Setup Steps

## Quick Setup Guide

### Step 1: Run Database Migration (Inside Docker)

```bash
# Navigate to backend directory
cd ahlQuran_Back

# Run the migration script
run_achievement_migration.bat

# OR manually:
docker-compose exec web alembic upgrade head
```

### Step 2: Restart Backend Server

```bash
# Restart the Docker container
docker-compose restart web

# OR stop and start:
docker-compose down
docker-compose up -d
```

### Step 3: Test the Feature

1. Open the application in your browser
2. Navigate to "متابعة الحفظ والمراجعة" (Track and Memorize)
3. Select a lecture from the dropdown
4. Select a date
5. Click the submit button
6. You should see only students registered in that lecture
7. Click the "الإنجاز" button for any student
8. The achievement dialog should open with three tabs

### Step 4: Add Test Data

1. In the achievement dialog, click "إضافة" (Add)
2. Select:
   - From Surah: سُورَةُ البَقَرَةِ (Al-Baqara)
   - From Verse: 1
   - To Surah: سُورَةُ البَقَرَةِ (Al-Baqara)
   - To Verse: 10
   - Note: "Test achievement"
3. Click "حفظ" (Save)
4. Verify the achievement appears in the list

## Files Modified/Created

### Backend Files
- ✅ `ahlQuran_Back/app/models/acheivements.py` - Added achievement_type field
- ✅ `ahlQuran_Back/app/schemas/achievement.py` - Added achievement_type to schemas
- ✅ `ahlQuran_Back/app/api/v1/routes/student.py` - Added lecture filtering and achievement_type
- ✅ `ahlQuran_Back/alembic/versions/add_achievement_type_field.py` - Migration file
- ✅ `ahlQuran_Back/run_achievement_migration.bat` - Helper script

### Frontend Files
- ✅ `ahlQuran_Front/lib/system/new_models/achievement.dart` - Achievement model
- ✅ `ahlQuran_Front/lib/system/widgets/dialogs/achievement.dart` - Achievement dialog
- ✅ `ahlQuran_Front/lib/system/screens/track_memorize_students_screen.dart` - Updated to show dialog

### Documentation
- ✅ `ahlQuran_Back/ACHIEVEMENT_FEATURE_GUIDE.md` - Complete feature guide
- ✅ `ACHIEVEMENT_SETUP_STEPS.md` - This file

## Verification Checklist

- [ ] Database migration completed successfully
- [ ] Backend server restarted
- [ ] Frontend can connect to backend
- [ ] Students are filtered by lecture
- [ ] Achievement dialog opens when clicking "الإنجاز"
- [ ] Can add achievement in "حفظ" tab
- [ ] Can add achievement in "مراجعة صغرى" tab
- [ ] Can add achievement in "مراجعة كبرى" tab
- [ ] Can delete individual achievement
- [ ] Can delete all achievements in a tab
- [ ] Achievements persist after page reload

## Common Issues and Solutions

### Issue: Migration fails with "relation already exists"
**Solution**: The migration might have already run. Check with:
```bash
docker-compose exec web alembic current
```

### Issue: Achievement dialog doesn't open
**Solution**: 
1. Check browser console for errors
2. Verify student data has `personalInfo.studentId`
3. Check network tab for API errors

### Issue: No students appear after selecting lecture
**Solution**:
1. Verify students are registered in that lecture
2. Check backend logs: `docker-compose logs web`
3. Test API directly: `GET /api/v1/students/?lecture_id=1`

### Issue: Enum type error in database
**Solution**:
```bash
# Connect to database
docker-compose exec db psql -U postgres -d ahlquran_db

# Check if enum exists
\dT+ achievementtype

# If not, run migration again
docker-compose exec web alembic upgrade head
```

## Next Steps

After successful setup, you can:
1. Add more achievements for different students
2. Test the three different achievement types
3. Verify data integrity across page reloads
4. Test with multiple lectures and dates

## Support

For issues or questions, refer to:
- `ahlQuran_Back/ACHIEVEMENT_FEATURE_GUIDE.md` - Detailed feature documentation
- Backend logs: `docker-compose logs web`
- Database logs: `docker-compose logs db`
