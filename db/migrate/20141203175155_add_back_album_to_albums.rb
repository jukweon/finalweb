class AddBackAlbumToAlbums < ActiveRecord::Migration
  def change
    change_table :albums do |t|
      t.string :back_album
    end
  end
end
