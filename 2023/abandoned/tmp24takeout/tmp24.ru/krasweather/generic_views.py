# coding: utf-8
from datetime import date, datetime, timedelta
from flask import request, render_template, redirect, jsonify
from flask.views import MethodView

from .models import db, WeatherData, FlatPage


class BaseView(MethodView):
    pass


class TemplateMixin(object):
    template_name = None
    title = ''

    def get_template_name(self):
        return self.template_name

    def get_context_data(self, **kwargs):
        flatpages = FlatPage.query.filter(FlatPage.menu_text != None).order_by('menu_order')
        current_temp = db.session.query(
            db.func.round(db.func.avg(WeatherData.temp), 2)
        ).filter(
            WeatherData.date > datetime.now() - timedelta(minutes=10)
        ).order_by(db.desc(WeatherData.date)).scalar()

        last_update = WeatherData.query.order_by(db.desc(WeatherData.date)).first()

        context = kwargs
        context.update({
            'current_temp': current_temp,
            'last_update': last_update,
            'title': self.get_title(),
            'now': datetime.now(),
            'today': date.today(),
            'now': datetime.now(),
            'menu_flatpages': flatpages
        })
        return context

    def get_title(self):
        return self.title

    def render(self, **kwargs):
        context = self.get_context_data(**kwargs)
        return render_template(self.get_template_name(), **context)


class TemplateView(TemplateMixin, BaseView):
    def get(self, *args, **kwargs):
        return self.render(**kwargs)


class JsonView(BaseView):
    def get(self, *args, **kwargs):
        return self.render(**kwargs)

    def get_context_data(self, **kwargs):
        context = kwargs
        return context

    def render(self, **kwargs):
        context = self.get_context_data(**kwargs)
        return jsonify(**context)


class FormView(TemplateMixin, BaseView):
    form_class = None
    success_url = None

    def get_form(self, formdata=None):
        return self.form_class(formdata)

    def get(self, *args, **kwargs):
        form = self.get_form()
        return self.render(form=form)

    def post(self, *args, **kwargs):
        form = self.get_form(formdata=request.form)
        if form.validate():
            return self.form_valid(form)
        else:
            return self.form_invalid(form)

    def get_success_url(self, form):
        return self.success_url

    def form_valid(self, form):
        if hasattr(form, 'save'):
            form.save()
        return redirect(self.get_success_url(form))

    def form_invalid(self, form):
        return self.render(form=form)


class ListView(TemplateMixin, BaseView):
    model = None
    queryset = None
    context_object_name = None

    def get(self, *args, **kwargs):
        object_list = self.get_queryset()
        if self.context_object_name:
            kwargs = {
                self.context_object_name: object_list
            }
        else:
            kwargs = {
                'object_list': object_list
            }
        return self.render(**kwargs)

    def get_queryset(self):
        if self.model:
            return self.model.query.all()

        if self.queryset():
            return self.queryset()
