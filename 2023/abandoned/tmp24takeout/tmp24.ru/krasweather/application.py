# coding: utf-8
import calendar
import json
import os
from datetime import date, datetime, timedelta
from itertools import groupby
from urlparse import urlparse

from flask import Flask, abort, url_for, request, redirect, flash, jsonify
from flask.ext.login import LoginManager, login_user, logout_user, current_user, login_required
from flask.ext.uploads import UploadSet, configure_uploads, patch_request_class, IMAGES
from sqlalchemy.orm.exc import NoResultFound

from .assets import init_assets
from .conf import settings
from .forms import DataForm, FilterForm, FlatPageForm, LoginForm, YandexMapForm, SettingsForm
from .generic_views import BaseView, TemplateView, JsonView, FormView
from .models import (
    db, init_db,
    WeatherData, WeatherForecast,
    HeartbeatData,
    AverageDailyTempCache, AverageMonthlyTempCache,
    AnonymousUser, User,
    FlatPage, YandexMap,
    Settings
)
from .sitemap import Sitemap, SitemapView
from .templates import init_templates, get_month_name


def init_logging(app):
    if not app.debug:
        import logging
        from logging.handlers import SMTPHandler
        mail_handler = SMTPHandler(app.config['EMAIL_HOST'],
                                   app.config['EMAIL_FROM'],
                                   app.config['ADMIN_EMAILS'], 'Application Error')
        mail_handler.setLevel(logging.ERROR)
        app.logger.addHandler(mail_handler)


def init_errorhandlers(app):
    @app.errorhandler(404)
    def page_not_found(error):
        view = PageNotFoundView.as_view('404')
        return (view(), 404)

    if not app.config['DEBUG']:
        @app.errorhandler(500)
        def internal_server_error(error):
            view = FailView.as_view('500')
            return (view(), 500)


# Some helper functions
def safe_int(value):
    """
    Converts passed value to integer. On error returns 0
    """

    try:
        return int(value)
    except (TypeError, ValueError):
        return 0


def is_safe_url(url):
    """
    Tests that passed url is safe to redirect.
    Used to prevent url spoofing attacks.
    """
    parsed_url = urlparse(url)
    return not parsed_url.netloc or parsed_url.netloc in app.config['TRUSTED_HOSTS']


def redirect_to_next():
    """
    Redirects user to page set in the request argument "next".
    """
    redirect_to = request.args.get('next', '/')
    if is_safe_url(redirect_to):
        return redirect(redirect_to)

    app.logging.warning(
        'Redirect to unknown host requested. '
        'Possible misconfiguration or brake in attempt. '
        'Please check TRUSTED_HOSTS setting. '
        'Redirecting to site root url.')

    return redirect('/')


def avg(iterable):
    return round(sum(iterable) / float(len(iterable)), 2)

# Init application
app = Flask(__name__)
app.config.from_object(settings)

# Init user authentication system
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'
login_manager.anonymous_user = AnonymousUser

# Init uploads

file_manager = UploadSet()
configure_uploads(app, file_manager)
patch_request_class(app, app.config['MAX_UPLOAD_SIZE'])

# Init flask extensions and logging
init_templates(app)
init_assets(app)
init_db(app)
init_logging(app)
init_errorhandlers(app)


# Add hook for user authentication system
@login_manager.user_loader
def load_user(userid):
    try:
        return User.get_by_username(userid)
    except NoResultFound:
        return None


def dayrange(start_date, days):
    for n in range(days):
        yield start_date - timedelta(n)


def get_timestamp(date_obj):
    return int(date_obj.strftime('%s')) * 1000


class MessageView(TemplateView):
    template_name = 'message.html'


class HomeView(TemplateView):
    template_name = 'home.html'
    title = u'Текущая температура {temp}°C.'

    def get_context_data(self, **kwargs):
        context = super(HomeView, self).get_context_data(**kwargs)
        context['title'] = self.title.format(temp=context['last_update'].temp)
        return context


