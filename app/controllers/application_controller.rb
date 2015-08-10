class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    render_500
  end

  def render_500
    render file: "#{Rails.root}/public/500.html", layout: false, status: 500
  end
  
end
