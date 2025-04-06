from django.db import models
from myapp.models import Student, Course  # Import the Student and Course models

class StudentCourse(models.Model):
    student = models.ForeignKey(Student, on_delete=models.RESTRICT, db_column='id_student')
    course = models.ForeignKey(Course, on_delete=models.RESTRICT, db_column='id_course')
    class Meta:
        managed = False
        db_table = 'STUDENT_COURSE'
        unique_together = ('student', 'course')
    
    def __str__(self):
        return f"Student {self.student} registered to the course {self.course}"
