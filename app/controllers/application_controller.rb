require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    "Welcome to Fwitter"
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  end

  get '/signup' do
    if session[:user_id]
      redirect to '/tweets'
    else
    erb :'/users/create_user'
    end
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect to '/signup'
    else
    @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
    session[:user_id] = @user.id
    redirect to '/tweets'
    end
  end

  get '/login' do
    if logged_in?
      redirect to '/tweets'
    else
    erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params["username"])
    session[:user_id] = @user.id
    binding.pry
    redirect to '/tweets'
  end

  get '/tweets' do
    if logged_in?
    erb :'/tweets/tweets'
    else
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    erb :'/tweets/create_tweet'
  end

  post '/tweets' do
    erb :'/tweets/show_tweet'
  end

  get '/logout' do
    if logged_in?
      session.clear
    else
      redirect to '/'
    end
  end
end
