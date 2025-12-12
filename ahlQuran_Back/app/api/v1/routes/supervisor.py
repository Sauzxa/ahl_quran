from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.session import get_db
from app.models.student import Student
from app.models.user import User, UserRoleEnum
from app.models.supervisor import Supervisor
from app.schemas.supervisor import SupervisorCreate, SupervisorResponse
from app.core.dependencies import require_president_or_supervisor

supervisorRouter = APIRouter()

@supervisorRouter.post("/add_teacher")
async def add_teacher(
    teacher_data,
    db: AsyncSession = Depends(get_db),
    current_supervisor: Supervisor = Depends(require_president_or_supervisor)
):
    new_teacher = User(
        firstname=teacher_data.firstname,
        lastname=teacher_data.lastname,
        email=teacher_data.email,
        hashed_password=teacher_data.passwor,
        role=UserRoleEnum.TEACHER
    )
    
    db.add(new_teacher)
    await db.commit()
    await db.refresh(new_teacher)
    
    return {
        "message": "Teacher added successfully",
        "teacher": new_teacher
    }

@supervisorRouter.post("/add_student", response_model=SupervisorResponse)
async def add_student(
    student_data: SupervisorCreate,
    db: AsyncSession = Depends(get_db),
    current_supervisor: Supervisor = Depends(require_president_or_supervisor)
):
    new_student = Student(
        name=student_data.name,
        email=student_data.email,
        hashed_password=student_data.password  # Assume password is hashed in the schema
    )
    
    db.add(new_student)
    await db.commit()
    await db.refresh(new_student)
    
    return {
        "message": "Student added successfully",
        "student": new_student
    }