from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from typing import List

from app.db.session import get_db
from app.models.user import User, UserRoleEnum
from app.models.guardian import Guardian
from app.models.student import Student
from app.schemas.guardian import (
    GuardianCreate, GuardianUpdate, GuardianResponse, GuardianListResponse
)
from app.core.security import get_password_hash
from app.core.dependencies import require_president_or_supervisor

router = APIRouter()


@router.post("/", response_model=GuardianResponse, status_code=status.HTTP_201_CREATED)
async def create_guardian(
    guardian_data: GuardianCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Create a new guardian"""
    
    # Check if email already exists
    result = await db.execute(
        select(User).where(User.email == guardian_data.guardian_info.email)
    )
    existing_user = result.scalar_one_or_none()
    
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already exists"
        )
    
    # Create user account
    new_user = User(
        firstname=guardian_data.guardian_info.first_name,
        lastname=guardian_data.guardian_info.last_name,
        email=guardian_data.guardian_info.email,
        hashed_password=get_password_hash(guardian_data.account_info.password),
        role=UserRoleEnum.STUDENT,  # Using existing role enum
        is_active=True
    )
    db.add(new_user)
    await db.flush()
    
    # Create guardian record
    new_guardian = Guardian(
        user_id=new_user.id,
        first_name=guardian_data.guardian_info.first_name,
        last_name=guardian_data.guardian_info.last_name,
        relationship_to_student=guardian_data.guardian_info.relationship,
        date_of_birth=guardian_data.guardian_info.date_of_birth,
        phone_number=guardian_data.guardian_info.phone_number,
        email=guardian_data.guardian_info.email,
        job=guardian_data.guardian_info.job,
        address=guardian_data.guardian_info.address,
        student_id=guardian_data.student_id,
        created_by_id=current_user.id
    )
    db.add(new_guardian)
    await db.commit()
    await db.refresh(new_guardian)
    await db.refresh(new_user)
    
    # Load student relationship if exists
    if new_guardian.student_id:
        await db.refresh(new_guardian, ['student'])
    
    student_info = None
    if new_guardian.student_id and new_guardian.student:
        student_info = {
            'id': new_guardian.student.id,
            'first_name_ar': new_guardian.student.user.firstname,
            'last_name_ar': new_guardian.student.user.lastname
        }
    
    return GuardianResponse(
        id=new_guardian.id,
        user_id=new_guardian.user_id,
        first_name=new_guardian.first_name,
        last_name=new_guardian.last_name,
        relationship_to_student=new_guardian.relationship_to_student,
        date_of_birth=new_guardian.date_of_birth,
        phone_number=new_guardian.phone_number,
        email=new_guardian.email,
        job=new_guardian.job,
        address=new_guardian.address,
        username=new_user.email,
        student_id=new_guardian.student_id,
        student=student_info,
        created_at=new_guardian.created_at
    )


@router.get("/", response_model=GuardianListResponse)
async def get_guardians(
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Get all guardians"""
    
    # Get guardians with pagination and load student relationship
    result = await db.execute(
        select(Guardian)
        .options(
            selectinload(Guardian.user),
            selectinload(Guardian.student).selectinload(Student.user)
        )
        .offset(skip)
        .limit(limit)
    )
    guardians = result.scalars().all()
    
    # Efficient count using func.count()
    from sqlalchemy import func
    count_result = await db.execute(select(func.count(Guardian.id)))
    total = count_result.scalar()
    
    guardian_responses = []
    for guardian in guardians:
        student_info = None
        if guardian.student_id and guardian.student:
            student_info = {
                'id': guardian.student.id,
                'first_name_ar': guardian.student.user.firstname,
                'last_name_ar': guardian.student.user.lastname
            }
        
        guardian_responses.append(GuardianResponse(
            id=guardian.id,
            user_id=guardian.user_id,
            first_name=guardian.first_name,
            last_name=guardian.last_name,
            relationship_to_student=guardian.relationship_to_student,
            date_of_birth=guardian.date_of_birth,
            phone_number=guardian.phone_number,
            email=guardian.email,
            job=guardian.job,
            address=guardian.address,
            username=guardian.user.email,
            student_id=guardian.student_id,
            student=student_info,
            created_at=guardian.created_at
        ))
    
    return GuardianListResponse(guardians=guardian_responses, total=total)


@router.get("/{guardian_id}", response_model=GuardianResponse)
async def get_guardian(
    guardian_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Get a specific guardian by ID"""
    
    result = await db.execute(
        select(Guardian)
        .options(
            selectinload(Guardian.user),
            selectinload(Guardian.student).selectinload(Student.user)
        )
        .where(Guardian.id == guardian_id)
    )
    guardian = result.scalar_one_or_none()
    
    if not guardian:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Guardian not found"
        )
    
    student_info = None
    if guardian.student_id and guardian.student:
        student_info = {
            'id': guardian.student.id,
            'first_name_ar': guardian.student.user.firstname,
            'last_name_ar': guardian.student.user.lastname
        }
    
    return GuardianResponse(
        id=guardian.id,
        user_id=guardian.user_id,
        first_name=guardian.first_name,
        last_name=guardian.last_name,
        relationship_to_student=guardian.relationship_to_student,
        date_of_birth=guardian.date_of_birth,
        phone_number=guardian.phone_number,
        email=guardian.email,
        job=guardian.job,
        address=guardian.address,
        username=guardian.user.email,
        student_id=guardian.student_id,
        student=student_info,
        created_at=guardian.created_at
    )


@router.put("/{guardian_id}", response_model=GuardianResponse)
async def update_guardian(
    guardian_id: int,
    guardian_data: GuardianUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Update a guardian"""
    
    result = await db.execute(
        select(Guardian).options(selectinload(Guardian.user)).where(Guardian.id == guardian_id)
    )
    guardian = result.scalar_one_or_none()
    
    if not guardian:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Guardian not found"
        )
    
    # Update guardian info
    if guardian_data.guardian_info:
        guardian.first_name = guardian_data.guardian_info.first_name
        guardian.last_name = guardian_data.guardian_info.last_name
        guardian.relationship_to_student = guardian_data.guardian_info.relationship
        guardian.date_of_birth = guardian_data.guardian_info.date_of_birth
        guardian.phone_number = guardian_data.guardian_info.phone_number
        guardian.email = guardian_data.guardian_info.email
        guardian.job = guardian_data.guardian_info.job
        guardian.address = guardian_data.guardian_info.address
        
        # Update user info
        guardian.user.firstname = guardian_data.guardian_info.first_name
        guardian.user.lastname = guardian_data.guardian_info.last_name
        guardian.user.email = guardian_data.guardian_info.email
    
    # Update student_id if provided
    if guardian_data.student_id is not None:
        guardian.student_id = guardian_data.student_id
    
    # Update account info if provided
    if guardian_data.account_info and guardian_data.account_info.get("password"):
        guardian.user.hashed_password = get_password_hash(
            guardian_data.account_info["password"]
        )
    
    await db.commit()
    
    # Reload guardian with relationships
    result = await db.execute(
        select(Guardian)
        .options(
            selectinload(Guardian.user),
            selectinload(Guardian.student).selectinload(Student.user)
        )
        .where(Guardian.id == guardian_id)
    )
    guardian = result.scalar_one()
    
    student_info = None
    if guardian.student_id and guardian.student:
        student_info = {
            'id': guardian.student.id,
            'first_name_ar': guardian.student.user.firstname,
            'last_name_ar': guardian.student.user.lastname
        }
    
    return GuardianResponse(
        id=guardian.id,
        user_id=guardian.user_id,
        first_name=guardian.first_name,
        last_name=guardian.last_name,
        relationship_to_student=guardian.relationship_to_student,
        date_of_birth=guardian.date_of_birth,
        phone_number=guardian.phone_number,
        email=guardian.email,
        job=guardian.job,
        address=guardian.address,
        username=guardian.user.email,
        student_id=guardian.student_id,
        student=student_info,
        created_at=guardian.created_at
    )


@router.delete("/{guardian_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_guardian(
    guardian_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_president_or_supervisor)
):
    """Delete a guardian"""
    
    result = await db.execute(
        select(Guardian).options(selectinload(Guardian.user)).where(Guardian.id == guardian_id)
    )
    guardian = result.scalar_one_or_none()
    
    if not guardian:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Guardian not found"
        )
    
    # Delete user (cascade will delete guardian)
    await db.delete(guardian.user)
    await db.commit()
    
    return None