class FailView(TemplateView):
    template_name = 'home.html'

    def get_context_data(self, **kwargs):
        class FakeData:
            date = datetime(1900, 1, 1)
            temp = 0
            sensor_id = 0

        context = super(FailView, self).get_context_data(**kwargs)
        context.update({
            'current': FakeData()
        })
        return context


class PageNotFoundView(TemplateView):
    template_name = '404.html'
    title = u'404 Страница не найдена'


class StatusView(TemplateView):
    title = u'Состояние системы за последние 24 дня.'
    template_name = 'status.html'

    def get_context_data(self, **kwargs):
        today = date.today()
        month_ago = today - timedelta(days=25)

        days = [day for day in dayrange(today, 25)]
        query = HeartbeatData.query.filter(
            HeartbeatData.date >= month_ago
        ).order_by(db.desc(HeartbeatData.date), HeartbeatData.hour)

        data = {}
        for k, g in groupby(query, lambda item: item.date):
            data[k] = [i.hour for i in g]

        context = super(StatusView, self).get_context_data(**kwargs)
        context.update({
            'days': days,
            'data': data
        })
        return context


class YearArchiveView(TemplateView):
    template_name = 'year_archive.html'

    def get_context_data(self, year, **kwargs):
        years = WeatherData.get_all_years()

        if not year in years:
            abort(404)

        data = AverageMonthlyTempCache.get_for_year(year)

        total = db.session.query(
            db.func.min(AverageMonthlyTempCache.avg_low).label('avg_low'),
            db.func.max(AverageMonthlyTempCache.avg_high).label('avg_high'),
            db.func.avg(AverageMonthlyTempCache.avg).label('avg')
        ).filter_by(year=year).group_by('year').one()

        self.title = u'Погода в Красноярске за {0} год.'.format(year)

        context = super(YearArchiveView, self).get_context_data(**kwargs)
        context.update({
            'year': year,
            'years': years,
            'months': [i.month for i in data],
            'min_temp': round(total.avg_low, 2),
            'max_temp': round(total.avg_high, 2),
            'avg_temp': round(total.avg, 2),
            'data': data,
            'kwargs': kwargs
        })
        return context


class MonthArchiveView(TemplateView):
    template_name = 'month_archive.html'

    def get_context_data(self, year, month, **kwargs):
        years = [row[0] for row in db.session.query(
            db.func.year(WeatherData.date)
        ).distinct().all()]

        if not year in years:
            abort(404)

        months = WeatherData.get_all_months(year)

        if not month in months:
            abort(404)

        days = WeatherData.get_all_days(year, month)

        data = AverageDailyTempCache.get_for_month(year, month)

        total = db.session.query(
            db.func.min(AverageDailyTempCache.avg_low).label('avg_low'),
            db.func.max(AverageDailyTempCache.avg_high).label('avg_high'),
            db.func.avg(AverageDailyTempCache.avg).label('avg')
        ).filter_by(year=year, month=month).one()

        self.title = u'Погода в красноярске за {month} {year} года.'.format(year=year, month=get_month_name(month))

        context = super(MonthArchiveView, self).get_context_data(**kwargs)
        context.update({
            'year': year,
            'month': month,
            'years': years,
            'months': months,
            'days': days,
            'data': data,
            'min_temp': round(total.avg_low, 2),
            'max_temp': round(total.avg_high, 2),
            'avg_temp': round(total.avg, 2),
            'kwargs': kwargs,
            'monthrange': calendar.monthrange(year, month)
        })
        return context


