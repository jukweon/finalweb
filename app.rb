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
  user = User.find_by(name: params[:name])
  if user.nil?
    @message = "User not found."
    erb :message_page
  elsif user.albums.include?(@album)
    @message = "The user is already in the group."
    erb :message_page
  else
    user.albums << @album
  end
  redirect '/'
end



#HERE
#post '/new_album_member' do
  #add_member_to_album(params['name'], params['id'])
#end

#HERE
#helpers do

  #def add_member_to_album(name, album_id)

    #album = Album.find(album_id)

    #name.each do |e|
    #new_member = User.find_by(name: name.strip)

      #if new_member && @user.albums.include?(album) #new_member has an account and user is associated with group
        #unless new_member.albums.include?(album)
          #HERE! new_member.albums << album #new_member is added to group
          #Balance.create(user: new_member, group: group)
        #end
      #else #not registered or @user is not associated with given group => send email to join.
        #@message = "This user does not have an account"
        #erb :message_page
      #end
    #end
    #calculate_balances(group)
    #redirect '/'
  #end
#end
