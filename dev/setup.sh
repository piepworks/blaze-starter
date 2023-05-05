#!/bin/bash

# This is to initially set up a project. You probably don't need to
# ever run it again.

# Set up reference to your project folder.
raw_folder=${PWD##*/} # Get the name of the current folder.
current_folder=${raw_folder//-/_} # Replace hyphens with underscores.

# Install Gum for nice interactive prompts and status indicators.
# https://charm.sh
# https://github.com/charmbracelet/gum
if ! command -v gum &> /dev/null; then
  brew install gum
fi

export GUM_SPIN_SPINNER='line'
export GUM_SPIN_SHOW_OUTPUT=true
echo -e "\n"
export PROJECT_NAME="$(gum input --prompt "Enter a name for this project (separate words with underscores): " --value="$(echo $current_folder)" --placeholder="$(echo $current_folder)")"
export PROJECT_FOLDER="$(gum input --prompt "Enter a project folder (leave as ‘.’ for the current folder): " --value="." --placeholder=".")"
export USERNAME="$(gum input --prompt "Enter a username for the Django admin: " --value "$(whoami)")"
export EMAIL="$(gum input --prompt "Enter an email for this user: " --placeholder "you@example.com")"
export DJANGO_SUPERUSER_PASSWORD="$(gum input --password --prompt "Enter a password for this user: ")"

gum format -- \
  "## Project Settings"\
  "Project name   $(gum style --foreground 212 $PROJECT_NAME)"\
  "Project folder $(gum style --foreground 212 $PROJECT_FOLDER)"\
  "Username       $(gum style --foreground 212 $USERNAME)"\
  "Email address  $(gum style --foreground 212 $EMAIL)"

gum confirm "Does this look ok?" &&\
  gum style --margin="2" "Here we go!" ||\
  gum style --margin="2" "Ok, let’s start over." && exit 1

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
  $PROJECT_NAME $PROJECT_FOLDER
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
  "./manage.py changepassword ${USERNAME}"
