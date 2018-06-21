class Order::IframeV1Service < RequestBaseService
  def initialize(user, order_id)
    super(user)
    @order_id = order_id
  end

  private

  attr_reader :order_id

  def order
    @order ||= user.orders.find(order_id)
  end

  def payload
    {
      callback_url: Rails.application.secrets.callback_url,
      redirect_url: subdomain_secrets.redirect_url,
      primary_phone: user.phone_number,
      primary_email: user.email,
      current_order: {
        sum: format('%.2f', order.amount),
        order_id: ['ORDER-IFRAME-V1-', order.uid].join
      }
    }.to_json
  end

  def uri
    @uri ||= URI("#{host}/iframe/v1/auth")
  end

  def password
    Rails.application.secrets.password
  end
end
