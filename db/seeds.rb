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
    { name: 'Samsung UE22H5610',            price: 1_990,  image: 'http://mdata.yandex.net/i?path=b0613150311_img_id5308957719092040926.jpeg'},
    { name: 'Sony Xperia Z3 Compact',       price: 2_490,  image: 'http://mdata.yandex.net/i?path=b0904224335_img_id425230623294204433.jpeg'},
    { name: 'Lenovo G700',                  price: 2_900,  image: 'http://mdata.yandex.net/i?path=b0819164800_img_id5103345589481248070.jpg'},
    { name: 'Amazon Kindle 5',              price: 8_150,   image: 'http://mdata.yandex.net/i?path=b1011104710_img_id5245341255920608103.jpg'},
    { name: 'Canon EOS 600D Kit',           price: 2_840,  image: 'http://mdata.yandex.net/i?path=b0213210535_img_id6351211769282151944.jpg'},
    { name: 'Apple iPod shuffle 4 2Gb',     price: 3_560,   image: 'http://mdata.yandex.net/i?path=b0129084249_img_id6984693941852072862.jpeg'},
    { name: 'Samsung Gear 2 Neo',           price: 8_490,   image: 'http://mdata.yandex.net/i?path=b0423085224_img_id5227319824167798490.jpeg'},
    { name: 'Lenovo IdeaTab A7600 16Gb 3G', price: 1_020,  image: 'http://mdata.yandex.net/i?path=b0521004031_img_id6569655011894724867.jpeg'},
    { name: 'LG GA-B409 SLCA',              price: 3_230,  image: 'http://mdata.yandex.net/i?path=b0210151125_img_id4639031377487357309.jpg'},
].each {|p| Product.create p}
