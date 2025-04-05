# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.contrib.auth.models import User

class Instructor(models.Model):
    id_instructor = models.AutoField(primary_key=True)
    user = models.OneToOneField(
        User,
        on_delete=models.DO_NOTHING,
        db_column='id_user',
        blank=True,
        null=True
    )
    n_phone = models.CharField(max_length=20, blank=True, null=True)
    v_specialty = models.CharField(max_length=255)
    v_bio = models.TextField()

    class Meta:
        managed = False
        db_table = 'INSTRUCTOR'

    def __str__(self):
        if self.user:
            return f"Instructor: {getattr(self.user, 'first_name', '')} {getattr(self.user, 'last_name', '')}"
        return f"Instructor {self.id_instructor}"
