class AuctionsController < ApplicationController
  before_action :set_auction, only: [:show, :edit, :update, :destroy]
  before_action :set_bid_auction, only: [:purchase, :purchase_confirmation]
  before_action :set_armor_client, only: [:purchase, :purchase_confirmation]

  # GET /auctions
  # GET /auctions.json
  def index
    @auctions = current_user.auctions
    @buyer_auctions = current_user.auctions.where(active: true)
    @supplier_auctions = Bid.supplier_auctions(current_user.bids)
    possible_auctions = get_possible_auctions.uniq! || get_possible_auctions
    @possible_auctions = possible_auctions - @supplier_auctions - @buyer_auctions
    @inactive_auctions = current_user.auctions.where(active: false)

    @buyer_auctions.each do |auction|
      @condition = []
        @condition << "NE" if auction.condition_ne == true
          
        @condition << "OH" if auction.condition_oh == true
          
        @condition << "SV" if auction.condition_sv == true
          
        @condition << "AR" if auction.condition_ar == true
          
        @condition << "SC" if auction.condition_sc == true

        auction.condition = @condition.to_sentence
          
      auction.update(condition: "All Conditions") if @condition.count == 5 || @condition.count == 0

      
    end

    @supplier_auctions.each do |auction|
      @condition = []
        @condition << "NE" if auction.condition_ne == true
          
        @condition << "OH" if auction.condition_oh == true
          
        @condition << "SV" if auction.condition_sv == true
          
        @condition << "AR" if auction.condition_ar == true
          
        @condition << "SC" if auction.condition_sc == true

        auction.condition = @condition.to_sentence 
          
      auction.update(condition: "All Conditions") if @condition.count == 5 || @condition.count == 0

      
    end  
  end
#
  def set_auction_to_false
    @auction = Auction.find(params[:id])
    @auction.active = false
    @auction.save
    redirect_to company_path
  end
#
  # GET /auctions/1
  # GET /auctions/1.json
  def show
    @init_price = @auction.auction_part.init_price
    @condition_ne = (@auction.condition_ne) ? 'New ': ""
    @condition_oh = (@auction.condition_ne) ? 'Overhaul ': ""
    @condition_sv = (@auction.condition_sv) ? 'Servicable ': ""
    @condition_ar = (@auction.condition_ar) ? 'As Removed ': ""
    @condition_sc = (@auction.condition_sc) ? 'Scrap ': ""
    @all_conditions_empty = ( @condition_ne.empty? && @condition_oh.empty? && @condition_sv.empty? && @condition_ar.empty? && @condition_sc.empty?)
  end

  def purchase


    ##### We should put an ARE YOU SURE YOU WANT TO PURCHASE PART_NUM FOR $$ IN CONDITION ??

    redirect_to action: "purchase_confirmation"
  end

  def purchase_confirmation
    set_order
    p result = @client.orders(@bid.company.armor_account_id).create(@order_data)
    @bid.update(order_id: result.data[:body]["order_id"])
    @auction.update(order_id: result.data[:body]["order_id"])

    auth_data = { 'uri' => "/accounts/#{@bid.company.armor_account_id}/orders/#{@bid.order_id}/paymentinstructions", 'action' => 'view' }
    result = @client.accounts.users(current_user.armor_account_id).authentications(current_user.armor_user_id).create(auth_data)
    @url = result.data[:body]["url"]

    @bid.auction.update(active: false)


    ## triggering payment being made ONLY FOR SANDBOX ENVIRONMENT
    action_data = { "action" => "add_payment", "confirm" => true, "source_account_id" => current_user.armor_account_id, "amount" => @bid.amount }
    result = @client.orders(current_user.armor_account_id).update(@bid.order_id, action_data)
  end

  # GET /auctions/new
  def new
    @auction = Auction.new
  end

  # GET /auctions/1/edit
  def edit
  end

  # POST /auctions
  # POST /auctions.json
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
          format.html { redirect_to @auction, notice: 'Auction was successfully created.' }
          format.json { render :show, status: :created, location: @auction }
      else
        format.html { redirect_to new_auction_path, alert: 'That part does not exist in our database.' }
      end
    end
  end

  # PATCH/PUT /auctions/1
  # PATCH/PUT /auctions/1.json
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

  # DELETE /auctions/1
  # DELETE /auctions/1.json
  def destroy
    @auction.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Auction was successfully destroyed.' }
      format.json { head :no_content }
    end
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
        "description" => @auction.condition,
        "invoice_num" => "123456",
        "purchase_order_num" => "675890",
        "message" => "Hello, Example Buyer! Thank you for your example goods order." }
    end

    def get_possible_auctions
      possible_auctions = []
      @parts = current_user.inventory_parts

      @parts.each do |inv_part|
        if @auction_parts = AuctionPart.where(part_id: inv_part.part_id)
          @auction_parts.each do |auct_part|
            possible_auctions << auct_part.auction if auct_part.auction.active == true
          end
        end
      end
      possible_auctions
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_auction
      @auction = Auction.find(params[:id])
    end

    def set_bid_auction
      @auction = Auction.find(params[:auction_id])
      @bid = Bid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_params
      params.require(:auction).permit(:company_id, :part_num, :condition_ne, :condition_oh, :condition_sv, :condition_ar, :condition_sc)
    end
end
