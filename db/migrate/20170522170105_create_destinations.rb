class CreateDestinations < ActiveRecord::Migration
	def change
		create_table :destinations do |t|
			t.string :address, default: ""
			t.string :city, default: ""
			t.string :state, default: ""
			t.string :country, default: ""
			t.string :zip, default: ""
			t.string :title, default: ""

			t.timestamps null: false
		end
	end
end
