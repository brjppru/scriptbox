# coding: utf-8
import os


class Settings(object):
    NAME = 'tmp24ru'
    DEBUG = False
    TESTING = False
    ASSETS_DEBUG = False
    DATA_USER = 'update'
    DATA_PASSWORD = 'dersecret#65'
    CSRF_ENABLED = False
    EMAIL_FROM = 'www@tmp24.ru'
    EMAIL_HOST = 'localhost'
    ADMIN_EMAILS = ['cld@elcasa.org']
    MAX_UPLOAD_SIZE = 32 * 1024 * 1024  # 32 megabytes
    #WEATHER_API_URL = 'http://free.worldweatheronline.com/feed/weather.ashx?q=Krasnoyarsk&format=json&num_of_days=2&key=96f1d1396c051745131303'
    WEATHER_API_URL = 'http://ntpserv.appspot.com/weather?lat=56.029531&long=92.912137'


class Production(Settings):
    SECRET_KEY = 'DEVKEY'
    HOST = '0.0.0.0'
    PORT = 8000
    SQLALCHEMY_DATABASE_URI = 'mysql://tmp24ru:chieng1tat@localhost/tmp24ru'
    DEBUG = False
    ASSETS_DEBUG = False
    ASSETS_AUTO_BUILD = False
    UPLOADED_FILES_DEST = '/srv/files/'
    UPLOADED_FILES_URL = '/files/'


class Development(Settings):
    SECRET_KEY = 'DEVKEY'
    HOST = '0.0.0.0'
    PORT = 8000
    SQLALCHEMY_DATABASE_URI = 'mysql://localhost/tmp24ru'

    UPLOADED_FILES_DEST = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'files')

    DEBUG = True
    ASSETS_DEBUG = True


class Testing(Settings):
    SECRET_KEY = 'TESTKEY'
    DEBUG = True
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'mysql://localhost/tmp24ru_test'

ENVIRONMENT = os.environ.get('SERVER_ENVIRONMENT')

if not ENVIRONMENT:
    raise ValueError('SERVER_ENVIRONMENT is not set')

if ENVIRONMENT == 'production':
    settings = Production()
elif ENVIRONMENT == 'development':
    settings = Development()
else:
    raise ValueError('Unknown environment')

test_settings = Testing()
