# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Creating products'
Order.delete_all
Product.delete_all
[
  { name: "Samsung UE22H5610", price: 1990,
    image: "/images/products/samsung_ue.jpg", sale_price: 1500 },
  { name: "Sony Xperia Z3 Compact", price: 2490,
    image: "/images/products/sony_xperia.jpg" },
  { name: "Lenovo G700", price: 2900,
    image: "/images/products/lenovo_g700.jpg" },
  { name: "Amazon Kindle 5", price: 8150,
    image: "/images/products/amazon_kindle.jpg" },
  { name: "Canon EOS 600D Kit", price: 2840,
    image: "/images/products/canon_eos.jpg" },
  { name: "Apple iPod shuffle 4 2Gb", price: 3560,
    image: "/images/products/apple_ipod.jpg" },
  { name: "Samsung Gear 2 Neo", price: 8490,
    image: "/images/products/samsung_gear.jpg" },
  { name: "Lenovo IdeaTab A7600 16Gb 3G", price: 1020,
    image: "/images/products/lenovo_ideatab.jpg" },
  { name: "LG GA-B409 SLCA", price: 3230,
    image: "/images/products/lg_ga.jpg" },
  { name: "Long satin dress", price: 1499,
    image: "/images/products/long_satin_dress.jpg" },
  { name: "Leather court shoes", price: 4999,
    image: "/images/products/leather_court_shoes.jpg" },
  { name: "Shiny leggings", price: 1499,
    image: "/images/products/shiny_leggins.jpg", sale_price: 1000 }
].each {|p| Product.create p}
