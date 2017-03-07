# @company = Company.create!(name: "Admin", email: 'admin@demo.com', password: 'password', password_confirmation: 'password')
# @company2 = Company.create!(name: "Company2", email: 'Company2@demo.com', password: 'password', password_confirmation: 'password')
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# parts_database = [
#   open["MAIN ENGINE CONTROL", "8063-215", "WOODWARD", 32560],
#   ["SHAFT  HPT REAR", "1864M91P02", "CFMI", 98010],
#   ["COVER  SPINNER CONE", "335-106-402-0", "CFMI", 5257],
#   ["ENGINE STARTER", "3505526-9-1", "HONEYWELL", 63710],
#   ["HPT BLADE", "1475M35P01", "GENERAL ELECTRIC", 8330],
#   ["AIRSEAL  LPT STAGE 3", "50N008", "PRATT & WHITNEY", 144150],
#   open["YAW DAMPER MODUEL", "28T0013-126", "BOEING", 56138],
#   ["MAIN LANDING GEAR ASSY", "65-73761-121", "BOEING", 264447],
#   ["FAIRING", "33A1144-13", "BOEING", 1096],
#   ["SPOOL  BOOSTER", "335-009-306-0", "CFMI", 235700],
#   ["MANIFOLD", "9387M58G02", "CFMI", 1448],
#   open["BRAKE", "26010142-5", "HONEYELL", 16640],
#   ["DISK  STAGE 3", "1590M59P01", "CFMI", 51910],
#   ["NOZZLE  SEGMENT STG 2", "305-390-506-0", "CFMI", 5523],
#   ["VHF TRANSCEIVER", "822-1044-004", "ROCKWELL COLLINS", 33252],
#   ["ALTIMETER TRANSCEIVER", "9599-607-14", "BRITISH AEROSPACE", 20077],
#   ["TCAS COMPUTER", "9000000-20004", "ACSS", 99369]
# ]

# parts_database.each do |description, partnum, manufacturer, manufacturer_price|
#   Part.create(description: description, part_num: partnum, manufacturer: manufacturer, manufacturer_price: manufacturer_price)
# end


# i = 1
# while (i < 30)
#   Company.create( name: Faker::Company.name, email: Faker::Internet.email,  password: 'password', password_confirmation: 'password', phone: "305-726-8857", address: Faker::Address.street_address, city: Faker::Address.city, state: Faker::Address.state, zip: Faker::Address.zip_code, representative: Faker::Internet.user_name, country: Faker::Address.country_code, url: 'bid.aero', business_type: 2)
#   parts_database.each do |description, partnum, manufacturer, manufacturer_price|
#     InventoryPart.create(part_num: partnum, description: description,  manufacturer: manufacturer, company_id: i, serial_num: "191223", condition: rand(0..4))
#   end
#   i += 1
# end



# 5.times do
#   @auction = Auction.create(company_id: @company.id, part_num: Faker::Company.ein, active: true, condition: "OH", condition_oh: true)
# end

# 5.times do
#   AuctionPart.create( part_num: Faker::Company.ein, description: Faker::Company.catch_phrase,
#                       manufacturer: Faker::Company.name, init_price: Faker::Commerce.price)
# end



# i = 30
# while i < 36
#   i += 1
#   5.times do
#     Rating.create( packaging: rand(1..5), timeliness: rand(1..5), documentation: rand(1..5), bid_aero: rand(1..5), dependability: rand(1..5), company_id: i)
#   end
# end

# i = 1
# while (i < 16)
# 	i += 1
# 	Aircraft.create( aircraft_type: Faker::Company.ein, msn: Faker::Company.ein, tail_number: Faker::StarWars.droid,
# 									 yob: rand(1999..2016), mtow: Faker::Number.number(5), engine_major_variant: Faker::Company.name,
# 									 engine_minor_variant: Faker::Company.name, apu_model: Faker::Company.name,
# 									 cabin_config: Faker::Beer.hop, service_status: 0, current_operator: Faker::StarWars.vehicle,
# 									 last_operator: Faker::StarWars.vehicle, location: Faker::StarWars.planet, maintenance_status: "A - Check",
# 									 available_date: Faker::Date.forward(229), sale: true, company_id: i)
# end

# i = 1
# while (i < 29)
# 	i += 1
# 	Engine.create(engine_major_variant: Faker::StarWars.planet, engine_minor_variant: Faker::StarWars.planet,
# 		esn: Faker::Company.ein, condition: rand(1..3), service_status: 0,
# 		current_operator: Company.find(i).name, last_operator:Company.find(i-1).name, location: Faker::StarWars.planet,
# 		cycles_remaining: Faker::Number.number(5), available_date: Faker::Date.forward(230), lease: true, company_id: i)
# end

# Company.where(id: 1..10).each do |company|
#   company.email_activate unless !company.state
# end


## Making auctions with bids for ARMOR PAYMENTS TESTING

seller = Company.find(28)
buyer = Company.find(33)
parts = seller.inventory_parts
auctions = []

i = 0
while (i < parts.count)

  i_part = parts[i]

  auc = Auction.create(company: buyer, part_num: i_part.part_num, active: true, condition: [i_part.condition.to_sym, :""],
                 destination_address: Faker::Address.street_address, destination_zip: Faker::Address.zip, 
                 destination_city: Faker::Address.city_suffix, destination_country: Faker::Address.country, 
                 required_date: Faker::Date.forward(23), target_price: Faker::Commerce.price, quantity: 1)
  auctions << auc
  i+=1
end

i = 0
while (i < parts.count)
  AuctionPart.create( part_num: parts[i].part_num, description: parts[i].part_num,
                      manufacturer: parts[i].manufacturer, auction: auctions[i], part: i_part.part)
  i+=1
end

i = 0
while (i < parts.count)
  3.times do
    Bid.create( part_price: Faker::Commerce.price, est_shipping_cost: Faker::Commerce.price, 
                auction: auctions[i], inventory_part: parts[i])
  end
  i+=1
end
