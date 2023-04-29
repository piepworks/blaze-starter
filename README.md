# Django Starter

A little [Piepworks](https://piep.works) project.

## Requirements

- [macOS](https://www.apple.com/macos/)
- [Python version 3](https://www.python.org/downloads/)
- [Node Version Manager](https://github.com/nvm-sh/nvm)

## Installation

To get started:

```shell
script/bootstrap
```

### Next Steps

- Run `git add . && git commit -m 'Install django-starter.'`
- Generate a secret key: `script/generate-django-key`.
- Paste the key in your `.env` file as `SECRET_KEY`.

Add/adjust various things in `[project_folder]/settings.py`:

(Don’t forget to replace `[project_folder]` with your actual project folder’s name.)

```python
# Other stuff…
import os
from django.core.management.utils import get_random_secret_key
from dotenv import load_dotenv
import dj_database_url

# ----------------------------

# After `BASE_DIR` …

load_dotenv(BASE_DIR / ".env")

# ----------------------------

SECRET_KEY = os.environ.get("SECRET_KEY", default=get_random_secret_key())

DEBUG = int(os.environ.get("DEBUG", default=0))

ALLOWED_HOSTS = os.environ.get("ALLOWED_HOSTS").split(",")
CSRF_TRUSTED_ORIGINS = os.environ.get("CSRF_TRUSTED_ORIGINS").split(",")

# ----------------------------

INSTALLED_APPS = [
    "[project_name].core",
    "debug_toolbar",
    "django_browser_reload",
    # Other stuff…
]

# ----------------------------

MIDDLEWARE = [
    # Other stuff…
    "debug_toolbar.middleware.DebugToolbarMiddleware",
    "django_browser_reload.middleware.BrowserReloadMiddleware",
]

# ----------------------------

DATABASES = {
    "default": dj_database_url.parse(os.environ.get("DATABASE_URL"), conn_max_age=600),
}

AUTH_USER_MODEL = "core.User"

# ----------------------------

# After `STATIC_URL = "static/"` …
STATICFILES_DIRS = [BASE_DIR / "static"]
STATIC_ROOT = BASE_DIR / "staticfiles"

# ----------------------------

# At the very end of the file:

# Django Debug Toolbar

INTERNAL_IPS = ["127.0.0.1"]
```

### Warm up the database

Only run this after you’ve made the changes/additions to `settings.py`.

```shell
script/database-warmup
```

## To run the local server to work on things

For Django only:

```shell
script/start
```

For Django + Tailwind compilation:

```shell
npm run start
```

Note, you can safely ignore this warning ([it looks like it’ll be fixed eventually](https://github.com/tailwindlabs/tailwindcss/discussions/6694#discussioncomment-4716568)).

> Nested `@tailwind` rules were detected, but are not supported.
