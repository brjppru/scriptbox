"""Add sensor id field

Revision ID: 4e9f3d50441
Revises: None
Create Date: 2013-03-10 10:40:44.893928

"""

# revision identifiers, used by Alembic.
revision = '4e9f3d50441'
down_revision = None

from alembic import op
import sqlalchemy as sa


def upgrade():
    op.add_column('weather_data', sa.Column('sensor_id', sa.Integer, nullable=False))

def downgrade():
    op.drop_column('weather_data', 'sensor_id')
