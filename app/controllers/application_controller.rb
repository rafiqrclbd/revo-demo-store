class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_cart

  protected
  def current_cart
    @current_cart ||= Cart.new session
  end

  def current_cart_items
    current_cart.items
  end
end
