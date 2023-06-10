# Deploy on Fly

[Deploy app servers close to your users · Fly](https://fly.io/)

---

Create a `fly.toml` file in the root of your project.

```toml
app = "your-app-name"
# Choose a region from:
# https://fly.io/docs/reference/regions/
primary_region = "your-region"
console_command = "/code/manage.py shell"

[env]
  PORT = "8000"

[[mounts]]
  source = "storage"
  destination = "/mnt/storage"

[http_service]
  internal_port = 8000
  force_https = true
  auto_stop_machines = false
  auto_start_machines = true
  min_machines_running = 0

[[statics]]
  guest_path = "/code/static"
  url_prefix = "/static/"
```

Create a `.dockerignore` file in the root of your project.

```
fly.toml
.git/
*.sqlite3
.env
fly.env
node_modules/
.venv/
```

Create a `Dockerfile` in the root of your project.

```dockerfile
FROM python:3.11.3

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /code

WORKDIR /code

# install Git and Node
RUN apt-get update && \
    apt-get install -y git && \
    apt-get remove nodejs npm && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash && \
    apt-get install -y nodejs

COPY requirements/requirements.txt /tmp/requirements.txt

RUN set -ex && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/

COPY . /code/

EXPOSE 8000

CMD ["/bin/bash", "-c", "npm i; npm run build; python manage.py collectstatic --noinput; python manage.py migrate --noinput; gunicorn --bind :8000 --workers 2 config.wsgi"]
```

If you haven't already, authenticate with Fly.

```sh
fly auth login
```

Then set up your app on Fly.

```sh
fly launch
```

It'll now ask a few questions:

- Answer **Y** when it asks “Would you like to copy its configuration to the new app?”
- Answer **N** when it asks to overwrite your `.dockerignore`
- Answer **N** when it asks to overwrite your `Dockerfile`
- Answer **N** when it asks to set up PostgreSQL
- Answer **N** when it asks to set up Upstash Redis

Assuming you customized the app name, you should next be able to accept that “default.”

Create and load your environment variables. Create a file in the root of your project called `fly.env`. You can base this on `example-production.env`. `fly.env` should already be ignored in your `.gitignore` file, but make sure, because we're about to put server secrets in it!

Note, you can generate a new `SECRET_KEY` by running the command `dev/generate-django-key`.

Once that's set up how you want it, load it into Fly.

```sh
fly secrets import < fly.env
```

Persistent storage for your SQLite database should be set up for you automatically based on the settings you already pasted in.

Deploy your code.

```sh
fly deploy
```

Log in and create your a superuser account.

```sh
fly ssh console
python manage.py createsuperuser
exit
```

You should be up and running! Now would be a good time to [purchase a license](https://hub.piep.works)! 😉

Let us know if you have questions or run into any problems! <blaze.horse@piepworks.com>
