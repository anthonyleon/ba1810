require 'rails_helper'

feature "Pages from Dashboard Should All Work" do


	let(:company) do
		company = create(:company)
	end

	def login
		sign_in company
	end


	context "Side Nav" do
		context "My Auctions View" do
			it "shouldn't raise an error" do
				login
				visit auctions_path
			end
		end	

		context "Pending Purchases" do
			it "shouldn't raise an error" do	
				login
				visit pending_purchases_path
			end
		end	

		context "Completed Purchases" do
			it "shouldn't raise an error" do	
				login
				visit purchases_path
			end
		end		
	end

	context "All Sell Views from Dashboard Should be Accessible" do
		context "My Auctions View" do
			it "shouldn't raise an error" do	
				login
				visit bids_path
			end
		end	

		context "My Auctions View" do
			it "shouldn't raise an error" do	
				login
				visit pending_sales_path
			end
		end	

		context "My Auctions View" do
			it "shouldn't raise an error" do	
				login
				visit sales_path
			end
		end		
	end

	context "All Manage Views from Dashboard Should be Accessible" do
		context "My Inventory Parts" do
			it "shouldn't raise an error" do	
				login
				visit inventory_parts_path
			end
		end	

		context "Aircraft Listings" do
			it "shouldn't raise an error" do	
				login
				visit aircrafts_path
			end
		end	

		context "Engine Listings" do
			it "shouldn't raise an error" do	
				login
				visit engines_path
			end
		end		
	end

	context "Top Nav" do

		context "Settings" do
			it "shouldn't raise an error" do	
				login
				visit edit_company_path
			end
		end	

		context "Completed Purchases" do
			it "shouldn't raise an error" do	
				login
				visit notifications_index_path
			end
		end		
	end
end
