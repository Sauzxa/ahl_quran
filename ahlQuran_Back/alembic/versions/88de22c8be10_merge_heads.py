"""merge_heads

Revision ID: 88de22c8be10
Revises: a85200acdb09, 4e8f9c2a1b3d
Create Date: 2025-12-14 13:17:21.883678

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '88de22c8be10'
down_revision = ('a85200acdb09', '4e8f9c2a1b3d')
branch_labels = None
depends_on = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
