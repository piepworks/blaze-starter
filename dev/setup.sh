#!/bin/bash

# This is to initially set up a project. You probably don't need to
# ever run it again.

raw_folder=${PWD##*/} # Get the name of the current folder.
project_folder=${raw_folder//-/_} # Replace hyphens with underscores.

# Setup Python stuff
python3 -m venv --prompt . .venv
.venv/bin/pip install -U pip setuptools wheel
source .venv/bin/activate
python -m pip install pip-tools Django
django-admin startproject \
  --extension=ini,py,toml,yaml,yml \
  --template=https://github.com/piepworks/django-starter/archive/main.zip \
  $project_folder .
pip-compile --resolver=backtracking requirements/requirements.in
python -m pip install -r requirements/requirements.txt
pre-commit install

# Setup .env file
echo "SECRET_KEY=$(eval ./dev/generate-django-key)" >> .env
echo "DEBUG=True" >> .env
echo "ALLOWED_HOSTS=*" >> .env
echo "CSRF_TRUSTED_ORIGINS=http://localhost" >> .env
echo "DATABASE_URL=sqlite:///db.sqlite3" >> .env

# Warm up the database and static files
python manage.py collectstatic
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser

# Setup JS stuff
source $HOME/.nvm/nvm.sh
nvm install
npm install

# Start a new Git project
git init --initial-branch=main&&git add .&&git commit -m "New project from Piepwork's Django Starter."

# Explain next steps
echo -e "\nNow run these commands:\n\nsource .venv/bin/activate\n./manage.py runserver"
