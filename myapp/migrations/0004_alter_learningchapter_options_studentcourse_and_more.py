# Generated by Django 4.2.9 on 2025-03-29 04:08

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('myapp', '0003_alter_learningchapter_options'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='learningchapter',
            options={'managed': False},
        ),
        migrations.CreateModel(
            name='StudentCourse',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('course', models.ForeignKey(on_delete=django.db.models.deletion.RESTRICT, to='myapp.course')),
                ('student', models.ForeignKey(on_delete=django.db.models.deletion.RESTRICT, to='myapp.student')),
            ],
            options={
                'unique_together': {('student', 'course')},
            },
        ),
        migrations.CreateModel(
            name='CourseLearnChapter',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('chapter', models.ForeignKey(on_delete=django.db.models.deletion.RESTRICT, to='myapp.learningchapter')),
                ('course', models.ForeignKey(on_delete=django.db.models.deletion.RESTRICT, to='myapp.course')),
            ],
            options={
                'unique_together': {('course', 'chapter')},
            },
        ),
        migrations.CreateModel(
            name='ChapterStudent',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('n_score', models.DecimalField(decimal_places=2, max_digits=5, null=True)),
                ('n_ranking', models.IntegerField()),
                ('d_begin', models.DateField()),
                ('d_finish', models.DateField(blank=True, null=True)),
                ('learning_chapter', models.ForeignKey(db_column='id_learningchapter', on_delete=django.db.models.deletion.CASCADE, to='myapp.learningchapter')),
                ('student', models.ForeignKey(db_column='id_student', on_delete=django.db.models.deletion.CASCADE, to='myapp.student')),
            ],
            options={
                'unique_together': {('student', 'learning_chapter')},
            },
        ),
        migrations.CreateModel(
            name='AnswerMultipleOption',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('answer', models.ForeignKey(db_column='id_answer', on_delete=django.db.models.deletion.RESTRICT, to='myapp.answer')),
                ('option', models.ForeignKey(db_column='id_option', on_delete=django.db.models.deletion.RESTRICT, to='myapp.multipleoption')),
            ],
            options={
                'unique_together': {('option', 'answer')},
            },
        ),
    ]
