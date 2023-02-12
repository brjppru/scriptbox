# coding: utf-8
from flask.ext.script import Command
from sqlalchemy.sql import text

from ..models import db


class DeleteCache(Command):
    "Clears cache tables"

    def run(self):
        sql = text(
            'truncate table daily_cache_meta; '
            'truncate table monthly_cache_meta; '
            'truncate table average_monthly_temp; '
            'truncate table average_daily_temp;'
        )
        db.engine.execute(sql)


def add_commands(manager):
    manager.add_command("delete_cache", DeleteCache())
