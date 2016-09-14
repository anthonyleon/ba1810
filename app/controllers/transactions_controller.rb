class TransactionsController < ApplicationController
  protect_from_forgery :except => [:receive_webhook]
  skip_before_action :require_logged_in, only: [:receive_webhook]
  before_action :set_transaction, only: [:create_shipment]
  before_action :set_bid, only: [:receive_webhook]
  before_action :set_variables, only: [:buyer_purchase, :seller_purchase]
  ## or?
  # skip_before_filter :verify_authenticity_token

  def receive_webhook
    p "-_-" * 80
    if request.headers['Content-Type'] == 'application/json'
      data = JSON.parse(request.body.read)
      if data["api_key"]["api_key"] == "71634fba00bd805fba58cce92b394ee8"
        case data["event"]["type"]
        when 2  # payments received in full 
          #make notification to let user know to ship part(s) and dont mark as read until part has been shipped
          @transaction.payment_received
          notify("Payment has been received in full please proceed to ship part", @bid, seller)
        when 16 # order cancelled
          notify("The order ##{@transaction.order_id} for part ##{@bid.auction.part_num} has been cancelled.", @bid, seller)
          notify("You have cancelled your order ##{@transaction.order_id}", @bid, buyer)
        when 15 # shipment details added to order
          notify("Shipment information for order ##{@transaction.order_id} for #{@transaction.auction.part_num} has been received.", @bid, buyer)
        when 3 #goods shipped to buyer - DOES ARMOR CHECK CARRIER FOR CONFIRMATION?????
          notify("Your purchase for part ##{@bid.auction.part_num} (order ##{@transaction.order_id}) has been shipped.", @bid, buyer)
        when 4 # goods received by buyer
          @transaction.delivered
          notify("Buyer for order ##{@transaction.order_id}, has received shipment. Funds will be released upon approval of part.", @bid, seller)
        when 5 # dispute initiated
          notify("Buyer for #{@bid.auction.part_num}, order ##{@transaction.order_id}, has disputed the transaction.", @bid, seller)
          # testing purposes. ALSO SEND AN EMAIL TO THE USER
        when 6 # order accepted (ie. funds released from buyer to seller)
          @transaction.transfer_inventory #have to do something about this. Doesn't account for if a part is being sent to be put on an engine or aircraft.
          @transaction.complete
          notify("The funds for order ##{@transaction.order_id} have been released from escrow in accordance with your payout preference.", @bid, seller)
        end
      end
    else
      # application/x-www-form-urlencoded
      data = params.as_json
    end

    render nothing: true
  end

  def update_tax_shipping
    p @transaction = Auction.find(params[:auction_id]).tx
    respond_to do |format|  ## Add this
      if @transaction.update(transaction_params)
        @transaction.calculate_total_payment
        format.json { render nothing: true, status: :ok}
        format.html
      end
    end  
  end

  def create_shipment
    respond_to do |format|
      if @transaction.update(transaction_params)
        ArmorPaymentsApi.create_shipment_record(@transaction.bid)
        format.html { redirect_to auction_purchase_path(@transaction.auction, @transaction.bid), notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def buyer_purchase
    redirect_to root_path unless @bid.buyer == current_user
    @notification = notify("You have won an auction! Please proceed with shipment process.", @bid, @bid.seller) #put unless bid already has a notification
  
  end

  def seller_purchase
    redirect_to root_path unless @bid.seller == current_user
  end

  private

    def notify(message, bid, company)
      Notification.create(message: message, bid: bid, auction: bid.auction, company: company)
    end
    def seller
      @bid.seller
    end
    def buyer
      @bid.buyer
    end
    def transaction_params
      params.require(:transaction).permit(:carrier_code, :tracking_num, :carrier, :shipment_desc, :part_price, :delivered, :shipping_account, :tax_rate, :final_shipping_cost)
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def set_bid_and_transaction
      @transaction = Transaction.find_by(order_id: data["event"]["order_id"])
      @bid = @transaction.bid
    end

    def set_variables
      @bid = Bid.find(params[:id])
      @auction = @bid.auction
      @transaction = @auction.tx
    end
    
end
