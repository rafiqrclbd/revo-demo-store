class Product < ActiveRecord::Base
  def actual_price
    sale_price || price
  end
end
