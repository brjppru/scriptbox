import datetime
import urllib2
from flask import json
from flask.ext.script import Manager, Command, Server, Option
from flask.ext.assets import ManageAssets
from sqlalchemy.exc import IntegrityError

from krasweather.application import app
from krasweather.assets import assets
from krasweather.conf import settings
from krasweather.dateparse import parse_datetime, utc
from krasweather.management import auth, maintaince
from krasweather.models import db, WeatherData, WeatherForecast


def farenheit2celsius(temp):
    return (temp - 32) * 5. / 9


class CreateDatabaseTables(Command):
    "Creates database tables"

    def run(self):
        db.create_all()


class DropDatabaseTables(Command):
    "Drops database tables"

    def run(self):
        db.drop_all()


class ImportData(Command):
    "Imports weather data from text file"
    option_list = (
        Option('--filename', '-f', dest='filename', required=True),
        Option('--sensor', '-s', dest='sensor_id', default=1),
        Option('--date-format', '-d', dest='date_format', default='%Y-%m-%d %H:%M'),
    )

    def run(self, filename, sensor_id, date_format):
        with open(filename) as f:
            n = 0
            for line in f:
                n += 1
                try:
                    date, time, temp = line.split()
                except ValueError:
                    print "Warning: droping incorrect data in line {n}: {line}".format(n=n, line=line)
                else:
                    db.session.add(
                        WeatherData(
                            date=datetime.datetime.strptime(' '.join([date, time]), date_format),
                            temp=temp,
                            sensor_id=sensor_id
                        )
                    )
                    try:
                        db.session.commit()
                    except IntegrityError:
                        print "Warning: droping duplicate data in line {n}: {line}".format(n=n, line=line)
                        db.session.rollback()


class GetForecast(Command):
    "Get forecast data info from worldweatheronline.com"

    def run(self):
        url = app.config['WEATHER_API_URL']
        try:
            f = urllib2.urlopen(url)
            forecast = json.load(f)
        except IOError as e:
            app.logger.info('Erorr retriving data: {0} ({1})'.format(url, str(e)))
            raise
        except ValueError as e:
            app.logger.info('Error decoding data: {0}'.format(str(e)))
            raise

        temp = forecast['current']['temp_f']
        last_update = parse_datetime(forecast['update_time']).astimezone(utc)
        date = datetime.date(year=last_update.year,
                             month=last_update.month,
                             day=last_update.day)

        db.session.add(
            WeatherForecast(date=date, temp=temp)
        )
        try:
            db.session.commit()
        except IntegrityError:
            db.session.rollback()


def main():
    manager = Manager(app)
    manager.add_command("runserver", Server(host=settings.HOST, port=settings.PORT))
    manager.add_command("assets", ManageAssets(assets))
    manager.add_command("createdb", CreateDatabaseTables())
    manager.add_command("dropdb", DropDatabaseTables())
    manager.add_command("import", ImportData())
    manager.add_command("getforecast", GetForecast())
    auth.add_commands(manager)
    maintaince.add_commands(manager)
    manager.run()


if __name__ == '__main__':
    main()
