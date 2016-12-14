require 'net/http'
class RevoController < ApplicationController

  SUBDOMAIN_LOCALES = {
    'engstore' => :en,
    'store'    => :ru
  }

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def show
    order = Order.find params[:id]
    result = call_revo order
    if result['status'] == 0
      iframe_url = add_subdomain_locale_param(result['iframe_url'])
      render json: {status: :ok, url: iframe_url}
    else
      render json: {status: :error, message: result['message']}
    end
  end

  def callback
    order = Order.find_by! uid: params[:order_id]
    order.update_attribute :revo_status, params[:decision]
    render text: :ok
  rescue
    render text: :fail
  end

  private

  def sign(payload)
    Digest::SHA1.hexdigest(payload + Rails.application.secrets.password)
  end

  def call_revo(order, action = :auth)
    url = action == :auth ? Rails.application.secrets.revo_internal_host : Rails.application.secrets.revo_host
    payload = {
        callback_url: Rails.application.secrets.callback_url,
        redirect_url: redirect_url,
        primary_phone: order.user.phone_number,
	primary_email: current_user.email,
        current_order: {
          sum: "%.2f" % order.amount,
          order_id: order.uid,
        }
    }.to_json
    signature = sign payload

    params = {store_id: Rails.application.secrets.revo_store_id, signature: signature}
    uri = URI("#{url}/iframe/v1/#{action}")
    uri.query = params.to_query

    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    logger.debug "uri: #{uri.inspect}"
    logger.debug "uri.request_uri: #{uri.request_uri}"
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = payload

    response = http.request(request)
    logger.debug "response: #{response}"
    ActiveSupport::JSON.decode response.body
  end

  private

  def subdomain
    request.subdomains.first
  end

  def subdomain_locale
    SUBDOMAIN_LOCALES.fetch(subdomain, I18n.default_locale)
  end

  def redirect_url
    method = subdomain_locale == :en ? :redirect_eng_url : :redirect_url
    Rails.application.secrets.public_send(method)
  end

  def add_subdomain_locale_param(url)
    url + "?locale=#{subdomain_locale}"
  end
end
