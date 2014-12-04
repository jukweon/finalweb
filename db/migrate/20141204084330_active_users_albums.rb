class ActiveUsersAlbums < ActiveRecord::Migration

  def change
    change_table :users do |u|
      u.boolean :active, default: true
    end

    change_table :albums do |g|
      g.boolean :active, default: true
    end
    
  end
end
