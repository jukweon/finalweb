# db/migrate/20141001173512_create_groups.rb
class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :description
      t.string :name
    end
  end
end
