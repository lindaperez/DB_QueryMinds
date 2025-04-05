from django.db import models

from django.utils.html import strip_tags
from ckeditor.fields import RichTextField

# base model for creating Learning PAth for Instructor and Student
class LearningChapter(models.Model):
    id_learningchapter = models.AutoField(primary_key=True)
    instructor = models.ForeignKey(
        'Instructor',
        on_delete=models.DO_NOTHING,
        db_column='id_instructor'
    )
    d_created_at = models.DateField()
    v_content   = RichTextField(blank=True, null=True)
    d_deadline = models.DateField(blank=True, null=True)
    f_weight =  models.DecimalField(
        max_digits=5,
        decimal_places=2,
        default=10.0 
    )

    class Meta:
        managed = False
        db_table = 'LEARNING_CHAPTER'

    def __str__(self):
        clean_content = strip_tags(self.v_content)  # Removes HTML tags
        preview = clean_content[:30] + "..." if len(clean_content) > 30 else clean_content
        return f"Chapter {self.id_learningchapter}: \"{preview}\" | Deadline: {self.d_deadline} | Weight: {self.f_weight}%"