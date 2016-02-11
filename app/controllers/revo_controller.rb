require 'net/http'
class RevoController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    order = Order.find params[:id]
    encrypted = encrypt "order_id=#{order.uid}&order_sum=#{"%.2f" % order.amount}&store_id=#{Rails.application.secrets.revo_store_id}"

    url = "http://#{Rails.application.secrets.revo_host}/iframe/check?store_id=#{Rails.application.secrets.revo_store_id}&params=#{encrypted}"
    uri = URI.parse(URI.encode(url))
    resp = Net::HTTP.get(uri)
    render text: resp
  end

  private
  def encrypt(str_params)
    public_key = OpenSSL::PKey::RSA.new(File.read Rails.root.join('config', 'ssh', 'iframe_rsa.pub'))
    encrypted_string = Base64.strict_encode64(public_key.public_encrypt(str_params))
    encrypted_string.tr('/+=','_\­,')
  end
end