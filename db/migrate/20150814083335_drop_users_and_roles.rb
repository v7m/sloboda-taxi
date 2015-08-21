class DropUsersAndRoles < ActiveRecord::Migration
  def up
  	drop_table :roles_users
  end
  def down
  	create_table :roles_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :role, index: true
    end
  end	
end
