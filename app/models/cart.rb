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
    }
  end

  def delete(id)
    @items.delete id
  end

  def clear
    @store[:cart] = {}
  end

  def products
    Product.where id: @items.keys
  end

  def products_ids
    @items.keys
  end

  def total
    @items.values.map{|i| i[:price.to_s]}.reduce(:+)
  end
end
