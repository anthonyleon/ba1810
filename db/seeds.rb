# This file should contain all the record creation needed to seed the database with its default values.
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