class DayArchiveView(TemplateView):
    template_name = 'day_archive.html'

    def get_context_data(self, year, month, day, **kwargs):
        years = [row[0] for row in db.session.query(
            db.func.year(WeatherData.date)
        ).distinct().all()]

        if not year in years:
            abort(404)

        months = WeatherData.get_all_months(year)

        if not month in months:
            abort(404)

        days = WeatherData.get_all_days(year, month)

        if not day in days:
            abort(404)

        data = db.session.query(
            db.func.hour(WeatherData.date),
            db.func.round(db.func.avg(WeatherData.temp))
        ).filter(
            db.func.year(WeatherData.date) == year,
            db.func.month(WeatherData.date) == month,
            db.func.day(WeatherData.date) == day
        ).group_by(
            db.func.hour(WeatherData.date)
        )

        total = db.session.query(
            db.func.min(WeatherData.temp),
            db.func.max(WeatherData.temp),
            db.func.avg(WeatherData.temp)
        ).filter(
            db.func.year(WeatherData.date) == year,
            db.func.month(WeatherData.date) == month,
            db.func.day(WeatherData.date) == day
        )

        self.title = u'Погода в Красноярске за {day}.{month}.{year} года.'.format(year=year, month=month, day=day)

        context = super(DayArchiveView, self).get_context_data(**kwargs)
        context.update({
            'year': year,
            'month': month,
            'day': day,
            'years': years,
            'months': months,
            'days': days,
            'data': data,
            'min_temp': round(total[0][0], 2),
            'max_temp': round(total[0][1], 2),
            'avg_temp': round(total[0][2], 2),
            'kwargs': kwargs,
            'monthrange': calendar.monthrange(year, month)
        })
        return context


class TodayTempView(JsonView):
    def get_context_data(self, **kwargs):
        now = datetime.now()
        then = now - timedelta(hours=24)

        q = db.session.query(
            WeatherData.date,
            db.func.round(db.func.avg(WeatherData.temp), 2)
        ).filter(
            WeatherData.date >= then
        ).group_by(
            db.func.date(WeatherData.date),
            db.func.hour(WeatherData.date)
        ).order_by(
            db.desc(WeatherData.date)
        ).all()

        forecast_data = db.session.query(
            WeatherForecast
        ).filter(
            WeatherForecast.date >= then
        ).all()

        # Hack to align forecast and hourly temp graphs
        if forecast_data and q:
            forecast_data[0].date = q[0].date
            forecast_data[-1].date = q[-1].date

        q.reverse()

        temp_data = [d[1] for d in q]

        return {
            'data': [
                [
                    get_timestamp(row[0]),
                    row[1]
                ] for row in q
            ],
            'forecast': [
                [
                    get_timestamp(row.date),
                    row.temp
                ] for row in forecast_data
            ],
            'min': min(temp_data),
            'max': max(temp_data),
            'avg': avg(temp_data)
        }


class WeekTempView(JsonView):
    def get_context_data(self, **kwargs):
        now = datetime.now()
        then = now - timedelta(days=7)

        weather_data = db.session.query(
            WeatherData.date,
            db.func.round(db.func.avg(WeatherData.temp), 2)
        ).filter(
            WeatherData.date >= then
        ).group_by(
            db.func.date(WeatherData.date),
            db.func.day(WeatherData.date)
        ).order_by(
            WeatherData.date
        ).offset(1)

        forecast_data = db.session.query(
            WeatherForecast.date,
            db.func.round(db.func.avg(WeatherForecast.temp), 2)
        ).filter(
            WeatherForecast.date >= then
        ).group_by(
            db.func.date(WeatherForecast.date),
            db.func.day(WeatherForecast.date)
        ).order_by(
            WeatherForecast.date
        )[:-1]

        temp_data = [d[1] for d in weather_data]

        return {
            'data': [
                [get_timestamp(row[0]), row[1]] for row in weather_data
            ],
            'forecast': [
                [get_timestamp(row[0]), row[1]] for row in forecast_data
            ],
            'min': min(temp_data),
            'max': max(temp_data),
            'avg': avg(temp_data)
        }


