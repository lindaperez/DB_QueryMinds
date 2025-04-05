

from django.db import models
from .exercise import Exercise  # Import the Exercise model from the appropriate module
from .students import Student

class Answer(models.Model):
    id = models.AutoField(primary_key=True)
    student = models.ForeignKey(Student, on_delete=models.RESTRICT)
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE)
    v_answer = models.TextField()
    n_score = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    b_iscorrect = models.BooleanField(null=True, blank=True)
    submitted_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Attempt by {self.student} for {self.exercise}"
