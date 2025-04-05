from myapp.models.auth_user import AuthUser
from django.contrib.auth.models import User

def get_auth_user(django_user):
    try:
        return AuthUser.objects.get(id=django_user.id)
    except AuthUser.DoesNotExist:
        return None

