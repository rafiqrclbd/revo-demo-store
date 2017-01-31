class PayuCheckout
  CREDS = {
    3 => {merchant: 'erwghrtt', secret_key: 'k5#13%R8~4|Qz9(E8?i!'},
    6 => {merchant: 'DEMO2', secret_key: 'demosecret_old'}
  }

  def initialize(order, term = 3)
    @order = order
    @term = term.to_i
  end

  def payload
    base_string.merge({
      'BILL_FNAME' => 'John',
      'BILL_LNAME' => 'Snow',
      'BILL_EMAIL' => order.user.email,
      'BILL_PHONE' => (order.user.phone_number.presence || '8888000001'),
      'AUTOMODE' => '1',
      'ORDER_HASH' => signature
    })
  end

  def url
    'https://secure.payu.ru/order/lu.php'
  end

  def signature_string
    base_string.values.map(&:to_s).map { |i| "#{i.bytesize}#{i}" }.join
  end

  private

  attr_reader :order, :term

  def merchant
    CREDS[term][:merchant]
  end

  def secret_key
    CREDS[term][:secret_key]
  end

  def base_string
    {
        'MERCHANT' => merchant,
        'ORDER_REF' => order.id,
        'ORDER_DATE' => order.created_at.strftime("%Y-%m-%d"),
        'ORDER_PNAME[]' => 'Test',
        'ORDER_PCODE[]' => '8888',
        'ORDER_PRICE[]' => order.amount.to_i,
        'ORDER_QTY[]' => order.items.count,
        'ORDER_VAT[]' => '13',
        'ORDER_SHIPPING' => '50',
        'PRICES_CURRENCY' => 'RUB',
        'DISCOUNT' => '10',
        'DESTINATION_CITY' => 'Москва',
        'DESTINATION_STATE' => 'Москва',
        'DESTINATION_COUNTRY' => 'RU',
        'PAY_METHOD' => 'REVO'
    }
  end

  def signature
    Digest::HMAC.hexdigest(signature_string, secret_key, Digest::MD5)
  end
end