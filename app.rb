# app.rb

# use bundler
require 'rubygems'
require 'bundler/setup'
# load all of the gems in the gemfile
Bundler.require

require './models/Group'

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
  @all_groups = Group.all.order(:name)
  erb :index
end

post '/' do
  Group.create(description: params[:group], name: params[:name])
  redirect '/'
end

delete '/:id' do
  Group.find_by(params[:id]).destroy
  redirect '/'
end
