class AuctionsController < ApplicationController
	before_action :set_auction, only: [:show, :edit, :update, :destroy, :invite_more_suppliers]
	before_action :set_bid_and_auction, only: [:purchase_confirmation, :purchase]
	before_action :set_destination, only: [:show, :purchase_confirmation]
	autocomplete :company, :name, full: true

	def index
		@owned_auctions = current_user.auctions.where(active: true).where(project: nil)
		@pending_purchases_count = Transaction.where(buyer_id: current_company.id, status: 5).count
		@purchases_count = Transaction.where(buyer_id: current_company.id).where.not(status: 5).count
	end

	def show
		## should show if one of the auctions is a current_users
		@auction_invitees = @auction.invites.joins(:company).map(&:company)
		@invited_suppliers_bids = @auction.bids.joins(:company).where(companies: {id: @auction.invites.map(&:company_id)})
		@bid_aero_suppliers_bids = (@auction_invitees.empty? ? @auction.bids.joins(:company) : 
									@auction.bids.joins(:company).where.not(companies: {id: @auction_invitees.map(&:id)}))
	end

	def auction_invites
		@auctions = current_user.invites.map(&:auction)
	end

	def new
		@projects = current_user.projects
		@project = params[:project_id]
		@auction = Auction.new
	end

	def edit
		@auction_invitees = Company.find_invitees(@auction.invitees)
	end

	def create

		auction_params[:target_price].gsub!(' ', '')
		params["invitees"].delete("") if params["invitees"]

		@auction = Auction.new(auction_params)
		@destination = Destination.new(destination_params)
		@auction.destination = @destination
		part_match = Part.find_by(part_num: @auction.part_num.upcase)
		@auction.resale_check
		respond_to do |format|
			@auction.company = current_company
			@auction.user = current_user
			@auction.condition.map!{ |x| x.to_sym }
			if @auction.save
				invitees = @auction.set_invitees(params[:invitees]) if params[:invitees]
				@destination.update(country: params["country"])
				# @auction.invite_and_setup_suppliers(invitees)
				@auction.req_forms.reject! { |c| c.empty? }
				Auction.part_match_or_not_actions(@auction, part_match)
				Notification.notify_of_opportunities(@auction, @auction.company, :broadcast)
				format.html { redirect_to @auction, notice: 'RFQ was successfully created.' }
				format.json { render :show, status: :created, location: @auction }
			else
				format.html { render :new }
				format.json { render json: @auction.errors, status: :unprocessable_entity }
			end
		end
	end

	def invite_more_suppliers
		params["invitees"].delete("")
		@auction.set_invitees(params[:invitees]) if params[:invitees]
		render nothing: true
	end

	def update
		respond_to do |format|
			params["invitees"].delete("")
			if params[:target_price]
				@auction.update(target_price: params[:target_price].gsub(' ', ''))
			elsif @auction.update(auction_params)
				@destination = @auction.destination
				@destination.update(destination_params)
				@auction.set_invitees(params[:invitees]) if params[:invitees]
				@auction.invite_and_setup_suppliers(@auction.invitees)
				@auction.update(condition: auction_params[:condition].map!{ |x| x.to_sym }) if auction_params[:condition]
			else
				format.html { render :edit }
				format.json { render json: @auction.errors, status: :unprocessable_entity }
			end
			@auction.save
			format.html { redirect_to @auction, notice: 'RFQ was successfully updated.' }
			format.js { }
			format.json { render :show, status: :ok, location: @auction }
		end
	end

	def destroy
		@auction.destroy
		respond_to do |format|
			format.html { redirect_to auctions_path, notice: 'RFQ was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	def purchase_confirmation
		# this action (auctions#purchase_confirmation) should be moved to Transaction as the new action
		@transaction = Transaction.new
	end

	def current_opportunities
		@sales_opportunities = current_company.sales_opportunities
		@todays_opportunity_count = (@sales_opportunities.select { |attachment| attachment.created_at == Time.zone.now.beginning_of_day }).count
		Auction.find(@sales_opportunities.map(&:id)).each { |x| @todays_opportunity_count +=1 if x.created_at.between?(DateTime.now.at_beginning_of_day.utc, Time.now.utc) }
		@decorated_sales_opportunities = AuctionDecorator.decorate_collection(@sales_opportunities)
	end


	private

	def set_auction
		@auction = Auction.find(params[:id])
	end

	def set_destination
		@destination = @auction.destination
	end

	def set_bid_and_auction
		@auction = Auction.find(params[:auction_id])
		@bid = Bid.find(params[:id])
	end

	def auction_params
		params.require(:auction).permit(:company_id, :project_id, :part_num, :target_price, :cycles, :quantity,
										:country, :required_date, :resale_status, :resale_yes, :resale_no,
										:rep_name, :rep_email, :rep_phone, :reference_num,
										condition: [], req_forms: [], invitees: [])
	end

	def transaction_params
		params.require(:auction).permit(transactions: [:id, :carrier, :shipping_account])[:transactions]
	end

	def destination_params
		params.require(:auction).permit(destination: [:title, :address, :city, :state, :zip])[:destination]
	end
end
