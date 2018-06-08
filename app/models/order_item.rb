class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  def price
    (product.actual_price * quantity).to_i
  end
end
