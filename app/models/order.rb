class Order < ActiveRecord::Base
  

  belongs_to :client, class_name: "User"
  belongs_to :driver, class_name: "User"

  enum status: { opened: 0, pending: 1, edited: 2, rejected: 3, confirmed: 4, closed: 5 }
  enum car_type: { sedan: 0, minivan: 1, truck: 2 }

  scope :with_status, -> status { where("status = ?", Order.statuses[status]).order(updated_at: :desc) }
  scope :where_user, -> role, user { where(role => user).order(updated_at: :desc) }
  
  validates :departure, presence: true,
                       length: { in: 5..25 }
  validates :destination, presence: true,
                       length: { in: 5..25 }   
  validates :datetime, presence: true
  validates :car_type, presence: true
  validates :feedback, length: { maximum: 100 }
  validates :rating, numericality: { allow_blank: true }
  validate :feedback_with_rating

  def feedback_with_rating
    if (!feedback.blank? && rating.nil?)
      errors.add(:rating, "can't be blank")
    end
  end

  def self.all_orders(user)
    if user.can?(:assign_driver, Order)
      Order.all.order(updated_at: :desc) 
    elsif user.can?(:confirm, Order)  
      Order.where_user(:driver, user) 
    elsif user.can?(:create, Order)  
      Order.where_user(:client, user) 
    end  
  end  

  def self.orders_with_status(user, status) 
    if user.can?(:assign_driver, Order)
      Order.with_status(status.to_sym) 
    elsif user.can?(:confirm, Order)  
      Order.where_user(:driver, user).with_status(status.to_sym) 
    elsif user.can?(:create, Order)  
      Order.where_user(:client, user).with_status(status.to_sym) 
    end  
  end  

  def notify_about_create
    UserMailer.create_order_email(self.client, self).deliver_now
  end  

  def notify_about_confirm
    UserMailer.confirm_order_email(self.client, self).deliver_now
  end  

  def notify_about_close
    UserMailer.close_order_email(self.client, self).deliver_now
  end

  def notify_about_reject
    UserMailer.reject_order_email(self.client, self).deliver_now
  end

  def websocket_trigger(action)
    WebsocketRails[:orders].trigger action.to_s, self
  end  

end