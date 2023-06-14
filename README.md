# Blaze.horse — Django Starter Kit

<img src="https://blaze.horse/assets/icons/seahorse.svg" alt="Seahorse icon" width="200" height="200">

## Get your next [Django](https://www.djangoproject.com/start/overview/) project out the starting gate in a hurry!

Big tech thinks everyone needs to [build aircraft carriers](https://youtu.be/KrPsyr8Ig6M?t=841), but all you need is a horse.

From the makers of [Cassette Nest](https://cassettenest.com) and [Lists of Books](https://listsofbooks.com). We’ve distilled what we’ve learned, making all the little picky decisions so you don’t have to: just get to work on your project!

<details open>
  <summary><del>Batteries</del> <u>Reins and Saddle</u> included!</summary>
  <ul>
    <li>🐍 Uses Django’s built-in <a href="https://docs.djangoproject.com/en/stable/ref/django-admin/#cmdoption-startapp-template">django-admin --template option</a>.</li>
    <li>
      🫥 Sets up a custom User model.
      <ul>
        <li><a href="https://docs.djangoproject.com/en/stable/topics/auth/customizing/#using-a-custom-user-model-when-starting-a-project">“If you’re starting a new project, it’s highly recommended to set up a custom user model, even if the default User model is sufficient for you.”</a></li>
        <li>Email addresses are the usernames: the most sensible default!</li>
      </ul>
    </li>
    <li>🎁 <a href="https://pypi.org/project/pip-tools/">pip-compile</a> for easy dependency management.</li>
    <li>📐 <a href="https://pre-commit.com">pre-commit</a> to keep your code clean and working properly.</li>
    <li>🧪 <a href="https://pytest-django.readthedocs.io/en/latest/">pytest</a> for fast, easy-to-write tests.</li>
    <li>🫀 Sets you up to build <a href="https://developer.mozilla.org/en-US/docs/Glossary/Progressive_Enhancement">progressively-enhanced</a>, accessible websites and applications.</li>
  </ul>
</details>

<details>
  <summary>Free to try!</summary>
  <p>Only pay when you’re ready to launch your project! We want to make sure you get exactly what you need before money changes hands.</p>
</details>

<details>
  <summary>Local system requirements</summary>
  <ul>
    <li><a href="https://www.apple.com/macos/">macOS</a></li>
    <li><a href="https://brew.sh">Homebrew</a></li>
    <li><a href="https://www.python.org/downloads/">Python version 3</a></li>
    <li><a href="https://github.com/nvm-sh/nvm">Node Version Manager</a></li>
  </ul>
</details>

💌 [Sign up for the newsletter!](https://buttondown.email/blaze.horse/)

## Installation

Run the following command in your Terminal app.

```shell
/bin/bash -c "$(curl -fsSL https://blaze.horse/django-starter/install)"
```

[Here's the script that command runs.](https://github.com/piepworks/django-starter/blob/main/dev/setup.sh)

<details>
  <summary>Here's what the <code>curl</code> flags mean if you're interested.</summary>
  <ul>
    <li><code>-f</code> = "Fail fast with no output at all on server errors."</li>
    <li><code>-s</code> = "Silent or quiet mode."</li>
    <li><code>-S</code> = "When used with -s, --silent, it makes curl show an error message if it fails."</li>
    <li><code>-L</code> = "If the server reports that the requested page has moved to a different location (indicated with a Location: header and a 3XX response code), this option will make curl redo the request on the new place."</li>
  </ul>
</details>

## Demo Application

You can view a demo application built with this starter kit here: https://github.com/piepworks/blazehorse-demo

## 🤩 Inspired (and helped) by the works of these folks. Thank you!

- [jefftriplett/django-startproject: Django Start Project template with batteries](https://github.com/jefftriplett/django-startproject)
- [oliverandrich/django-poetry-startproject: Django startproject template with some poetry.](https://github.com/oliverandrich/django-poetry-startproject)
- [adamchainz/django-startproject-templates](https://github.com/adamchainz/django-startproject-templates)
