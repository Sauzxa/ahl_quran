"""add_guardian_table

Revision ID: c9f8e3a1b2d4
Revises: 282029d1d9cb
Create Date: 2025-12-15 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from datetime import datetime, timezone


# revision identifiers, used by Alembic.
revision = 'c9f8e3a1b2d4'
down_revision = '282029d1d9cb'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Create guardians table
    op.create_table('guardians',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('first_name', sa.String(length=100), nullable=False),
        sa.Column('last_name', sa.String(length=100), nullable=False),
        sa.Column('relationship_to_student', sa.String(length=50), nullable=False),
        sa.Column('date_of_birth', sa.String(length=20), nullable=True),
        sa.Column('phone_number', sa.String(length=20), nullable=True),
        sa.Column('email', sa.String(length=255), nullable=True),
        sa.Column('job', sa.String(length=100), nullable=True),
        sa.Column('address', sa.String(length=255), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('created_by_id', sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(['created_by_id'], ['users.id'], ),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('user_id')
    )
    op.create_index(op.f('ix_guardians_id'), 'guardians', ['id'], unique=False)


def downgrade() -> None:
    op.drop_index(op.f('ix_guardians_id'), table_name='guardians')
    op.drop_table('guardians')
