from fastapi import APIRouter, Depends
from typing import List
from pydantic import BaseModel

lectureRouter = APIRouter()

class LectureResponse(BaseModel):
    lecture_id: int
    team_accomplishment_id: int | None = None
    lecture_name_ar: str
    lecture_name_en: str | None = None
    shown_on_website: int = 1
    circle_type: str | None = None

@lectureRouter.get("/", response_model=List[LectureResponse])
async def get_lectures():
    # Return mock data or empty list to satisfy frontend
    return [
        {
            "lecture_id": 1,
            "lecture_name_ar": "حلقة الشيخ جمال",
            "lecture_name_en": "Sheikh Jamal Circle",
            "circle_type": "Recitation"
        },
        {
            "lecture_id": 2,
            "lecture_name_ar": "حلقة الشيخ عبد الحميد",
            "lecture_name_en": "Sheikh Abdul Hamid Circle",
            "circle_type": "Memorization"
        }
    ]
