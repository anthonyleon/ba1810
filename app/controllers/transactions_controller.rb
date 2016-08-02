class TransactionsController < ApplicationController
  protect_from_forgery :except => [:receive_webhook]
  before_action :set_transaction, only: [:update_shipment]
  ## or?
  # skip_before_filter :verify_authenticity_token

  def receive_webhook
    if params["event"]["type"] == "0"
      puts "HEELLLLOOOO WOOOORLLLDD"
      Transaction.create(company_id: params["event"]["type"])
    end
  end

  def update_shipment
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
