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

  after_create :set_default_role

  enum car_type: { sedan: 0, minivan: 1, truck: 2 }

  scope :with_role, -> (role) { where(role: Role.find_by(name: role.to_s)) }  
  scope :with_car_type, -> (car_type) { where("car_type = ?", Order.car_types[car_type]) }

  validates :firstname, presence: true,
                       length: { in: 2..15 }
  validates :lastname, presence: true,
                       length: { in: 2..15 }
  validates :phone, presence: true,
                    length: { in: 5..15 }                                          

  def has_role?(role_sym)
    role && role.name.underscore.to_sym == role_sym
  end  

  private

  def set_default_role
    self.role = Role.find_by(name: "client") unless self.role 
    self.save
  end

end
