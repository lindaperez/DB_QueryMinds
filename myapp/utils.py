from django.contrib.auth.models import User

def get_auth_user(django_user):
    return django_user if isinstance(django_user, User) else None
