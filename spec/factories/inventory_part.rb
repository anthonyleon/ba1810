FactoryGirl.define do
  factory :inventory_part do
    part_num      "9000000-20004"
    description   "TCAS COMPUTER"
    manufacturer  "ACSS"
    serial_num    "191223"
    condition     :as_removed
    # company
  end
end
