class Order::FactoringPrecheckV1Service < RequestBaseService
  def initialize(user, order_id, type:, amount:)
    super(user)
    @order_id = order_id
    @type = type || :auth
    @amount = amount
  end

  def call
    res = super
    update_local_price_after_change(res)
    res
  end

  def update_local_price_after_change(res)
    return unless res['status'].zero? && type == 'change'

    order.update!(revo_amount: amount)
  end

  private

  attr_reader :order_id, :type, :amount

  def payload
    send("#{type}_payload").to_json
  end

  def auth_payload
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
    }
  end

  def cancel_payload
    {
      order_id: public_order_id
    }
  end

  def finish_payload
    {
      order_id: public_order_id,
      check_number: public_order_id,
      amount: format('%.2f', (order.revo_amount || order.amount))
    }
  end

  def change_payload
    {
      order_id: public_order_id,
      amount: format('%.2f', amount),
      cart_items: cart_items
    }
  end

  def uri
    @uri ||= URI("#{host}/factoring/v1/precheck/#{type}")
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
    ['ORDER-FACT-PRECH-V1-', order.uid].join
  end

  def order
    @order ||= user.orders.find(order_id)
  end
end
