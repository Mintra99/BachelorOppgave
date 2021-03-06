# Generated by Django 3.1.4 on 2021-02-17 00:19

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Answer',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('answer_text', models.CharField(choices=[('true', 'true'), ('barely-true', 'barely-true'), ('false', 'false'), ('mostly-true', 'mostly-true'), ('pants-fire', 'pants-fire')], max_length=256)),
                ('is_correct', models.BooleanField(default=False)),
            ],
        ),
        migrations.CreateModel(
            name='Player',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('score', models.IntegerField(blank=True, null=True)),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Question',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('question_text', models.CharField(max_length=2000)),
                ('correct_answer', models.CharField(choices=[('true', 'true'), ('barely-true', 'barely-true'), ('false', 'false'), ('mostly-true', 'mostly-true'), ('pants-fire', 'pants-fire')], max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='UserQuestionHistory',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('questioner_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='questioner', to='game.player')),
                ('respoender_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='respoender', to='game.player')),
            ],
        ),
        migrations.CreateModel(
            name='Result',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('answer_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='Answer', to='game.answer')),
                ('question_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='spørsmål', to='game.question')),
                ('questioner_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='Player_1', to='game.player')),
                ('respondent_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='Player_2', to='game.player')),
            ],
        ),
        migrations.AddField(
            model_name='answer',
            name='questionid',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='game.question', verbose_name='related to Question'),
        ),
    ]
