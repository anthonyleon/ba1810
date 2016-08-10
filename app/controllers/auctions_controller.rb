class AuctionsController < ApplicationController
  before_action :set_auction, only: [:show, :edit, :update, :destroy]
  before_action :set_bid_and_auction, only: [:purchase]

  def index
    @owned_auctions = current_user.auctions.where(active: true)
    @supplier_auctions = owned_bids
    get_sales_opportunities
  end

  def show
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
    @auction.condition_match

    respond_to do |format|

      if @part_match
          @auction_part = AuctionPart.new(
            part_num: @part_match.part_num,
            init_price: @part_match.manufacturer_price,
            description: @part_match.description,
            manufacturer: @part_match.manufacturer
          )
          # @auction.save && @auction_part.save
          @part_match.auction_parts << @auction_part
          @auction.auction_part = @auction_part
          current_user.auctions << @auction
          @auction.save && @auction_part.save

          notify_of_opportunities("You have a new opportunity to sell!")
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
        format.html { redirect_to @auction, notice: 'Auction was successfully updated.' }
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

  def purchase
    # create transaction
    transaction = Transaction.create_armor_order(@bid)
    ## get URL modal popup
    p @url = ArmorPaymentsApi.get_payment_url(current_user, transaction)

    @auction.update(active: false)

    ## triggering payment being made ONLY FOR SANDBOX ENVIRONMENT
    action_data = { "action" => "add_payment", "confirm" => true, "source_account_id" => current_user.armor_account_id, "amount" => @bid.total_amount }
    p result = ArmorPaymentsApi::CLIENT.orders(current_user.armor_account_id).update(transaction.order_id, action_data)
    # webhook saying full payment has been received for the below notification
    notify_of_sale("You have won an auction! Please proceed with shipment process.")
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

    def notify_of_sale(message)
      Notification.create(company: @bid.company, bid: @bid, auction: @auction, message: message)
    end


    def get_sales_opportunities
      parts = current_user.inventory_parts
      parts.uniq! { |part| [part[:part_num], part[:condition]] }
      @sales_opportunities = []
      parts.each do |part|
        #stick auction in sales opportunities if the auction is not the current_user's, already contains a current_user bid, or if the auction isn't asking for the part in questions condition
        Auction.where(part_num: part.part_num, active: true).each do |auction|
          @sales_opportunities << auction unless auction.company == current_user || !(auction.bids & current_user.bids).empty? || !auction.condition.include?(part.condition)
          @sales_opportunities << auction if auction.condition == "All Conditions" && auction.company != current_user && (auction.bids & current_user.bids).empty?
        end
      end
      @sales_opportunities.uniq!
    end

    def owned_bids
      auctions = []
      current_user.bids.each do |bid|
        auctions << bid.auction if bid.auction.active
      end
      auctions
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
      params.require(:auction).permit(:company_id, :part_num, :condition_ne, :condition_oh, :condition_sv, :condition_ar, :condition_sc, :destination_address, :destination_zip, :destination_city, :destination_state, :destination_country, :required_date, :resale_status, :resale_yes, :resale_no)
    end
end
