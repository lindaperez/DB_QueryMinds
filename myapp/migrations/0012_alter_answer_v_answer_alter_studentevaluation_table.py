# Generated by Django 4.2.9 on 2025-04-04 02:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('myapp', '0011_alter_studentevaluation_options'),
    ]

    operations = [
        migrations.AlterField(
            model_name='answer',
            name='v_answer',
            field=models.TextField(blank=True, null=True),
        ),
        migrations.AlterModelTable(
            name='studentevaluation',
            table='STUDENT_EVALUATION',
        ),
    ]
