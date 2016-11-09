class AuctionsController < ApplicationController
  before_action :set_auction, only: [:show, :edit, :update, :destroy]
  before_action :set_bid_and_auction, only: [:purchase_confirmation, :purchase]

  def index
    @owned_auctions = current_user.auctions.where(active: true).decorate
    # @supplier_auctions = AuctionDecorator.decorate_collection(current_user.auctions_with_owned_bids)
    # above code (@owned_auctions) should look like this but I need to work on auctions_with_owned_bids first
    # @supplier_auctions = current_user.auctions_with_owned_bids.decorate
    # @sales_opportunities = AuctionDecorator.decorate_collection(Auction.get_sales_opportunities(current_user))
  end

  def show
    @auction = @auction.decorate
    @msrp = @auction.auction_part.init_price
  end

  def new
    @auction = Auction.new
  end

  def edit
  end

  def create
    @auction = Auction.new(auction_params)
    @part_match = Part.find_by(part_num: @auction.part_num)
    @auction.resale_check
    respond_to do |format|

      if @part_match
          AuctionPart.make(@part_match, @auction)
          @auction.company = current_user
          @auction.save
          Notification.notify_of_opportunities(@auction, @auction.company, "You have a new opportunity to sell!")
          format.html { redirect_to @auction, notice: 'Auction was successfully created.' }
          format.json { render :show, status: :created, location: @auction }
      else
        format.html { redirect_to new_auction_path, alert: 'That part does not exist in our database.' }
      end
    end
  end

  def update
    respond_to do |format|
      if @auction.update(auction_params)
        unless params[:commit] == "Update Auction"
          @transaction = Transaction.find(transaction_params[:id])
          @transaction.update(transaction_params)
        end
        format.html { redirect_to @auction, notice: 'Auction was successfully updated.' }
        format.js { }
        format.json { render :show, status: :ok, location: @auction }
      else
        format.html { render :edit }
        format.json { render json: @auction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @auction.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Auction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def purchase_confirmation
      @transaction = Transaction.create_order(@bid) unless @bid.tx # change to Transaction.new, and next action Transaction.new(transaction_params) then @transaction.save
      if @auction.tx
        @auction.tx.destroy
        @transaction = Transaction.create_order(@bid)
      end
      ## triggering payment being made ONLY FOR SANDBOX ENVIRONMENT [testing purposes]
      # action_data = { "action" => "add_payment", "confirm" => true, "source_account_id" => current_user.armor_account_id, "amount" => @transaction.total_amount }
      # p result = ArmorPaymentsApi::CLIENT.orders(current_user.armor_account_id).update(@transaction.order_id, action_data)
      # webhook saying full payment has been received for the below notification
  end

  def current_opportunities
    @sales_opportunities = AuctionDecorator.decorate_collection(Auction.get_sales_opportunities(current_user))
  end

  private

    def notify_of_opportunities(message)
      parts = []
      parts = InventoryPart.where(part_num: @auction.part_num).each do |part|
        parts << part if @auction.condition.include?(part.condition) || @auction.condition == "All Conditions"
      end
      parts.uniq! { |p| p.company_id }
      parts.each do |part|
        Notification.create(company: part.company, auction: @auction, message: message) unless part.company == current_user
      end
    end

    def set_auction
      @auction = Auction.find(params[:id])
    end

    def set_bid_and_auction
      @auction = Auction.find(params[:auction_id])
      @bid = Bid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_params
      params.require(:auction).permit(:company_id, :part_num, :destination_company, :destination_address, :destination_zip, :destination_city, :destination_state, :destination_country, :required_date, :resale_status, :resale_yes, :resale_no, condition: [])
    end

    def transaction_params
      params.require(:auction).permit(transactions: [:id, :carrier, :shipping_account])[:transactions]
    end
end
