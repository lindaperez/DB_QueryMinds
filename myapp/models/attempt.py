
from django.db import models

from multiple_option import MultipleOption  # Import the MultipleOption model
from answers import Answer
class Attempt(models.Model):
    answer = models.ForeignKey(Answer, on_delete=models.RESTRICT, db_column='id_answer')
    option = models.ForeignKey(MultipleOption, on_delete=models.RESTRICT, db_column='id_option')
    d_began = models.DateTimeField()
    d_finished = models.DateTimeField()
    n_attempt_number = models.IntegerField()

    class Meta:
        unique_together = ('answer', 'option')
