class UserMailer < ApplicationMailer

  def create_order_email(user, order)
    @user = user
    @order = order
    @url  = order_url(@order)
    mail(to: @user.email, subject: 'You have created new Order!')
  end

  def confirm_order_email(user, order)
    @user = user
    @order = order
    @url  = order_url(@order)
    mail(to: @user.email, subject: 'Your Order has been confirmed!')
  end

  def reject_order_email(user, order)
    @user = user
    @order = order
    @url  = order_url(@order)
    mail(to: @user.email, subject: 'Your Order has been rejected!')
  end

  def close_order_email(user, order)
    @user = user
    @order = order
    @url  = order_url(@order)
    mail(to: @user.email, subject: 'Your Order has been closed!')
  end

end
