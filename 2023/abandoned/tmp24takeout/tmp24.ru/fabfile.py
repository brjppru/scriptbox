# coding: utf-8
import os
from fabric.api import run, env, sudo, prefix, shell_env, cd  # as fabric_sudo
from fabric.contrib.project import rsync_project


env.shell = "/bin/sh -c"
env.hosts = ['tmp24.ru', ]
env.user = "root"
env.key_filename = ["/Users/cld/.ssh/id_rsa"]

LOCAL_PATH = '.'
APP_PATH = '/srv/krasweather/'
APP_NAME = 'krasweather'
PYTHON = '/srv/virtualenv/bin/python'
MANAGE_CMD = os.path.join(APP_PATH, 'manage.py')
VENV_ACTIVATE_CMD = '. /srv/virtualenv/bin/activate'

EXCLUDE = ('*.pyc', 'fabfile.py', '.DS_Store', '.idea', '.git', '.gitignore', '.gitmodules', 'upload/', 'static_common/',
           'htmlcov/', 'app-messages/', 'env/', 'sftp-config.json', '*.sublime-project', '*.sublime-workspace',
           'debug.log', '.coverage', 'settings_development.py', 'settings_jenkins.py', '.ropeproject/', '.webassets-cache',
           'files')


def reload():
    run('supervisorctl restart {0}'.format('tmp24'))


def stop(application='testing'):
    run('supervisorctl stop {0}'.format('tmp24'))


def start(application='testing'):
    sudo('supervisorctl start {0}'.format('tmp24'))


def createdb():
    with prefix(VENV_ACTIVATE_CMD), shell_env(SERVER_ENVIRONMENT='production'), cd(APP_PATH):
        run('python manage.py createdb')


def rsync():
    rsync_project(
        remote_dir=APP_PATH.rstrip('/'), local_dir=LOCAL_PATH,
        exclude=EXCLUDE, extra_opts='--progress -p')
