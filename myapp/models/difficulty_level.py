from django.db import models
# base model for creating Learning PAth for Instructor and Student
class DifficultyLevel(models.Model):
    id_difficultylevel = models.AutoField(primary_key=True)
    v_title = models.CharField(max_length=20)
    v_description = models.TextField()

    class Meta:
        managed = False
        db_table = 'DIFFICULTY_LEVEL'

    def __str__(self):
        return self.v_title
