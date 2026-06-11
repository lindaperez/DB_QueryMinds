"""
WSGI config for query_minds_project_web_app project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.1/howto/deployment/wsgi/
"""

import os
from pathlib import Path

from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'query_minds_project_web_app.settings')
from dotenv import load_dotenv

# App-level .env first, then the project-root .env (outside the git repo) where
# real secrets like EMAIL_HOST_PASSWORD live. On App Engine the root file is
# absent, so prod must supply these via Secret Manager / env vars instead.
load_dotenv()
load_dotenv(Path(__file__).resolve().parent.parent.parent / '.env', override=False)
application = get_wsgi_application()
