class Order::FactoringV1Service < RequestBaseService
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
        amount: format('%.2f', order.amount),
        order_id: public_order_id
      },
      cart_items: cart_items
    }.to_json
  end

  def uri
    @uri ||= URI("#{host}/factoring/v1/auth")
  end

  def password
    Rails.application.secrets.factoring_password
  end

  def cart_items
    order.items.map.with_index do |item, i|
      {
        sku: i + 1,
        name: item.product.name,
        price: item.product.price,
        sale_price: item.product.sale_price,
        quantity: item.quantity
      }
    end
  end

  def public_order_id
    ['ORDER-FACT-V1-', order.uid].join
  end
end
