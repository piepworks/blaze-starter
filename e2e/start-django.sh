#!/usr/bin/env bash

if [[ $CREATE_USER && $CREATE_USER -eq "True" ]]; then
    if [[ $PLAYWRIGHT_USERNAME && $PLAYWRIGHT_PASSWORD ]]; then
        DJANGO_SUPERUSER_USERNAME=$PLAYWRIGHT_USERNAME \
        DJANGO_SUPERUSER_PASSWORD=$PLAYWRIGHT_PASSWORD \
        DJANGO_SUPERUSER_EMAIL=$PLAYWRIGHT_USERNAME \
        .venv/bin/python manage.py createsuperuser --noinput
    fi
fi

.venv/bin/python manage.py collectstatic --noinput
DEBUG=False .venv/bin/python manage.py runserver
