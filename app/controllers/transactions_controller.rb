class TransactionsController < ApplicationController
	protect_from_forgery :except => [:receive_webhook]
	skip_before_action :require_logged_in, only: [:receive_webhook]
	before_action :set_transaction, only: [:show, :send_invoice, :create_shipment, :update]
	before_action :set_variables, only: [:buyer_purchase, :seller_purchase, :material_cert]
	## or?
	# skip_before_filter :verify_authenticity_token

	def receive_webhook
		if request.headers['Content-Type'] == 'application/json'
			@data = JSON.parse(request.body.read)
			p "=+" * 120
			p @transaction = Transaction.find_by(order_id: @data["event"]["order_id"])
			p "=-" * 120
			p @bid = @transaction.bid if @transaction
			p "==" * 120
			@transaction.parse_webhook(@data, @bid)
		else
			# application/x-www-form-urlencoded
			data = params.as_json
		end

		render nothing: true
	end

	def record
		@bid = Bid.find(params[:bid_id])
		@auction = Auction.find(params[:auction_id])
		@transaction = Transaction.record(@auction, @bid)

		render nothing: true
	end

	def remove_from_purchase_history
		@bid = Bid.find(params[:bid_id])
		@bid.tx.destroy

		render nothing: true
	end

	def show
		if @transaction.buyer == current_user
			redirect_to buyer_purchase_path(@transaction)
		elsif @transaction.seller == current_user
			redirect_to seller_purchase_path(@transaction)
		else
			redirect_to root_path
		end
	end

	def create
		bid = Bid.find(transaction_params[:bid_id])
		@auction = bid.auction
		@destination = Destination.find(params[:transaction][:destination][:id])
		@destination.update(destination_params)
		@transaction = Transaction.create_order(bid)
		@transaction.destination = @destination
		@auction.update(active: false) if @auction.active
		CompanyMailer.won_auction_notification(@transaction.bid, @transaction.seller, @transaction).deliver_later(wait_until: 1.minute.from_now) &&
			Notification.notify(@transaction.seller, :win, bid: @transaction.bid,
				transaction: @transaction) unless Notification.exists?(@bid, :win)
		respond_to do |format|
			if @transaction.update(transaction_params)
				format.html { redirect_to buyer_purchase_path(@transaction), notice: 'Transaction was successfully created.' }
				format.json { render :show, status: :ok, location: @transaction }
			else
				format.html { render auction_purchase_confirmation_path(@transaction.auction, @transaction.bid) }
				format.json { render json: @aircraft.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|

			if @transaction.update(transaction_params)
				#hotfix.. the shipment dropdown box should send carrier name as a param as well
				if carrier_code = transaction_params[:carrier_code]
					@carriers = ArmorPaymentsApi.carriers_list
					@transaction.update(carrier: @carriers[:body][carrier_code.to_i - 1]["name"])
					@transaction.update(status: :in_transit)
					Notification.notify(@transaction.buyer, :shipment_in_transit, bid: @transaction.bid, transaction: @transaction)
				end
				format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
				format.json { render :show, status: :ok, location: @transaction }
			else
				format.html { render :edit }
				format.json { render json: @transaction.errors, status: :unprocessable_entity }
			end
		end
	end

	def send_invoice
		respond_to do |format|  ## Add this
			if @transaction.update(transaction_params)
				CompanyMailer.send_escrow_money(@transaction, @transaction.buyer).deliver_now
				@transaction.calculate_total_payment
				ArmorPaymentsApi.create_order(@transaction)

				Notification.notify(@transaction.buyer, :send_payment, bid: @transaction.bid, transaction: @transaction)

				format.html { redirect_to seller_purchase_path(@transaction), notice: 'Invoice was successfully created.' }
				format.json { render :show, status: :ok, location: @transaction }
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
		if @transaction.pending_payment?
			response.headers.delete "X-Frame-Options"
			@payment_url = ArmorPaymentsApi.get_payment_url(@transaction)
		elsif @transaction.delivered?
			response.headers.delete "X-Frame-Options"
			@release_payment_url = ArmorPaymentsApi.release_payment(@transaction)
			@dispute_transaction_url = ArmorPaymentsApi.initiate_dispute(@transaction)
		elsif @transaction.disputed?
			@dispute_settlement_url = ArmorPaymentsApi.offer_dispute_settlement(current_user, @transaction, @transaction.seller) if @transaction.disputed
			@settlement_offer_url = ArmorPaymentsApi.respond_to_settlement_offer(company_responding_to_offer, transaction, company_receiving_response) if @transaction.dispute_settlement
		end
	end

	def seller_purchase
		redirect_to select_payout_preference_path unless current_user.payout_selected?
		@carriers = ArmorPaymentsApi.carriers_list if @transaction.pending_shipment?
		if @transaction.disputed?
			@dispute_settlement_url = ArmorPaymentsApi.offer_dispute_settlement(current_user, @transaction, @transaction.buyer)

			@settlement_offer_url = ArmorPaymentsApi.respond_to_settlement_offer(company_responding_to_offer, transaction, company_receiving_response) if @transaction.dispute_settlement
		end
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
			params.require(:transaction).permit(:carrier_code, :price_before_fees, :tracking_num, :carrier, :shipment_desc, :part_price,
																					:delivered, :shipping_account, :tax_rate, :final_shipping_cost,
																					:po_num, :invoice_num, :order_id, :required_date, :bid_id)
		end

		def destination_params
			params.require(:transaction).permit(destination:[:id, :title, :address, :city, :state, :country, :zip])[:destination]
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