class YearTempView(JsonView):
    def get_context_data(self, year, **kwargs):
        years = WeatherData.get_all_years()
        today = date.today()

        filters = [db.func.year(WeatherForecast.date) == year]
        if year == today.year:
            filters.append(db.func.month(WeatherForecast.date) <= today.month)

        if not year in years:
            abort(404)

        weather_data = AverageMonthlyTempCache.get_for_year(year)

        forecast_data = db.session.query(
            db.func.month(WeatherForecast.date),
            db.func.avg(WeatherForecast.temp)
        ).filter(
            *filters
        ).group_by(
            db.func.month(WeatherForecast.date)
        )

        avg = []
        low = []
        high = []

        for row in weather_data:
            avg.append([row.month, round(row.avg, 2)])
            low.append([row.month, round(row.avg_low, 2)])
            high.append([row.month, round(row.avg_high, 2)])

        return {
            'avg': avg,
            'low': low,
            'high': high,
            'forecast': [[row[0], round(row[1], 2)] for row in forecast_data]
        }


class MonthTempView(JsonView):
    def get_context_data(self, year, month, **kwargs):
        years = [row[0] for row in db.session.query(
            db.func.year(WeatherData.date)
        ).distinct().all()]

        if not year in years:
            abort(404)

        months = WeatherData.get_all_months(year)

        if not month in months:
            abort(404)

        weather_data = AverageDailyTempCache.get_for_month(year, month)

        forecast_data = db.session.query(
            db.func.day(WeatherForecast.date),
            WeatherForecast.temp
        ).filter(
            db.func.year(WeatherForecast.date) == year,
            db.func.month(WeatherForecast.date) == month
        ).group_by(
            db.func.day(WeatherForecast.date)
        )

        avg = []
        low = []
        high = []

        for row in weather_data:
            avg.append([row.day, round(row.avg, 2)])
            low.append([row.day, round(row.avg_low, 2)])
            high.append([row.day, round(row.avg_high, 2)])

        return {
            'avg': avg,
            'low': low,
            'high': high,
            'forecast': [[row[0], round(row[1], 2)] for row in forecast_data]
        }


class DayTempView(JsonView):
    def get_context_data(self, year, month, day, **kwargs):

        years = [row[0] for row in db.session.query(
            db.func.year(WeatherData.date)
        ).distinct().all()]

        if not year in years:
            abort(404)

        months = WeatherData.get_all_months(year)

        if not month in months:
            abort(404)

        days = WeatherData.get_all_days(year, month)

        if not day in days:
            abort(404)

        weather_data = db.session.query(
            db.func.hour(WeatherData.date),
            db.func.avg(WeatherData.temp)
        ).filter(
            db.func.year(WeatherData.date) == year,
            db.func.month(WeatherData.date) == month,
            db.func.day(WeatherData.date) == day
        ).group_by(
            db.func.hour(WeatherData.date)
        )

        forecast_temp = db.session.query(WeatherForecast.temp).filter_by(
            date=date(year, month, day)
        ).scalar()

        if forecast_temp:
            forecast_temp = round(forecast_temp, 2)

        return {
            'data': [
                [row[0], round(row[1], 2)] for row in weather_data
            ],
            'forecast': [
                [row[0], forecast_temp] for row in weather_data
            ]
        }


class DataView(FormView):
    template_name = 'data_form.html'
    form_class = DataForm
    success_url = '/data/'


class QueryView(TemplateView):
    template_name = 'query.html'

    def get_context_data(self, **kwargs):
        context = super(QueryView, self).get_context_data(**kwargs)
        query = WeatherData.query

        filter_form = FilterForm(request.args)
        if filter_form.validate():
            query = query.filter(db.func.date(WeatherData.date) == filter_form.day.data)
            if not filter_form.sensor.data is None:
                query = query.filter_by(sensor_id=filter_form.sensor.data)

        context['data'] = query
        return context


class LoginView(FormView):
    template_name = 'login_form.html'
    form_class = LoginForm
    title = u'Вход в систему'

    def form_valid(self, form):
        login_user(form.user, remember=form.remember.data)
        return redirect_to_next()


class LogoutView(BaseView):
    def get(self):
        logout_user()
        return redirect_to_next()


