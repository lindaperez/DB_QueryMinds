"""
Test-only settings.

Runs the test suite against an in-memory SQLite database so the suite does not
require the Cloud SQL proxy / MySQL to be running. Everything else is inherited
from the normal settings module.
"""
from .settings import *  # noqa: F401,F403

# Fast, isolated, throwaway database for tests.
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
    }
}

# Capture password-reset emails in memory instead of trying to reach an SMTP server.
EMAIL_BACKEND = 'django.core.mail.backends.locmem.EmailBackend'

# Speed up password hashing in tests.
PASSWORD_HASHERS = ['django.contrib.auth.hashers.MD5PasswordHasher']