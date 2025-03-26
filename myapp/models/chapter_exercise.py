from django.db import models

class ChapterExercise(models.Model):
    id_learningchapter = models.ForeignKey(
        'LearningChapter',
        on_delete=models.CASCADE,
        db_column='id_learningchapter'
    )
    id_exercise = models.ForeignKey(
        'Exercise',
        on_delete=models.CASCADE,
        db_column='id_exercise'
    )

    class Meta:
        managed = False
        db_table = 'CHAPTER_EXERCISE'
        unique_together = (('id_learningchapter', 'id_exercise'),)

    def __str__(self):
        return f"Chapter {self.id_learningchapter_id} - Exercise {self.id_exercise_id}"
