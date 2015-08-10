class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :client_orders, foreign_key: 'client_id', class_name: "Order"
  has_many :drivers, through: :client_order, source: :client  
  has_many :driver_orders, foreign_key: 'driver_id', class_name: "Order"
  has_many :clients, through: :driver_order, source: :driver      

  has_and_belongs_to_many :roles

  enum car_type: [:sedan, :minivan, :truck]      

end
