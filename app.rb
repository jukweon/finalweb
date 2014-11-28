# app.rb

# use bundler
require 'rubygems'
require 'bundler/setup'
# load all of the gems in the gemfile
Bundler.require

require './models/Photo'
require './models/Album'

if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'db/development.db',
  :encoding => 'utf8'
  )
end

# define a route for the root of the site

get '/' do
  @all_albums = Album.all.order(:name)
  erb :album_list
end

post '/' do
  @album = Album.create(name: params[:name])
  redirect '/'
end

get '/:album_id' do
  @album = Album.find(params[:album_id])
  @all_photos = @album.all_photos.order(:date)
  erb :photo_list
end

post '/:album_id' do
  @album= Album.find(params[:album_id])
  Photo.create(album: @album, picture: params[:picture], description: params[:description], date: params[:date])
  redirect "/#{params[:album_id]}"
end
