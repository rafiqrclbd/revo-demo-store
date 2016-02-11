class CartsController < ApplicationController
  def show
    @items = current_cart.items
    @total = current_cart.total
  end

  def add
    current_cart.push params[:product_id]
    redirect_to :back
  end

  def remove
    current_cart.delete params[:product_id]
    redirect_to :back
  end
end
