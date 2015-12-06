from django.db import models
from django.utils import timezone
# Import Signals
from django.db.models.signals import pre_save
from django.dispatch import receiver

class Post(models.Model):
    author = models.ForeignKey('auth.User')
    title = models.CharField(max_length=200)
    summary = models.TextField()
    url = models.URLField()
    created_date = models.DateTimeField(default=timezone.now)
    tag = models.CharField(max_length=10)

    def __str__(self):
        return self.title

class Comment(models.Model):
    post = models.ForeignKey('posting_wall.Post', related_name='comments')
    author = models.ForeignKey('auth.User')
    text = models.TextField()
    created_date = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return self.text

@receiver(pre_save, sender=Post)
def tag_to_lowercase(sender, instance, *args, **kwargs):
    instance.tag = instance.tag.lower()
