from django.db import models
from django.utils import timezone

# Create your models here.
class Post(models.Model):
    author = models.ForeignKey('auth.User')
    title = models.CharField(max_length=200)
    summary = models.TextField()
    url = models.URLField(blank=True)
    created_date = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return self.title
