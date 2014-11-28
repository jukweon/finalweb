# db/migrate/20141126185756_create_albums.rb
class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string:name
    end
  end
end
