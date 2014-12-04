class AddAlbumIdToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :album_id
    end
  end
end
