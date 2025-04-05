from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from myapp.models.auth_user import AuthUser
from myapp.models.students import Student
from myapp.models.profile import UserProfile
from django.utils import timezone

class Command(BaseCommand):
    help = "Sync Django User with AuthUser and Student tables"

    def handle(self, *args, **kwargs):
        synced_auth_users = 0
        synced_students = 0

        for user in User.objects.all():
            auth_user, created = AuthUser.objects.get_or_create(
                id=user.id,
                defaults={
                    'username': user.username,
                    'first_name': user.first_name,
                    'last_name': user.last_name,
                    'email': user.email,
                    'is_superuser': user.is_superuser,
                    'is_staff': user.is_staff,
                    'is_active': user.is_active,
                    'date_joined': user.date_joined,
                    'password': user.password
                }
            )
            if created:
                synced_auth_users += 1

            # Sync Student profile
            try:
                profile = user.userprofile
                if profile.user_type == 'student' and not Student.objects.filter(id_user=auth_user).exists():
                    Student.objects.create(
                        id_user=auth_user,
                        n_gpa=0.00,
                        d_starting_date=user.date_joined.date(),
                        d_join_date=user.date_joined.date()
                    )
                    synced_students += 1
            except Exception as e:
                self.stdout.write(self.style.WARNING(f"Skipped user {user.username}: {str(e)}"))

        self.stdout.write(self.style.SUCCESS(f"✔ Synced {synced_auth_users} AuthUser(s)"))
        self.stdout.write(self.style.SUCCESS(f"✔ Synced {synced_students} Student(s)"))
