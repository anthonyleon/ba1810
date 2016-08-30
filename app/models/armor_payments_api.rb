class ArmorPaymentsApi
	CLIENT = ArmorPayments::API.new( ENV['ARMOR_PKEY'], ENV['ARMOR_SKEY'], true)


	def self.create_account(company)
    account_data = {
      company: company.name,
      user_name: company.representative,
      user_email: company.email,
      user_phone: "+1 #{company.phone.gsub('-', '')}",
      address: company.address,
      city: company.city,
      state: company.state,
      zip: company.zip,
      country: company.country,
      email_confirmed: company.email_confirmed,
      agreed_terms: true
      }
      p response = CLIENT.accounts.create(account_data)
      p armor_account_num = response.data[:body]["account_id"].to_s
      p users = CLIENT.accounts.users(armor_account_num).all
      user_id = users.data[:body][0]["user_id"]
      return {armor_user_number: user_id, armor_account_number: armor_account_num}
	end

	def self.create_order(bid)
		data = {
			"type" => 1,
			"seller_id" => bid.seller.armor_user_id,
			"buyer_id" => bid.buyer.armor_user_id,
			"amount" => bid.total_amount,
			"summary" => bid.auction.part_num,
			"description" => bid.inventory_part.condition,
			"invoice_num" => "123456",
			"purchase_order_num" => "675890",
			"message" => "Hello, Example Buyer! Thank you for your example goods order."
		}
		# is this the buyer or seller id? TESTING PURPOSES
		result = CLIENT.orders(bid.buyer.armor_account_id).create(data)
		result[:body]["order_id"]
	end

  def self.update_order(bid, opts = {})
    p data = {
      "type" => 1,
      "amount" => bid.total_amount,
      "invoice_num" => "123456",
      "purchase_order_num" => "675890",
      "message" => opts["message"]
    }
    order_id = bid.tx.order_id
    p result = CLIENT.orders(bid.buyer.armor_account_id).update(order_id, data)

  end

  def self.release_payment(bid, company)
    account_id = company.armor_account_id
    user_id = company.armor_user_id
    auth_data = { 'uri' => "/accounts/#{account_id}/orders/#{bid.tx.order_id}", 'action' => 'release' }
    url_result = CLIENT.accounts.users(account_id).authentications(user_id).create(auth_data)
    url_result.data[:body]["url"]
  end

	def self.get_payment_url(company, transaction)
		auth_data = { 'uri' => "/accounts/#{company.armor_account_id}/orders/#{transaction.order_id}/paymentinstructions", 'action' => 'view' }
		result = CLIENT.accounts.users(company.armor_account_id).authentications(company.armor_user_id).create(auth_data)
		result.data[:body]["url"]
	end

	def self.select_payout_preference(company)
    auth_data = { 'uri' => "/accounts/#{company.armor_account_id}/bankaccounts", 'action' => 'create' }
    result = CLIENT.accounts.users(company.armor_account_id).authentications(company.armor_user_id).create(auth_data)
    result.data[:body]["url"]
	end

  def self.carriers_list
    CLIENT.shipmentcarriers.all
  end

  def self.create_shipment_record(bid)
    #testing purposes carrier name not being passed through form.. because of _shipment partial 'options_for_select'
    bid.tx.update_attribute('carrier', CLIENT.shipmentcarriers.all[:body][bid.tx.carrier_code.to_i - 1]["name"])
    user_id = bid.company.armor_user_id
    account_id = bid.company.armor_account_id
    order_id = bid.tx.order_id
    action_data = { "user_id" => user_id, "carrier_id" => bid.tx.carrier_code, "tracking_id" => bid.tx.tracking_num,
                     "description" => bid.tx.shipment_desc }
    result = CLIENT.orders(account_id).shipments(order_id).create(action_data)
  end

  

end