"""add hearbeat_data table

Revision ID: 330c391ded0a
Revises: 220ce94a5a87
Create Date: 2013-03-26 21:01:58.156490

"""

# revision identifiers, used by Alembic.
revision = '330c391ded0a'
down_revision = '220ce94a5a87'

from alembic import op
import sqlalchemy as sa


def upgrade():
    op.create_table(
        'heartbeat_data',
        sa.Column('sensor_id', sa.Integer, primary_key=True),
        sa.Column('date', sa.Date, primary_key=True),
        sa.Column('hour', sa.Integer, primary_key=True)
    )


def downgrade():
    op.drop_table('heartbeat_data')
