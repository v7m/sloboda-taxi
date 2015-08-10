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
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.client = current_user
    @order.status = :pending
    if @order.save
      flash[:notice] = "Order successfully created"
      redirect_to root_path
    else
      render action: "new"
    end
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

  private

  def order_params
    params.require(:order).permit(:departure, :destination, :datetime, :car_type)
  end
    
end
