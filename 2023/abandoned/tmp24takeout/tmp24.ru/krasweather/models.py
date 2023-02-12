# coding: utf-8
from datetime import datetime, date, timedelta, MAXYEAR
from flask.ext.login import AnonymousUserMixin, UserMixin
from flask.ext.sqlalchemy import SQLAlchemy
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm.exc import NoResultFound
from werkzeug.security import generate_password_hash, check_password_hash


__all__ = ['init_db', 'db', 'WeatherData', 'HeartbeatData', 'WeatherForecast', 'AverageDailyTempCache',
           'AverageMonthlyTempCache', 'DailyCacheMeta', 'MonthlyCacheMeta', 'AnonymousUser', 'User',
           'TextDocument', 'FlatPage']

db = SQLAlchemy()


def init_db(app):
    db.init_app(app)


class AnonymousUser(AnonymousUserMixin):
    def check_password(self, password):
        return False


class User(UserMixin, db.Model):
    __tablename__ = 'user'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True)
    email = db.Column(db.String(80), unique=True)
    password = db.Column(db.String(100), nullable=False)
    enabled = db.Column(db.Boolean())

    def __init__(self,
                 username, password, id=None, email=None,
                 enabled=False):
        self.id = id
        self.username = username
        self.email = email
        self.enabled = enabled
        self.set_password(password)

    def __repr__(self):
        return '<User %r>' % self.username

    @property
    def full_name(self):
        return unicode(self.username)

    @staticmethod
    def get_by_username(username):
        return User.query.filter_by(username=username).one()

    @classmethod
    def create(cls, *args, **kwargs):
        user = cls(*args, **kwargs)
        user.save()
        return user

    def get_id(self):
        return unicode(self.username)

    def set_password(self, password):
        self.password = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password, password)

    def is_active(self):
        return self.enabled

    def save(self):
        db.session.add(self)
        db.session.commit()

    def enable(self, commit=True):
        self.enabled = True
        if commit:
            self.save()

    def disable(self, commit=True):
        self.enabled = False
        if commit:
            self.save()


class WeatherData(db.Model):
    __tablename__ = 'weather_data'

    sensor_id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.DateTime, primary_key=True)
    temp = db.Column(db.Float)

    def __init__(self, date, temp, sensor_id=1):
        self.date = date
        self.temp = temp
        self.sensor_id = sensor_id

    @staticmethod
    def get_all_years():
        return [row[0] for row in db.session.query(
            db.func.year(WeatherData.date)
        ).distinct().all()]

    @staticmethod
    def get_all_months(year):
        return [row[0] for row in db.session.query(
            db.func.month(WeatherData.date)
        ).filter(db.func.year(WeatherData.date) == year).distinct().all()]

    @staticmethod
    def get_all_days(year, month):
        return [row[0] for row in db.session.query(
            db.func.day(WeatherData.date)
        ).filter(
            db.func.year(WeatherData.date) == year,
            db.func.month(WeatherData.date) == month
        )]


class HeartbeatData(db.Model):
    __tablename__ = 'heartbeat_data'

    sensor_id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.Date, primary_key=True)
    hour = db.Column(db.Integer, primary_key=True)

    def __init__(self, sensor_id, date, hour):
        self.sensor_id = sensor_id
        self.date = date
        self.hour = hour


class WeatherForecast(db.Model):
    __tablename__ = 'weather_forecast'

    date = db.Column(db.Date, primary_key=True)
    temp = db.Column(db.Float)

    def __init__(self, date, temp):
        self.date = date
        self.temp = temp


