class Order < ActiveRecord::Base
  enum status: [:closed, :pending, :confirmed, :changed, :rejected]
  enum car_type: [:sedan, :minivan, :truck]
end
