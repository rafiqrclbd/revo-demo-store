require 'net/http'
class RevoController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def show
    order = Order.find params[:id]
    resp = Net::HTTP.get build_url(order, :check)
    result = ActiveSupport::JSON.decode resp
    if result['status'] == 0
      render json: {status: :ok, url: build_url(order, :form).to_s}
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
  def encrypt(str_params)
    public_key = OpenSSL::PKey::RSA.new(File.read Rails.root.join('config', 'ssh', 'iframe_rsa.pub'))
    encrypted_string = Base64.strict_encode64(public_key.public_encrypt(str_params))
    encrypted_string.tr('/+=','_\­,')
  end

  def build_url(order, action = :check)
    url = action == :check ? Rails.application.secrets.revo_internal_host : Rails.application.secrets.revo_host
    encrypted = encrypt "order_id=#{order.uid}&order_sum=#{"%.2f" % order.amount}&store_id=#{Rails.application.secrets.revo_store_id}"

    params = {store_id: Rails.application.secrets.revo_store_id, params: encrypted}
    uri = URI("http://#{url}/iframe/#{action}")
    uri.query = URI.encode_www_form(params)

    uri
  end
end