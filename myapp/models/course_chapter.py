from django.db import models
from .courses import Course
from .learning_chapter import LearningChapter

class CourseLearnChapter(models.Model):
    course = models.ForeignKey(Course, on_delete=models.RESTRICT)
    chapter = models.ForeignKey(LearningChapter, on_delete=models.RESTRICT)

    class Meta:
        unique_together = ('course', 'chapter')
        managed = False
        db_table = 'COURSE_LEARN_CHAPTER'
    def __str__(self):
        return f"Course {self.course.id_course} → Chapter {self.chapter.id_chapter}"