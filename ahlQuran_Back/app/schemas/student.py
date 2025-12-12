from pydantic import BaseModel, EmailStr, Field
from datetime import datetime
from typing import Optional


class StudentBase(BaseModel):
    firstname: str = Field(..., min_length=1, max_length=50, example="John")
    lastname: str = Field(..., min_length=1, max_length=50, example="Doe")
    email: EmailStr = Field(..., example="john.doe@example.com")
    parent_name: Optional[str] = Field(None, max_length=255, example="Jane Doe")
    parent_phone: Optional[str] = Field(None, max_length=20, example="+1234567890")
    guardian_email: Optional[EmailStr] = Field(None, example="guardian@example.com")
    golden: Optional[bool] = Field(False, example=False)


class StudentCreate(StudentBase):
    password: str = Field(..., min_length=6, example="securepassword")


class StudentUpdate(BaseModel):
    firstname: Optional[str] = Field(None, min_length=1, max_length=50)
    lastname: Optional[str] = Field(None, min_length=1, max_length=50)
    email: Optional[EmailStr] = None
    parent_name: Optional[str] = Field(None, max_length=255)
    parent_phone: Optional[str] = Field(None, max_length=20)
    guardian_email: Optional[EmailStr] = None
    golden: Optional[bool] = None


class StudentResponse(BaseModel):
    id: int
    user_id: int
    firstname: str
    lastname: str
    email: str
    enrollment_date: datetime
    parent_name: Optional[str]
    parent_phone: Optional[str]
    guardian_email: Optional[str]
    golden: bool
    is_active: bool

    class Config:
        from_attributes = True


class StudentList(BaseModel):
    students: list[StudentResponse]
    total: int
