from sqlalchemy import String, DateTime, ForeignKey, Integer, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.db.base import Base
from datetime import datetime, timezone
from typing import Optional

class Achievement(Base):
    __tablename__ = "achievements"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    student_id: Mapped[int] = mapped_column(Integer, ForeignKey("students.id", ondelete="CASCADE"))

    from_surah: Mapped[str] = mapped_column(String(50), nullable=False)
    to_surah: Mapped[str] = mapped_column(String(50), nullable=False)
    from_verse: Mapped[int] = mapped_column(Integer, nullable=False)
    to_verse: Mapped[int] = mapped_column(Integer, nullable=False)

    note: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), onupdate=lambda: datetime.now(timezone.utc))

    # Relationship
    student: Mapped["Student"] = relationship(
        "Student",
        foreign_keys=[student_id]
    )

    def __repr__(self) -> str:
        return f"Achievement(id={self.id}, student_id={self.student_id}, {self.from_surah}:{self.from_verse} - {self.to_surah}:{self.to_verse})"
