from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class TeacherAttendanceBase(BaseModel):
    teacher_id: int
    date: str = Field(..., description="Date in DD-MM-YYYY format")
    status: str = Field(..., description="Attendance status: present, late, absent, excused")
    notes: Optional[str] = None


class TeacherAttendanceCreate(TeacherAttendanceBase):
    pass


class TeacherAttendanceUpdate(BaseModel):
    date: Optional[str] = None
    status: Optional[str] = None
    notes: Optional[str] = None


class TeacherAttendanceResponse(TeacherAttendanceBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class TeacherAttendanceList(BaseModel):
    attendances: list[TeacherAttendanceResponse]
    total: int
