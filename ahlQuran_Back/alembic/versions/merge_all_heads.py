"""merge all heads

Revision ID: c3d4e5f6g7h8
Revises: b2c3d4e5f6g7, fix_sp_timestamps
Create Date: 2024-12-17 12:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'c3d4e5f6g7h8'
down_revision = ('b2c3d4e5f6g7', 'fix_sp_timestamps')
branch_labels = None
depends_on = None


def upgrade() -> None:
    # This is a merge migration, no changes needed
    pass


def downgrade() -> None:
    # This is a merge migration, no changes needed
    pass
