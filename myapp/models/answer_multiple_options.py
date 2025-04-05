
from django.db import models

from .multiple_option import MultipleOption  # Import the MultipleOption model
from .answers import Answer
class AnswerMultipleOption(models.Model):
    id = models.AutoField(primary_key=True,db_column='id')
    option = models.ForeignKey(MultipleOption, on_delete=models.CASCADE, db_column='id_option')
    answer = models.ForeignKey(Answer, on_delete=models.CASCADE, db_column='id_answer')

    class Meta:
        unique_together = ('option', 'answer')
        managed = False
        db_table = 'ANSWER_MULTIPLE_OPTION'
    def __str__(self):
        return f"{self.option.v_option}"