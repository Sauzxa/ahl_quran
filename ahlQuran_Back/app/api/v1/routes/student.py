from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload

from app.db.session import get_db
from app.models.user import User, UserRoleEnum
from app.models.student import Student
from app.models.acheivements import Achievement
from app.schemas.student import StudentCreate, StudentUpdate, StudentResponse, StudentList
from app.schemas.achievement import AchievementCreate, AchievementUpdate, AchievementResponse, AchievementList
from app.core.dependencies import get_current_user, require_president_or_supervisor
from app.core.security import get_password_hash

import logging
logger = logging.getLogger(__name__)

studentRouter = APIRouter()


@studentRouter.post("/", response_model=StudentResponse, status_code=status.HTTP_201_CREATED)
async def create_student(
    student_data: StudentCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    # Check if email already exists
    result = await db.execute(
        select(User).where(User.email == student_data.email)
    )
    existing_user = result.scalar_one_or_none()

    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )

    # Create user record
    new_user = User(
        firstname=student_data.firstname,
        lastname=student_data.lastname,
        email=student_data.email,
        hashed_password=get_password_hash(student_data.password),
        role=UserRoleEnum.STUDENT,
        is_active=True
    )

    db.add(new_user)
    await db.flush()

    # Create student record
    new_student = Student(
        user_id=new_user.id,
        parent_name=student_data.parent_name,
        parent_phone=student_data.parent_phone,
        guardian_email=student_data.guardian_email,
        created_by_id=current_user.id,
        Golden=student_data.golden
    )

    db.add(new_student)
    await db.commit()
    await db.refresh(new_student)
    await db.refresh(new_user)

    logger.info(f"Student created: {new_student.id} by user {current_user.id}")

    return StudentResponse(
        id=new_student.id,
        user_id=new_user.id,
        firstname=new_user.firstname,
        lastname=new_user.lastname,
        email=new_user.email,
        enrollment_date=new_student.enrollment_date,
        parent_name=new_student.parent_name,
        parent_phone=new_student.parent_phone,
        guardian_email=new_student.guardian_email,
        golden=new_student.Golden,
        is_active=new_user.is_active
    )


@studentRouter.get("/", response_model=StudentList)
async def list_students(
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db),
    # current_user: User = Depends(require_president_or_supervisor)
):
    """Get all students. Only presidents and supervisors can view all students."""

    result = await db.execute(
        select(Student)
        .options(selectinload(Student.user))
        .offset(skip)
        .limit(limit)
    )
    students = result.scalars().all()

    # Get total count
    count_result = await db.execute(select(Student))
    total = len(count_result.scalars().all())

    student_responses = [
        StudentResponse(
            id=student.id,
            user_id=student.user.id,
            firstname=student.user.firstname,
            lastname=student.user.lastname,
            email=student.user.email,
            enrollment_date=student.enrollment_date,
            parent_name=student.parent_name,
            parent_phone=student.parent_phone,
            guardian_email=student.guardian_email,
            golden=student.Golden,
            is_active=student.user.is_active
        )
        for student in students
    ]

    return StudentList(students=student_responses, total=total)


@studentRouter.get("/{student_id}", response_model=StudentResponse)
async def get_student(
    student_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Get a specific student by ID."""

    result = await db.execute(
        select(Student)
        .options(selectinload(Student.user))
        .where(Student.id == student_id)
    )
    student = result.scalar_one_or_none()

    if not student:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Student with ID {student_id} not found"
        )

    return StudentResponse(
        id=student.id,
        user_id=student.user.id,
        firstname=student.user.firstname,
        lastname=student.user.lastname,
        email=student.user.email,
        enrollment_date=student.enrollment_date,
        parent_name=student.parent_name,
        parent_phone=student.parent_phone,
        guardian_email=student.guardian_email,
        golden=student.Golden,
        is_active=student.user.is_active
    )


@studentRouter.put("/{student_id}", response_model=StudentResponse)
async def update_student(
    student_id: int,
    student_data: StudentUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Update student information. Only presidents and supervisors can update students."""

    result = await db.execute(
        select(Student)
        .options(selectinload(Student.user))
        .where(Student.id == student_id)
    )
    student = result.scalar_one_or_none()

    if not student:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Student with ID {student_id} not found"
        )

    # Update user fields
    update_data = student_data.model_dump(exclude_unset=True)

    if "firstname" in update_data:
        student.user.firstname = update_data["firstname"]
    if "lastname" in update_data:
        student.user.lastname = update_data["lastname"]
    if "email" in update_data:
        # Check if new email is already taken
        email_result = await db.execute(
            select(User).where(User.email == update_data["email"], User.id != student.user.id)
        )
        if email_result.scalar_one_or_none():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )
        student.user.email = update_data["email"]

    # Update student-specific fields
    if "parent_name" in update_data:
        student.parent_name = update_data["parent_name"]
    if "parent_phone" in update_data:
        student.parent_phone = update_data["parent_phone"]
    if "guardian_email" in update_data:
        student.guardian_email = update_data["guardian_email"]
    if "golden" in update_data:
        student.Golden = update_data["golden"]

    await db.commit()
    await db.refresh(student)
    await db.refresh(student.user)

    logger.info(f"Student {student_id} updated by user {current_user.id}")

    return StudentResponse(
        id=student.id,
        user_id=student.user.id,
        firstname=student.user.firstname,
        lastname=student.user.lastname,
        email=student.user.email,
        enrollment_date=student.enrollment_date,
        parent_name=student.parent_name,
        parent_phone=student.parent_phone,
        guardian_email=student.guardian_email,
        golden=student.Golden,
        is_active=student.user.is_active
    )


