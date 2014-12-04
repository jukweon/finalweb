require 'rubygems'
require 'bundler/setup'

Bundler.require

require './models/Album.rb'
require './models/User.rb'

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

#this good :)
before do
  @user = User.find_by(name: session[:name])
end


get '/' do
  if @user
    #@all_albums = @user.albums.order(:name)
    erb :album_list
  else #this part is okay
    erb :login
  end
end

#this method is good! :)
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
  @user.albums.create(name: params[:name])
  unless params['names'].nil?
    add_members_to_album(params['names'].split(','), Album.last.id)
  end
  redirect '/'
end

post '/new_album_member' do
  add_members_to_album(params['names'].split(','), params['id'])
end

#get '/delete/:album' do
  #@album = Album.find(params[:album])
  ##@user = @album.user
  #@album.destroy
  #redirect '/'
#end

get '/delete' do
    @type = params[:type]
    @id = params[:id]
    if @type == 'g'
      @album = Album.find(@id)
    end
    erb :delete
end

post '/delete' do
    if params[:type] == 'g' #deactivate a group
      @album = Album.find(params[:id])
      @album.update(active: 'false')
    elsif params[:type] == 'u' #deactivate a user
      @user.update(active: 'false')
    end
    redirect '/'
end

#####################
# Helpers

helpers do

  def add_members_to_album(names, album_id)

    album = Album.find(album_id)

    names.each do |e|
      new_member = User.find_by(name: e.strip)

      if new_member && @user.albums.include?(album) #new_member has an account and user is associated with group
        unless new_member.albums.include?(album)
          new_member.albums << album #new_member is added to group
          #Balance.create(user: new_member, group: group)
        end
      else #not registered or @user is not associated with given group => send email to join.
        @message = "This user does not have an account"
        erb :message_page
      end
    end
    #calculate_balances(group)
    redirect '/'
  end
end
