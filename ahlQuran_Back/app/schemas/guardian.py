from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime


class GuardianInfo(BaseModel):
    """Guardian information schema"""
    first_name: str
    last_name: str
    relationship: str  # Required: relationship to student
    date_of_birth: Optional[str] = None
    phone_number: Optional[str] = None
    email: Optional[str] = None
    job: Optional[str] = None
    address: Optional[str] = None


class AccountInfo(BaseModel):
    """Account information for guardian"""
    username: str
    password: str


class GuardianCreate(BaseModel):
    """Schema for creating a guardian"""
    guardian_info: GuardianInfo
    account_info: AccountInfo
    student_id: Optional[int] = None


class GuardianUpdate(BaseModel):
    """Schema for updating a guardian"""
    guardian_info: Optional[GuardianInfo] = None
    account_info: Optional[dict] = None
    student_id: Optional[int] = None


class GuardianResponse(BaseModel):
    """Response schema for guardian"""
    id: int
    user_id: int
    first_name: str
    last_name: str
    relationship_to_student: str
    date_of_birth: Optional[str] = None
    phone_number: Optional[str] = None
    email: Optional[str] = None
    job: Optional[str] = None
    address: Optional[str] = None
    username: str
    student_id: Optional[int] = None
    student: Optional[dict] = None  # Will contain student info if available
    created_at: datetime
    
    class Config:
        from_attributes = True


class GuardianListResponse(BaseModel):
    """Response schema for list of guardians"""
    guardians: list[GuardianResponse]
    total: int