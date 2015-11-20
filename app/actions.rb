require 'digest'

helpers do

  def current_user
    User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def find_bookmark(article_id)
    Bookmark.where("user_id = ? AND article_id = ?", current_user.id, article_id)
  end

  def find_comment(article_id)
    Bookmark.where("user_id = ? AND article_id = ?", current_user.id, article_id)
  end

  def total_user_likes(user)
    total_likes = 0
    user.articles.each do |article|
      total_likes += article.likes.count
    end
    total_likes
  end

  def list_bookmarks
    Article.joins(:bookmarks).where(bookmarks: { user_id: current_user.id })
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

get '/users/signin' do
  erb :'users/signin'
end

get '/users/signout' do
  session.clear
  redirect '/articles'
end

get '/users/:id' do
  @user = User.find params[:id]
  @total_likes = total_user_likes(@user)
  @bookmarks = list_bookmarks
  erb :'users/show'
end

post '/articles' do
  article = current_user.articles.create(params[:article])
  if article.persisted?
    redirect "/articles/#{article.id}"
  else
    redirect '/articles/new'
  end
end

post '/users' do
  user = User.create(params[:user])
  if user.persisted?
    session[:user_id] = user.id
    redirect '/articles'
  else
    redirect '/users/new'
  end
end

post '/users/signin' do
  user = User.find_by(email: params[:email])
  if user.email && user.password == params[:password]
    session[:user_id] = user.id
    redirect '/articles'
  else
    redirect '/users/signin'
  end    
end

post '/users/signin/test' do
    session[:user_id] = params[:user_id]
    redirect '/articles' 
end

post "/articles/:article_id/likes" do
  @article = Article.find params[:article_id]
  @like = @article.likes.new
  @like.user = current_user
  if @like.save
    redirect back
  else
    # TODO: add flash comment here
    redirect back
  end
end

post '/articles/:article_id/comments' do
  @article = Article.find params[:article_id]
  @comment = @article.comments.new comment: params[:comment]
  @comment.user = current_user
  if @comment.save
    redirect back
  else
    redirect back
  end
end

post '/articles/:article_id/bookmarks' do
  @article = Article.find params[:article_id]
  @bookmark = @article.bookmarks.new
  @bookmark.user = current_user
  if @bookmark.save
    redirect back
  else
    # TODO: add flash comment here
    redirect back
  end
end

post '/articles/:article_id/delete' do
  @article = Article.find_by params[:article_id]
  @article.destroy!
  redirect '/articles'
end

post '/articles/:article_id/bookmarks/delete' do
  @article = Article.find params[:article_id]
  @article = @article.id
  @bookmark = find_bookmark(@article)
  @bookmark[0].destroy!
  redirect back
end

post '/articles/:article_id/comments/delete' do
  @article = Article.find params[:article_id]
  @article = @article.id
  @comment = find_comment(@article)
  @comment[0].destroy!
  redirect back
end