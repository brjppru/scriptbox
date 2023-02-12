# coding: utf-8
from flask.ext.assets import Bundle, Environment


styles = Bundle(
    'less/style.less',
    filters=['less', 'cleancss'],
    output='assets/style.css'
)


js = Bundle(
    'js/jquery.js',
    'js/bootstrap.js',
    'js/highcharts.js',
    'js/jquery.peity.js',
    'components/moment/moment.js',
    'js/moment.ru.js',
    'js/charts.js',
    'js/maps.js',
    filters=['uglifyjs'], output='assets/common.js'
)

ie_hacks = Bundle(
    'js/backgroundsize.htc',
    output='assets/backgroundsize.htc'
)


favicon = Bundle(
    'img/favicon.ico',
    output='assets/favicon.ico'
)

assets = Environment()


def init_assets(app):
    assets.init_app(app)
    assets.register('styles', styles)
    assets.register('js', js)
    assets.register('ie_hacks', ie_hacks)
    assets.register('favicon', favicon)
