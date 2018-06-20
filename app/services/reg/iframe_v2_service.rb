class Reg::IframeV2Service < Reg::BaseService

  private

  def payload
    {
      callback_url: Rails.application.secrets.callback_url,
      redirect_url: subdomain_secrets.redirect_url,
      primary_phone: user.phone_number,
      primary_email: user.email,
      current_order: {
        sum: format('%.2f', order.amount),
        order_id: order.uid
      }
    }.to_json
  end

  def uri
    @uri ||= URI("#{host}/iframe/v2/auth")
  end

  def signature
    Digest::SHA1.hexdigest(payload + password)
  end
end
