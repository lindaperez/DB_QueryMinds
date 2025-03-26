from django.db import models

class MultipleOption(models.Model):
    id_option = models.AutoField(primary_key=True)
    id_exercise = models.ForeignKey(
        'Exercise',
        on_delete=models.DO_NOTHING,
        db_column='id_exercise',
        related_name='options'
    )
    b_iscorrect = models.BooleanField()
    v_option = models.TextField()

    class Meta:
        managed = False
        db_table = 'MULTIPLE_OPTION'

    def __str__(self):
        return f"Option {self.id_option} for Exercise {self.id_exercise_id}"
