class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  def price
    (product.price * quantity).to_i
  end
end
