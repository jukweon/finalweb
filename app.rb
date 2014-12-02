# app.rb

# use bundler
require 'rubygems'
require 'bundler/setup'
# load all of the gems in the gemfile
Bundler.require

require './models/Album'
require './models/User'

enable :sessions

if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'db/development.db',
  :encoding => 'utf8'
  )
end

before do
  @user = User.find_by(name: session[:name])
end

# define a route for the root of the site

#get '/log_in' do
  #redirect '/album_lists'
#end

get '/' do
  if @user
    @all_albums = @user.albums.order(:name)
    erb :album_list
  else
    erb :login
  end
end

post '/login' do
  # Get a handle to a user with a name that matches the
  # submitted username. Returns nil if no such user
  # exists
  user = User.find_by(name: params[:name])

  if user.nil?
    # first, we check if the user is in our database
    @message = "User not found."
    erb :message_page

  elsif user.authenticate(params[:password])
    # if they are, we check if their password is valid,
    # then actually log in the user by setting a session
    # cookie to their username
    session[:name] = user.name
    redirect '/'

  else
    # if the password doesn't match our stored hash,
    # show a nice error page
    @message = "Incorrect password."
    erb :message_page
  end
end

get '/logout' do
  session.clear
  redirect '/'
end

#post '/:user/new_album' do
  #User.find(params[:user]).albums.create(params)
  ##@album = Album.create(params)
  #redirect "/#{params[:user]}"
#end

post '/new_user' do
  @user = User.create(params)
  if @user.valid?
    session[:name] = @user.name
    redirect '/'
  else
    @message = @user.errors.full_messages.join(', ')
    erb :message_page
  end
end

post '/new_album' do
  @user.albums.create(name: params[:name])
  redirect '/'
end

#get '/:user/delete/:album' do
  #Album.find(params[:album]).destroy
  #redirect '/album_lists'
#end

get '/delete_user' do
  @user.destroy
  redirect '/'
end

get '/delete/:album' do
  @album = Album.find(params[:album])
  @user = @album.user
  @album.destroy
  redirect '/'
end

#get '/' do
  #@all_users = User.all.order(:name)
  #erb :log_in
#end

#get '/album_lists' do
  #redirect '/' unless @user
  #get '/:user' do
  #@user = User.find_by(name: session[:name])
  #@all_albums = @user.albums.order(:name)
  #erb :album_list
#end

#post '/:user/new_album' do
  #User.find(params[:user]).albums.create(params)
  ##@album = Album.create(params)
  #redirect "/#{params[:user]}"
#end

#get '/:album' do
  #@album = Album.find(params[:album])
  #@all_photos = @album.photos.order(:date)
  #erb :photo_list
#end

#post '/:album/new_photo' do
  #Album.find(params[:album]).photos.create(picture: params[:picture], description: params[:description], date: params[:date])
  #redirect "/#{params[:album]}"
#end

#get '/:album/delete/:photo' do
  #Photo.find(params[:photo]).destroy
  #redirect "/#{params[:album]}"
#end
