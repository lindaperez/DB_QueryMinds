from django.db import models

class ChapterEvaluation(models.Model):
    id_learningchapter = models.ForeignKey(
        'LearningChapter',
        on_delete=models.CASCADE,
        db_column='id_learningchapter'
    )
    id_evaluation = models.ForeignKey(
        'Evaluation',
        on_delete=models.CASCADE,
        db_column='id_evaluation'
    )

    class Meta:
        managed = False
        db_table = 'CHAPTER_EVALUATION'
        unique_together = (('id_learningchapter', 'id_evaluation'),)

    def __str__(self):
        return f"Chapter {self.id_learningchapter_id} → Evaluation {self.id_evaluation_id}"