class FlatPageFormView(FormView):
    decorators = [login_required]
    template_name = 'flatpages/flatpage_form.html'
    form_class = FlatPageForm
    success_url = '/'
    form_defaults = {
        'width': 12,
        'menu_order': 0
    }

    def get_flatpage(self):
        if self.slug:
            return FlatPage.query.filter_by(slug=self.slug).first()
        else:
            return None

    def get_form(self, formdata=None):
        obj = self.get_flatpage()
        if obj is None:
            if self.slug:
                self.form_defaults['slug'] = self.slug
            return self.form_class(formdata, **self.form_defaults)
        else:
            return self.form_class(formdata, obj=obj, text=obj.text_data)

    def dispatch_request(self, slug=None):
        if slug:
            self.slug = slug
        elif 'slug' in request.args:
            self.slug = request.args['slug']

        return super(FlatPageFormView, self).dispatch_request(self, slug)

    def form_valid(self, form):
        flatpage = form.save(self.get_flatpage())
        return redirect(url_for('flatpage', slug=flatpage.slug))


class FlatPageView(TemplateView):
    template_name = 'flatpages/flatpage_detail.html'

    def get(self, slug):
        try:
            self.flatpage = FlatPage.get_by_slug(slug)
        except NoResultFound:
            if current_user.is_authenticated():
                return redirect(url_for('create_flatpage', slug=slug))
            else:
                abort(404)
                # return ''
        return super(FlatPageView, self).get()

    def get_context_data(self, **kwargs):
        context = super(FlatPageView, self).get_context_data(**kwargs)
        offset = (12 - self.flatpage.width) / 2
        context.update({
            'title': self.flatpage.title,
            'description': self.flatpage.description,
            'flatpage': self.flatpage,
            'offset': offset
        })
        return context


class YandexMapFormView(FormView):
    decorators = [login_required]
    template_name = 'yandex_map_form.html'
    form_class = YandexMapForm
    map = None

    def dispatch_request(self, id=None):
        if id:
            try:
                self.map = YandexMap.query.filter_by(id=id).one()
            except NoResultFound:
                abort(404)
        return super(YandexMapFormView, self).dispatch_request()

    def get_title(self):
        if self.map is None:
            return u'Создание карты'
        else:
            return u'Редактирование карты'

    def get_form(self, formdata=None):
        return self.form_class(formdata, obj=self.map)

    def form_valid(self, form):
        m = form.save(self.map)
        flash(u'Карта успешно сохранена')
        return redirect(url_for('update_map', id=m.id))


class SettingsFormView(FormView):
    decorators = [login_required]
    template_name = 'settings.html'
    form_class = SettingsForm
    title = u'Настройки сайта'
    success_url = 'settings'

    def get_form(self, formdata=None):
        class Init(object):
            def __init__(self):
                self.min = Settings.get('min_temp', -60)
                self.max = Settings.get('max_temp', 55)
        return self.form_class(formdata, obj=Init())


class YandexMapJsonView(JsonView):
    def get_context_data(self, **kwargs):
        try:
            m = YandexMap.query.filter_by(id=kwargs['id']).one()
        except NoResultFound:
            abort(404)
        return {
            'width': m.width,
            'height': m.height,
            'center_lat': m.center_lat,
            'center_lng': m.center_lng,
            'placement_lat': m.placemark_lat,
            'placement_lng': m.placemark_lng,
            'zoom': m.zoom
        }


class FileUploadJsonView(BaseView):
    decorators = [login_required]

    def post(self):
        if (request.files['file']):
            filename = file_manager.save(request.files['file'])
        return jsonify({'filelink': file_manager.url(filename)})


class ImageListJsonView(BaseView):
    decorators = [login_required]

    def get(self):
        images = []
        files = os.listdir(file_manager.config.destination)
        for f in files:
            _, ext = os.path.splitext(f)
            if ext[1:] in IMAGES:
                image_url = file_manager.url(f)
                images.append({
                    "thumb": image_url,
                    "image": image_url
                })
        return (json.dumps(images), 200, {'Content-Type': 'application/json'})


