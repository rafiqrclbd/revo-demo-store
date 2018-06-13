class Order < ActiveRecord::Base
  serialize :items

  belongs_to :user
  has_many :items, foreign_key: :order_id, class_name: 'OrderItem'
  has_many :products, through: :items

  after_commit :generate_uid, on: :create

  private

  def generate_uid
    update_column :uid, "R#{format('%08d', id)}"
  end
end
