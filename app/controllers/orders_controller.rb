class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.where('amount > 1')
  end

  def show
    @order = Order.find params[:id]
  end

  def create
    Order.create do |o|
      o.user = current_user
      o.items = current_cart.items.map do |id, item|
        OrderItem.new(
          product_id: id,
          quantity: item[:quantity.to_s]
        )
      end
      o.amount = current_cart.total
    end
    current_cart.clear
    redirect_to orders_path
  end
end
