from django.db import models
from  .students import Student  # Adjust the import path based on your project structure

from  .learning_chapter import LearningChapter

class ChapterStudent(models.Model):
    
    id = models.AutoField(primary_key=True, db_column='id')
    student = models.ForeignKey(Student, on_delete=models.CASCADE, db_column='id_student')
    learning_chapter = models.ForeignKey(LearningChapter, on_delete=models.CASCADE, db_column='id_learningchapter')
    n_score = models.DecimalField(max_digits=5, decimal_places=2, null=True)
    n_ranking = models.IntegerField()
    d_begin = models.DateField()

    d_finish = models.DateField(null=True, blank=True,db_column='d_finish')

    class Meta:
        
        managed = False
        db_table = 'CHAPTER_STUDENT'