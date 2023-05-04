#!/bin/bash

# This is to initially set up a project. You probably don't need to
# ever run it again.

# Set up reference to your project folder.
raw_folder=${PWD##*/} # Get the name of the current folder.
project_folder=${raw_folder//-/_} # Replace hyphens with underscores.

# Install Gum for nice interactive prompts and status indicators.
# https://charm.sh
# https://github.com/charmbracelet/gum
if ! command -v gum &> /dev/null; then
  brew install gum
fi

# Setup Python stuff
gum style --border normal --margin "1" --padding "0 2" --border-foreground 212 \
  "Installing $(gum style --foreground 212 'Python') goodies…"
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
gum style --border normal --margin "1" --padding "0 2" --border-foreground 212 \
  "Warming up $(gum style --foreground 212 'database') and $(gum style --foreground 212 'static files')…"
python manage.py collectstatic
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser

# Setup JS stuff
gum style --border normal --margin "1" --padding "0 2" --border-foreground 212 \
  "Installing $(gum style --foreground 212 'JavaScript') goodies…"
source $HOME/.nvm/nvm.sh
nvm install
npm install

# Start a new Git project
git init --initial-branch=main&&git add .&&git commit -m "New project from Piepwork's Django Starter."

# Explain next steps
gum format -- "# Next steps:" "source .venv/bin/activate" "./manage.py runserver"
