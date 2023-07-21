# Deploy on Fly

[Deploy app servers close to your users · Fly](https://fly.io/)

---

Start by updating the `fly.toml` file in the root of your project.

Then, if you haven't already, authenticate with [Fly](https://fly.io/docs/flyctl/)

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

Create and load your environment variables. Create a file in the root of your project called `fly.env`. You can base this on `example-production.env` (`cp example-production.env fly.env`). `fly.env` should already be ignored in your `.gitignore` file, but make sure, because we're about to put server secrets in it!

Note, you can generate a new `SECRET_KEY` by running the command `dev/generate-django-key`.

You'll need some S3-compatible service (might we suggest something not from Amazon such as [DigitalOcean's Spaces](https://www.digitalocean.com/products/spaces) or [MinIO](https://min.io/)?) to hold your SQLite streaming backups from [Litestream](https://litestream.io). Plug the appropriate values into your `fly.env` file in the `LITESTREAM_ACCESS_KEY_ID`, `LITESTREAM_SECRET_ACCESS_KEY`, and `S3_DB_URL` fields.

Once that's set up how you want it, load it into Fly

```sh
fly secrets import < fly.env
```

Deploy your app (we want "high availability" set to false because we want to run on a single machine and Fly defaults to starting two, which would make Litestream unhappy)

```sh
fly deploy --ha=false
```

Log in and create your a superuser account

```sh
fly ssh console
python manage.py createsuperuser
exit
```

You should be up and running! Now would be a good time to [purchase a license](https://hub.piep.works)! 😉

Let us know if you have questions or run into any problems! <blaze.horse@piepworks.com>
