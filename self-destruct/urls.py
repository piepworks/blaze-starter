from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    # TODO: Change the `admin/` path to something custom.
    path("admin/", admin.site.urls),
    path("__debug__/", include("debug_toolbar.urls")),
    path("__reload__/", include("django_browser_reload.urls")),
]
