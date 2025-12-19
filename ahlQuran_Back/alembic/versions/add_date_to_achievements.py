"""add_date_to_achievements

Revision ID: f6g7h8i9j0k1
Revises: e5f6g7h8i9j0
Create Date: 2024-12-19 16:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'f6g7h8i9j0k1'
down_revision = 'e5f6g7h8i9j0'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Add date column to achievements table
    # Default to created_at date for existing records
    op.add_column('achievements', sa.Column('date', sa.String(length=10), nullable=True))
    
    # Update existing records to use created_at date in DD-MM-YYYY format
    op.execute("""
        UPDATE achievements 
        SET date = TO_CHAR(created_at, 'DD-MM-YYYY')
        WHERE date IS NULL
    """)
    
    # Make the column non-nullable after populating existing records
    op.alter_column('achievements', 'date', nullable=False)
    
    # Create index on date column
    op.create_index(op.f('ix_achievements_date'), 'achievements', ['date'], unique=False)


def downgrade() -> None:
    # Drop index
    op.drop_index(op.f('ix_achievements_date'), table_name='achievements')
    
    # Drop column
    op.drop_column('achievements', 'date')
