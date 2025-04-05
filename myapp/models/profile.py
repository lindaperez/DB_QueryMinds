# myapp/models/profile.py

from django.db import models
from django.contrib.auth.models import User

class UserProfile(models.Model):
    USER_TYPE_CHOICES = [
        ('', 'User Role'),  # 👈 default empty choice
        ('instructor', 'Instructor'),
        ('student', 'Student'),
    ]
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    user_type = models.CharField(max_length=20, choices=USER_TYPE_CHOICES)
    class Meta:
        managed = True
        db_table = 'USER_PROFILE'
    def __str__(self):
        return f'{self.user.username} - {self.user_type}'
