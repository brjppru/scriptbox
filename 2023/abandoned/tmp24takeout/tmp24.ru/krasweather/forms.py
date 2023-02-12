# coding: utf-8
from flask import abort, flash
from flask.ext.wtf import (
    DateField, DateTimeField, FloatField, IntegerField, Form,
    TextField, PasswordField, BooleanField, TextAreaField,
    Required, Optional, NumberRange, ValidationError
)
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm.exc import NoResultFound
from werkzeug.utils import cached_property
from wtforms.compat import iteritems

from .models import (
    db, AnonymousUser, User, HeartbeatData, WeatherData, TextDocument, FlatPage, YandexMap,
    Settings
)


class DataForm(Form):
    sensor_id = IntegerField(u'Sensor ID', validators=[Optional()])
    date = DateTimeField(u'Дата/Время:', validators=[Required(u'Укажите дату')])
    temp = FloatField(u'Температура:', validators=[Required(u'Укажите температуру')])

    def validate_temp(self, field):
        if field.data <= float(Settings.get('min_temp')) or field.data >= float(Settings.get('max_temp')):
            raise ValidationError(u'Температура выходит за рамки допустимых значений')

    def get_sensor_id(self):
        if self.sensor_id.data is None:
            sensor_id = 0
        else:
            sensor_id = self.sensor_id.data
        return sensor_id

    def save(self):
        sensor_id = self.get_sensor_id()

        data = WeatherData(
            sensor_id=sensor_id,
            date=self.date.data,
            temp=self.temp.data
        )
        db.session.add(data)

        try:
            db.session.commit()
        except IntegrityError:
            db.session.rollback()
            abort(400)

        db.session.add(HeartbeatData(
            sensor_id=sensor_id,
            date=self.date.data.date(),
            hour=self.date.data.hour
        ))
        try:
            db.session.commit()
        except IntegrityError:
            db.session.rollback()

        return data


class FilterForm(Form):
    day = DateField()
    sensor = IntegerField(validators=[Optional()])


class LoginForm(Form):
    username = TextField(u'Имя пользователя:', validators=[Required(u'Введите имя пользователя')])
    password = PasswordField(u'Пароль:', validators=[Required(u'Введите пароль')])
    remember = BooleanField(u'Запомнить меня на этом компьютере')

    @cached_property
    def user(self):
        try:
            return User.get_by_username(self.username.data)
        except NoResultFound:
            return AnonymousUser()

    def validate_password(self, field):
        if not self.user.check_password(field.data):
            raise ValidationError(u'Неправильный логин или пароль.')


class FlatPageForm(Form):
    slug = TextField(u'Slug', validators=[Required(u'Обязательное поле')])
    width = IntegerField(u'Ширина страницы',
                         validators=[Required(u'Укажите ширину страницы'),
                         NumberRange(1, 12, u'Ширина страницы может быть от 1 до 12')])
    menu_text = TextField(u'Пункт меню навигации')
    menu_order = IntegerField(u'Порядковый номер в меню')
    title = TextField(u'Заголовок', validators=[Required(u'Укажите заголовок страницы')])
    description = TextField(u'Описание')
    yandex_maps = BooleanField(u'Подключить Яндекс.Карты')
    text = TextAreaField(u'Текст страницы', validators=[Required(u'Страница не может быть пустой')])

    def populate_obj(self, obj):
        for name, field in iteritems(self._fields):
            if hasattr(obj, name):
                field.populate_obj(obj, name)

    def save(self, flatpage=None):
        if flatpage is None:
            txt = TextDocument(text=self.text.data)
            flatpage = FlatPage()
        else:
            txt = flatpage.text_doc
            txt.text = self.text.data

        db.session.add(txt)
        db.session.flush()
        self.populate_obj(flatpage)
        if not self.menu_text.data:
            flatpage.menu_text = None
        flatpage.text_id = txt.id
        db.session.add(flatpage)
        db.session.commit()
        return flatpage


class YandexMapForm(Form):
    id = TextField(u'ID контейнера карты', validators=[Required(u'Нужно указать ID контейнера')])
    width = TextField(u'Ширина', validators=[Required(u'Укажите ширину')])
    height = TextField(u'Высота', validators=[Required(u'Укажите высоту')])
    center_lat = FloatField(u'Широта', validators=[Required(u'Укажите широту центра карты')])
    center_lng = FloatField(u'Долгота', validators=[Required(u'Укажите долготу центра карты')])
    placemark_lat = FloatField(u'Широта', validators=[Required(u'Укажите широту для установки маркера на карте')])
    placemark_lng = FloatField(u'Долгота', validators=[Required(u'Укажите долготу для установки маркера на карте')])
    zoom = IntegerField(u'Масштаб', default=16, validators=[Required(u'Укажите масштаб')])

    def save(self, m=None):
        if m is None:
            m = YandexMap()
        self.populate_obj(m)
        db.session.add(m)
        db.session.commit()
        return m


class SettingsForm(Form):
    min = FloatField(u'Минимальная температура', validators=[Required(u'Укажите минимально допустимую температуру')])
    max = FloatField(u'Максимальная температура', validators=[Required(u'Укажите максимально допустимую температуру')])

    def save(self):
        Settings.set('min_temp', self.min.data)
        Settings.set('max_temp', self.max.data)
        flash(u'Настройки обновлены')
