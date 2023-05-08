# Django Starter

A little [Piepworks](https://piep.works) project to bootstrap a new [Django](https://djangoproject.com) project.

- 🐍 Uses Django's built in [`django-admin` `template` option](https://docs.djangoproject.com/en/stable/ref/django-admin/#cmdoption-startapp-template).
- 🫥 Sets up [a custom User model](https://docs.djangoproject.com/en/stable/topics/auth/customizing/#auth-custom-user).
- 🎁 [pip-compile](https://pypi.org/project/pip-tools/) for easy dependency management.
- 🤹 [pre-commit](https://pre-commit.com) to keep your code clean and working properly.
- 🐎 One horsepower is all you need!
- 🤩 Inspired (and helped) by the works of these folks. Thank you!
  - [jefftriplett/django-startproject: Django Start Project template with batteries](https://github.com/jefftriplett/django-startproject)
  - [oliverandrich/django-poetry-startproject: Django startproject template with some poetry.](https://github.com/oliverandrich/django-poetry-startproject)
  - [adamchainz/django-startproject-templates](https://github.com/adamchainz/django-startproject-templates)

## Requirements

- [macOS](https://www.apple.com/macos/)
- [Homebrew](https://brew.sh)
- [Python version 3](https://www.python.org/downloads/)
- [Node Version Manager](https://github.com/nvm-sh/nvm)

## Installation

Replace `your-project` with whatever you want.

```shell
/bin/bash -c "$(curl -fsSL https://piep.works/scripts/django-starter)"
```

<details>
<summary>Here's what the <code>curl</code> flags mean if you're interested.</summary>
  <ul>
    <li><code>-f</code> = "Fail fast with no output at all on server errors."</li>
    <li><code>-s</code> = "Silent or quiet mode."</li>
    <li><code>-S</code> = "When used with -s, --silent, it makes curl show an error message if it fails."</li>
    <li><code>-L</code> = "If the server reports that the requested page has moved to a different location (indicated with a Location: header and a 3XX response code), this option will make curl redo the request on the new place."</li>
  </ul>
</details>
