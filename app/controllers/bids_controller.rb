class BidsController < ApplicationController
  before_action :set_bid, only: [:show, :edit, :update, :destroy, :release_payment]
  before_action :set_auction, only: [:new, :edit, :create, :destroy, :show, :update]
  # GET /bids
  # GET /bids.json
  def index
    @bids = Bid.all
  end

  # GET /bids/1
  # GET /bids/1.json
  def show
    set_armor_client
    @carriers = @client.shipmentcarriers.all

    if @bid.carrier_code != nil
      release_payment
      funds_released
    end

    @company = @bid.company
    @rating = Rating.new
  end

  # GET /bids/new
  def new
    @bid = Bid.new
    @parts = current_user.inventory_parts
    @match_parts = @parts.where(part_num: @auction.part_num)
    @inventory = @match_parts.ids
  end

  # GET /bids/1/edit
  def edit
    @parts = current_user.inventory_parts
    @match_parts = @parts.where(part_num: @auction.part_num)
    @inventory = @match_parts.ids
  end

  # POST /bids
  # POST /bids.json
  def create
    @bid = @auction.bids.new(bid_params)
    @bid.company = current_user
    respond_to do |format|
      if @bid.save
        notify_other_bidders("A bid has been placed on an auction you are participating in!")
        notify_auctioner(@auction.company, "A new bid was placed in your auction!")
        format.html { redirect_to @auction, notice: 'Bid was successfully created.' }
        format.json { render :show, status: :created, location: @bid }
      else
        format.html { render :new }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bids/1
  # PATCH/PUT /bids/1.json
  def update
    respond_to do |format|
      if @bid.update(bid_params)
        notify_other_bidders("A bid has been updated on an auction you're competing in!")
        notify_auctioner(@auction.company, "A bid was updated in your auction!")
        format.html { redirect_to @auction, notice: 'Bid was successfully updated.' }
        format.json { render :show, status: :ok, location: @bid }
        if @bid.tracking_num # POST shipping info to armor
          set_armor_client
          @bid.update(carrier: @client.shipmentcarriers.all[:body][@bid.carrier_code.to_i - 1]["name"])
          user_id = @bid.company.armor_user_id
          account_id = @bid.company.armor_account_id
          order_id = @bid.order_id
          action_data = { "user_id" => user_id, "carrier_id" => @bid.carrier_code, "tracking_id" => @bid.tracking_num,
                           "description" => @bid.shipment_desc }
          result = @client.orders(account_id).shipments(order_id).create(action_data)
          deliver_data = { "action" => "delivered", "confirm" => true }
          delivery_result = @client.orders(account_id).update(order_id, deliver_data)
        end
      else
        format.html { render :edit }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bids/1
  # DELETE /bids/1.json
  def destroy
    @bid.destroy
    respond_to do |format|
      format.html { redirect_to @auction, notice: 'Bid was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # def purchase #(testing purposes)
  #   set_armor_client
  #   set_order
  #   result = client.orders(@bid.armor_account_id).create(@order_data)
  #   @bid.update(:order_id => result.data[:body]["order_id"])
  #   @auction.update(:order_id => result.data[:body]["order_id"])
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bid
      @bid = Bid.find(params[:id])
    end

    def notify_other_bidders(message)
      bid_collection =[]
      @auction.bids.each do |bid|
        bid_collection << bid
      end
      bid_collection.uniq! { |b| b.company_id }
      bid_collection.each do |bid|
        Notification.create(company_id: bid.company.id, auction_id: @auction.id, bid_id: bid.id, message: message) unless bid.company == current_user
        CompanyMailer.delay.auction_notification(bid)
        CompanyMailer.delay.place_new_bid(bid)
      end
    end

    def notify_auctioner(user, message)
      Notification.create(company_id: user.id, auction_id: @auction.id, message: message)
      CompanyMailer.notify_buyer(@bid.auction).deliver_now
    end

    def set_armor_client
      @client = ArmorPayments::API.new ENV['ARMOR_PKEY'], ENV['ARMOR_SKEY'], true
    end

    def set_order
      @order_data = {
        "type" => 1,
        "seller_id" => @bid.company.armor_user_id,
        "buyer_id" => current_user.company.armor_user_id,
        "amount" => @bid.amount,
        "summary" => @auction.part_num,
        "description" => @auction.condition,
        "invoice_num" => "12345",
        "purchase_order_num" => "67890",
        "message" => "Hello, Example Buyer! Thank you for your example goods order." }
    end

    def release_payment
      account_id = current_user.armor_account_id
      user_id = current_user.armor_user_id
      auth_data = { 'uri' => "/accounts/#{account_id}/orders/#{@bid.order_id}", 'action' => 'release' }
      url_result = @client.accounts.users(account_id).authentications(user_id).create(auth_data)
      @url = url_result.data[:body]["url"]
    end

    def funds_released # for testing purposes only sandbox trigger
      account_id = @bid.company.armor_account_id
      order_id = @bid.order_id
      action_data = { "action" => "release", "confirm" => true }
      fund_result = @client.orders(account_id).update(order_id, action_data)
      @bid.auction.update(paid: true)
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def bid_params
      params.require(:bid).permit(:amount, :company_id, :auction_id, :inventory_part_id, :delivered, :carrier, :carrier_code, :tracking_num, :shipment_desc)
    end


    def set_auction
      @auction = Auction.find(params[:auction_id])
    end

end