class AverageDailyTempCache(db.Model):
    __tablename__ = 'average_daily_temp'

    year = db.Column(db.Integer, primary_key=True)
    month = db.Column(db.Integer, primary_key=True)
    day = db.Column(db.Integer, primary_key=True)
    avg = db.Column(db.Float)
    avg_low = db.Column(db.Float)
    avg_high = db.Column(db.Float)

    def __init__(self, year, month, day, avg, avg_low, avg_high):
        self.year = year
        self.month = month
        self.day = day
        self.avg = avg
        self.avg_low = avg_low
        self.avg_high = avg_high

    @classmethod
    def refresh(cls, year, month):
        db.session.query(cls).filter_by(year=year, month=month).delete()
        db.session.commit()

        min_temp = db.session.query(
            db.func.day(WeatherData.date).label('day'),
            db.func.hour(WeatherData.date).label('hour'),
            db.func.min(WeatherData.temp).label('temp')
        ).filter(
            db.func.year(WeatherData.date) == year,
            db.func.month(WeatherData.date) == month
        ).group_by('day', 'hour').subquery()

        max_temp = db.session.query(
            db.func.day(WeatherData.date).label('day'),
            db.func.hour(WeatherData.date).label('hour'),
            db.func.max(WeatherData.temp).label('temp')
        ).filter(
            db.func.year(WeatherData.date) == year,
            db.func.month(WeatherData.date) == month
        ).group_by('day', 'hour').subquery()

        avg_temp = db.session.query(
            db.func.day(WeatherData.date).label('day'),
            db.func.avg(WeatherData.temp).label('avg_temp')
        ).filter(
            db.func.year(WeatherData.date) == year,
            db.func.month(WeatherData.date) == month
        ).group_by('day').all()

        avg_min_temp = db.session.query(
            min_temp.c.day,
            db.func.avg(min_temp.c.temp).label('min_temp')
        ).group_by('day').order_by('day').all()

        avg_max_temp = db.session.query(
            max_temp.c.day,
            db.func.avg(max_temp.c.temp).label('max_temp')
        ).group_by('day').order_by('day').all()

        assert(len(avg_min_temp) == len(avg_max_temp) == len(avg_temp))

        for avg_row, min_row, max_row in zip(avg_temp, avg_min_temp, avg_max_temp):
            try:
                db.session.add(cls(
                    year,
                    month,
                    avg_row.day,
                    avg_row.avg_temp,
                    min_row.min_temp,
                    max_row.max_temp)
                )
                db.session.commit()
            except IntegrityError:
                db.session.rollback()

    @classmethod
    def get_for_month(cls, year, month):
        try:
            meta = DailyCacheMeta.query.filter_by(year=year, month=month).one()
            if meta.refresh <= date.today():
                cls.refresh(year, month)
                meta.update_refresh()
                db.session.add(meta)
                db.session.commit()
        except NoResultFound:
            cls.refresh(year, month)
            db.session.add(DailyCacheMeta(year, month))
            db.session.commit()

        return cls.query.filter_by(year=year, month=month).order_by('day')


class AverageMonthlyTempCache(db.Model):
    __tablename__ = 'average_monthly_temp'

    year = db.Column(db.Integer, primary_key=True)
    month = db.Column(db.Integer, primary_key=True)
    avg = db.Column(db.Float)
    avg_low = db.Column(db.Float)
    avg_high = db.Column(db.Float)

    def __init__(self, year, month, avg, avg_low, avg_high):
        self.year = year
        self.month = month
        self.avg = avg
        self.avg_low = avg_low
        self.avg_high = avg_high

    @classmethod
    def refresh(cls, year):
        db.session.query(cls).filter_by(year=year).delete()
        db.session.commit()

        min_temp = db.session.query(
            db.func.month(WeatherData.date).label('month'),
            db.func.hour(WeatherData.date).label('hour'),
            db.func.min(WeatherData.temp).label('temp')
        ).filter(
            db.func.year(WeatherData.date) == year
        ).group_by('month', 'hour').subquery()

        max_temp = db.session.query(
            db.func.month(WeatherData.date).label('month'),
            db.func.hour(WeatherData.date).label('hour'),
            db.func.max(WeatherData.temp).label('temp')
        ).filter(
            db.func.year(WeatherData.date) == year
        ).group_by('month', 'hour').subquery()

        avg_temp = db.session.query(
            db.func.month(WeatherData.date).label('month'),
            db.func.avg(WeatherData.temp).label('avg_temp')
        ).filter(
            db.func.year(WeatherData.date) == year
        ).group_by('month').all()

        avg_min_temp = db.session.query(
            min_temp.c.month,
            db.func.avg(min_temp.c.temp).label('min_temp')
        ).group_by('month').order_by('month').all()

        avg_max_temp = db.session.query(
            max_temp.c.month,
            db.func.avg(max_temp.c.temp).label('max_temp')
        ).group_by('month').order_by('month').all()

        assert(len(avg_min_temp) == len(avg_max_temp) == len(avg_temp))

        for avg_row, min_row, max_row in zip(avg_temp, avg_min_temp, avg_max_temp):
            try:
                db.session.add(cls(
                    year,
                    min_row.month,
                    avg_row.avg_temp,
                    min_row.min_temp,
                    max_row.max_temp)
                )
                db.session.commit()
            except IntegrityError:
                db.session.rollback()

    @classmethod
    def get_for_year(cls, year):
        try:
            meta = MonthlyCacheMeta.query.filter_by(year=year).one()
            if meta.refresh <= date.today():
                cls.refresh(year)
                meta.update_refresh()
                db.session.add(meta)
                db.session.commit()
        except NoResultFound:
            cls.refresh(year)
            db.session.add(MonthlyCacheMeta(year))
            db.session.commit()

        return cls.query.filter_by(year=year).order_by('month')


