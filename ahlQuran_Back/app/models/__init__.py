# Import all models so they're registered with Base.metadata
# This is needed for alembic and create_all() to work
from app.models.user import User, UserRoleEnum
from app.models.president import President
from app.models.supervisor import Supervisor
from app.models.teacher import Teacher
from app.models.student import Student
from app.models.admin import Admin
from app.models.session import Session
from app.models.sessionParticipation import SessionParticipation, ParticipationStatus
from app.models.acheivements import Achievement

__all__ = [
    "User",
    "UserRoleEnum",
    "President",
    "Supervisor",
    "Teacher",
    "Student",
    "Admin",
    "Session",
    "SessionParticipation",
    "ParticipationStatus",
    "Achievement",
]