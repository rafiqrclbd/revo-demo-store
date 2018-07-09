class Reg::IframeV1Service < RequestBaseService
  private

  def payload
    {
      callback_url: Rails.application.secrets.callback_url,
      redirect_url: subdomain_secrets.redirect_url,
      primary_phone: user.phone_number,
      primary_email: user.email,
      current_order: {
        sum: format('%.2f', order.amount),
        order_id: ['REG-IFRAME-V1-', order.uid].join
      }
    }.to_json
  end

  def uri
    @uri ||= URI("#{host}/iframe/v1/auth")
  end

  def password
    subdomain_secrets.limit_store_password
  end

  def store_id
    subdomain_secrets.revo_limit_store_id
  end
end
