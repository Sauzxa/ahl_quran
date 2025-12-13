from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List, Any
from datetime import date

class PersonalInfo(BaseModel):
    first_name_ar: str
    last_name_ar: str
    first_name_en: Optional[str] = None
    last_name_en: Optional[str] = None
    sex: Optional[str] = None
    date_of_birth: Optional[str] = None
    place_of_birth: Optional[str] = None
    home_address: Optional[str] = None
    nationality: Optional[str] = None
    father_status: Optional[str] = None
    mother_status: Optional[str] = None

class AccountInfo(BaseModel):
    username: str
    passcode: str
    account_type: Optional[str] = None

class ContactInfo(BaseModel):
    phone_number: Optional[str] = None
    email: Optional[EmailStr] = None

class GuardianInfo(BaseModel):
    guardian_id: Optional[int] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    relationship: Optional[str] = None
    guardian_contact_id: Optional[int] = None
    guardian_account_id: Optional[int] = None
    home_address: Optional[str] = None
    job: Optional[str] = None
    profile_image: Optional[str] = None

class LectureInfo(BaseModel):
    lecture_id: int
    lecture_name_ar: Optional[str] = None
    lecture_name_en: Optional[str] = None

class FormalEducationInfo(BaseModel):
    academic_level: Optional[str] = None
    grade: Optional[str] = None
    school_name: Optional[str] = None

class StudentCreateFull(BaseModel):
    personalInfo: PersonalInfo
    accountInfo: AccountInfo
    contactInfo: ContactInfo
    guardian: GuardianInfo
    lectures: List[LectureInfo] = []
    formalEducationInfo: FormalEducationInfo
