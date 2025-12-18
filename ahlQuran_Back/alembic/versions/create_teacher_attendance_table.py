"""create_teacher_attendance_table

Revision ID: e5f6g7h8i9j0
Revises: d4e5f6g7h8i9
Create Date: 2024-12-18 15:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision = 'e5f6g7h8i9j0'
down_revision = 'd4e5f6g7h8i9'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Create teacher_attendances table
    op.create_table(
        'teacher_attendances',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('teacher_id', sa.Integer(), nullable=False),
        sa.Column('date', sa.String(length=10), nullable=False),
        sa.Column('status', sa.String(length=20), nullable=False),
        sa.Column('notes', sa.Text(), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), nullable=True),
        sa.ForeignKeyConstraint(['teacher_id'], ['teachers.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id')
    )
    
    # Add check constraint for status values
    op.execute("ALTER TABLE teacher_attendances ADD CONSTRAINT teacher_attendances_status_check CHECK (status IN ('present', 'late', 'absent', 'excused'))")
    
    # Create indexes
    op.create_index(op.f('ix_teacher_attendances_id'), 'teacher_attendances', ['id'], unique=False)
    op.create_index(op.f('ix_teacher_attendances_teacher_id'), 'teacher_attendances', ['teacher_id'], unique=False)
    op.create_index(op.f('ix_teacher_attendances_date'), 'teacher_attendances', ['date'], unique=False)
    
    # Create unique constraint for teacher_id + date combination
    op.create_index('ix_teacher_attendances_teacher_date', 'teacher_attendances', ['teacher_id', 'date'], unique=True)


def downgrade() -> None:
    # Drop indexes
    op.drop_index('ix_teacher_attendances_teacher_date', table_name='teacher_attendances')
    op.drop_index(op.f('ix_teacher_attendances_date'), table_name='teacher_attendances')
    op.drop_index(op.f('ix_teacher_attendances_teacher_id'), table_name='teacher_attendances')
    op.drop_index(op.f('ix_teacher_attendances_id'), table_name='teacher_attendances')
    
    # Drop table
    op.drop_table('teacher_attendances')
