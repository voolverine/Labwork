from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'),
    url(r'^search_request/$', views.search, name='search'),
    url(r'^edit/$', views.edit, name='edit'),
    url(r'^edit/add_index_request/$', views.add_to_index, name='add_to_index'),
    url(r'^urls/$', views.urls, name='urls'),
    url(r'^urls/request/$', views.urls_request, name='urls_requests'),
    url(r'^index/$', views.index_table, name='index_table'),
]
