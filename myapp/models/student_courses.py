from django.db import models
from myapp.models import Student, Course  # Import the Student and Course models

class StudentCourse(models.Model):
    student = models.ForeignKey(Student, on_delete=models.RESTRICT)
    course = models.ForeignKey(Course, on_delete=models.RESTRICT)

    class Meta:
        unique_together = ('student', 'course')

