class Reg::FactoringV1Service < Reg::BaseService
  private

  def payload
    {
      callback_url: Rails.application.secrets.callback_url,
      redirect_url: subdomain_secrets.redirect_url,
      primary_phone: user.phone_number,
      primary_email: user.email,
      current_order: {
        order_id: ['FACT', order.uid].join
      }
    }.to_json
  end

  def uri
    @uri ||= URI("#{host}/factoring/v1/limit/auth")
  end

  def password
    Rails.application.secrets.factoring_password
  end
end
