# Generated by Django 5.0.2 on 2024-03-05 14:46

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ImageApp', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='images',
            name='ImagePath',
            field=models.CharField(max_length=30000),
        ),
    ]
