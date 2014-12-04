class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      #t.belongs_to :album
      t.string :picture
      t.string :description
      t.string :date
    end
  end
end
