class OrdersController < ApplicationController
  before_action :authenticate_user! 
  before_action :get_order, except: [:new, :create, :index]

  def index
    if can? :assign_driver, Order
      @orders = Order.all.order(updated_at: :desc)
      @drivers =  User.joins(:roles).where(roles: {name: 'driver'})
    elsif can? :confirm, Order 
      @orders = Order.where(driver: current_user).order(updated_at: :desc)
    elsif can? :create, Order 
      @orders = Order.where(client: current_user).order(updated_at: :desc)  
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
    if @order.update(params[:order].permit(:driver_id, :status))
      flash[:notice] = "Driver successfully assigned"
      redirect_to orders_path
    else
      render action: "index"
    end
    authorize! :assign_driver, Order
  end

  def confirm
    @order.status = 'confirmed'
    if @order.save
      flash[:notice] = "Order successfully confirmed"
      redirect_to orders_path
    end  
    authorize! :confirm, Order
  end

  def edit
    authorize! :change, Order
  end

  def change
    @order.update(order_params)
    if @order.save
      flash[:notice] = "Order successfully updated"
      redirect_to orders_path
    else
      render action: "edit"
    end
    authorize! :change, Order
  end

  def close
    @order.status = 'closed'
    if @order.save
      flash[:notice] = "Order successfully closed"
      redirect_to orders_path
    end 
    authorize! :close, Order
  end

  def reject
    @order.status = 'rejected'
    if @order.save
      flash[:notice] = "Order successfully rejected"
      redirect_to orders_path
    end 
    authorize! :reject, Order
  end  

  private

  def get_order
    @order = Order.find(params[:id])
  end  

  def order_params
    params.require(:order).permit(:departure, :destination, :datetime, :car_type, :status)
  end
    
end
