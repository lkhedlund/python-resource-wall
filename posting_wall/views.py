from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from .models import Post
from .forms import PostForm, CommentForm

# Create your views here.
def post_list(request):
    posts = Post.objects.all()
    return render(request, 'posting_wall/post_list.html', { 'posts': posts })

@login_required
def post_detail(request, pk):
    post = get_object_or_404( Post, pk=pk )
    comments = post.comments.all
    return render(request, 'posting_wall/post_detail.html', { 'post': post, 'comments': comments })

@login_required
def post_new(request):
    if request.method == "POST":
        form = PostForm( request.POST )
        if form.is_valid():
            post = form.save( commit=False )
            post.author = request.user
            post.save()
            return redirect( 'post_detail', pk=post.pk )
    else:
        form = PostForm()
    return render(request, 'posting_wall/post_edit.html', { 'form': form })

@login_required
def post_edit(request, pk):
    post = get_object_or_404( Post, pk=pk )
    if request.method == "POST":
        form = PostForm( request.POST, instance=post )
        if form.is_valid():
            post = form.save( commit=False )
            post.author = request.user
            post.save()
            return redirect( 'post_detail', pk=post.pk )
    else:
        form = PostForm( instance=post )
    return render(request, 'posting_wall/post_edit.html', { 'form': form })

@login_required
def post_comment_new(request, pk):
    post = get_object_or_404( Post, pk=pk )
    if request.method == "POST":
        form = CommentForm( request.POST )
        if form.is_valid():
            comment = form.save( commit=False )
            comment.author = request.user
            comment.post = post
            comment.save()
            return redirect('posting_wall.views.post_detail', pk=post.pk )
    else:
        form = CommentForm()
    return render(request, 'posting_wall/post_comment_new.html', { 'form':form })
