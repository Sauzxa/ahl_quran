"""add english names and parent status to students

Revision ID: 4e8f9c2a1b3d
Revises: fbec4d3b411b
Create Date: 2025-12-14 12:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '4e8f9c2a1b3d'
down_revision: Union[str, None] = 'fbec4d3b411b'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Add new columns to students table
    op.add_column('students', sa.Column('first_name_en', sa.String(length=50), nullable=True))
    op.add_column('students', sa.Column('last_name_en', sa.String(length=50), nullable=True))
    op.add_column('students', sa.Column('father_status', sa.String(length=50), nullable=True))
    op.add_column('students', sa.Column('mother_status', sa.String(length=50), nullable=True))


def downgrade() -> None:
    # Remove columns if downgrading
    op.drop_column('students', 'mother_status')
    op.drop_column('students', 'father_status')
    op.drop_column('students', 'last_name_en')
    op.drop_column('students', 'first_name_en')
