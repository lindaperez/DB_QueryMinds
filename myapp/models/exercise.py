
from django.db import models
from .difficulty_level import DifficultyLevel
# base model for creating Learning PAth for Instructor and Student
class Exercise(models.Model):
    id_exercise = models.AutoField(primary_key=True)
    f_weight = models.DecimalField(max_digits=5, decimal_places=2)
    d_deadline = models.DateField()
    
    id_difficultylevel = models.ForeignKey(
        DifficultyLevel,
        on_delete=models.DO_NOTHING,
        db_column='id_difficultylevel'
    )
    n_max_attempts = models.PositiveIntegerField(default=3)

    description = models.TextField()

    
    class Meta:
        managed = False
        db_table = 'EXERCISE'

    def __str__(self):
        return f"Exercise {self.id_exercise}"
