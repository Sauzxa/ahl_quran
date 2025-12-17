"""fix session_participation timestamps to be timezone aware

Revision ID: fix_session_participation_timestamps
Revises: make_session_id_nullable
Create Date: 2024-12-16

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = 'fix_sp_timestamps'
down_revision = 'make_session_id_nullable'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Alter marked_at to be timezone aware
    op.alter_column('session_participations', 'marked_at',
                    existing_type=sa.DateTime(),
                    type_=sa.DateTime(timezone=True),
                    existing_nullable=False)
    
    # Alter updated_at to be timezone aware
    op.alter_column('session_participations', 'updated_at',
                    existing_type=sa.DateTime(),
                    type_=sa.DateTime(timezone=True),
                    existing_nullable=True)


def downgrade() -> None:
    # Revert marked_at to non-timezone aware
    op.alter_column('session_participations', 'marked_at',
                    existing_type=sa.DateTime(timezone=True),
                    type_=sa.DateTime(),
                    existing_nullable=False)
    
    # Revert updated_at to non-timezone aware
    op.alter_column('session_participations', 'updated_at',
                    existing_type=sa.DateTime(timezone=True),
                    type_=sa.DateTime(),
                    existing_nullable=True)
