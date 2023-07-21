#!/bin/bash

# This is to initially set up a new project from the Blaze.horse — Django Starter Kit

# Check for arguments
VERSION="main"
while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--version)
      VERSION="$2"
      shift
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arguments
      shift
      ;;
  esac
done
set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters
# ----------------------
# End of arguments check

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

ADMIN_FOLDER_NAMES=("castle" "theoffice" "clubhouse" "batcave" "froghaven" "grotto" "headquarters")
ADMIN_FOLDER_NAME=${ADMIN_FOLDER_NAMES[ $RANDOM % ${#ADMIN_FOLDER_NAMES[@]} ]}

# Get (a version of) the name of the current folder
raw_folder=${PWD##*/} # Get the name of the current folder.
current_folder=$(format_python_friendly "$raw_folder")

# Make sure we have Homebrew intalled.
if ! command -v brew &> /dev/null; then
  gum format -- \
    "## Whoops!" \
    "Homebrew is required and you don’t seem to have it installed:" \
    "https://brew.sh"
  exit
fi

# Install Gum for nice interactive prompts and status indicators.
# https://charm.sh
# https://github.com/charmbracelet/gum
if ! command -v gum &> /dev/null; then
  brew install gum
fi

# Make sure we have NVM installed.
if [ ! -d "$HOME/.nvm/.git" ]; then
  gum format -- \
    "## Whoops!" \
    "NVM is required and you don’t seem to have it installed:" \
    "https://github.com/nvm-sh/nvm#installing-and-updating"
  exit
fi

# Ask a few questions to get going.
export GUM_SPIN_SPINNER='line'
export GUM_SPIN_SHOW_OUTPUT=true
temp_name="$(require "gum input --prompt 'Enter a name for this project: ' --value='${current_folder}' --placeholder='${current_folder}'")"
PROJECT_NAME=$(format_python_friendly "$temp_name")
PROJECT_FOLDER="$(gum input --prompt "Enter a project folder (leave blank to use the current folder, ${raw_folder}): " --placeholder='project-folder')"
EMAIL="$(require "gum input --prompt 'Enter an email for the Django admin: ' --placeholder 'you@example.com'")"
export DJANGO_SUPERUSER_PASSWORD="$(require "gum input --password --prompt 'Enter a password for this user: '")"
echo "What type of project is this?"
PROJECT_TYPE="$(require "gum choose 'Commercial' 'Personal'")"

if [ "${PROJECT_FOLDER}" == "" ]; then
  PROJECT_FOLDER=$raw_folder
  NEXT_STEP_ADDENDUM=""
else
  NEXT_STEP_ADDENDUM="cd $PROJECT_FOLDER"
  PROJECT_FOLDER_PATH="${raw_folder}/${PROJECT_FOLDER}"
fi

gum format -- \
  "## Project Settings" \
  "Project name   $(gum style --foreground 212 $PROJECT_NAME)" \
  "Project folder $(gum style --foreground 212 $PROJECT_FOLDER_PATH)" \
  "Email address  $(gum style --foreground 212 $EMAIL)" \
  "Project type   $(gum style --foreground 212 $PROJECT_TYPE)"

gum confirm "Does this look ok?" && echo -e "\n Here we go!" || exit 1

# Create a folder if needed
if [ "${PROJECT_FOLDER}" != "" ]; then
  mkdir $PROJECT_FOLDER
  cd $PROJECT_FOLDER
fi

# Setup Python stuff
gum style --border normal --margin "1" --padding "0 2" --border-foreground 212 \
  "Installing $(gum style --foreground 212 'Python') goodies…"
gum spin --title "Setting up Python virtual environment" -- python3 -m venv --prompt . .venv
gum spin --title "Warming up virtual environment" -- .venv/bin/pip install -U pip setuptools wheel
source .venv/bin/activate
gum spin --title "Warming up virtual environment" -- python -m pip install pip-tools Django
gum spin --title "Installing Django Starter Kit" -- django-admin startproject \
  --exclude=.git,__pycache__,.env \
  --template=https://github.com/piepworks/django-starter/archive/$VERSION.zip \
  $PROJECT_NAME .
gum spin --title "Installing Python dependencies" -- pip-compile --resolver=backtracking requirements/requirements.in
gum spin --title "Installing Python dependencies" -- python -m pip install -r requirements/requirements.txt

# Setup .env file
echo "SECRET_KEY=$(eval ./dev/generate-django-key)"                 >> .env
echo "DEBUG=True"                                                   >> .env
echo "ALLOWED_HOSTS=*"                                              >> .env
echo "CSRF_TRUSTED_ORIGINS=http://localhost"                        >> .env
echo "DATABASE_URL=sqlite:///db.sqlite3"                            >> .env
echo "ADMIN_URL=$ADMIN_FOLDER_NAME/"                                >> .env

# Setup e2e/playwright.env file
touch e2e/playwright.env
echo "PLAYWRIGHT_USERNAME=$EMAIL"                      > e2e/playwright.env
echo "PLAYWRIGHT_PASSWORD=$DJANGO_SUPERUSER_PASSWORD" >> e2e/playwright.env

# Append to pre-commit hooks
echo "      - id: playwright"             >> .pre-commit-config.yaml
echo "        name: Run Playwright"       >> .pre-commit-config.yaml
echo "        language: system"           >> .pre-commit-config.yaml
echo "        entry: npx playwright test" >> .pre-commit-config.yaml
echo "        files: \.(css|html|js)$"    >> .pre-commit-config.yaml
echo "        pass_filenames: false"      >> .pre-commit-config.yaml

# Delete files related to the starter kit project itself
# These have no meaning on a generated project
rm .github/workflows/blaze-*
rm dev/setup.sh # Local version of this file
rm dev/test-build* # Scripts for testing project generation

# Set up the right admin template for the kind of badge it should display
if [ "${PROJECT_TYPE}" == "Personal" ]; then
  rm templates/admin/base-commercial.html
  mv templates/admin/base-personal.html templates/admin/base.html
else
  rm templates/admin/base-personal.html
  mv templates/admin/base-commercial.html templates/admin/base.html
fi

# Warm up the database and static files
gum style --border normal --margin "1" --padding "0 2" --border-foreground 212 \
  "Warming up $(gum style --foreground 212 'database') and $(gum style --foreground 212 'static files')…"
gum spin --title "Collecting static files" -- python manage.py collectstatic
gum spin --title "Warming up the database" -- python manage.py makemigrations
gum spin --title "Warming up the database" -- python manage.py migrate
gum spin --title "Creating initial superuser account" -- python manage.py createsuperuser --noinput --email=$EMAIL

# Setup JS stuff
gum style --border normal --margin "1" --padding "0 2" --border-foreground 212 \
  "Installing $(gum style --foreground 212 'JavaScript') goodies…"
source $HOME/.nvm/nvm.sh
gum spin --title "Making sure we’re using the right version of Node" -- sleep 1&&nvm install
gum spin --title "Installing JavaScript dependencies" -- npm install
gum spin --title "Building PostCSS files" -- npm run build

# Start a new Git project
git init --initial-branch=main&&git add .&&git commit -m "New project from Blaze.horse — Django Starter Kit."
gum spin --title "Installing Git pre-commit hooks" -- pre-commit install

# Explain next steps
gum format -- \
  "## Next steps:" \
  "${NEXT_STEP_ADDENDUM}" \
  "source .venv/bin/activate" \
  "" \
  "./manage.py runserver" \
  "" \
  "…or, if you want to watch and build with PostCSS while running your dev server…" \
  "" \
  "npm run dev" \
  "" \
  "Log into your admin at 'http://127.0.0.1:8000/${ADMIN_FOLDER_NAME}'" \
  "You can change that URL (and other settings) in your .env file" \
  "## If you need to change your password:" \
  "./manage.py changepassword '${EMAIL}'" \
  "" \
  "## For instructions on how to deploy to Fly.io:" \
  "documentation/deployment/fly.md"
