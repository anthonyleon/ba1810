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
      @transaction = Transaction.find_by(order_id: @data["event"]["order_id"])
      @bid = @transaction.bid
      if @data["api_key"]["api_key"] == "71634fba00bd805fba58cce92b394ee8"
        case @data["event"]["type"]
        when 2  # payments received in full
          #make notification to let user know to ship part(s) and dont mark as read until part has been shipped
          @transaction.payment_received
          notify("Payment has been received in full please proceed to shipping procedure.", @bid, @bid.seller)
        when 16 # order cancelled
          notify("The order ##{@transaction.order_id} for part ##{@bid.auction.part_num} has been cancelled.", @bid, @bid.seller)
          notify("You have cancelled your order ##{@transaction.order_id}", @bid, @bid.buyer)
        when 15 # shipment details added to order (testing purposes, not really but need to check later) this doesn't mean it was received does it?
          notify("Shipment information for order ##{@transaction.order_id} for #{@transaction.auction.part_num} has been received.", @bid, @bid.buyer)
        when 3 #goods shipped to buyer
          notify("Your purchase for part ##{@bid.auction.part_num} (order ##{@transaction.order_id}) has been shipped.", @bid, @bid.buyer)
          @transaction.update(shipped: true)
        when 4 # goods received by buyer
          @transaction.delivery_received
          notify("Buyer for order ##{@transaction.order_id}, has received shipment. Funds will be released upon approval of part.", @bid, @bid.seller)
        when 5 # dispute initiated
          notify("Buyer for #{@bid.auction.part_num}, order ##{@transaction.order_id}, has disputed the transaction.", @bid, @bid.seller)
          # testing purposes. ALSO SEND AN EMAIL TO THE USER
        when 6 # order accepted (ie. funds released from buyer to seller)
          @transaction.transfer_inventory #have to do something about this. Doesn't account for if a part is being sent to be put on an engine or aircraft.
          @transaction.completed
          # CREATE A REVIEW NOTIFICATION
          notify("The funds for order ##{@transaction.order_id} have been released from escrow in accordance with your payout preference.", @bid, @bid.seller)
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
        #generate invoice here....
        armor_order_id = ArmorPaymentsApi.create_order(@transaction)
        @transaction.update(order_id: armor_order_id)
        notify("Seller has finalized costs. Please send funds to escrow.", @transaction.bid, @transaction.buyer)
        format.html { redirect_to seller_purchase_path(@transaction), notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :ok, location: @aircraft }
      end
    end
  end

  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        @transaction.update(shipping_account: nil) if @transaction.shipping_account.blank?
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
    @notification = notify("You have won an auction! Please proceed with shipment process.", @bid, @bid.seller) unless Notification.exists?(@bid, "You have won an auction! Please proceed with shipment process.")
    @auction.update(active: false) if @auction.active
    if !@transaction.shipped && !@transaction.paid && @transaction.bid_aero_fee
      response.headers.delete "X-Frame-Options"
      @payment_url = ArmorPaymentsApi.get_payment_url(@transaction)
    elsif @transaction.delivered && @transaction.paid && !@transaction.complete
      response.headers.delete "X-Frame-Options"
      p @release_payment_url = ArmorPaymentsApi.release_payment(@transaction)
      p @dispute_transaction_url = ArmorPaymentsApi.initiate_dispute(@transaction)
    end
  end

  def seller_purchase
    redirect_to root_path unless @bid.seller == current_user
    @carriers = ArmorPaymentsApi.carriers_list if @transaction.paid
  end

  def show
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

    def notify(message, bid, company)
      Notification.create(message: message, bid: bid, auction: bid.auction, company: company)
    end

    def transaction_params
      params.require(:transaction).permit(:carrier_code, :tracking_num, :carrier, :shipment_desc, :part_price, :delivered, :shipping_account, :tax_rate, :final_shipping_cost, :po_num, :invoice_num, :order_id)
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
