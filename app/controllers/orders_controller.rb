class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.where('amount > 1')
  end

  def show
    @order = Order.find params[:id]
  end

  def update
    @order = Order.find params[:id]
    @order.update(order_params)

    redirect_to order_path(@order)
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

  private

  def order_params
    params.require(:order).permit(:prepayment_amount)
  end
end
