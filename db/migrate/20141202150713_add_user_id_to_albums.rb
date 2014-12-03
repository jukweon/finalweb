class AddUserIdToAlbums < ActiveRecord::Migration
  def change
    change_table :albums do |t|
      t.integer :user_id
    end
  end
end
