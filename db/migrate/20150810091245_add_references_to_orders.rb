class AddReferencesToOrders < ActiveRecord::Migration
  def change
  	add_reference :orders, :client, index: true
    add_reference :orders, :driver, index: true
  end
end
