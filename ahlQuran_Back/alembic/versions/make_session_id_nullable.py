"""make session_id nullable in session_participations

Revision ID: make_session_id_nullable
Revises: 88de22c8be10
Create Date: 2024-12-16

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'make_session_id_nullable'
down_revision = 'd5e6f7a8b9c0'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Make session_id nullable in session_participations table
    op.alter_column('session_participations', 'session_id',
                    existing_type=sa.Integer(),
                    nullable=True)


def downgrade() -> None:
    # Make session_id not nullable again
    op.alter_column('session_participations', 'session_id',
                    existing_type=sa.Integer(),
                    nullable=False)
