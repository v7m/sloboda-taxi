class Order < ActiveRecord::Base
  belongs_to :client, class_name: "User"
  belongs_to :driver, class_name: "User"

  enum status: { opened: 0, pending: 1, edited: 2, rejected: 3, confirmed: 4, closed: 5 }
  enum car_type: [:sedan, :minivan, :truck]

  scope :with_status, -> (status) { Order.where("status = ?", Order.statuses[status]).order(updated_at: :desc) }
  
  validates :departure, presence: true,
                       length: { in: 5..25 }
  validates :destination, presence: true,
                       length: { in: 5..25 }   
  validates :datetime, presence: true
  validates :car_type, presence: true

end
