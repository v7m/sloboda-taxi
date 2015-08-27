class OrdersController < ApplicationController
  before_action :authenticate_user! 
  before_action :get_order, except: [:new, :create, :index]
  after_action :delete_driver, only: :reject

  def index
    authorize! :read, Order
    @orders_status = params[:orders_status] || "all"
    if @orders_status == "all"
      @orders = Order.all.order(updated_at: :desc) if can? :assign_driver, Order
      @orders = Order.where_user(:driver, current_user) if can? :confirm, Order
      @orders = Order.where_user(:client, current_user) if can? :create, Order 
    else
      @orders = Order.with_status(@orders_status.to_sym) if can? :assign_driver, Order
      @orders = Order.where_user(:driver, current_user).with_status(@orders_status.to_sym) if can? :confirm, Order
      @orders = Order.where_user(:client, current_user).with_status(@orders_status.to_sym) if can? :create, Order
    end  
    respond_to do |format|
      format.html 
      format.js { render 'sort_index' }
    end
  end
  
  def show
    authorize! :read, Order
    session[:return_to] ||= request.referer
    @drivers =  User.with_role(:driver).with_car_type(@order.car_type)
  end

  def new
    authorize! :create, Order
    @order = Order.new
  end

  def create
    authorize! :create, Order
    @order = Order.new(order_params)
    @order.client = current_user
    if @order.save
      WebsocketRails[:orders].trigger 'new', @order  
      flash[:notice] = "Order successfully created"
      redirect_to order_path(@order)
      UserMailer.create_order_email(@order.client, @order).deliver_now
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
      WebsocketRails[:orders].trigger 'assign_driver', @order 
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
      WebsocketRails[:orders].trigger 'confirm', @order 
      respond_to do |format|
        format.html { redirect_to order_path(@order) }
        format.js { render :confirm }
      end
      UserMailer.confirm_order_email(@order.client, @order).deliver_now
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
      WebsocketRails[:orders].trigger 'change', @order
      flash[:notice] = "Order successfully updated"
      redirect_to order_path(@order)
    else
      render action: "edit"
    end
  end

  def accept_changes
    authorize! :accept_changes, Order
    if @order.pending!
      WebsocketRails[:orders].trigger 'accept_changes', @order
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
      WebsocketRails[:orders].trigger 'close', @order
      respond_to do |format|
        format.html { redirect_to order_path(@order) }
        format.js { render :close }
      end
      UserMailer.close_order_email(@order.client, @order).deliver_now
    else
      render :show    
    end  
  end

  def reject
    authorize! :reject, Order
    @drivers =  User.with_role(:driver).with_car_type(@order.car_type)
    if @order.rejected!
      WebsocketRails[:orders].trigger 'reject', @order
      flash[:notice] = "Order successfully rejected"
      respond_to do |format|
        format.html { redirect_to order_path(@order) }
        format.js { render :reject }
      end
      UserMailer.reject_order_email(@order.client, @order).deliver_now
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
    @order.feedback = nil
    @order.rating = nil
    if @order.save
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

  def delete_driver
    @order.driver_id = nil
    @order.save
  end  

end