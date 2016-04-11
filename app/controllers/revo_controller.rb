require 'net/http'
class RevoController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def show
    order = Order.find params[:id]
    result = call_revo order
    if result['status'] == 0
      render json: {status: :ok, url: result['iframe_url']}
    else
      render json: {status: :error, message: result['message']}
    end
  end

  def callback
    order = Order.find_by! uid: params[:order_id]
    order.update_attribute :revo_status, params[:status]
    render text: :ok
  rescue
    render text: :fail
  end

  private

  def sign(payload)
    Digest::SHA1.hexdigest(payload + Rails.application.secrets.password)
  end

  def call_revo(order, action = :auth)
    url = action == :check ? Rails.application.secrets.revo_internal_host : Rails.application.secrets.revo_host
    payload = {
        callback_url: Rails.application.secrets.callback_url,
        redirect_url: Rails.application.secrets.redirect_url,
        current_order: {
          sum: "%.2f" % order.amount,
          order_id: order.uid,
        }
    }.to_json
    signature = sign payload

    params = {store_id: Rails.application.secrets.revo_store_id, signature: signature}
    uri = URI("http://#{url}/iframe/v1/#{action}")
    uri.query = URI.encode_www_form(params)

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = payload

    response = http.request(request)
    ActiveSupport::JSON.decode response.body
  end
end