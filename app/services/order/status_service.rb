class Order::StatusService< RequestBaseService
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
      order_id: public_order_id
    }.to_json
  end

  def uri
    @uri ||= URI("#{host}/factoring/v1/status")
  end

  def password
    Rails.application.secrets.factoring_password
  end

  def public_order_id
    ['ORDER-FACT-PRECH-V1-', order.uid].join
  end
end
