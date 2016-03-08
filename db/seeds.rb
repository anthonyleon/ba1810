# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
parts_database = [
  ["MAIN ENGINE CONTROL", "8063-215", "WOODWARD", 325.60],
  ["SHAFT  HPT REAR", "1864M91P02", "CFMI", 980.10],
  ["COVER  SPINNER CONE", "335-106-402-0", "CFMI", 52.57],
  ["ENGINE STARTER", "3505526-9-1", "HONEYWELL", 637.10],
  ["HPT BLADE", "1475M35P01", "GENERAL ELECTRIC", 83.30],
  ["AIRSEAL  LPT STAGE 3", "50N008", "PRATT & WHITNEY", 1441.50],
  ["YAW DAMPER MODUEL", "28T0013-126", "BOEING", 561.38],
  ["MAIN LANDING GEAR ASSY", "65-73761-121", "BOEING", 2644.47],
  ["FAIRING", "33A1144-13", "BOEING", 10.96],
  ["SPOOL  BOOSTER", "335-009-306-0", "CFMI", 2357.00],
  ["MANIFOLD", "9387M58G02", "CFMI", 14.48],
  ["BRAKE", "26010142-5", "HONEYELL", 166.40],
  ["DISK  STAGE 3", "1590M59P01", "CFMI", 519.10],
  ["NOZZLE  SEGMENT STG 2", "305-390-506-0", "CFMI", 55.23],
  ["VHF TRANSCEIVER", "822-1044-004", "ROCKWELL COLLINS", 332.52],
  ["ALTIMETER TRANSCEIVER", "9599-607-14", "BRITISH AEROSPACE", 200.77],
  ["TCAS COMPUTER", "9000000-20004", "ACSS", 993.69]



]

parts_database.each do |description, partnum, manufacturer, manufacturer_price|
  Part.create(description: description, part_num: partnum, manufacturer: manufacturer, manufacturer_price: manufacturer_price)
end
