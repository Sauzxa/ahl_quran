"""add_achievement_type_field

Revision ID: a1b2c3d4e5f6
Revises: 4e8f9c2a1b3d, make_session_id_nullable
Create Date: 2024-12-17 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = 'a1b2c3d4e5f6'
down_revision = ('4e8f9c2a1b3d', 'make_session_id_nullable')
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Create enum type for achievement_type
    achievement_type_enum = postgresql.ENUM('normal', 'small', 'big', name='achievementtype')
    achievement_type_enum.create(op.get_bind(), checkfirst=True)
    
    # Add achievement_type column with default value 'normal'
    op.add_column('achievements', 
        sa.Column('achievement_type', 
                  sa.Enum('normal', 'small', 'big', name='achievementtype'),
                  nullable=False,
                  server_default='normal')
    )


def downgrade() -> None:
    # Drop the achievement_type column
    op.drop_column('achievements', 'achievement_type')
    
    # Drop the enum type
    achievement_type_enum = postgresql.ENUM('normal', 'small', 'big', name='achievementtype')
    achievement_type_enum.drop(op.get_bind(), checkfirst=True)
