require 'rails_helper'

feature "Sales Opportunities" do
	let(:part) do
		create(:part)
	end

	let(:second_part) do
		create(:part, part_num: "8063-215")
	end

	let(:third_part) do
		create(:part, part_num: "A07D32")
	end

	let(:selling_company) do
		company = create(:company)
		create(:inventory_part, company: company, part: part)
		create(:inventory_part, company: company, part: second_part)
		company
	end

	let!(:buying_company) do
		company = create(:company)

		auction = create(:auction, company: company)
		create(:auction_part, auction: auction, part: part)

		company
	end

	let(:auction) do
		buying_company.auctions.first
	end

	def sign_in_and_visit
		sign_in selling_company
		visit current_opportunities_path
	end

	def condition_match?(auction, inventory_part)
		p "**" * 80
		auction.conditions.include?(inventory_part.condition.to_sym)
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
				second_auction = create(:auction, company: buying_company)
				create(:auction_part, part: second_part, auction: second_auction)

				sign_in_and_visit
				expect(page).to have_content(part.part_num, count: 2)
				expect(page).to have_content(selling_company.inventory_parts.first.abbreviated_condition, count: 2)
			end

			it "show auctions for two different parts as sales opportunities" do
				second_auction = create(:auction, company: buying_company, part_num: second_part.part_num)
				create(:auction_part, part: second_part, auction: second_auction)
				second_part
				second_auction

				sign_in_and_visit
				expect(page).to have_content(part.part_num, count: 1)
				expect(page).to have_content(second_part.part_num, count: 1)
				expect(page).to have_content(selling_company.inventory_parts.first.abbreviated_condition, count: 2)
			end
		end

	end

	context "invalid sales opportunities" do 
		context "1 seller, 1 buyer, 1 part, 1 seller bid" do
			it "auction isn't a sales opportunity" do 
				create(:bid, company: selling_company, auction: auction, inventory_part: selling_company.inventory_parts.first)

				sign_in_and_visit
				expect(page).to have_no_content(part.part_num)
			end
		end

		context "multiple auctions, some bids" do
			it "only unbid auctions are sales opportunities" do
				# 2nd auction
				second_auction = create(:auction, company: buying_company)
				create(:auction_part, part: part, auction: second_auction)
				expect(part.auctions.count).to eq(2)

				# seller's bid
				create(:bid, company: selling_company, auction: second_auction, inventory_part: selling_company.inventory_parts.first)

				sign_in_and_visit
				sales_opportunity_not_duplicated?
			end
		end

		context "mutiple copies of an inventory part" do
			it "auction should only appear once" do
				create(:inventory_part, company: selling_company, part: part)
				expect(selling_company.inventory_parts.count).to eq(3)
				expect(part.auctions.count).to eq(1)

				sign_in_and_visit
				sales_opportunity_not_duplicated?
			end
		end
	end

	context "every condition for auctions should show for the appropriate inventory part conditions" do
		it "Auction for NEW part should show for part in NEW condition" do
			new_part = create(:inventory_part, part_num: "A07D32", condition: 0, company: selling_company, part: third_part)
			new_auction = create(:auction, part_num: new_part.part_num, condition: [:recent, :""], company: buying_company)
			create(:auction_part, auction: new_auction, part: third_part)

			sign_in_and_visit
			expect(page).to have_content(new_part.part_num, count: 1)
			expect(page).to have_content(selling_company.inventory_parts.last.abbreviated_condition, count: 1)
		end
		it "Auction for OVERHAUL part should show for part in OVERHAUL condition" do
			oh_part = create(:inventory_part, part_num: "A07D32", condition: 1, company: selling_company, part: third_part)
			oh_auction = create(:auction, part_num: oh_part.part_num, company: buying_company, condition: [:overhaul, :""])
			create(:auction_part, auction: oh_auction, part: third_part)

			sign_in_and_visit
			expect(page).to have_content(oh_part.part_num, count: 1)
			# should show OH condition twice because first auction of selling company is asking for part in OH condition 
				# that is also in this selling_company's inventory
			expect(page).to have_content(selling_company.inventory_parts.last.abbreviated_condition, count: 2)
		end

		it "Auction for AS REMOVED part should show for part in AS REMOVED condition" do
			ar_part = create(:inventory_part, part_num: "A07D32", condition: 2, company: selling_company, part: third_part)
			ar_auction = create(:auction, part_num: ar_part.part_num, company: buying_company, condition: [:as_removed, :""])
			create(:auction_part, auction: ar_auction, part: third_part)

			sign_in_and_visit
			# should show AR condition twice because first auction of selling company is asking for part in AR condition 
				# that is also in this selling_company's inventory
			expect(page).to have_content(ar_part.part_num, count: 1)
			expect(page).to have_content(selling_company.inventory_parts.last.abbreviated_condition, count: 2)
				
		end

		it "Auction for SERVICEABLE part should show for part in SERVICEABLE condition" do
			sv_part = create(:inventory_part, part_num: "A07D32", condition: 3, company: selling_company, part: third_part)
			sv_auction = create(:auction, part_num: sv_part.part_num, condition: [:serviceable, :""], company: buying_company)
			create(:auction_part, auction: sv_auction, part: third_part)

			sign_in_and_visit
			expect(page).to have_content(sv_part.part_num, count: 1)
			expect(page).to have_content(selling_company.inventory_parts.last.abbreviated_condition, count: 1)
		end

		it "Auction for NON SERVICEABLE part should show for part in NON SERVICEABLE condition" do
			nsv_part = create(:inventory_part, part_num: "A07D32", condition: 4, company: selling_company, part: third_part)
			nsv_auction = create(:auction, part_num: nsv_part.part_num, company: buying_company, condition: [:non_serviceable, :""])
			create(:auction_part, auction: nsv_auction, part: third_part)

			sign_in_and_visit
			expect(page).to have_content(nsv_part.part_num, count: 1)
			expect(page).to have_content(selling_company.inventory_parts.last.abbreviated_condition, count: 1)
		end
		it "Auction for SCRAP part should show for part in SCRAP condition" do
			sc_part = create(:inventory_part, part_num: "A07D32", condition: 5, company: selling_company, part: third_part)
			sc_auction = create(:auction, part_num: sc_part.part_num, company: buying_company, condition: [:scrap, :""])
			create(:auction_part, auction: sc_auction, part: third_part)

			sign_in_and_visit
			expect(page).to have_content(sc_part.part_num, count: 1)
			expect(page).to have_content(selling_company.inventory_parts.last.abbreviated_condition, count: 1)
		end
	end
end
