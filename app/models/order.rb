class Order < ActiveRecord::Base
  serialize :items
  belongs_to :user
end
