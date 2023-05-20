# import pytest
from http import HTTPStatus


def test_favicon(client):
    response = client.get("/favicon.ico")
    assert response.status_code == HTTPStatus.OK
    assert response["Cache-Control"] == "max-age=86400, immutable, public"
