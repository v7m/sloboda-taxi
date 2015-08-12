class AddFirstnameAndLastnameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :firstname, :string, dafault: ""
    add_column :users, :lastname, :string, dafault: ""
  end
end
