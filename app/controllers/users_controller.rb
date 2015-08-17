class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @drivers = User.with_role(:driver)
  end

end
