from django.db import models

class StudentEvaluation(models.Model):
    student = models.ForeignKey(Student, on_delete=models.CASCADE, db_column='id_student')
    evaluation = models.ForeignKey(Evaluation, on_delete=models.CASCADE, db_column='id_evaluation')
    f_score = models.DecimalField(max_digits=5, decimal_places=2)
    d_begins = models.DateField(null=True, blank=True)
    d_finish = models.DateField(null=True, blank=True)

    class Meta:
        unique_together = ('student', 'evaluation')