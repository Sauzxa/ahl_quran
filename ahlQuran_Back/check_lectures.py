import asyncio
from app.db.session import get_db
from app.models.lecture import Lecture
from sqlalchemy import select

async def check():
    async for db in get_db():
        result = await db.execute(select(Lecture))
        lectures = result.scalars().all()
        
        if lectures:
            print(f'Found {len(lectures)} lectures:')
            for lecture in lectures:
                print(f'  - ID: {lecture.id}, AR: {lecture.lecture_name_ar}, EN: {lecture.lecture_name_en}')
        else:
            print('No lectures found')
        break

asyncio.run(check())
