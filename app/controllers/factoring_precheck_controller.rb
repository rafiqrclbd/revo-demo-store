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

  def finish
    order = Order.find params[:id]
    result = call_revo order, :finish
    if result['status'].zero?
      render json: { status: :ok }
    else
      render json: { status: :error }
    end
  end

  def cancel
    order = Order.find params[:id]
    result = call_revo order, :cancel
    if result['status'].zero?
      render json: { status: :ok }
    else
      render json: { status: :error }
    end
  end

  def change
    order = Order.find params[:id]
    result = call_revo order, :change, amount: params[:amount]
    if result['status'].zero?
      render json: { status: :ok }
    else
      render json: { status: :error }
    end
  end

  private

  def sign(payload)
    Digest::SHA1.hexdigest(payload + Rails.application.secrets.factoring_password)
  end

  def auth_payload(order, _)
    {
      callback_url: Rails.application.secrets.callback_url,
      redirect_url: subdomain_secrets.redirect_url,
      primary_phone: order.user.phone_number,
      primary_email: current_user.email,
      current_order: {
        amount: format('%.2f', order.amount),
        order_id: ['FACTPRECH', order.uid].join,
        valid_till: 10.minutes.from_now.to_s
      },
      cart_items: order.products.map.with_index do |product, i|
        { sku: i + 1, name: product.name, price: product.price, quantity: 1, brand: product.brand }
      end
    }.to_json
  end

  def finish_payload(order, _)
    id = ['FACTPRECH', order.uid].join
    {
      order_id: id,
      amount: format('%.2f', order.amount),
      check_number: id
    }.to_json
  end

  def cancel_payload(order, _)
    {
      order_id: ['FACTPRECH', order.uid].join,
    }.to_json
  end

  def change_payload(order, params = {})
    {
      amount: format('%.2f', params[:amount]),
      order_id: ['FACTPRECH', order.uid].join
    }.to_json
  end

  def call_revo(order, action = :auth, params = {})
    url = Rails.application.secrets.revo_internal_host
    payload = send("#{action}_payload", order, params)
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
