class AddProfilePhotosToAlbums < ActiveRecord::Migration
  def change
    change_table :albums do |t|
      t.string :picture
    end
  end
end
