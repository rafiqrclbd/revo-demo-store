class AddRedirectUrlToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :redirect_url, :string
  end
end
