

from django.db import models
from .exercise import Exercise  # Import the Exercise model from the appropriate module
from .students import Student

class Answer(models.Model):
    id = models.AutoField(primary_key=True,db_column='id_answer')
    student = models.ForeignKey(Student, on_delete=models.RESTRICT,db_column='id_student')
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE,db_column='id_exercise')
    v_answer = models.TextField(null=True, blank=True)
    n_score = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    b_iscorrect = models.BooleanField(null=True, blank=True)
    class Meta:
        managed = False
        db_table = 'ANSWER'
    def __str__(self):
        return f"Aswer {self.id} Attempt by {self.student} for {self.exercise} - Score: {self.n_score} - Correct: {self.b_iscorrect} - Answer: {self.v_answer} - ID: {self.id}" 
