class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    params[:car_type] ? @car_type = params[:car_type] : @car_type = "all"
      if @car_type == "all" 
        @drivers = User.with_role(:driver)
      else  
        @drivers = User.with_role(:driver).with_car_type(@car_type)
      end  
    respond_to do |format|
      format.html 
      format.js { render 'sort_index' }
    end  
  end

end
