class Order < ActiveRecord::Base
  serialize :items
  belongs_to :user
  after_commit :generate_uid, on: :create

  private
  def generate_uid
    update_column :uid, "R#{"%08d" % id}"
  end
end
