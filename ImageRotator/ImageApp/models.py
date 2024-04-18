from django.db import models

# Create your models here.

class Images(models.Model):
    ImageId=models.AutoField(primary_key=True)
    ImagePath= models.CharField(max_length=30000)