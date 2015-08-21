class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :role, index: true
    add_foreign_key :users, :role
  end
end
