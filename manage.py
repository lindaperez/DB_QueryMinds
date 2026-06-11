#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
from pathlib import Path
from dotenv import load_dotenv

# Load the app-level .env (DB_*, OPENAI_API_KEY) found by walking up from cwd,
# then layer in the project-root .env that lives OUTSIDE the git repo. The root
# file is the home for real secrets (e.g. EMAIL_HOST_PASSWORD) since it can't be
# committed. override=False keeps app-level values authoritative on any overlap.
load_dotenv()
load_dotenv(Path(__file__).resolve().parent.parent / '.env', override=False)

import sys


def main():
    """Run administrative tasks."""
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'query_minds_project_web_app.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    main()
