class BidsController < ApplicationController
  before_action :set_bid, only: [:show, :edit, :update, :destroy, :release_payment]
  before_action :set_auction, only: [:new, :edit, :create, :destroy, :show, :update]

  def index
    @bids = Bid.all
  end

  def show
    @transaction = @bid.tx
    @carriers = ArmorPaymentsApi.carriers_list
    ## uncomment to see modal when shipment info not set delete out of testing purposes
    @url = ArmorPaymentsApi.release_payment(@bid, current_user)
    if @transaction.carrier_code != nil
      @url = ArmorPaymentsApi.release_payment(@bid, current_user)
      # funds_released
    end
    @company = @bid.company
    @rating = Rating.new
  end

  def new
    @bid = Bid.new
    @parts = current_user.inventory_parts
    @match_parts = @parts.where(part_num: @auction.part_num)
    @inventory = @match_parts.ids
  end

  def edit
    @parts = current_user.inventory_parts
    @match_parts = @parts.where(part_num: @auction.part_num)
    @inventory = @match_parts.ids
  end

  def create
    @bid = @auction.bids.new(bid_params)
    @bid.company = current_user
    respond_to do |format|
      if @bid.save
        notify_other_bidders("A bid has been placed on an auction you are participating in!")
        notify_auctioner("A new bid was placed in your auction!")
        format.html { redirect_to @auction, notice: 'Bid was successfully created.' }
        format.json { render :show, status: :created, location: @bid }
      else
        format.html { render :new }
        format.json { render json: @bid.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @bid.assign_attributes(bid_params)
      ArmorPaymentsApi.update_order(@bid) if @bid.changed?
      if @bid.update(bid_params)
        # notify_other_bidders("A bid has been updated on an auction you're competing in!")
        # notify_auctioner("A bid was updated in your auction!")
        format.html { redirect_to @auction, notice: 'Bid was successfully updated.' }
        format.json { render :show, status: :ok, location: @bid }
        if @bid.tx.tracking_num # POST shipping info to armor
          set_armor_client
          @bid.update(carrier: @client.shipmentcarriers.all[:body][@bid.tx.carrier_code.to_i - 1]["name"])
          user_id = @bid.company.armor_user_id
          account_id = @bid.company.armor_account_id
          order_id = @bid.tx.order_id
          action_data = { "user_id" => user_id, "carrier_id" => @bid.tx.carrier_code, "tracking_id" => @bid.tx.tracking_num,
                           "description" => @bid.tx.shipment_desc }
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
      format.html { redirect_to @auction, notice: 'Bid was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

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
        CompanyMailer.auction_notification(bid).deliver_later(wait: 1.minute)
        CompanyMailer.place_new_bid(bid).deliver_later(wait_until: 1.minute.from_now)
      end
    end

    def notify_auctioner(message)
      Notification.create(company: @auction.company, auction: @auction, message: message)
      CompanyMailer.notify_buyer(@bid.auction).deliver_now
    end

    def funds_released # for testing purposes only sandbox trigger
      account_id = @bid.company.armor_account_id
      order_id = @bid.tx.order_id
      action_data = { "action" => "release", "confirm" => true }
      fund_result = @client.orders(account_id).update(order_id, action_data)
      @bid.auction.update(paid: true)
    end

    def bid_params
      params.require(:bid).permit(:part_price, :shipping_cost, :company_id, :auction_id, :inventory_part_id, :delivered, :carrier, :carrier_code, :tracking_num, :shipment_desc)
    end


    def set_auction
      @auction = Auction.find(params[:auction_id])
    end

end
