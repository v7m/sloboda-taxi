class ChangeStatusDepartureDestinationDatetimeCarTypeAtOrders < ActiveRecord::Migration
  def up
    change_column :orders, :status, :integer, null: false
    change_column :orders, :departure, :string, null: false
    change_column :orders, :destination, :string, null: false
    change_column :orders, :datetime, :datetime, null: false
    change_column :orders, :car_type, :integer, null: false
  end

  def down
    change_column :orders, :car_type, :integer
    change_column :orders, :datetime, :datetime
    change_column :orders, :destination, :string
    change_column :orders, :departure, :string
    change_column :orders, :status, :integer
  end   
end
