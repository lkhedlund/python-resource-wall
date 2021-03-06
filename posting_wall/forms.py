from django import forms
from .models import Post, Comment

class PostForm(forms.ModelForm):
    TAG_CHOICES = (
        ("python", "python"),
        ("django", "django"),
        ("flask", "flask"),
        ("other","other"),
    )
    tag = forms.ChoiceField(choices = TAG_CHOICES)

    class Meta:
        model = Post
        fields = ('title', 'summary', 'url', 'tag')
        widgets = {
            'title': forms.TextInput(attrs={ 'class': 'form-control' }),
            'summary': forms.Textarea(attrs={ 'class': 'form-control' }),
            'url': forms.URLInput(attrs={ 'class': 'form-control' }),
            'tag': forms.Select(attrs={ 'class': 'form-control' }),
        }

class CommentForm(forms.ModelForm):

    class Meta:
        model = Comment
        fields = ('text',)
        widgets = {
            'text': forms.Textarea(attrs={ 'class': 'form-control', 'rows': 1 }),
        }
