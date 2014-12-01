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

get '/:album' do
  @album = Album.find(params[:album])
  @all_photos = @album.photos.order(:date)
  erb :photo_list
end

post '/new_album' do
  @album = Album.create(params)
  redirect '/'
end

post '/:album/new_photo' do
  Album.find(params[:album]).photos.create(picture: params[:picture], description: params[:description], date: params[:date])
  redirect "/#{params[:album]}"
end
