from django.contrib import admin
from django.urls import include, path
from django.views.generic.base import TemplateView

urlpatterns = [
    # TODO: Remove this template and add your own.
    path(
        "", TemplateView.as_view(template_name="placeholder.html"), name="placeholder"
    ),
    # TODO: Change the `admin/` path to something custom.
    path("admin/", admin.site.urls),
    path("__debug__/", include("debug_toolbar.urls")),
    path("__reload__/", include("django_browser_reload.urls")),
]
