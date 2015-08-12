class Order < ActiveRecord::Base
  belongs_to :client, class_name: "User"
  belongs_to :driver, class_name: "User"

  enum status: [:closed, :pending, :confirmed, :edited, :rejected]
  enum car_type: [:sedan, :minivan, :truck]

end
