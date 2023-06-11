#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys
from pathlib import Path


def main():
    """Run administrative tasks."""
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc

    try:
        import pip_lock
    except ModuleNotFoundError:
        raise ModuleNotFoundError(
            "Couldn't import pip-lock. Are you on the right virtualenv and up to date?"
        )
    requirements_path = str(Path(__file__).parent / "requirements/requirements.txt")
    pip_lock.check_requirements(
        requirements_path,
        post_text="\nRun the following:\n\ndev/update-venv\n",
    )

    execute_from_command_line(sys.argv)


if __name__ == "__main__":
    main()
