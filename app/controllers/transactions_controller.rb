class TransactionsController < ApplicationController
  protect_from_forgery :except => [:receive_webhook]
  skip_before_action :require_logged_in, only: [:receive_webhook]
  before_action :set_transaction, only: [:create_shipment]
  ## or?
  # skip_before_filter :verify_authenticity_token

  def receive_webhook
    if request.headers['Content-Type'] == 'application/json'
      data = JSON.parse(request.body.read)
      if data["api_key"]["api_key"] == "71634fba00bd805fba58cce92b394ee8"
        case data["event"]["type"]
        when 2  # payments received in full 
          #make notification to let user know to ship part(s) and dont mark as read until part has been shipped
        when 16 # order cancelled
        when 15 # shipment details added to order
        when 3 #goods shipped to buyer
        when 4 # goods received by buyer
        when 5 # dispute initiated
        when 6 #funds released from buyer to seller
          puts "HELLOOOOO WOOOOOOORLLLLLLDDDDD"


        end
      end
    else
      # application/x-www-form-urlencoded
      data = params.as_json
    end

    render nothing: true
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
    def transaction_params
      params.require(:transaction).permit(:carrier_code, :tracking_num, :carrier, :shipment_desc, :delivered)
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end
    
end
