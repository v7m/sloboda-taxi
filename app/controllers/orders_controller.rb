class OrdersController < ApplicationController
  before_action :authenticate_user! 
  before_action :get_order, only: [:edit_driver, :assign_driver]

  def index
    if can? :assign_driver, Order
      @orders = Order.all
      @drivers =  User.joins(:roles).where(roles: {name: 'driver'})
    elsif can? :confirm, Order 
      @orders = Order.where(driver: current_user)
    end  
    authorize! :read, Order
  end
  
  def show
  end

  def new
    @order = Order.new
    authorize! :create, Order
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
    authorize! :create, Order
  end

  def edit_driver
    @drivers =  User.joins(:roles).where(roles: {name: 'driver'})
    authorize! :assign_driver, Order
  end  

  def assign_driver
    if @order.update(params[:order].permit(:driver_id))
      flash[:notice] = "Driver successfully assigned"
      redirect_to orders_path
    else
      render action: "index"
    end
    authorize! :assign_driver, Order
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

  def get_order
    @order = Order.find(params[:id])
  end  

  def order_params
    params.require(:order).permit(:departure, :destination, :datetime, :car_type)
  end
    
end
