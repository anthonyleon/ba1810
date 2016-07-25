class TransactionsController < ApplicationController
  protect_from_forgery :except => [:payment_in_escrow]

  def payment_in_escrow
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

  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
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
    # def set_users
    #   params["api_key"]
    # end
end
