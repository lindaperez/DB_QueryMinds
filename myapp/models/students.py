# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models

from django.contrib.auth.models import User

class Student(models.Model):
    id_student = models.AutoField(primary_key=True)
    id_user = models.OneToOneField(User, models.DO_NOTHING, db_column='id_user', blank=True, null=True)
    n_gpa = models.DecimalField(max_digits=3, decimal_places=2, blank=True, null=True)
    d_starting_date = models.DateField()
    d_join_date = models.DateField()

    class Meta:
        managed = False
        db_table = 'STUDENT'
