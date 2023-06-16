# import pytest
from http import HTTPStatus


def test_favicon(client):
    response = client.get("/favicon.ico")
    assert response.status_code == HTTPStatus.OK
    assert response["Cache-Control"] == "max-age=86400, immutable, public"


def test_homepage(client, settings):
    settings.STORAGES = {
        "staticfiles": {
            "BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage"
        }
    }
    response = client.get("/")
    assert response.status_code == HTTPStatus.OK
