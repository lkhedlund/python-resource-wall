helpers do

  def current_user
    User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def redirects_non_user
    if !current_user
      redirect '/articles' unless request.path == '/' || request.path == '/users' || request.path == '/users/new' || request.path == '/users/signin' || request.path == '/users/signin/test' || request.path == '/articles' || request.path =~ /\/articles\/\d+/
    end
  end

  def find_bookmark(article_id)
    Bookmark.where("user_id = ? AND article_id = ?", current_user.id, article_id)
  end

  def find_comment(article_id)
    Comment.where("user_id = ? AND article_id = ?", current_user.id, article_id)
  end

  def find_like(article_id)
    Like.where("user_id = ? AND article_id = ?", current_user.id, article_id)
  end

  def total_user_likes(user)
    total_likes = 0
    user.articles.each do |article|
      total_likes += article.likes.count
    end
    total_likes
  end

  def user_ranking(user)
    user_rank = 0
    user.articles.each do |article|
      user_rank += article.likes.count
    end
    if user_rank >= 0 && user_rank < 3
      return "Cadet Trainee"
    elsif user_rank >= 3 && user_rank < 5
      return "Space Cadet"
    elsif user_rank >= 5 && user_rank < 9
      return "Senior Cadet"
    elsif user_rank >= 9  && user_rank < 12
      return "Astronaut"
    elsif user_rank >= 12  && user_rank < 10000
      return "Commander"
    else 
      return "NASA HQ CEO"
    end
  end
  def list_bookmarks
    Article.joins(:bookmarks).where(bookmarks: { user_id: current_user.id })
  end

  def url_information
    OpenGraph.fetch(session[:article_url])
  end

end

before do
  redirects_non_user
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

get '/articles/edit' do
  @url = url_information
  @url_backup = session[:article_url]
  erb :'articles/edit'
end

get '/articles/:id' do
  @article = Article.find_by_id params[:id]
  if @article
    erb :'articles/show'
  else
    erb :'error'
  end
end

get '/users' do
  @users = User.all
  erb :'users/index'
end

get '/users/new' do
  erb :'users/new', :layout => :layout_landing
end

get '/users/signin' do
  erb :'users/signin', :layout => :layout_landing
end

get '/users/signout' do
  session.clear
  redirect '/articles'
end

get '/users/:id' do
  @user = User.find_by_id params[:id]
  if @user
    @total_likes = total_user_likes(@user)
    @user_rank = user_ranking(@user)
    @bookmarks = list_bookmarks
    erb :'users/show'
  else
    erb :'error'
  end
end

post '/articles' do
  session[:article_url] = params[:url]
  redirect '/articles/edit'
end

post '/articles/edit' do
  article = current_user.articles.create(params[:article])
  if article.persisted?
    redirect "/articles/#{article.id}"
    session[:article_url]
  else
    redirect '/articles/edit'
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

# post '/articles/:article_id/delete' do
#   @article = Article.find_by params[:article_id]
#   @article.destroy!
#   redirect '/articles'
# end

post '/articles/:article_id/bookmarks/delete' do
  @article = Article.find params[:article_id]
  @article = @article.id
  @bookmark = find_bookmark(@article)
  @bookmark[0].destroy!
  redirect back
end

post '/articles/:article_id/likes/delete' do
  @article = Article.find params[:article_id]
  @article = @article.id
  @like = find_like(@article)
  @like[0].destroy!
  redirect back
end

post '/articles/:article_id/comments/:comment_id/delete' do
  @article = Article.find params[:article_id]
  @comment = @article.comments.find params[:comment_id]
  @comment.destroy!
  redirect back
end
