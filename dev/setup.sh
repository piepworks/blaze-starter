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

export GUM_SPIN_SPINNER='line'
export GUM_SPIN_SHOW_OUTPUT=true
export USERNAME="$(gum input --prompt "Enter a username for the Django admin: " --value "$(whoami)")"
export EMAIL="$(gum input --prompt "Enter an email for the Django admin: " --placeholder "you@example.com")"
export DJANGO_SUPERUSER_PASSWORD="$(gum input --password --prompt "Enter a password for the Django admin: ")"

# Setup Python stuff
gum style --border normal --margin "1" --padding "0 2" --border-foreground 212 \
  "Installing $(gum style --foreground 212 'Python') goodies…"
gum spin --title "Set up Python virtual environment" -- python3 -m venv --prompt . .venv
gum spin --title "Warm up virtual environment" -- .venv/bin/pip install -U pip setuptools wheel
source .venv/bin/activate
gum spin --title "Warm up virtual environment" -- python -m pip install pip-tools Django
gum spin --title "Install Django Starter" -- django-admin startproject \
  --extension=ini,py,toml,yaml,yml \
  --template=https://github.com/piepworks/django-starter/archive/main.zip \
  $project_folder .
gum spin --title "Install Python dependencies" -- pip-compile --resolver=backtracking requirements/requirements.in
gum spin --title "Install Python dependencies" -- python -m pip install -r requirements/requirements.txt
gum spin --title "Install Python dependencies" -- pre-commit install

# Setup .env file
echo "SECRET_KEY=$(eval ./dev/generate-django-key)" >> .env
echo "DEBUG=True" >> .env
echo "ALLOWED_HOSTS=*" >> .env
echo "CSRF_TRUSTED_ORIGINS=http://localhost" >> .env
echo "DATABASE_URL=sqlite:///db.sqlite3" >> .env

# Warm up the database and static files
gum style --border normal --margin "1" --padding "0 2" --border-foreground 212 \
  "Warming up $(gum style --foreground 212 'database') and $(gum style --foreground 212 'static files')…"
gum spin --title "Collect static files" -- python manage.py collectstatic
gum spin --title "Database warmup" -- python manage.py makemigrations
gum spin --title "Database warmup" -- python manage.py migrate
gum spin --title "Create initial superuser account" -- python manage.py createsuperuser \
  --noinput --username=$USERNAME --email=$EMAIL

# Setup JS stuff
gum style --border normal --margin "1" --padding "0 2" --border-foreground 212 \
  "Installing $(gum style --foreground 212 'JavaScript') goodies…"
source $HOME/.nvm/nvm.sh
gum spin --title "Make sure we’re using the right version of Node" -- nvm install
gum spin --title "Install JavaScript dependencies" -- npm install

# Start a new Git project
git init --initial-branch=main&&git add .&&git commit -m "New project from Piepwork's Django Starter."

# Explain next steps
gum format -- \
  "## Next steps:"\
  "source .venv/bin/activate"\
  "./manage.py runserver"\
  "## If you need to change your password:"\
  "./manage.py changepassword $(echo $USERNAME)"
