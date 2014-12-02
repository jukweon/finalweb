# db/migrate/20141201235303_add_passwords_to_users.rb
class AddPasswordsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :password_digest
    end
  end
end
