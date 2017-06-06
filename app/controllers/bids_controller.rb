class BidsController < ApplicationController
	before_action :set_bid, only: [:show, :edit, :update, :destroy, :release_payment]
	before_action :set_auction, only: [:new, :temp_user_new_bid, :temp_user_create_bid, :edit, :create, :destroy, :update]
	before_action :set_transaction, only: [:show, :update, :funds_released]

	def index
		@bids = current_user.bids
		@supplier_auctions = AuctionDecorator.decorate_collection(current_user.auctions_with_owned_bids)
		@sales_count = Transaction.where(seller_id: current_user.id, status: 5).count
		@pending_sales_count = Transaction.where(seller_id: current_user.id).where.not(status: 5).count

	end

	def show
		@company = @bid.company
		@auction = @bid.auction
		@document = Document.new
	end

	def new
		redirect_to temp_user_new_bid_path if current_user.temp? || !InventoryPart.find_by(company: current_user, part_num: @auction.part_num)
		@bid = Bid.new
		@match_parts = Bid.matched_parts(@auction, current_user)
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
					@inventory_part.add_part_details(part_match, current_user)
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
		@parts = current_user.inventory_parts
		@match_parts = @parts.where(part_num: @auction.part_num)
		@inventory = @match_parts.ids
	end

	def create
		Bid.strip_symbols(bid_params)
		@bid = @auction.bids.new(bid_params)
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
			ArmorPaymentsApi.update_order(@transaction) if @transaction.bid.changed?
			if @bid.update(bid_params)
				format.html { redirect_to @auction, notice: 'Quote was successfully updated.' }
				format.json { render :show, status: :ok, location: @bid }
				if @transaction.tracking_num # POST shipping info to armor
					set_armor_client
					@bid.update(carrier: @client.shipmentcarriers.all[:body][@transaction.carrier_code.to_i - 1]["name"])
					user_id = @bid.company.armor_user_id
					account_id = @bid.company.armor_account_id
					order_id = @transaction.order_id
					action_data = { "user_id" => user_id, "carrier_id" => @transaction.carrier_code, "tracking_id" => @transaction.tracking_num,
													 "description" => @transaction.shipment_desc }
					result = @client.orders(account_id).shipments(order_id).create(action_data)

					# for sandbox testing purposes only (should be triggered on webhook)
					deliver_data = { "action" => "delivered", "confirm" => true }
					delivery_result = @client.orders(account_id).update(order_id, deliver_data)
				end
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
			params.require(:bid).permit(:part_price, :est_shipping_cost, :company_id, :auction_id, :inventory_part_id, :quantity, :reference_num, :tag_date)
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
