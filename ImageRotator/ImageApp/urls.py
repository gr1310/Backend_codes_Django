from django.urls import re_path
from ImageApp import views

from django.conf.urls.static import static
from django.conf import settings
urlpatterns=[
    re_path(r'^images/$', views.imageApi),
    re_path(r'^images/([0-9]+)$', views.imageApi),
    re_path(r'^images/savefile', views.SaveFile)
]+static(settings.MEDIA_URL,document_root=settings.MEDIA_ROOT)