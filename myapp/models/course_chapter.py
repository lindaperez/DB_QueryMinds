from django.db import models
from myapp.models import Course, LearningChapter  # Import the Course and LearningChapter models

class CourseLearnChapter(models.Model):
    course = models.ForeignKey(Course, on_delete=models.RESTRICT)
    chapter = models.ForeignKey(LearningChapter, on_delete=models.RESTRICT)

    class Meta:
        unique_together = ('course', 'chapter')
