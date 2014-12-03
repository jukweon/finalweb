class AddNotesToPhotos < ActiveRecord::Migration
  def change
    change_table :photos do |t|
      t.string :notes
    end
  end
end
