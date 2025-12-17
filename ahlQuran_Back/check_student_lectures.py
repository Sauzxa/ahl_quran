import asyncio
from app.db.session import get_db
from app.models.student import Student
from app.models.sessionParticipation import SessionParticipation
from sqlalchemy import select
from sqlalchemy.orm import selectinload

async def check():
    async for db in get_db():
        result = await db.execute(
            select(Student)
            .options(
                selectinload(Student.user),
                selectinload(Student.participations).selectinload(SessionParticipation.lecture)
            )
            .limit(3)
        )
        students = result.scalars().all()
        
        if students:
            for student in students:
                print(f'\nStudent ID: {student.id}, Name: {student.user.firstname} {student.user.lastname}')
                print(f'Participations: {len(student.participations)}')
                for p in student.participations:
                    print(f'  - Participation ID: {p.id}')
                    print(f'    Session ID: {p.session_id}')
                    print(f'    Lecture ID: {p.lecture_id}')
                    if p.lecture:
                        print(f'    Lecture: {p.lecture.lecture_name_ar} ({p.lecture.lecture_name_en})')
                    else:
                        print(f'    Lecture: None')
        else:
            print('No students found')
        break

asyncio.run(check())
