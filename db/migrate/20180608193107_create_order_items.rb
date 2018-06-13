class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.float :quantity
      t.references :order, index: true
      t.references :product, index: true

      t.timestamps null: false
    end
  end
end
