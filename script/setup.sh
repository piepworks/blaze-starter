#!/bin/sh

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

# Setup JS stuff
source $HOME/.nvm/nvm.sh
nvm install
npm install

# Start a new Git project
git init --initial-branch=main&&git add .&&git commit -m "New project from Piepwork's Django Starter."
