# -*- coding: utf-8 -*-
# Generated by Django 1.9.2 on 2016-03-11 05:25
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0109_add_level_order'),
    ]

    operations = [
        migrations.AddField(
            model_name='teacher',
            name='status_confirm',
            field=models.BooleanField(default=False),
        ),
    ]