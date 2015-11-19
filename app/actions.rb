require 'digest'

helpers do

  def current_user
    User.find_by(id: session[:user_id]) if session[:user_id]
  end

end

before do

end

get '/' do
  redirect '/articles'
end

get '/articles' do
  @articles = Article.all
  erb :'articles/index'
end

get '/articles/new' do
  erb :'articles/new'
end

get '/articles/:id' do
  @article = Article.find params[:id]
  erb :'articles/show'
end

get '/users' do
  @users = User.all
  erb :'users/index'
end

get '/users/new' do
  erb :'users/new'
end

get '/users/:id' do
  @user = User.find params[:id]
  erb :'users/show'
end

get '/users/signin' do
  erb :'users/signin'
end

get '/users/signout' do
  session.clear
  redirect '/articles'
end

post '/articles/new' do
  article = Article.create(
    title: params[:title],
    summary: params[:summary],
    url: params[:url],
    image: params[:image],
    user_id: params[:user_id]
  )
  if post.persisted?
    redirect "/articles/#{article.id}"
  else
    redirect '/articles/new'
  end
end

post '/users/new' do
  user = User.create(
    username: params[:username],
    email: params[:email],
    password: params[:password]
  )
  if user.persisted?
    session[:user_id] = user.id
    redirect '/articles'
  else
    redirect '/users/new'
  end
end

post '/users/signin' do
  user = User.find_by(email: params[:email])
  if user && user.password == params[:password]
    session[:user_id] = user.id
    redirect '/articles'
  else
    redirect '/users/signin'
  end    
end

post '/like' do
  binding.pry
  like = Like.create(
    article_id: params[:article_id],
    user_id: params[:user_id]
  )
  if like.persisted?
    redirect '/articles'
  else
    redirect '/articles'
  end
end

post '/comment' do
  comment = Comment.create(
    article_id: params[:article_id],
    user_id: params[:user_id],
    comment: params[:comment]
  )
  if comment.persisted?
    redirect "/articles/#{params[:article_id]}"
  else
    redirect "/articles/#{params[:article_id]}"
  end
end

post '/bookmark' do
  bookmark = Bookmark.create(
    article_id: params[:article_id],
    user_id: params[:user_id]
  )
  if bookmark.persisted?
    redirect "/articles/#{params[:article_id]}"
  else
    redirect "/articles/#{params[:article_id]}"
  end
end

post '/articles/delete' do
  article = Article.find_by(id: params[:article_id])
  article.destroy
  redirect '/articles'
end

post '/comment/delete' do
  comment = Comment.find_by(id: params[:comment_id])
  comment.destroy
  redirect "/articles/#{comment.article_id}"
end

post '/bookmark/delete' do
  bookmark = Bookmark.find_by(id: params[:bookmark_id])
  bookmark.destroy
  redirect "/articles/#{current_user.id}"
end