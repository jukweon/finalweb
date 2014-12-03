require 'rubygems'
require 'bundler/setup'

Bundler.require

require './models/Album'
require './models/User'
require './models/Photo'

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

get '/' do
  if @user
    @all_albums = @user.albums.order(:name)
    erb :album_list
  else
    erb :login
  end
end

post '/login' do
  user = User.find_by(name: params[:name])
  if user.nil?
    @message = "User not found."
    erb :message_page
  elsif user.authenticate(params[:password])
    session[:name] = user.name
    redirect '/'
  else
    @message = "Incorrect password."
    erb :message_page
  end
end

get '/logout' do
  session.clear
  redirect '/'
end

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

get '/delete_user' do
  @user.destroy
  redirect '/'
end

post '/new_album' do
  #@user = User.find(params[:user])
  @user.albums.create(params)
  redirect '/'
end

get '/delete/:album' do
  @album = Album.find(params[:album])
  #@user = @album.user
  @album.destroy
  redirect '/'
end

post '/share' do
  user = User.find_by(name: params[:username])
  if user.nil?
    @message = "User not found."
    erb :message_page
  else
    @message = "YAY"
    erb :message_page
  end
  redirect '/'
end

get '/:album' do
  @album = Album.find(params[:album])
  #@user = @album.user
  @all_photos = @album.photos.order(:date)
  erb :photo_list
end

#post '/:album/new_photo' do
  #Album.find(params[:album]).photos.create
  #@album = Album.find(params[:album])
  #@album.photos.create(params)
  ##"Hello World"
  ##@album = Album.find(params[:album])
  ##@user = @album.user
  ##@album.photos.create(picture: params[:picture], description: params[:description], date: params[:date])
  #redirect "/"
#end

#post '/:album/new_photo' do
  #Album.find(params[:album]).photos.create(picture: params[:picture], description: params[:description], date: params[:date])
  #@album = Album.find(params[:album])
  #@user = @album.user
  #@album.photos.create(picture: params[:picture], description: params[:description], date: params[:date])
  #redirect "/"
#end

#get '/delete/:photo' do
  #@photo = Photo.find_by(params[:photo])
  #@album = @photo.album
  #@user = @album.user
  #@photo.destroy
  #redirect "/"
#end
