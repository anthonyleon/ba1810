class TransactionsController < ApplicationController
  protect_from_forgery :except => [:receive_webhook]
  skip_before_action :require_logged_in, only: [:receive_webhook]
  before_action :set_transaction, only: [:update_tax_shipping, :create_shipment, :update]
  before_action :set_variables, only: [:buyer_purchase, :seller_purchase, :material_cert]
  ## or?
  # skip_before_filter :verify_authenticity_token

  def receive_webhook
    if request.headers['Content-Type'] == 'application/json'
      @data = JSON.parse(request.body.read)
      p "=+" * 120
      p @transaction = Transaction.find_by(order_id: @data["event"]["order_id"]) if @transaction = Transaction.find_by(order_id: @data["event"]["order_id"])
      p "=-" * 120
      p @bid = @transaction.bid if @transaction
      p "==" * 120
      if @data["api_key"]["api_key"] == ENV['ARMOR_PKEY']
        case @data["event"]["type"]
        when 0  # order created
        when 2  # payments received in full
          #make notification to let user know to ship part(s) and dont mark as read until part has been shipped
          @transaction.payment_received
          Notification.notify(@bid, @bid.seller, "Payment has been received in full please proceed to shipping procedure.")
          CompanyMailer.ship_part(@bid, @bid.seller).deliver_now
        when 16 # order cancelled
          Notification.notify(@bid, @bid.seller, "The order ##{@transaction.order_id} for part ##{@bid.auction.part_num} has been cancelled.", transaction: @transaction)
          Notification.notify(@bid, @bid.buyer, "You have cancelled your order ##{@transaction.order_id}")
          CompanyMailer.order_cancelled(@bid, @bid.seller, @bid.buyer)
        when 15 # shipment details added to order (testing purposes, not really but need to check later) this doesn't mean it was received does it?
          Notification.notify(@bid, @bid.buyer, "Shipment information for order ##{@transaction.order_id} for #{@transaction.auction.part_num} has been received.", transaction: @transaction)
        when 3 #goods shipped to buyer
          Notification.notify(@bid, @bid.buyer, "Your purchase for part ##{@bid.auction.part_num} (order ##{@transaction.order_id}) has been shipped.", transaction: @transaction)
          @transaction.update(shipped: true)
          CompanyMailer.part_shipped(@bid, @bid.buyer, @bid.tx)
        when 4 # goods received by buyer
          @transaction.delivery_received
          CompanyMailer.shipment_received(@bid, @bid.seller).deliver_now
          Notification.notify(@bid, @transaction.seller, "Buyer for order ##{@transaction.order_id}, has received shipment. Funds will be released upon approval of part.", transaction: @transaction)
          Notification.notify(@bid, @transaction.buyer, "Order ##{@transaction.order_id}, has been marked as received. You have 3 days to approve part.", transaction: @transaction)
        when 6 # order accepted (ie. funds released from buyer to seller)
          @transaction.transfer_inventory
          @transaction.completed
          # CREATE A REVIEW NOTIFICATION
          Notification.notify(@bid, @bid.seller, "The funds for order ##{@transaction.order_id} have been released from escrow in accordance with your payout preference.")
          CompanyMailer.funds_released(@bid, @bid.seller).deliver_now
          Notification.notify(@bid, @bid.seller, "The funds for order ##{@transaction.order_id} have been released from escrow in accordance with your payout preference.", transaction: @transaction)
        when 10 # dispute settlement offer has been submitted by either buyer or seller
          @transaction.settlement_offer_submitted
          Notification.notify(@bid, @transaction.buyer, "A settlement offer has been submitted to you. Please review.", transaction: @transaction)
        when 26 #Goods inspection completed
          # we already have a funds release event
  #DISPUTES
        when 3000 # Dispute created
          @transaction.mark_as_disputed
          Notification.notify(@bid, @bid.seller, "Buyer for #{@bid.auction.part_num}, order ##{@transaction.order_id}, has disputed the transaction.", transaction: @transaction)
          # testing purposes. ALSO SEND AN EMAIL TO THE USER
        when 3003 # A counter-offer was made to this Offer
          offerer = Company.find_by(armor_user_id: @data["event"]["user_id"])
          if offerer == @transaction.seller
            oferree = @transaction.buyer
          else
            offeree = @transaction.seller
          end
          Notification.notify(@bid, offeree, "A settlement offer has been created on dispute ##{@data["event"]["order_id"]}")
          @transaction.clear_dispute_responses
        when 3004 # Offer to settle dispute on order accepted
          company_accepting = Company.find_by(armor_user_id: @data["event"]["user_id"])
          if company_accepting == @transaction.seller
            company = @transaction.buyer
          else
            company = @transaction.seller
          end
          Notification.notify(@bid, company, "Your settlement offer for order ##{@transaction.order_id} has been accepeted", transaction: @transaction)
        when 2005 #dispute escalated to arbitration
          Notification.notify(@bid, @bid.seller, "Disputed Order ##{@transaction.order_num} has been escalated to arbitration.")
          Notification.notify(@bid, @bid.buyer, "Disputed Order ##{@transaction.order_num} has been escalated to arbitration.")
  #ACCOUNT EVENTS
        when 1001 # Bank Account details Added
          
        when 1002 # Bank Account Approved

        when 1003 # Bank Account Declined
        end
      end
    else
      # application/x-www-form-urlencoded
      data = params.as_json
    end

    render nothing: true
  end

  def update_tax_shipping
    respond_to do |format|  ## Add this
      if @transaction.update(transaction_params)
        @transaction.calculate_total_payment
        p armor_order_id = ArmorPaymentsApi.create_order(@transaction)
        @transaction.update(order_id: armor_order_id)
        # Notification.notify(@transaction.bid, @transaction.buyer, "Seller has finalized costs. Please send funds to escrow.")
        CompanyMailer.send_escrow_money(@transaction, @transaction.buyer).deliver_now
        Notification.notify(@transaction.bid, @transaction.buyer, "Seller has finalized costs. Please send funds to escrow.", transaction: @transaction)

        format.html { redirect_to seller_purchase_path(@transaction), notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :ok, location: @transaction }
      end
    end
  end

  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        @transaction.update(shipping_account: nil) if @transaction.shipping_account.blank?

        #hotfix.. the shipment dropdown box should send carrier name as a param as well
        if carrier_code = transaction_params[:carrier_code]
          @carriers = ArmorPaymentsApi.carriers_list
          @transaction.update(carrier: @carriers[:body][carrier_code.to_i - 1]["name"])

        end
        @transaction.update(shipped: true) if params[:commit] == "Update Tracking Info"
        if @transaction.seller == current_user
          format.html { redirect_to seller_purchase_path(@transaction), notice: 'Transaction was successfully updated.' }
        elsif @transaction.buyer == current_user
          format.html { redirect_to buyer_purchase_path(@transaction), notice: 'Transaction was successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_shipment
    respond_to do |format|
      if @transaction.update(transaction_params)
        ArmorPaymentsApi.create_shipment_record(@transaction)
        format.html { redirect_to auction_purchase_path(@transaction.auction, @transaction.bid), notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def buyer_purchase
    redirect_to root_path unless @transaction.buyer == current_user

    CompanyMailer.won_auction_notification(@bid, @bid.seller, @transaction).deliver_later(wait_until: 1.minute.from_now) && Notification.notify(@bid, @bid.seller, "You have won an auction! Please finalize tax and shipping costs, and input your invoice number.", transaction: @transaction) unless Notification.exists?(@bid, "You have won an auction! Please finalize tax and shipping costs, and input your invoice number.")
    @auction.update(active: false) if @auction.active
    if !@transaction.shipped && !@transaction.paid && @transaction.bid_aero_fee
      response.headers.delete "X-Frame-Options"
      @payment_url = ArmorPaymentsApi.get_payment_url(@transaction)
    elsif @transaction.delivered && @transaction.paid && !@transaction.complete && !@transaction.disputed
      response.headers.delete "X-Frame-Options"
      p @release_payment_url = ArmorPaymentsApi.release_payment(@transaction)
      p @dispute_transaction_url = ArmorPaymentsApi.initiate_dispute(@transaction)
    elsif @transaction.disputed
      @dispute_settlement_url = ArmorPaymentsApi.offer_dispute_settlement(current_user, @transaction, @transaction.seller) if @transaction.disputed
      @settlement_offer_url = ArmorPaymentsApi.respond_to_settlement_offer(company_responding_to_offer, transaction, company_receiving_response) if @transaction.dispute_settlement
    end
  end

  def seller_purchase
    redirect_to dashboard_path unless @bid.seller == current_user
    redirect_to select_payout_preference_path unless current_user.payout_selected?
    @carriers = ArmorPaymentsApi.carriers_list
    @dispute_settlement_url = ArmorPaymentsApi.offer_dispute_settlement(current_user, @transaction, @transaction.buyer) if @transaction.disputed
    @settlement_offer_url = ArmorPaymentsApi.respond_to_settlement_offer(company_responding_to_offer, transaction, company_receiving_response) if @transaction.dispute_settlement
  end

  def invoice_pdf
    @transaction = Transaction.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicePdf.new(@transaction)
        send_data pdf.render, filename: "Invoice_#{@transaction.order_id}.pdf", type: 'application/pdf'
      end
    end
  end

  def po
    @transaction = Transaction.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = PoPdf.new(@transaction)
        send_data pdf.render, filename: "PO_#{@transaction.order_id}.pdf", type: 'application/pdf'
      end
    end
  end

  def material_cert
    respond_to do |format|
      format.html
      format.pdf do
        pdf = MaterialCertPdf.new(@transaction)
        send_data pdf.render, filename: "MaterialCert_#{@transaction.order_id}.pdf", type: 'application/pdf'
      end
    end
  end

  private

    def transaction_params
      params.require(:transaction).permit(:carrier_code, :price_before_fees, :tracking_num, :carrier, :shipment_desc, :part_price, :delivered, :shipping_account, :tax_rate, :final_shipping_cost, :po_num, :invoice_num, :order_id)
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def set_variables
      @transaction = Transaction.find(params[:id])
      @bid = @transaction.bid
      @auction = @transaction.auction
    end

end
