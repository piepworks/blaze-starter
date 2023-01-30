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

```python
import os
# …
from django.core.management.utils import get_random_secret_key
from dotenv import load_dotenv

# after BASE_DIR …
load_dotenv(BASE_DIR / ".env")
```

```python
SECRET_KEY = os.environ.get("SECRET_KEY", default=get_random_secret_key())
```

```python
INSTALLED_APPS = [
    "[project_name].core",
    # Other stuff…
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

## To run the local server to work on things:

```shell
script/start
```
