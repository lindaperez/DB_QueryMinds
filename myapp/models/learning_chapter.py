from django.db import models
from django_quill.fields import QuillField

# base model for creating Learning PAth for Instructor and Student
class LearningChapter(models.Model):
    id_learningchapter = models.AutoField(primary_key=True)
    instructor = models.ForeignKey(
        'Instructor',
        on_delete=models.DO_NOTHING,
        db_column='id_instructor'
    )
    d_created_at = models.DateField()
    v_content  = QuillField()
    d_deadline = models.DateField(blank=True, null=True)
    f_weight = models.DecimalField(max_digits=5, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'LEARNING_CHAPTER'

    def __str__(self):
        return f"Chapter {self.id_learningchapter} ({self.f_weight}%)"
