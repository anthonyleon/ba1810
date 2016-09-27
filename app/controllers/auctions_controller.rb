class AuctionsController < ApplicationController
  before_action :set_auction, only: [:show, :edit, :update, :destroy]
  before_action :set_bid_and_auction, only: [:purchase_confirmation, :purchase]

  def index
    @owned_auctions = current_user.auctions.where(active: true).decorate
    @supplier_auctions = AuctionDecorator.decorate_collection(current_user.owned_bids)
    # above code should look like this but I need to work on owned_bids first
    # @supplier_auctions = current_user.owned_bids.decorate
    @sales_opportunities = AuctionDecorator.decorate_collection(get_sales_opportunities)
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
    @auction.condition_match
    @auction.resale_check
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
    ## create transaction
    ## if else logic for testing purposes, for if armor order already created
    # if @bid.tx
    #   @transaction = @bid.tx
    # else
      @transaction = Transaction.create_order(@bid) # delete for testing
      ## triggering payment being made ONLY FOR SANDBOX ENVIRONMENT
      action_data = { "action" => "add_payment", "confirm" => true, "source_account_id" => current_user.armor_account_id, "amount" => @bid.tx.total_amount }
      p result = ArmorPaymentsApi::CLIENT.orders(current_user.armor_account_id).update(@transaction.order_id, action_data)
      # webhook saying full payment has been received for the below notification
      notify_of_sale("You have won an auction! Please proceed with shipment process.")
    # end

    ## get URL modal popup
    @url = ArmorPaymentsApi.get_payment_url(current_user, @transaction)
  end

  def purchase
    @transaction = @auction.tx
    @transaction = Transaction.create_order(@bid) unless @auction.tx
    @transaction.calculate_total_payment

    @transaction.create_armor_order unless @transaction.order_id
    @auction.update(active: false)


    @carriers = ArmorPaymentsApi.carriers_list if @transaction.paid
    ## get URL modal popup
    @url = ArmorPaymentsApi.get_payment_url(current_user, @transaction) unless @transaction.shipped
    @url = ArmorPaymentsApi.release_payment(@bid, current_user) if @transaction.delivered

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
      @sales_opportunities.uniq
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
      params.require(:auction).permit(:company_id, :part_num, :condition, :destination_address, :destination_zip, :destination_city, :destination_state, :destination_country, :required_date, :resale_status, :resale_yes, :resale_no)
    end
end
