# Deploy on Fly

[Deploy app servers close to your users · Fly](https://fly.io/)

---

Create a `fly.toml` file in the root of your project

```toml
app = "your-app-name"
# Choose a region from:
# https://fly.io/docs/reference/regions/
primary_region = "your-region"
console_command = "/code/manage.py shell"

[env]
  PORT = "8000"

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

Create a `.dockerignore` file in the root of your project

```
fly.toml
.git/
*.sqlite*
.env
fly.env
node_modules/
.venv/
static/css/
```

Create a `Dockerfile` in the root of your project

```dockerfile
FROM python:3.11.4

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

# Install Litestream
RUN wget https://github.com/benbjohnson/litestream/releases/download/v0.3.8/litestream-v0.3.8-linux-amd64.deb \
    && dpkg -i litestream-v0.3.8-linux-amd64.deb

COPY requirements/requirements.txt /tmp/requirements.txt

RUN set -ex && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/

COPY . /code/

EXPOSE 8000

RUN npm i && npm run build

CMD ["/code/start.sh"]
```

Create a `start.sh` file in the root of your project

Make sure it's executable (`chmod +x start.sh`)

```shell
#!/usr/bin/env bash

if [[ -z "$DB_DIR" ]]; then
    echo "DB_DIR env var not specified - this should be a path of the directory where the database file should be stored"
    exit 1
fi
if [[ -z "$S3_DB_URL" ]]; then
    echo "S3_DB_URL env var not specified - this should be an S3-style URL to the location of the replicated database file"
    exit 1
fi

mkdir -p "$DB_DIR"

litestream restore -if-db-not-exists -if-replica-exists -o "$DB_DIR/db.sqlite" "$S3_DB_URL"

./manage.py collectstatic --noinput
./manage.py migrate --noinput
./manage.py createcachetable

chmod -R a+rwX /db

# Copy our Litestream config to the default location so we don't have to add a
# `-config` argument to every command.
mv /etc/litestream.yml /etc/litestream.yml-example
cp /code/litestream.yml /etc/litestream.yml

exec litestream replicate
```

Create a `litestream.yml` file in the root of your project

```yaml
exec: gunicorn --bind :8000 --workers 2 config.wsgi
dbs:
  - path: '$DB_DIR/db.sqlite'
    replicas:
      - url: '$S3_DB_URL'
```

If you haven't already, authenticate with Fly

```sh
fly auth login
```

Then set up your app on Fly

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

Create and load your environment variables. Create a file in the root of your project called `fly.env`. You can base this on `example-production.env` (`cp example-production.env fly.env`). `fly.env` should already be ignored in your `.gitignore` file, but make sure, because we're about to put server secrets in it!

Note, you can generate a new `SECRET_KEY` by running the command `dev/generate-django-key`.

You'll need some S3-compatible service (might we suggest something not from Amazon such as [DigitalOcean's Spaces](https://www.digitalocean.com/products/spaces) or [MinIO](https://min.io/)?) to hold your SQLite streaming backups from [Litestream](https://litestream.io). Plug the appropriate values into your `fly.env` file in the `LITESTREAM_ACCESS_KEY_ID`, `LITESTREAM_SECRET_ACCESS_KEY`, and `S3_DB_URL` fields.

Once that's set up how you want it, load it into Fly

```sh
fly secrets import < fly.env
```

Deploy your code

```sh
fly deploy
```

Log in and create your a superuser account

```sh
fly ssh console
python manage.py createsuperuser
exit
```

You should be up and running! Now would be a good time to [purchase a license](https://hub.piep.works)! 😉

Let us know if you have questions or run into any problems! <blaze.horse@piepworks.com>
