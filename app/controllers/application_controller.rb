class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!, :set_locale
  helper_method :current_cart

  protected
  def current_cart
    @current_cart ||= Cart.new session
  end

  def current_cart_items
    current_cart.items
  end

  def subdomain_locale
    SUBDOMAIN_LOCALES.fetch(subdomain, I18n.default_locale)
  end

  def set_locale
    I18n.locale = subdomain_locale
  end

  private

  SUBDOMAIN_LOCALES = {
    'engstore' => :en,
    'store'    => :ru
  }

  def subdomain
    request.subdomains.first
  end
end
