from django.db import migrations, models
from django.conf import settings


class Migration(migrations.Migration):
    dependencies = [
        ("core", "0001_initial"),
    ]

    operations = [
        migrations.AlterField(
            model_name="user",
            name="timezone",
            field=models.CharField(
                blank=True,
                choices=settings.TIME_ZONES,
                default=settings.TIME_ZONE,
                max_length=40,
            ),
        ),
    ]
