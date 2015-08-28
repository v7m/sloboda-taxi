class OrdersController < ApplicationController
  before_action :authenticate_user! 
  before_action :get_order, except: [:new, :create, :index]
  after_action :clean_order_driver, only: :reject

  def index
    authorize! :read, Order
    @orders_status = params[:orders_status] || "all"
    @orders = @orders_status == "all" ? Order.all_orders(current_user) : Order.orders_with_status(current_user, @orders_status)
    respond_to do |format|
      format.html 
      format.js { render 'sort_index' }
    end
  end

  def show
    authorize! :read, Order
    session[:return_to] ||= request.referer
    @drivers =  User.with_role(:driver).with_car_type(@order.car_type).not_busy
  end

  def new
    authorize! :create, Order
    @order = Order.new
  end

  def create
    authorize! :create, Order
    @order = Order.new(order_params.merge(client: current_user))
    if @order.save
      @order.websocket_trigger(:new)
      flash[:notice] = "Order successfully created"
      redirect_to order_path(@order)
      @order.notify_about_create
    else
      render action: "new"
    end
  end

  def edit_driver
    authorize! :assign_driver, Order
    @drivers =  User.with_role(:driver)
  end

  def assign_driver
    authorize! :assign_driver, Order
    if @order.update(params[:order].permit(:driver_id, :status))
      driver = @order.driver
      driver.set_busyness(true)
      @order.websocket_trigger(:assign_driver)
      flash[:notice] = "Driver successfully assigned"
      respond_to do |format|
        format.html { redirect_to order_path(@order) }
        format.js { render :assign_driver }
      end
    else
      render action: "index"
    end
  end

  def confirm
    authorize! :confirm, Order
    if @order.confirmed!
      @order.websocket_trigger(:confirm)
      respond_to do |format|
        format.html { redirect_to order_path(@order) }
        format.js { render :confirm }
      end
      @order.notify_about_confirm
    else
      render :show  
    end
  end

  def edit
    authorize! :change, Order
  end

  def change
    authorize! :change, Order
    if @order.update(order_params)
      @order.websocket_trigger(:change)
      flash[:notice] = "Order successfully updated"
      redirect_to order_path(@order)
    else
      render action: "edit"
    end
  end

  def accept_changes
    authorize! :accept_changes, Order
    if @order.pending!
      @order.websocket_trigger(:accept_changes)
      respond_to do |format|
        format.html { redirect_to order_path(@order) }
        format.js { render :accept_changes }
      end
    else
      render :show  
    end
  end

  def close
    authorize! :close, Order
    if @order.closed!
      driver = @order.driver
      driver.set_busyness(false)
      @order.websocket_trigger(:close)
      respond_to do |format|
        format.html { redirect_to order_path(@order) }
        format.js { render :close }
      end
      @order.notify_about_close
    else
      render :show
    end
  end

  def reject
    authorize! :reject, Order
    @drivers =  User.with_role(:driver).with_car_type(@order.car_type)
    if @order.rejected!
      driver = @order.driver
      driver.set_busyness(false)
      @order.websocket_trigger(:reject)
      flash[:notice] = "Order successfully rejected"
      respond_to do |format|
        format.html { redirect_to order_path(@order) }
        format.js { render :reject }
      end
      @order.notify_about_reject
    else
      render :show  
    end
  end

  def add_feedback
    authorize! :add_feedback, Order
    if @order.update(params[:order].permit(:feedback, :rating))
      flash[:notice] = "Feedback successfully rejected"
      respond_to do |format|
        format.html { render action: "show" }
        format.js { render :add_feedback }
      end
    else
      respond_to do |format|
        format.html { render action: "show" }
        format.js { render :feedback_errors }
      end
    end
  end

  def destroy_feedback
    authorize! :destroy_feedback, Order
    if @order.update_attributes(feedback: nil, rating: nil)
      flash[:notice] = "Feedback successfully rejected"
      respond_to do |format|
        format.html { render action: "show" }
        format.js { render :destroy_feedback }
      end
    else
      render action: "show"
    end
  end

  private

  def get_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:departure, :destination, :datetime, :car_type, :status)
  end

  def clean_order_driver
    @order.update_attributes(driver_id: nil)
  end

end