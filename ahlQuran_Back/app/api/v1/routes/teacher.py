from fastapi import APIRouter, HTTPException, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from app.db.session import get_db
from app.models.user import User, UserRoleEnum
from app.models.teacher import Teacher
from app.schemas.teacher import TeacherCreate, TeacherUpdate, TeacherResponse, TeacherList
from app.core.dependencies import require_president_or_supervisor
from app.core.security import get_password_hash
import logging

logger = logging.getLogger(__name__)

teacherRouter = APIRouter()


@teacherRouter.post("/", response_model=TeacherResponse, status_code=status.HTTP_201_CREATED)
async def create_teacher(
    teacher_data: TeacherCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Create a new teacher. Only presidents and supervisors can create teachers."""
    logger.debug(f"teacher data :  {teacher_data} \n current user: {current_user}")

    # Check if email already exists
    result = await db.execute(
        select(User).where(User.email == teacher_data.email)
    )
    existing_user = result.scalar_one_or_none()

    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )

    # Create user record with TEACHER role
    new_user = User(
        firstname=teacher_data.firstname,
        lastname=teacher_data.lastname,
        email=teacher_data.email,
        hashed_password=teacher_data.password,
        role=UserRoleEnum.TEACHER,
        is_active=True
    )

    db.add(new_user)
    await db.flush()  # Flush to get the user ID

    # Create teacher record with teacher-specific fields
    new_teacher = Teacher(
        user_id=new_user.id,
        riwaya=teacher_data.riwaya,
        created_by_id=current_user.id
    )

    db.add(new_teacher)
    await db.commit()
    await db.refresh(new_teacher)
    await db.refresh(new_user)

    logger.info(f"Teacher created: {new_teacher.id} by user {current_user.id}")

    return TeacherResponse(
        id=new_teacher.id,
        user_id=new_user.id,
        firstname=new_user.firstname,
        lastname=new_user.lastname,
        email=new_user.email,
        riwaya=new_teacher.riwaya,
        hire_date=new_teacher.hire_date,
        is_active=new_user.is_active
    )


@teacherRouter.get("/{teacher_id}", response_model=TeacherResponse)
async def get_teacher(
    teacher_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Get a specific teacher by ID."""

    result = await db.execute(
        select(Teacher)
        .options(selectinload(Teacher.user))
        .where(Teacher.id == teacher_id)
    )
    teacher = result.scalar_one_or_none()
    
    if not teacher:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Teacher with ID {teacher_id} not found"
        )

    return TeacherResponse(
        id=teacher.id,
        user_id=teacher.user.id,
        firstname=teacher.user.firstname,
        lastname=teacher.user.lastname,
        email=teacher.user.email,
        riwaya=teacher.riwaya,
        hire_date=teacher.hire_date,
        is_active=teacher.user.is_active
    )


@teacherRouter.get("/", response_model=TeacherList)
async def list_teachers(
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Get all teachers. Only presidents and supervisors can view all teachers."""

    result = await db.execute(
        select(Teacher)
        .options(selectinload(Teacher.user))
        .offset(skip)
        .limit(limit)
    )
    teachers = result.scalars().all()

    # Get total count
    count_result = await db.execute(select(Teacher))
    total = len(count_result.scalars().all())

    teacher_responses = [
        TeacherResponse(
            id=teacher.id,
            user_id=teacher.user.id,
            firstname=teacher.user.firstname,
            lastname=teacher.user.lastname,
            email=teacher.user.email,
            riwaya=teacher.riwaya,
            hire_date=teacher.hire_date,
            is_active=teacher.user.is_active
        )
        for teacher in teachers
    ]

    return TeacherList(teachers=teacher_responses, total=total)


@teacherRouter.put("/{teacher_id}", response_model=TeacherResponse)
async def update_teacher(
    teacher_id: int,
    teacher_data: TeacherUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Update teacher information. Only presidents and supervisors can update teachers."""

    result = await db.execute(
        select(Teacher)
        .options(selectinload(Teacher.user))
        .where(Teacher.id == teacher_id)
    )
    teacher = result.scalar_one_or_none()
    
    if not teacher:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Teacher with ID {teacher_id} not found"
        )

    # Update user fields
    update_data = teacher_data.model_dump(exclude_unset=True)

    if "firstname" in update_data:
        teacher.user.firstname = update_data["firstname"]
    if "lastname" in update_data:
        teacher.user.lastname = update_data["lastname"]
    if "email" in update_data:
        # Check if new email is already taken
        email_result = await db.execute(
            select(User).where(User.email == update_data["email"], User.id != teacher.user.id)
        )
        if email_result.scalar_one_or_none():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )
        teacher.user.email = update_data["email"]

    # Update teacher-specific fields
    if "riwaya" in update_data:
        teacher.riwaya = update_data["riwaya"]

    await db.commit()
    await db.refresh(teacher)
    await db.refresh(teacher.user)

    logger.info(f"Teacher {teacher_id} updated by user {current_user.id}")

    return TeacherResponse(
        id=teacher.id,
        user_id=teacher.user.id,
        firstname=teacher.user.firstname,
        lastname=teacher.user.lastname,
        email=teacher.user.email,
        riwaya=teacher.riwaya,
        hire_date=teacher.hire_date,
        is_active=teacher.user.is_active
    )


