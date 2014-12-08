require 'rubygems'
require 'bundler/setup'

Bundler.require

require './models/Album.rb'
require './models/User.rb'
require './models/Photo.rb'

enable :sessions

set :session_secret, ENV['SESSION_SECRET']

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

get '/delete/:album' do
  @album = Album.find(params[:album])
  @album.destroy
  redirect '/'
end

post '/new_album' do
  @user.albums.create(name: params[:name], picture: params[:picture])
  redirect '/'
end

get '/:album' do
  @album = Album.find(params[:album])
  @all_photos = @album.photos.order(:date)
  erb :photo_list
end

post '/:album/new_photo' do
  @album = Album.find(params[:album])
  @album.photos.create(picture: params[:picture], description: params[:description], date: params[:date])
  redirect "/#{params[:album]}"
end

get '/:album/delete/:photo' do
  @album = Album.find(params[:album])
  @photo = Photo.find(params[:photo])
  @photo.destroy
  redirect "/#{params[:album]}"
end

post '/:album/new_member' do
  @album = Album.find(params[:album])
  member = User.find_by(name: params[:name])
  if member
    if member.albums.include?(@album)
    @message = "The user is already in the group."
    erb :message_page
    else
      member.albums << @album
    end
  else
    @message = "The user not found"
    erb :message_page
  end
  redirect '/'
end
