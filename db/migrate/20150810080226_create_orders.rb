class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :status
      t.string :departure
      t.string :destination
      t.decimal :cost
      t.datetime :datetime
      t.integer :car_type
      t.text :feedback
      t.integer :rating

      t.timestamps null: false
    end
  end
end
