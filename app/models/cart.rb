class Cart
  attr_reader :items
  delegate :any?, to: :items, prefix: false

  def initialize(store)
    @store = store
    store[:cart] = {} unless store[:cart].present?
    @items = store[:cart]
  end

  def push(id)
    p = Product.find(id)

    @items[id] = {
      id: id,
      name: p.name,
      image: p.image,
      price: p.actual_price,
      quantity: 1
    }
  end

  def delete(id)
    @items.delete id
  end

  def update_quantity(id, value)
    @items[id][:quantity.to_s] = value.to_f
  end

  def clear
    @store[:cart] = {}
  end

  def products
    Product.where id: @items.keys
  end

  def total
    @items.values.sum { |i| (i[:price.to_s] * i[:quantity.to_s]).to_i }
  end
end
