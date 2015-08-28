class AddFreeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :busy, :boolean, default: false
  end
end
