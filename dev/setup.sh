#!/bin/bash

# This is to initially set up a project. You probably don't need to
# ever run it again.

# Allow exiting the script with ctrl+c
set -e

format_python_friendly () {
  # 1. Replace hyphens and spaces with underscores.
  # 2. Make it all lowercase
  echo "$1" | tr '-' '_' | tr ' ' '_' | tr '[:upper:]' '[:lower:]'
}

require () {
  # Allow exiting the loop with ctrl+c.
  set -e
  while true; do
    input=$(eval "$@")
    if [[ "$input" != "" ]]
    then
      echo "$input"
      break
    fi
  done
}

# Get (a version of) the name of the current folder
raw_folder=${PWD##*/} # Get the name of the current folder.
current_folder=$(format_python_friendly "$raw_folder")

# Install Gum for nice interactive prompts and status indicators.
# https://charm.sh
# https://github.com/charmbracelet/gum
if ! command -v gum &> /dev/null; then
  brew install gum
fi

export GUM_SPIN_SPINNER='line'
export GUM_SPIN_SHOW_OUTPUT=true
temp_name="$(require "gum input --prompt 'Enter a name for this project: ' --value='${current_folder}' --placeholder='${current_folder}'")"
PROJECT_NAME=$(format_python_friendly "$temp_name")
PROJECT_FOLDER="$(require "gum input --prompt 'Enter a project folder (leave as ‘.’ for the current folder): ' --value='.' --placeholder='.'")"
USERNAME="$(require "gum input --prompt 'Enter a username for the Django admin: ' --value '$(whoami)'")"
EMAIL="$(require "gum input --prompt 'Enter an email for this user: ' --placeholder 'you@example.com'")"
export DJANGO_SUPERUSER_PASSWORD="$(require "gum input --password --prompt 'Enter a password for this user: '")"

gum format -- \
  "## Project Settings" \
  "Project name   $(gum style --foreground 212 $PROJECT_NAME)" \
  "Project folder $(gum style --foreground 212 $PROJECT_FOLDER)" \
  "Username       $(gum style --foreground 212 $USERNAME)" \
  "Email address  $(gum style --foreground 212 $EMAIL)"

gum confirm "Does this look ok?" && echo -e "\n Here we go!" || exit 1

NEXT_STEP_ADDENDUM=""
if [ "${PROJECT_FOLDER}" != "." ]; then
  mkdir $PROJECT_FOLDER
  cd $PROJECT_FOLDER

  NEXT_STEP_ADDENDUM="cd $PROJECT_FOLDER"
fi

# Setup Python stuff
gum style --border normal --margin "1" --padding "0 2" --border-foreground 212 \
  "Installing $(gum style --foreground 212 'Python') goodies…"
gum spin --title "Setting up Python virtual environment" -- python3 -m venv --prompt . .venv
gum spin --title "Warming up virtual environment" -- .venv/bin/pip install -U pip setuptools wheel
source .venv/bin/activate
gum spin --title "Warming up virtual environment" -- python -m pip install pip-tools Django
gum spin --title "Installing Django Starter" -- django-admin startproject \
  --extension=ini,py,toml,yaml,yml \
  --template=https://github.com/piepworks/django-starter/archive/main.zip \
  $PROJECT_NAME .
gum spin --title "Installing Python dependencies" -- pip-compile --resolver=backtracking requirements/requirements.in
gum spin --title "Installing Python dependencies" -- python -m pip install -r requirements/requirements.txt

# Setup .env file
echo "SECRET_KEY=$(eval ./dev/generate-django-key)" >> .env
echo "DEBUG=True" >> .env
echo "ALLOWED_HOSTS=*" >> .env
echo "CSRF_TRUSTED_ORIGINS=http://localhost" >> .env
echo "DATABASE_URL=sqlite:///db.sqlite3" >> .env

# Warm up the database and static files
gum style --border normal --margin "1" --padding "0 2" --border-foreground 212 \
  "Warming up $(gum style --foreground 212 'database') and $(gum style --foreground 212 'static files')…"
gum spin --title "Collecting static files" -- python manage.py collectstatic
gum spin --title "Warming up the database" -- python manage.py makemigrations
gum spin --title "Warming up the database" -- python manage.py migrate
gum spin --title "Creating initial superuser account" -- python manage.py createsuperuser \
  --noinput --username=$USERNAME --email=$EMAIL

# Setup JS stuff
gum style --border normal --margin "1" --padding "0 2" --border-foreground 212 \
  "Installing $(gum style --foreground 212 'JavaScript') goodies…"
source $HOME/.nvm/nvm.sh
gum spin --title "Making sure we’re using the right version of Node" -- sleep 1&&nvm install
gum spin --title "Installing JavaScript dependencies" -- npm install

# Start a new Git project
git init --initial-branch=main&&git add .&&git commit -m "New project from Piepwork's Django Starter."
gum spin --title "Installing Git pre-commit hooks" -- pre-commit install

# Explain next steps
gum format -- \
  "## Next steps:" \
  "${NEXT_STEP_ADDENDUM}" \
  "source .venv/bin/activate" \
  "./manage.py runserver" \
  "## If you need to change your password:" \
  "./manage.py changepassword ${USERNAME}"
