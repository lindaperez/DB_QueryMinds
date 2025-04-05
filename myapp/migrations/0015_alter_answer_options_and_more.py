# Generated by Django 4.2.9 on 2025-04-04 05:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('myapp', '0014_remove_answer_submitted_at'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='answer',
            options={'managed': False},
        ),
        migrations.AlterModelOptions(
            name='answermultipleoption',
            options={'managed': False},
        ),
        migrations.AlterModelOptions(
            name='attempt',
            options={'managed': False},
        ),
        migrations.AlterModelOptions(
            name='chapterstudent',
            options={'managed': False},
        ),
        migrations.AlterModelOptions(
            name='courselearnchapter',
            options={'managed': False},
        ),
        migrations.AlterField(
            model_name='userprofile',
            name='user_type',
            field=models.CharField(choices=[('', 'User Role'), ('instructor', 'Instructor'), ('student', 'Student')], max_length=20),
        ),
    ]
