class AddRevoAmountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :revo_amount, :float
  end
end
