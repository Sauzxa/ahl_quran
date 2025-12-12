from pydantic import BaseModel, EmailStr, Field
from typing import Optional

class GuardianBase(BaseModel):
    name: str
    email: EmailStr

class GuardianCreate(GuardianBase):
    password: str

class GuardianUpdate(GuardianBase):
    name: Optional[str] = None
    email: Optional[EmailStr] = None

class GuardianInDB(GuardianBase):
    id: int
    hashed_password: str

class GuardianResponse(GuardianBase):
    id: int
    message: str

class GuardianListResponse(BaseModel):
    guardians: list[GuardianResponse]