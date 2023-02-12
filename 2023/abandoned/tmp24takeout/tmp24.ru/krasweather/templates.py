# coding: utf-8


def get_month_name(month):
    months = (
        u'Январь',
        u'Февраль',
        u'Март',
        u'Апрель',
        u'Май',
        u'Июнь',
        u'Июль',
        u'Август',
        u'Сентябрь',
        u'Октябрь',
        u'Ноябрь',
        u'Декабрь'
    )
    return months[month - 1]


def half(data):
    length = len(data)
    if length % 2:
        length += 1
    return int(length / 2)


def startswith(string, prefix):
    return string.startswith(prefix)


def format_datetime(value, format='%c'):
    return value.strftime(format)


def format_date(value, format='%d.%m.%Y'):
    return format_datetime(value, format)


def init_templates(app):
    app.jinja_env.tests['startswith'] = startswith

    app.jinja_env.filters['datetime'] = format_datetime
    app.jinja_env.filters['date'] = format_date
    app.jinja_env.filters['month_name'] = get_month_name
    app.jinja_env.filters['half'] = half