@teacherRouter.delete("/{teacher_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_teacher(
    teacher_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Delete a teacher. Only presidents and supervisors can delete teachers."""

    result = await db.execute(
        select(Teacher).where(Teacher.id == teacher_id)
    )
    teacher = result.scalar_one_or_none()
    
    if not teacher:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Teacher with ID {teacher_id} not found"
        )

    # Delete the teacher (will cascade to user due to relationship)
    await db.delete(teacher)
    await db.commit()
    
    logger.info(f"Teacher {teacher_id} deleted by user {current_user.id}")

    return None


@teacherRouter.post("/session_creation", response_model=dict)
async def create_teacher_session():
    return {"detail": "Session creation endpoint - to be implemented"}



# ==================== TEACHER ATTENDANCE OPERATIONS ====================

from app.models.teacher_attendance import TeacherAttendance
from app.schemas.teacher_attendance import (
    TeacherAttendanceCreate,
    TeacherAttendanceUpdate,
    TeacherAttendanceResponse,
    TeacherAttendanceList
)


@teacherRouter.post("/{teacher_id}/attendance", response_model=TeacherAttendanceResponse, status_code=status.HTTP_201_CREATED)
async def create_teacher_attendance(
    teacher_id: int,
    attendance_data: TeacherAttendanceCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Create or update attendance record for a teacher on a specific date."""

    # Verify teacher exists
    result = await db.execute(
        select(Teacher).where(Teacher.id == teacher_id)
    )
    teacher = result.scalar_one_or_none()

    if not teacher:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Teacher with ID {teacher_id} not found"
        )

    # Validate attendance data belongs to the correct teacher
    if attendance_data.teacher_id != teacher_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Teacher ID in URL must match teacher_id in request body"
        )

    # Check if attendance already exists for this teacher and date
    existing_result = await db.execute(
        select(TeacherAttendance).where(
            TeacherAttendance.teacher_id == teacher_id,
            TeacherAttendance.date == attendance_data.date
        )
    )
    existing_attendance = existing_result.scalar_one_or_none()

    if existing_attendance:
        # Update existing attendance
        existing_attendance.status = attendance_data.status
        existing_attendance.notes = attendance_data.notes
        await db.commit()
        await db.refresh(existing_attendance)
        logger.info(f"Teacher attendance updated for teacher {teacher_id} on {attendance_data.date} by user {current_user.id}")
        return existing_attendance

    # Create new attendance record
    new_attendance = TeacherAttendance(
        teacher_id=teacher_id,
        date=attendance_data.date,
        status=attendance_data.status,
        notes=attendance_data.notes
    )

    db.add(new_attendance)
    await db.commit()
    await db.refresh(new_attendance)

    logger.info(f"Teacher attendance created for teacher {teacher_id} on {attendance_data.date} by user {current_user.id}")

    return new_attendance


@teacherRouter.get("/{teacher_id}/attendance", response_model=TeacherAttendanceList)
async def get_teacher_attendance(
    teacher_id: int,
    date: str = None,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Get attendance records for a specific teacher. Optionally filter by date."""

    # Verify teacher exists
    result = await db.execute(
        select(Teacher).where(Teacher.id == teacher_id)
    )
    teacher = result.scalar_one_or_none()

    if not teacher:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Teacher with ID {teacher_id} not found"
        )

    # Build query
    query = select(TeacherAttendance).where(TeacherAttendance.teacher_id == teacher_id)
    
    # Filter by date if provided
    if date:
        query = query.where(TeacherAttendance.date == date)
    
    query = query.order_by(TeacherAttendance.created_at.desc()).offset(skip).limit(limit)

    # Get attendance records
    attendance_result = await db.execute(query)
    attendances = attendance_result.scalars().all()

    # Get total count
    count_query = select(TeacherAttendance).where(TeacherAttendance.teacher_id == teacher_id)
    if date:
        count_query = count_query.where(TeacherAttendance.date == date)
    
    count_result = await db.execute(count_query)
    total = len(count_result.scalars().all())

    return TeacherAttendanceList(attendances=list(attendances), total=total)


@teacherRouter.put("/{teacher_id}/attendance/{attendance_id}", response_model=TeacherAttendanceResponse)
async def update_teacher_attendance(
    teacher_id: int,
    attendance_id: int,
    attendance_data: TeacherAttendanceUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Update a teacher attendance record."""

    result = await db.execute(
        select(TeacherAttendance).where(
            TeacherAttendance.id == attendance_id,
            TeacherAttendance.teacher_id == teacher_id
        )
    )
    attendance = result.scalar_one_or_none()

    if not attendance:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Attendance with ID {attendance_id} not found for teacher {teacher_id}"
        )

    # Update fields
    update_data = attendance_data.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(attendance, field, value)

    await db.commit()
    await db.refresh(attendance)

    logger.info(f"Teacher attendance {attendance_id} updated by user {current_user.id}")

    return attendance


@teacherRouter.delete("/{teacher_id}/attendance/{attendance_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_teacher_attendance(
    teacher_id: int,
    attendance_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Delete a teacher attendance record."""

    result = await db.execute(
        select(TeacherAttendance).where(
            TeacherAttendance.id == attendance_id,
            TeacherAttendance.teacher_id == teacher_id
        )
    )
    attendance = result.scalar_one_or_none()

    if not attendance:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Attendance with ID {attendance_id} not found for teacher {teacher_id}"
        )

    await db.delete(attendance)
    await db.commit()

    logger.info(f"Teacher attendance {attendance_id} deleted by user {current_user.id}")

    return None
