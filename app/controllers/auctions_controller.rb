class AuctionsController < ApplicationController
  before_action :set_auction, only: [:show, :edit, :update, :destroy]
  before_action :set_bid_and_auction, only: [:purchase, :purchase_confirmation]
  before_action :set_armor_client, only: [:purchase, :purchase_confirmation]

  def index
    @auctions = current_user.auctions
    @buyer_auctions = current_user.auctions.where(active: true)
    @supplier_auctions = Bid.supplier_auctions(current_user.bids)
    # @bid = Bid.where(company_id: current_user.id)
    # possible_auctions = get_possible_auctions.uniq! || get_possible_auctions
    # @possible_auctions = possible_auctions - @supplier_auctions - @buyer_auctions
    # @inactive_auctions = current_user.auctions.where(active: false)
    get_sales_opportunities
    @sales_opportunities.each do |auction|
      condition_match(auction)
    end
    @buyer_auctions.each do |auction|
        condition_match(auction)
    end
    @supplier_auctions.each do |auction|
        condition_match(auction)
      auction.update(condition: "All Conditions") if @condition.count == 5 || @condition.count == 0
    end
  end

  def show
    @init_price = @auction.auction_part.init_price
    @condition_ne = (@auction.condition_ne) ? 'New ': ""
    @condition_oh = (@auction.condition_oh) ? 'Overhaul ': ""
    @condition_sv = (@auction.condition_sv) ? 'Servicable ': ""
    @condition_ar = (@auction.condition_ar) ? 'As Removed ': ""
    @condition_sc = (@auction.condition_sc) ? 'Scrap ': ""
    @all_conditions_empty = ( @condition_ne.empty? && @condition_oh.empty? && @condition_sv.empty? && @condition_ar.empty? && @condition_sc.empty?)
  end

  def new
    @auction = Auction.new
  end

  def edit
  end

  def create
    @auction = Auction.new(auction_params)
    @part_match = Part.find_by(part_num: @auction.part_num)

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

          notify("You have a new opportunity to sell!")
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
    set_order
    result = @client.orders(@bid.company.armor_account_id).create(@order_data)
    transaction = Transaction.create(
      order_id: result.data[:body]["order_id"], 
      buyer_id: @auction.company.id, 
      seller_id: @bid.company.id, 
      inventory_part_id: @bid.inventory_part_id)
    @auction.update(transaction_id: transaction.id)
    @bid.update(transaction_id: transaction.id)

    auth_data = { 'uri' => "/accounts/#{current_user.armor_account_id}/orders/#{transaction.order_id}/paymentinstructions", 'action' => 'view' }
    result = @client.accounts.users(current_user.armor_account_id).authentications(current_user.armor_user_id).create(auth_data)
    @url = result.data[:body]["url"]
    @auction.update(active: false) #change this to be on webhook [testing purposes]

    ## triggering payment being made ONLY FOR SANDBOX ENVIRONMENT
    action_data = { "action" => "add_payment", "confirm" => true, "source_account_id" => current_user.armor_account_id, "amount" => @bid.amount }
    result = @client.orders(current_user.armor_account_id).update(transaction.order_id, action_data)
  end


  private

    def set_armor_client
      @client = ArmorPayments::API.new( ENV['ARMOR_PKEY'], ENV['ARMOR_SKEY'], true)
    end

    def set_order
      @order_data = {
        "type" => 1,
        "seller_id" => @bid.company.armor_user_id,
        "buyer_id" => current_user.armor_user_id,
        "amount" => @bid.amount,
        "summary" => @auction.part_num,
        "description" => @bid.inventory_part.condition,
        "invoice_num" => "123456",
        "purchase_order_num" => "675890",
        "message" => "Hello, Example Buyer! Thank you for your example goods order." }
    end

    def notify(message)
      parts = []
      InventoryPart.where(part_num: @auction.part_num).each do |part|
        parts << part
      end
      parts.uniq! { |p| p.company_id }
      parts.each do |part|
        condition_match(@auction)
        Notification.create(company_id: part.company.id, auction_id: @auction.id, message: message) if @condition.include?(part.condition) && part.company != current_user
      end
    end

    def condition_match(auction)
        @condition = ["NE", "OH", "SV", "AR", "SC"]
        @condition.delete("NE") if !auction.condition_ne
          
        @condition.delete("OH") if !auction.condition_oh
          
        @condition.delete("SV") if !auction.condition_sv
          
        @condition.delete("AR") if !auction.condition_ar
          
        @condition.delete("SC") if !auction.condition_sc

        if @condition.count == 5
          auction.update(condition: "All Conditions") 
        else
          auction.update(condition: @condition.to_sentence)
        end
    end

    def get_sales_opportunities
      @parts = current_user.inventory_parts
      @sales_opportunities = []
      @parts.uniq.each do |inventory|
        Auction.where(part_num: inventory.part_num, active: true).each do |auction|
          @sales_opportunities << auction if auction.company != current_user
        end
      end
      @sales_opportunities.uniq!
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
      params.require(:auction).permit(:company_id, :part_num, :condition_ne, :condition_oh, :condition_sv, :condition_ar, :condition_sc)
    end
end
