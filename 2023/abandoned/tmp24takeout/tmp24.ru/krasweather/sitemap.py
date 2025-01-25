# coding: utf-8
import urlparse
from flask import make_response, request
from .generic_views import TemplateView


class SitemapView(TemplateView):
    template_name = 'sitemap.xml'

    def get_context_data(self, **kwargs):
        context = super(SitemapView, self).get_context_data(**kwargs)
        context.update({
            'urls': self.get_urls(kwargs['sitemaps'])
        })
        return context

    def get_urls(self, sitemaps):
        maps = sitemaps.values()

        urls = []
        for site in maps:
            urls.extend(site.get_urls())
        return urls

    def render(self, **kwargs):
        response = make_response(super(TemplateView, self).render(**kwargs))
        response.mimetype='application/xml'
        return response


class Sitemap(object):
    def items(self):
        return []

    def get_urls(self):
        url_root = request.url_root

        urls = []
        for item in self.items():
            loc = urlparse.urljoin(url_root, item.get('location'))

            priority = item.get('priority', None)
            url_info = {
                'item':       item,
                'location':   loc,
                'lastmod':    item.get('lastmod', None),
                'changefreq': item.get('changefreq', None),
                'priority':   str(priority is not None and priority or ''),
            }
            urls.append(url_info)
        return urls
