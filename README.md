# Django Starter

A little [Piepworks](https://piep.works) project.

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
import os
# Other stuff…
from django.core.management.utils import get_random_secret_key
from dotenv import load_dotenv
```

```python
# after BASE_DIR …

load_dotenv(BASE_DIR / ".env")
```

```python
SECRET_KEY = os.environ.get("SECRET_KEY", default=get_random_secret_key())
# …
DEBUG = int(os.environ.get("DEBUG", default=0))

ALLOWED_HOSTS = os.environ.get("ALLOWED_HOSTS").split(",")
CSRF_TRUSTED_ORIGINS = [os.environ.get("CSRF_TRUSTED_ORIGINS")]
```

```python
INSTALLED_APPS = [
    "[project_name].core",
    "debug_toolbar",
    "django_browser_reload",
    # Other stuff…
]
```

```python
MIDDLEWARE = [
    # Other stuff…
    "debug_toolbar.middleware.DebugToolbarMiddleware",
    "django_browser_reload.middleware.BrowserReloadMiddleware",
]
```

```python
DATABASES = {
    "default": dj_database_url.parse(os.environ.get("DATABASE_URL"), conn_max_age=600),
}
```

```python
AUTH_USER_MODEL = "core.User"

# Right before `AUTH_PASSWORD_VALIDATORS = [`
```

```python
# After `STATIC_URL = "static/"` …
STATICFILES_DIRS = [BASE_DIR / "static"]
STATIC_ROOT = BASE_DIR / "staticfiles"
```

At the very end of the file:

```python
# Django Debug Toolbar

INTERNAL_IPS = ["127.0.0.1"]
DEBUG_TOOLBAR_CONFIG = {
    # Un-comment to temporarily disable Django Debug Toolbar. Don't commit it.
    # "SHOW_TOOLBAR_CALLBACK": lambda r: False,
}
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
