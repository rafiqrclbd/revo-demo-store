class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      t.float :amount
      t.text :items
      t.string :uid
      t.string :revo_status

      t.timestamps null: false
    end
  end
end
