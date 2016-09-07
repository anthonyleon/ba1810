class TransactionsController < ApplicationController
  protect_from_forgery :except => [:receive_webhook]
  skip_before_action :require_logged_in, only: [:receive_webhook]
  before_action :set_transaction, only: [:create_shipment]
  before_action :set_bid, only: [:receive_webhook]
  ## or?
  # skip_before_filter :verify_authenticity_token

  def receive_webhook
    if request.headers['Content-Type'] == 'application/json'
      data = JSON.parse(request.body.read)
      if data["api_key"]["api_key"] == "71634fba00bd805fba58cce92b394ee8"
        case data["event"]["type"]
        when 2  # payments received in full 
          #make notification to let user know to ship part(s) and dont mark as read until part has been shipped
          @bid.tx.update_attribute('paid', true)
          notify("Payment has been received in full please proceed to ship part", @bid, seller)
        when 16 # order cancelled
          notify("The order ##{@transaction.order_id} for part ##{@bid.auction.part_num} has been cancelled.", @bid, seller)
          notify("You have cancelled your order ##{@transaction.order_id}", @bid, buyer)
        when 15 # shipment details added to order
        when 3 #goods shipped to buyer
          notify("Your purchase for part ##{@bid.auction.part_num} (order ##{@transaction.order_id}) has been shipped.", @bid, buyer)
        when 4 # goods received by buyer
          @bid.tx.update_attribute('delivered', true)
          notify("Buyer for order ##{@transaction.order_id}, has received shipment. Funds will be released upon approval of part.", @bid, seller)
        when 5 # dispute initiated
          notify("The buyer for part #{@bid.auction.part_num}, order ##{@transaction.order_id}, has disputed the transaction.", @bid, seller)
        when 6 # order accepted (ie. funds released from buyer to seller)
          Transaction.find_by(order_id: data["event"]["order_id"]).transfer_inventory #have to do something about this. Doesn't account for if a part is being sent to be put on an engine or aircraft.
          notify("The funds for order ##{@transaction.order_id} have been released from escrow in accordance with your payout preference.", @bid, seller)
        end
      end
    else
      # application/x-www-form-urlencoded
      data = params.as_json
    end

    render nothing: true
  end

  def deduct_shipping_cost ## this is wrong.. what's the right way to do this Henry
    @transaction = Auction.find(params[:id]).tx
    if @transaction.update(transaction_params)
      @transaction.final_shipping_cost = 0
      @transaction.calculate_total_payment
      @transaction.bid
      ArmorPaymentsApi.update_order(@transaction.bid, "message" => "Buyer will be using their freight account #. Shipping costs that were quoted have been deducted from the order.")
    end
  end

  def create_shipment
    respond_to do |format|
      if @transaction.update(transaction_params)
        ArmorPaymentsApi.create_shipment_record(@transaction.bid)
        format.html { redirect_to auction_bid_path(@transaction.auction, @transaction.bid), notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def notify(message, bid, company)
      Notification.create(message: message, bid: bid, auction: bid.auction, company: company)
    end
    def seller
      @bid.company
    end
    def buyer
      @bid.auction.company
    end
    def transaction_params
      params.require(:transaction).permit(:carrier_code, :tracking_num, :carrier, :shipment_desc, :delivered, :shipping_account)
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end
    def set_bid
      @bid = Transaction.find_by(order_id: data["event"]["order_id"]).bid
    end
    
end
