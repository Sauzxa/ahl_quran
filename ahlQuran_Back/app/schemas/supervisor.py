from pydantic import BaseModel, EmailStr, Field

class SupervisorBase(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=6)

class SupervisorCreate(SupervisorBase):
    firstname: str
    lastname: str
    email: EmailStr
    password: str

class SupervisorInDB(SupervisorBase):
    id: int
    is_active: bool = True

    class Config:
        orm_mode = True

class SupervisorResponse(BaseModel):
    pass


class SupervisorApproval(BaseModel):
    supervisor_id: int
    approved: bool

class SupervisorList(BaseModel):
    supervisors: list[SupervisorInDB]