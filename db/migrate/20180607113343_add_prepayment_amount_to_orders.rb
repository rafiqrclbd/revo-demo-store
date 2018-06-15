class AddPrepaymentAmountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :prepayment_amount, :float, null: true
  end
end
