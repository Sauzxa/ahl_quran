from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional


class AchievementBase(BaseModel):
    from_surah: str = Field(..., min_length=1, max_length=50, example="Al-Baqarah")
    to_surah: str = Field(..., min_length=1, max_length=50, example="Al-Baqarah")
    from_verse: int = Field(..., gt=0, example=1)
    to_verse: int = Field(..., gt=0, example=10)
    note: Optional[str] = Field(None, example="Good memorization")


class AchievementCreate(AchievementBase):
    student_id: int = Field(..., gt=0, example=1)


class AchievementUpdate(BaseModel):
    from_surah: Optional[str] = Field(None, min_length=1, max_length=50)
    to_surah: Optional[str] = Field(None, min_length=1, max_length=50)
    from_verse: Optional[int] = Field(None, gt=0)
    to_verse: Optional[int] = Field(None, gt=0)
    note: Optional[str] = None


class AchievementResponse(AchievementBase):
    id: int
    student_id: int
    created_at: datetime
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True


class AchievementList(BaseModel):
    achievements: list[AchievementResponse]
    total: int

