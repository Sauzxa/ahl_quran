"""create_attendance_table

Revision ID: d4e5f6g7h8i9
Revises: c3d4e5f6g7h8
Create Date: 2024-12-17 14:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision = 'd4e5f6g7h8i9'
down_revision = 'c3d4e5f6g7h8'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Create enum type for attendance status (skip if exists)
    op.execute("DO $$ BEGIN CREATE TYPE attendancestatus AS ENUM ('present', 'late', 'absent', 'excused'); EXCEPTION WHEN duplicate_object THEN null; END $$;")
    
    # Create attendances table
    op.create_table(
        'attendances',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('student_id', sa.Integer(), nullable=False),
        sa.Column('date', sa.String(length=10), nullable=False),
        sa.Column('status', sa.String(length=20), nullable=False),
        sa.Column('notes', sa.Text(), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=True),
        sa.ForeignKeyConstraint(['student_id'], ['students.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id')
    )
    
    # Add check constraint for status values
    op.execute("ALTER TABLE attendances ADD CONSTRAINT attendances_status_check CHECK (status IN ('present', 'late', 'absent', 'excused'))")
    
    # Create indexes
    op.create_index(op.f('ix_attendances_id'), 'attendances', ['id'], unique=False)
    op.create_index(op.f('ix_attendances_student_id'), 'attendances', ['student_id'], unique=False)
    op.create_index(op.f('ix_attendances_date'), 'attendances', ['date'], unique=False)
    
    # Create unique constraint for student_id + date combination
    op.create_index('ix_attendances_student_date', 'attendances', ['student_id', 'date'], unique=True)


def downgrade() -> None:
    # Drop indexes
    op.drop_index('ix_attendances_student_date', table_name='attendances')
    op.drop_index(op.f('ix_attendances_date'), table_name='attendances')
    op.drop_index(op.f('ix_attendances_student_id'), table_name='attendances')
    op.drop_index(op.f('ix_attendances_id'), table_name='attendances')
    
    # Drop table
    op.drop_table('attendances')
    
    # Drop enum type
    attendance_status_enum = postgresql.ENUM('present', 'late', 'absent', 'excused', name='attendancestatus')
    attendance_status_enum.drop(op.get_bind(), checkfirst=True)
