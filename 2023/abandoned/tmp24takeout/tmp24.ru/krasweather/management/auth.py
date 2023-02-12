# coding: utf-8
from getpass import getpass
from flask.ext.script import Command, Option
from sqlalchemy.exc import IntegrityError

from ..models import User


def get_pass():
    password = getpass('Enter new password: ')
    password1 = getpass('Check password: ')
    if password != password1:
        print "Passwords do not match."
        exit(1)
    return password


class Passwd(Command):
    "Sets user password"
    option_list = (
        Option('--username', '-u', dest='username', required=True),
    )

    def run(self, username):
        u = User.get_by_username(username)
        password = get_pass()
        u.set_password(password)
        u.save()


class AddUser(Command):
    "Creates new user"
    option_list = (
        Option('--username', '-u', dest='username', required=True),
        Option('--email', '-e', dest='email', required=True),
    )

    def run(self, username, email):
        password = get_pass()
        u = User.create(username=username, email=email, password=password, enabled=True)
        try:
            u.save()
        except IntegrityError:
            print 'Username or email already registered.'
        else:
            print 'Created user: {username}'.format(username=u.username)


class EnableUser(Command):
    "Enables user account"
    option_list = (
        Option('--username', '-u', dest='username', required=True),
    )

    def run(self, username):
        u = User.get_by_username(username)
        u.enable()


class DisableUser(Command):
    "Enables user account"
    option_list = (
        Option('--username', '-u', dest='username', required=True),
    )

    def run(self, username):
        u = User.get_by_username(username)
        u.disable()


def add_commands(manager):
    manager.add_command("adduser", AddUser())
    manager.add_command("activateuser", EnableUser())
    manager.add_command("passwd", Passwd())
