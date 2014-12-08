class AddBackgroundPhotoToAlbums < ActiveRecord::Migration
  def change
    change_table :albums do |t|
      t.string :background
    end
  end
end
