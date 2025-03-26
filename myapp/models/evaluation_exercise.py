from django.db import models

class EvaluationExercise(models.Model):
    id_evaluation = models.ForeignKey(
        'Evaluation',
        on_delete=models.CASCADE,
        db_column='id_evaluation'
    )
    id_exercise = models.ForeignKey(
        'Exercise',
        on_delete=models.CASCADE,
        db_column='id_exercise'
    )

    class Meta:
        managed = False
        db_table = 'EVALUATION_EXERCISE'
        unique_together = (('id_evaluation', 'id_exercise'),)

    def __str__(self):
        return f"Evaluation {self.id_evaluation_id} → Exercise {self.id_exercise_id}"
