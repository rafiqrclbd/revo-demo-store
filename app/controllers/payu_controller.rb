class PayuController < ApplicationController
  layout false
  def show
    @order = Order.find params[:order_id]
    @form = PayuCheckout.new(@order, params[:term])
  end
end