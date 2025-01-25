"""Add forecast table

Revision ID: 220ce94a5a87
Revises: 4e9f3d50441
Create Date: 2013-03-13 14:12:17.853500

"""

# revision identifiers, used by Alembic.
revision = '220ce94a5a87'
down_revision = '4e9f3d50441'

from alembic import op
import sqlalchemy as sa


def upgrade():
    op.create_table(
        'weather_forecast',
        sa.Column('date', sa.Date, primary_key=True),
        sa.Column('temp', sa.Float, nullable=False),
    )


def downgrade():
    op.drop_table('weather_forecast')
