class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :picture
      t.string :description
      t.string :date
    end
  end
end