class DailyCacheMeta(db.Model):
    __tablename__ = 'daily_cache_meta'

    year = db.Column(db.Integer, primary_key=True)
    month = db.Column(db.Integer, primary_key=True)
    refresh = db.Column(db.Date, primary_key=True)

    def __init__(self, year, month):
        self.year = year
        self.month = month
        self.refresh = datetime.today()

    def update_refresh(self):
        today = date.today()

        if today >= self.refresh:
            self.refresh = today + timedelta(days=1)


class MonthlyCacheMeta(db.Model):
    __tablename__ = 'monthly_cache_meta'

    year = db.Column(db.Integer, primary_key=True)
    refresh = db.Column(db.Date)

    def __init__(self, year):
        self.year = year
        self.update_refresh()

    def update_refresh(self):
        today = date.today()
        if self.year < today.year:
            self.refresh = date(MAXYEAR, 12, 31)
        else:
            self.refresh = today + timedelta(days=1)


class TextDocument(db.Model):
    __tablename__ = 'text'

    id = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.Text, nullable=False)


class FlatPage(db.Model):
    __tablename__ = 'flatpage'

    slug = db.Column(db.String(100), primary_key=True)
    menu_text = db.Column(db.String(100))
    menu_order = db.Column(db.Integer, default=0, nullable=False)
    width = db.Column(db.Integer, default=12, nullable=False)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(100))
    yandex_maps = db.Column(db.Boolean, default=False, nullable=False)
    text_id = db.Column(db.ForeignKey('text.id'), nullable=False)

    text_doc = db.relationship('TextDocument')

    @property
    def text_data(self):
        return self.text_doc.text

    @classmethod
    def get_by_slug(cls, slug):
        return cls.query.filter_by(slug=slug).one()


class YandexMap(db.Model):
    __tablename__ = 'yandex_map'

    id = db.Column(db.String(20), primary_key=True)
    width = db.Column(db.String(10))
    height = db.Column(db.String(10))
    center_lat = db.Column(db.Float, nullable=False)
    center_lng = db.Column(db.Float, nullable=False)
    placemark_lat = db.Column(db.Float, nullable=False)
    placemark_lng = db.Column(db.Float, nullable=False)
    zoom = db.Column(db.Integer, nullable=False)


class Settings(db.Model):
    __tablename__ = 'settings'

    name = db.Column(db.String(20), primary_key=True)
    value = db.Column(db.String(100), nullable=False)

    @classmethod
    def get(cls, name, default=''):
        value = db.session.query(cls.value).filter_by(name=name).scalar()
        if value is None:
            value = default
            db.session.add(cls(name=name, value=value))
            db.session.commit()
        return value

    @classmethod
    def set(cls, name, value):
        try:
            s = cls.query.filter_by(name=name).one()
            s.value = value
        except NoResultFound:
            s = cls(name, value=value)
        db.session.add(s)
        db.session.commit()
