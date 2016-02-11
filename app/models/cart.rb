class Cart
  attr_reader :items
  delegate :any?, to: :items, prefix: false

  def initialize(store)
    store[:cart] = {} unless store[:cart].present?
    @items = store[:cart]
  end

  def push(id)
    p = Product.find(id)

    @items[id] = {
      id: id,
      name: p.name,
      image: p.image,
      price: p.price,
    }
  end

  def delete(id)
    @items.delete id
  end

  def products
    Product.where id: @items.keys
  end

  def total
    @items.values.map{|i| i[:price.to_s]}.reduce(:+)
  end
end