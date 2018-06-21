class Reg::IframeV2Service < RequestBaseService

  private

  def payload
    {
      callback_url: Rails.application.secrets.callback_url,
      redirect_url: subdomain_secrets.redirect_url,
      primary_phone: user.phone_number,
      primary_email: user.email,
      current_order: {
        sum: format('%.2f', order.amount),
        order_id: ['REG-IFRAME-V2-', order.uid].join
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
