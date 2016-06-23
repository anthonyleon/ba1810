@company = Company.create!(name: "Admin", email: 'admin@demo.com', password: 'password', password_confirmation: 'password')
# @company2 = Company.create!(name: "Company2", email: 'Company2@demo.com', password: 'password', password_confirmation: 'password')
# # This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
parts_database = [
  ["MAIN ENGINE CONTROL", "8063-215", "WOODWARD", 32560],
  ["SHAFT  HPT REAR", "1864M91P02", "CFMI", 98010],
  ["COVER  SPINNER CONE", "335-106-402-0", "CFMI", 5257],
  ["ENGINE STARTER", "3505526-9-1", "HONEYWELL", 63710],
  ["HPT BLADE", "1475M35P01", "GENERAL ELECTRIC", 8330],
  ["AIRSEAL  LPT STAGE 3", "50N008", "PRATT & WHITNEY", 144150],
  ["YAW DAMPER MODUEL", "28T0013-126", "BOEING", 56138],
  ["MAIN LANDING GEAR ASSY", "65-73761-121", "BOEING", 264447],
  ["FAIRING", "33A1144-13", "BOEING", 1096],
  ["SPOOL  BOOSTER", "335-009-306-0", "CFMI", 235700],
  ["MANIFOLD", "9387M58G02", "CFMI", 1448],
  ["BRAKE", "26010142-5", "HONEYELL", 16640],
  ["DISK  STAGE 3", "1590M59P01", "CFMI", 51910],
  ["NOZZLE  SEGMENT STG 2", "305-390-506-0", "CFMI", 5523],
  ["VHF TRANSCEIVER", "822-1044-004", "ROCKWELL COLLINS", 33252],
  ["ALTIMETER TRANSCEIVER", "9599-607-14", "BRITISH AEROSPACE", 20077],
  ["TCAS COMPUTER", "9000000-20004", "ACSS", 99369]



]

parts_database.each do |description, partnum, manufacturer, manufacturer_price|
  Part.create(description: description, part_num: partnum, manufacturer: manufacturer, manufacturer_price: manufacturer_price)
end


i = 1
while (i < 30)
  Company.create( name: Faker::Company.name, email: Faker::Internet.email,  password: 'password', password_confirmation: 'password')
  parts_database.each do |description, partnum, manufacturer, manufacturer_price|
    InventoryPart.create(part_num: partnum, description: description,  manufacturer: manufacturer, company_id: i, serial_num: "191223", condition: "OH")
  end
  i += 1
end



# 5.times do
#   @auction = Auction.create(company_id: @company.id, part_num: Faker::Company.ein, active: true, condition: "OH", condition_oh: true)
# end

# 5.times do
#   AuctionPart.create( part_num: Faker::Company.ein, description: Faker::Company.catch_phrase,
#                       manufacturer: Faker::Company.name, init_price: Faker::Commerce.price)




i = 0
while (i < 16)
  i+=1
  Auction.create(company_id: i, part_num: parts_database[i-1][1], active: true, condition: "OH", condition_oh: true)

end

i = 0
while (i < 16)
  i+=1
  AuctionPart.create( part_num: parts_database[i-1][1], description: Faker::Company.catch_phrase,
                      manufacturer: Faker::Company.name, init_price: Faker::Commerce.price, auction_id: i)

end

i = 0
while (i < 30)
  i+=1
  Bid.create( amount: Faker::Commerce.price, company_id: i, auction_id: Faker::Number.between(1, 10), inventory_part_id: Faker::Number.between(1, 150))
end
