class BidsController < ApplicationController
	before_action :set_bid, only: [:show, :edit, :update, :destroy, :release_payment]
	before_action :set_auction, only: [:new, :temp_user_new_bid, :temp_user_create_bid, :edit, :create, :destroy, :update]
	before_action :set_transaction, only: [:show, :update, :funds_released]

	def index
		@bids = current_user.bids
		@supplier_auctions = AuctionDecorator.decorate_collection(current_user.auctions_with_owned_bids)
		@sales_count = Transaction.where(seller_id: current_company.id, status: 5).count
		@pending_sales_count = Transaction.where(seller_id: current_company.id).where.not(status: 5).count

	end

	def show
		@company = @bid.company
		@auction = @bid.auction
		@document = Document.new
	end

	def new
		redirect_to temp_user_new_bid_path if !current_user.inventory_parts.find_by(part_num: @auction.part_num)
		@bid = Bid.new
		@match_parts = Bid.matched_parts(@auction, current_company)
	end

	def temp_user_new_bid
		@bid = Bid.new
	end


	def temp_user_create_bid
		Bid.strip_symbols(bid_params)
		@bid = @auction.bids.new(bid_params)
		@inventory_part = InventoryPart.new(inventory_part_params)
		part_match = Part.find_by(part_num: @inventory_part.part_num.upcase)
		respond_to do |format|
			if part_match
				@bid.inventory_part = @inventory_part
				if @bid.save
					@inventory_part.add_part_details(part_match, current_company)
					if @inventory_part.save
						# document_params[:attachment].each { |doc| @bid.documents.create(name: doc.original_filename, attachment: doc)} if document_params
						Notification.notify_other_bidders(@auction, current_user, :competing_quote)
						Notification.notify_auctioner(@auction, :new_quote)
						format.html { redirect_to @bid.auction, notice: 'Your quote has been saved' }
					else
						format.html { render :temp_user_new_bid }
					end
				elsif !part_match
					flash[:error] = "Part number is not valid"
					format.html { redirect_to temp_user_new_bid(@bid.auction), alert: 'Part Number was not valid.' }
				else
					flash[:error] = @bid.errors.full_messages.to_sentence.gsub('.','')
					format.html { redirect_to new_auction_bid_path(@auction) }
					format.json { render json: @bid.errors, status: :unprocessable_entity }
				end
			end
		end
	end

	def edit
	end

	def create
		Bid.strip_symbols(bid_params)
		@bid = @auction.bids.new(bid_params)
		@bid.user = current_user
		respond_to do |format|
			if @bid.save
				document_params[:attachment].each { |doc| @bid.documents.create(name: doc.original_filename, attachment: doc)} if document_params
				Notification.notify_other_bidders(@auction, current_user, :competing_quote)
				Notification.notify_auctioner(@auction, :new_quote)
				format.html { redirect_to @auction, notice: 'Quote was successfully created.' }
				format.json { render :show, status: :created, location: @bid }
			else
				flash[:error] = @bid.errors.full_messages.to_sentence.gsub('.','')
				format.html { redirect_to new_auction_bid_path(@auction) }
				format.json { render json: @bid.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			@bid.assign_attributes(bid_params)
			if @bid.update(bid_params)
				format.html { redirect_to @auction, notice: 'Quote was successfully updated.' }
				format.json { render :show, status: :ok, location: @bid }
			else
				format.html { render :edit }
				format.json { render json: @bid.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@bid.destroy
		respond_to do |format|
			format.html { redirect_to @auction, notice: 'Quote was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private

		def set_bid
			@bid = Bid.find(params[:id])
		end

		def funds_released # for testing purposes only sandbox trigger
			account_id = @bid.company.armor_account_id
			order_id = @transaction.order_id
			action_data = { "action" => "release", "confirm" => true }
			fund_result = @client.orders(account_id).update(order_id, action_data)
			@bid.auction.update(paid: true)
		end

		def bid_params
			params.require(:bid).permit(:part_price, :company_id, :auction_id, :inventory_part_id, :quantity, :reference_num, :tag_date)
		end

		def inventory_part_params
			params.require(:bid).permit(inventory_part: [:part_num, :condition, :serial_num, :manufacturer])[:inventory_part]
		end

		def document_params
			params.require(:bid).permit![:document]
		end

		def set_transaction
			@transaction = Transaction.find_by(bid_id: params[:id])
		end

		def set_auction
			@auction = Auction.find(params[:auction_id])
		end

end
