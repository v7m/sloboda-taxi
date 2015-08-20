class User < ActiveRecord::Base
  TEMP_PHONE_PREFIX = 'need_confirm'
  TEMP_EMAIL_PREFIX = 'need@confirm'
  TEMP_EMAIL_REGEX = /\Aneed@confirm/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable

  has_many :client_orders, foreign_key: 'client_id', class_name: "Order"
  has_many :drivers, through: :client_order, source: :client  
  has_many :driver_orders, foreign_key: 'driver_id', class_name: "Order"
  has_many :clients, through: :driver_order, source: :driver      

  has_many :identities
 
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

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update                                                         

  def has_role?(role_sym)
    role && role.name.underscore.to_sym == role_sym
  end  

  def has_identity?(identity_sym)
    identities.find_by("provider = ?", identity_sym)
  end

  def free?
    driver_orders.count == driver_orders.with_status(:closed).count
  end  

  def rating
    rating_sum = 0.0
    orders_with_rating = self.driver_orders.where.not(rating: nil)
    orders_with_rating.each do |order|
      rating_sum += order.rating.to_f
    end 
    orders_with_rating.count > 0 ? (rating_sum / orders_with_rating.count).round(1) : ""
  end  


  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        firstname = auth.extra.raw_info.name.split(" ").first
        lastname = auth.extra.raw_info.name.split(" ").last
        user = User.new(
          firstname: firstname,
          lastname: lastname,
          phone: TEMP_PHONE_PREFIX,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        #user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  private

  def set_default_role
    self.role = Role.find_by(name: "client") unless self.role 
    self.save
  end

end
