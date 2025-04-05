from django.db import models
from django.contrib.auth.models import User
# Adjust the import path as needed
from myapp.models.instructors import Instructor  # Adjust the path if necessary


class Course(models.Model):
    id_course = models.AutoField(primary_key=True)
    instructor = models.ForeignKey(
        'Instructor',
        on_delete=models.RESTRICT,
        db_column='id_instructor'  # important!
    )
    v_subject = models.CharField(max_length=255)
    d_created = models.DateField()
    d_starting_at = models.DateField()
    d_finishing_at = models.DateField()

    class Meta:
        managed = False  # Make sure this is False if using an existing DB
        db_table = 'COURSE'

