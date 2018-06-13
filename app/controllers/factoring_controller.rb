require 'net/http'
class FactoringController < ApplicationController
  include Locale

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def show
    order = Order.find params[:id]
    result = call_revo(order, type: :order)

    if result['status'].zero?
      iframe_url = add_locale_param(result['iframe_url'])
      render json: { status: :ok, url: iframe_url }
    else
      render json: { status: :error, message: result['message'] }
    end
  end

  def limit
    order = current_user.orders.create(amount: 1)
    result = call_revo(order, type: :limit)

    if result['status'].zero?
      iframe_url = add_locale_param(result['iframe_url'])
      render json: { status: :ok, url: iframe_url }
    else
      render json: { status: :error, message: result['message'] }
    end
  end

  private

  def sign(payload)
    Digest::SHA1.hexdigest(payload + Rails.application.secrets.factoring_password)
  end

  def call_revo(order, action: :auth, type: :order)
    url = action == :auth ? Rails.application.secrets.revo_internal_host : Rails.application.secrets.revo_host
    path = type == :order ? '/factoring/v1/auth' : '/factoring/v1/limit/auth'

    payload = {
      callback_url: Rails.application.secrets.callback_url,
      redirect_url: subdomain_secrets.redirect_url,
      primary_phone: order.user.phone_number,
      primary_email: current_user.email,
      current_order: {
        amount: format('%.2f', order.amount),
        order_id: ['FACT', order.uid].join,
        term: 3
      },
      cart_items: order.items.map.with_index do |item, i|
        {
          sku: i + 1,
          name: item.product.name,
          price: item.product.price,
          sale_price: item.product.sale_price,
          quantity: item.quantity
        }
      end
    }.to_json
    signature = sign payload

    params = { store_id: Rails.application.secrets.revo_store_id, signature: signature }
    uri = URI("#{url}#{path}")
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
