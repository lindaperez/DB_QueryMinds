from django.db import models

class Evaluation(models.Model):
    id_evaluation = models.AutoField(primary_key=True)
    f_weight = models.DecimalField(max_digits=5, decimal_places=2)
    d_deadline = models.DateField()

    class Meta:
        managed = False
        db_table = 'EVALUATION'

    def __str__(self):
        return f"Evaluation {self.id_evaluation}"
