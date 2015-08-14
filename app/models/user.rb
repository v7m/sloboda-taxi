class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :client_orders, foreign_key: 'client_id', class_name: "Order"
  has_many :drivers, through: :client_order, source: :client  
  has_many :driver_orders, foreign_key: 'driver_id', class_name: "Order"
  has_many :clients, through: :driver_order, source: :driver      

  belongs_to :role

  before_create :set_default_role

  enum car_type: [:sedan, :minivan, :truck]  

  scope :with_role, -> (role) { where(role: Role.find_by(name: role.to_s)) }  

  def has_role?(role_sym)
    role && role.name.underscore.to_sym == role_sym
  end  

  private

  def set_default_role
    role = Role.find_by_name(:client) unless role
  end

end
