# myapp/models/profile.py

# myapp/models/userprofile.py

from django.db import models
from django.contrib.auth.models import User

class UserProfile(models.Model):
    USER_TYPE_CHOICES = [
        ('', 'User Role'),
        ('instructor', 'Instructor'),
        ('student', 'Student'),
        ('admin', 'Admin'),
    ]
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    user_type = models.CharField(max_length=20, choices=USER_TYPE_CHOICES)

    def __str__(self):
        return f'{self.user.username} - {self.user_type}'
