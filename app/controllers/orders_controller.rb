class OrdersController < ApplicationController
  before_action :authenticate_user! 

  def index
    @orders = Order.all
    @drivers =  User.joins(:roles).where(roles: {name: 'driver'})
    authorize! :read, Order
  end
  
  def show
  end

  def new
  end

  def create
  end

  def assign_driver
  end

  def confirm
  end

  def edit
  end

  def close
  end

  def reject
  end  
end
