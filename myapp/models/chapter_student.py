from django.db import models
from  .students import Student  # Adjust the import path based on your project structure

from  .learning_chapter import LearningChapter

class ChapterStudent(models.Model):
    student = models.ForeignKey(Student, on_delete=models.CASCADE, db_column='id_student')
    learning_chapter = models.ForeignKey(LearningChapter, on_delete=models.CASCADE, db_column='id_learningchapter')
    n_score = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    n_ranking = models.IntegerField()
    d_begin = models.DateField()
    d_finish = models.DateField(null=True, blank=True)
    
    class Meta:
        unique_together = ('student', 'learning_chapter')