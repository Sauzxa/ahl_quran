"""change_surah_to_integer

Revision ID: b2c3d4e5f6g7
Revises: a1b2c3d4e5f6
Create Date: 2024-12-17 11:30:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'b2c3d4e5f6g7'
down_revision = 'a1b2c3d4e5f6'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Change from_surah and to_surah from String to Integer
    # First, we need to handle existing data if any
    op.execute("DELETE FROM achievements WHERE from_surah !~ '^[0-9]+$' OR to_surah !~ '^[0-9]+$'")
    
    # Alter column types
    op.alter_column('achievements', 'from_surah',
                    type_=sa.Integer(),
                    postgresql_using='from_surah::integer')
    op.alter_column('achievements', 'to_surah',
                    type_=sa.Integer(),
                    postgresql_using='to_surah::integer')


def downgrade() -> None:
    # Revert back to String
    op.alter_column('achievements', 'from_surah',
                    type_=sa.String(50),
                    postgresql_using='from_surah::text')
    op.alter_column('achievements', 'to_surah',
                    type_=sa.String(50),
                    postgresql_using='to_surah::text')