@studentRouter.delete("/{student_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student(
    student_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Delete a student. Only presidents and supervisors can delete students."""

    result = await db.execute(
        select(Student).where(Student.id == student_id)
    )
    student = result.scalar_one_or_none()

    if not student:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Student with ID {student_id} not found"
        )

    # Delete the student (will cascade to user due to relationship)
    await db.delete(student)
    await db.commit()

    logger.info(f"Student {student_id} deleted by user {current_user.id}")

    return None


# ==================== ACHIEVEMENT OPERATIONS ====================

@studentRouter.post("/{student_id}/achievements", response_model=AchievementResponse, status_code=status.HTTP_201_CREATED)
async def add_achievement(
    student_id: int,
    achievement_data: AchievementCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Add an achievement/progress record for a student."""

    # Verify student exists
    result = await db.execute(
        select(Student).where(Student.id == student_id)
    )
    student = result.scalar_one_or_none()

    if not student:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Student with ID {student_id} not found"
        )

    # Validate achievement data belongs to the correct student
    if achievement_data.student_id != student_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Student ID in URL must match student_id in request body"
        )

    # Create achievement record
    new_achievement = Achievement(
        student_id=student_id,
        from_surah=achievement_data.from_surah,
        to_surah=achievement_data.to_surah,
        from_verse=achievement_data.from_verse,
        to_verse=achievement_data.to_verse,
        note=achievement_data.note
    )

    db.add(new_achievement)
    await db.commit()
    await db.refresh(new_achievement)

    logger.info(f"Achievement added for student {student_id} by user {current_user.id}")

    return new_achievement


@studentRouter.get("/{student_id}/achievements", response_model=AchievementList)
async def get_student_achievements(
    student_id: int,
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all achievements for a specific student."""

    # Verify student exists
    result = await db.execute(
        select(Student).where(Student.id == student_id)
    )
    student = result.scalar_one_or_none()

    if not student:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Student with ID {student_id} not found"
        )

    # Get achievements
    achievements_result = await db.execute(
        select(Achievement)
        .where(Achievement.student_id == student_id)
        .offset(skip)
        .limit(limit)
        .order_by(Achievement.created_at.desc())
    )
    achievements = achievements_result.scalars().all()

    # Get total count
    count_result = await db.execute(
        select(Achievement).where(Achievement.student_id == student_id)
    )
    total = len(count_result.scalars().all())

    return AchievementList(achievements=list(achievements), total=total)


@studentRouter.put("/{student_id}/achievements/{achievement_id}", response_model=AchievementResponse)
async def update_achievement(
    student_id: int,
    achievement_id: int,
    achievement_data: AchievementUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Update an achievement record."""

    result = await db.execute(
        select(Achievement).where(
            Achievement.id == achievement_id,
            Achievement.student_id == student_id
        )
    )
    achievement = result.scalar_one_or_none()

    if not achievement:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Achievement with ID {achievement_id} not found for student {student_id}"
        )

    # Update fields
    update_data = achievement_data.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(achievement, field, value)

    await db.commit()
    await db.refresh(achievement)

    logger.info(f"Achievement {achievement_id} updated by user {current_user.id}")

    return achievement


@studentRouter.delete("/{student_id}/achievements/{achievement_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_achievement(
    student_id: int,
    achievement_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Delete an achievement record."""

    result = await db.execute(
        select(Achievement).where(
            Achievement.id == achievement_id,
            Achievement.student_id == student_id
        )
    )
    achievement = result.scalar_one_or_none()

    if not achievement:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Achievement with ID {achievement_id} not found for student {student_id}"
        )

    await db.delete(achievement)
    await db.commit()

    logger.info(f"Achievement {achievement_id} deleted by user {current_user.id}")

    return None