class GenericSitemap(Sitemap):
    def items(self):
        return [
            {'location': '/'},
            {'location': '/status/'},
            {'location': '/about/'}
        ]


class YearArchiveSitemap(Sitemap):
    def items(self):
        years = WeatherData.get_all_years()
        return [{
            'location': url_for('year_archive', year=year)
        } for year in years]


class MonthArchiveSitemap(Sitemap):
    def items(self):
        years = WeatherData.get_all_years()
        items = []
        for year in years:
            items.extend([{
                'location': url_for('month_archive', year=year, month=month)
            } for month in WeatherData.get_all_months(year)])
        return items


class DayArchiveSitemap(Sitemap):
    def items(self):
        years = WeatherData.get_all_years()
        items = []
        for year in years:
            months = WeatherData.get_all_months(year)

            for month in months:
                days = WeatherData.get_all_days(year, month)

                items.extend([{
                    'location': url_for('day_archive', year=year, month=month, day=day)
                } for day in days])
        return items


sitemaps = {
    'generic': GenericSitemap(),
    'year_archive': YearArchiveSitemap(),
    'month_archive': MonthArchiveSitemap()
}

# Standard pages
app.add_url_rule('/', view_func=HomeView.as_view('home'))
app.add_url_rule('/404/', view_func=PageNotFoundView.as_view('404'))
app.add_url_rule('/archive/<int:year>/', view_func=YearArchiveView.as_view('year_archive'))
app.add_url_rule('/archive/<int:year>/<int:month>/', view_func=MonthArchiveView.as_view('month_archive'))
app.add_url_rule('/archive/<int:year>/<int:month>/<int:day>/', view_func=DayArchiveView.as_view('day_archive'))
app.add_url_rule('/fail/', view_func=FailView.as_view('fail'))
app.add_url_rule('/data/', view_func=DataView.as_view('data'))
app.add_url_rule('/map/create/', view_func=YandexMapFormView.as_view('create_map'))
app.add_url_rule('/map/<id>/', view_func=YandexMapJsonView.as_view('map_json'))
app.add_url_rule('/map/<id>/edit/', view_func=YandexMapFormView.as_view('update_map'))
app.add_url_rule('/message/', view_func=MessageView.as_view('message'))
app.add_url_rule('/login/', view_func=LoginView.as_view('login'))
app.add_url_rule('/logout/', view_func=LogoutView.as_view('logout'))
app.add_url_rule('/query/', view_func=QueryView.as_view('query'))
app.add_url_rule('/settings/', view_func=SettingsFormView.as_view('settings'))
app.add_url_rule('/sitemap.xml', view_func=SitemapView.as_view('sitemap'), defaults={'sitemaps': sitemaps})
app.add_url_rule('/status/', view_func=StatusView.as_view('status'))
app.add_url_rule('/flatpages/create/', view_func=FlatPageFormView.as_view('create_flatpage'))
app.add_url_rule('/<slug>/', view_func=FlatPageView.as_view('flatpage'))
app.add_url_rule('/<slug>/edit/', view_func=FlatPageFormView.as_view('update_flatpage'))
app.add_url_rule('/upload/', view_func=FileUploadJsonView.as_view('redactor_upload'))
app.add_url_rule('/redactor/images/', view_func=ImageListJsonView.as_view('redactor_images'))

# Ajax Views
app.add_url_rule('/today/', view_func=TodayTempView.as_view('today'))
app.add_url_rule('/week/', view_func=WeekTempView.as_view('week'))
app.add_url_rule('/year/<int:year>/', view_func=YearTempView.as_view('year'))
app.add_url_rule('/year/<int:year>/<int:month>/', view_func=MonthTempView.as_view('month'))
app.add_url_rule('/year/<int:year>/<int:month>/<int:day>/', view_func=DayTempView.as_view('day'))
