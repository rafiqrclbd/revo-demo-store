require 'net/http'
class FactoringPrecheckController < ApplicationController
  include Locale

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def show
    order = Order.find params[:id]
    result = call_revo order
    if result['status'].zero?
      iframe_url = add_locale_param(result['iframe_url'])
      render json: { status: :ok, url: iframe_url }
    else
      render json: { status: :error, message: result['message'] }
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
    Digest::SHA1.hexdigest(payload + Rails.application.secrets.full_password)
  end

  def call_revo(order, action = :auth)
    url = action == :auth ? Rails.application.secrets.revo_internal_host : Rails.application.secrets.revo_host
    payload = {
      callback_url: Rails.application.secrets.callback_url,
      redirect_url: subdomain_secrets.redirect_url,
      primary_phone: order.user.phone_number,
      primary_email: current_user.email,
      current_order: {
        sum: format('%.2f', order.amount),
        order_id: ['FACTPRECH', order.uid].join
      }
    }.to_json
    signature = sign payload

    params = { store_id: Rails.application.secrets.revo_store_id, signature: signature }
    uri = URI("#{url}/factoring/v1/precheck/#{action}")
    uri.query = params.to_query

    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = payload

    response = http.request(request)
    ActiveSupport::JSON.decode response.body
  end
end
