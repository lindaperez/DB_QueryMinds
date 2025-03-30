from django.db import models
from django.contrib.auth.models import User
# Adjust the import path as needed
from myapp.models.instructors import Instructor  # Adjust the path if necessary


class Course(models.Model):
    instructor = models.ForeignKey(Instructor, on_delete=models.RESTRICT)
    subject = models.CharField(max_length=255)
    created = models.DateField()
    starting_at = models.DateField()
    finishing_at = models.DateField()

    def __str__(self):
        return self.subject

