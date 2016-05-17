# Homepage (Root path)

enable :sessions

get '/' do
  erb :index
end

post '/login' do
  @user = User.where(
    email: params[:email],
    password: params[:password]
    )[0]
  if @user.nil?
    @error_message = "Either your email or your password is incorrect!"
    erb :index
  else
    session[:key] = @user.rand_key
    erb :index
  end
end

get '/logout' do
  session.clear
  redirect :'/'
end

get '/songs' do
  @songs = Song.all.sort {|a,b| b.votes.count <=> a.votes.count }
  erb :'songs/index'
end


get '/songs/new' do
  if session[:email].nil?
    redirect '/register'
  else
    erb :'songs/new'
  end
end

post '/songs' do
  @song = Song.new(
    title: params[:title],
    author: params[:author],
    url: params[:url],
    posted_by: session[:email]
    )

  if @song.save
    redirect '/songs'
  else
    erb :'songs/new'
  end
end

get '/songs/:id' do
  @song = Song.find params[:id]
  @reviews = Review.where song_id: params[:id]
  erb :'songs/song'
end


get '/register' do
  erb :'register/index'
end

post '/register' do
  o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
  @string = (0...50).map { o[rand(o.length)] }.join
  @user = User.new(
    email: params[:email],
    password: params[:password],
    rand_key: @string
    )
  if @user.save
    redirect '/'
  else
    erb :'register/index'
  end
end

post '/upvote' do
  @song_id = params[:song_id]
  session[:id] = User.find_by(email:session[:email]).id
  @upvote = Vote.new(user_id: session[:id], song_id: @song_id)
  @upvote.save
  @songs = Song.all
  erb :'songs/index'
end

post '/review' do
  @song = Song.find params[:song_id]
  @reviews = Review.where song_id: @song.id
  session[:id] = User.find_by(email:session[:email]).id
  @review = Review.new(user_id: session[:id], song_id: @song.id, review: params[:review], score: params[:score])
  @review.save
  erb :'songs/song'
end

post '/delete_review' do
  @review_id = params[:review_id]
  Review.where(id: @review_id)[0].destroy
  redirect '/songs'
end


