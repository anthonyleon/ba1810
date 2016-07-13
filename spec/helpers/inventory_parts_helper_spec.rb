require 'rails_helper'

module InventoryPartHelper
	def create_inventory
		@inventory_part = InventoryPart.create(part_num: "8063-215", serial_num: "1", condition: "New")
  end

  def current_opportunity 
  	@auction = Auction.create(part_num: "8063-215", condition: "New")
  end
end
