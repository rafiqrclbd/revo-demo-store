class ProductsController < ApplicationController
  def index
    @products = Product.order(id: :desc)
  end
end
