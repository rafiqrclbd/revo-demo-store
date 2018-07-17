class ApplicationController < ActionController::Base
  include Locale

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

  def render_json(result)
    if result['status'].zero? && result['iframe_url']
      iframe_url = add_locale_param(result['iframe_url'])
      render json: { status: :ok, url: iframe_url }
    else
      render json: result
    end
  end
end
