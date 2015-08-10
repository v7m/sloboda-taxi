class AddPhoneAndCarTypeToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :phone, :string
  	add_column :users, :car_type, :integer
  end
end
