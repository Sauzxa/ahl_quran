"""add student_id to guardians

Revision ID: d5e6f7a8b9c0
Revises: c9f8e3a1b2d4
Create Date: 2025-12-15 12:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'd5e6f7a8b9c0'
down_revision = 'c9f8e3a1b2d4'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Add student_id column to guardians table
    op.add_column('guardians', 
        sa.Column('student_id', sa.Integer(), nullable=True)
    )
    
    # Add foreign key constraint
    op.create_foreign_key(
        'fk_guardians_student_id',
        'guardians', 'students',
        ['student_id'], ['id'],
        ondelete='SET NULL'
    )
    
    # Add index for better query performance
    op.create_index(
        'ix_guardians_student_id',
        'guardians',
        ['student_id'],
        unique=False
    )


def downgrade() -> None:
    # Remove index
    op.drop_index('ix_guardians_student_id', table_name='guardians')
    
    # Remove foreign key constraint
    op.drop_constraint('fk_guardians_student_id', 'guardians', type_='foreignkey')
    
    # Remove column
    op.drop_column('guardians', 'student_id')
