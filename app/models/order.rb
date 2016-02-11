class Order < ActiveRecord::Base
  serialize :items
  belongs_to :user
  after_commit :generate_uid, on: :create

  def products
    Product.where id: items
  end

  private
  def generate_uid
    update_column :uid, "R#{"%08d" % id}"
  end
end
