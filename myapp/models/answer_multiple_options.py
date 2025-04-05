
from django.db import models

from .multiple_option import MultipleOption  # Import the MultipleOption model
from .answers import Answer
class AnswerMultipleOption(models.Model):
    option = models.ForeignKey(MultipleOption, on_delete=models.RESTRICT, db_column='id_option')
    answer = models.ForeignKey(Answer, on_delete=models.RESTRICT, db_column='id_answer')

    class Meta:
        unique_together = ('option', 'answer')