@echo off
echo Testing POST achievement endpoint...
echo.
curl -X POST http://localhost:8000/api/v1/students/3/achievements ^
  -H "Content-Type: application/json" ^
  -d "{\"student_id\": 3, \"from_surah\": 1, \"to_surah\": 2, \"from_verse\": 1, \"to_verse\": 3, \"note\": \"test\", \"achievement_type\": \"normal\"}"
echo.
echo.
echo Check the response above. If you see an error, check backend logs:
echo docker-compose logs web --tail=50
echo.
pause
