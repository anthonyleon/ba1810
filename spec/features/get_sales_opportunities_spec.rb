require 'rails_helper'

feature "Sales Opportunities" do
	let(:part) do
		create(:part)
	end

	let(:selling_company) do
		company = create(:company)
		create(:inventory_part, company: company, part: part)
		company
	end

	let!(:buying_company) do
		company = create(:company)
		auction = create(:auction, company: company, auction_part: create(:auction_part, part: part))
		company
	end

	let(:auction) do
		buying_company.auctions.first
	end

	def sign_in_and_visit
		sign_in selling_company
		visit current_opportunities_path
	end

	def sales_opportunity_exists?
		expect(page).to have_content(part.part_num)
		expect(page).to have_content(selling_company.inventory_parts.first.abbreviated_condition)
	end

	def sales_opportunity_not_duplicated?
		expect(page).to have_content(part.part_num, count: 1)
		expect(page).to have_content(selling_company.inventory_parts.first.abbreviated_condition, count: 1)
	end

	context "valid sales opportunities" do
		context "1 seller, 1 buyer, 1 part, no bids" do
			it "auction is a sales opportunity" do
				sign_in_and_visit
				sales_opportunity_exists?
			end
		end		

		context "1 seller, 1 buyer, 1 part, 2 random bids" do
			it "auction is a sales opportunity" do
				2.times { create(:bid, auction: auction) } # 2 random bids
				
				sign_in_and_visit
				sales_opportunity_exists?
			end
		end

		context "multiple auctions, no bids" do
			it "every unbid auction is a sales opportunity" do
				# 2nd auction
				create(:auction, company: buying_company, auction_part: create(:auction_part, part: part))

				sign_in_and_visit
				expect(page).to have_content(part.part_num, count: 2)
				expect(page).to have_content(selling_company.inventory_parts.first.abbreviated_condition, count: 2)
			end
		end

	end

	context "invalid sales opportunities" do 
		context "1 seller, 1 buyer, 1 part, 1 seller bid" do
			it "auction isn't a sales opportunity" do 
				create(:bid, company: selling_company, auction: auction) # seller's bid

				sign_in_and_visit
				expect(page).to have_no_content(part.part_num)
			end
		end

		context "multiple auctions, some bids" do
			it "only unbid auctions are sales opportunities" do
				# 2nd auction
				second_auction = create(:auction, company: buying_company, auction_part: create(:auction_part, part: part))
				expect(part.auctions.count).to eq(2)

				# seller's bid
				create(:bid, company: selling_company, auction: second_auction)

				sign_in_and_visit
				sales_opportunity_not_duplicated?
			end
		end

		context "mutiple copies of an inventory part" do
			it "auction should only appear once" do
				create(:inventory_part, company: selling_company, part: part)
				expect(selling_company.inventory_parts.count).to eq(2)
				expect(part.auctions.count).to eq(1)

				sign_in_and_visit
				sales_opportunity_not_duplicated?
			end
		end
	end
end
