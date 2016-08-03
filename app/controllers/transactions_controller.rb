class TransactionsController < ApplicationController
  protect_from_forgery :except => [:receive_webhook]
  skip_before_action :require_logged_in, only: [:receive_webhook]
  before_action :set_transaction, only: [:update]
  ## or?
  # skip_before_filter :verify_authenticity_token

  def receive_webhook
    if request.headers['Content-Type'] == 'application/json'
      data = JSON.parse(request.body.read)
      if data["api_key"]["api_key"] == "71634fba00bd805fba58cce92b394ee8"
        case data["event"]["type"]
        when "2"  # payments received in full 
          #make notification to let user know to ship part(s) and dont mark as read until part has been shipped
          

        end
      end
    else
      # application/x-www-form-urlencoded
      data = params.as_json
    end

    render nothing: true
  end

  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
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
