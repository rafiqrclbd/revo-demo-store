class OrdersController < ApplicationController
  def index
    @orders = current_user.orders
  end

  def create
    Order.create do |o|
      o.user = current_user
      o.items = current_cart.products_ids
      o.amount = current_cart.total
    end
    current_cart.clear
    redirect_to orders_path
  end
end