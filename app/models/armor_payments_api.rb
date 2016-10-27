class ArmorPaymentsApi
  CLIENT = ArmorPayments::API.new( ENV['ARMOR_PKEY'], ENV['ARMOR_SKEY'], true)


  def self.get_account(account_id)
    p CLIENT.accounts.get(account_id)
  end

  def self.create_account(company)
    company.inc_state = nil unless company.inc_country == 'US'
    account_data = {
      company: company.name,
      user_name: company.representative,
      user_email: company.email,
      user_phone: "+1 #{company.phone.gsub(/[ ()-]/, '')}",
      address: company.address,
      city: company.city,
      state: company.state,
      zip: company.zip,
      country: company.country,
      email_confirmed: company.email_confirmed,
      agreed_terms: true,
      account_type: 2,
      url: company.url,
      inc_country: company.inc_country, 
      business_type: company.business_type,
      inc_state: company.inc_state
    }
    p response = CLIENT.accounts.create(account_data)
    p armor_account_num = response.data[:body]["account_id"].to_s
    p users = CLIENT.accounts.users(armor_account_num).all
    user_id = users.data[:body][0]["user_id"]
    return { armor_user_number: user_id, armor_account_number: armor_account_num }
  end

  def self.select_payout_preference(company)
    auth_data = { 'uri' => "/accounts/#{company.armor_account_id}/bankaccounts", 'action' => 'create' }
    result = CLIENT.accounts.users(company.armor_account_id).authentications(company.armor_user_id).create(auth_data)
    result.data[:body]["url"]
  end

  def self.create_order(transaction)
    p data = {
      "type" => 1,
      "seller_id" => transaction.seller.armor_user_id,
      "buyer_id" => transaction.buyer.armor_user_id,
      "amount" => transaction.total_amount.round(2),
      "summary" => transaction.auction.part_num,
      "description" => transaction.part.condition,
      "invoice_num" => transaction.invoice_num,
      "purchase_order_num" => transaction.po_num,
      "message" => "Order has been created. Awaiting buyer funds."
    }
    p transaction.total_amount
    p "***" * 80
    p result = CLIENT.orders(transaction.seller.armor_account_id).create(data)
    p result[:body]["order_id"]

  end

  def self.update_order(transaction, opts = {})
    p data = {
      "type" => 1,
      "amount" => transaction.total_amount.round(2),
      "invoice_num" => transaction.po_num,
      "purchase_order_num" => transaction.invoice_num,
      "message" => opts["message"]
    }
    order_id = transaction.order_id
    p result = CLIENT.orders(transaction.seller.armor_account_id).update(order_id, data)

  end

  def self.release_payment(transaction)
    account_id = transaction.buyer.armor_account_id
    user_id = transaction.buyer.armor_user_id
    auth_data = { 'uri' => "/accounts/#{account_id}/orders/#{transaction.order_id}", 'action' => 'release' }
    url_result = CLIENT.accounts.users(account_id).authentications(user_id).create(auth_data)
    url_result.data[:body]["url"]
  end

  def self.get_payment_url(transaction)
    auth_data = { 'uri' => "/accounts/#{transaction.buyer.armor_account_id}/orders/#{transaction.order_id}/paymentinstructions", 'action' => 'view' }
    p result = CLIENT.accounts.users(transaction.buyer.armor_account_id).authentications(transaction.buyer.armor_user_id).create(auth_data)
    result.data[:body]["url"]
  end

  def self.trigger_payment(transaction) #SANDBOX TRIGGER
    account_id = transaction.seller.armor_account_id
    action_data = { "action" => "add_payment",
                    "confirm" => true,
                    "source_account_id" => transaction.buyer.armor_account_id, # The account_id of the party making the payment
                    "amount" => transaction.total_amount }
    result = CLIENT.orders(account_id).update(transaction.order_id, action_data)
  end

  def self.trigger_delivered(transaction)
    account_id = transaction.seller.armor_account_id # The account_id of the seller for the order 
    order_id = transaction.order_id
    action_data = { "action" => "delivered", "confirm" => true } 
    result = CLIENT.orders(account_id).update(order_id, action_data)  
  end

  def self.carriers_list
    CLIENT.shipmentcarriers.all
  end

  def self.initiate_dispute(transaction)
    buyer_account_id = transaction.buyer.armor_account_id
    seller_account_id = transaction.seller.armor_account_id
    user_id = transaction.buyer.armor_user_id

    auth_data = { 'uri' => "/accounts/#{seller_account_id}/orders/#{transaction.order_id}/disputes", 'action' => 'view' }
    p result = CLIENT.accounts.users(buyer_account_id).authentications(user_id).create(auth_data)
    result[:body]["url"]
  end

  def self.offer_dispute_settlement(company_creating_offer, transaction, company_receiving_offer)
    account_id = company_creating_offer.armor_account_id
    user_id = company_creating_offer.armor_user_id
    auth_data = { 'uri' => "/accounts/#{company_receiving_offer.armor_account_id}/orders/#{transaction.order_id}/disputes/#{transaction.dispute_id}", 'action' => 'view' }
    result = CLIENT.accounts.users(account_id).authentications(user_id).create(auth_data)
    result[:body]["url"]
  end

  def self.respond_to_settlement_offer(company_responding_to_offer, transaction, company_receiving_response)
    account_id = company_responding_to_offer.armor_account_id
    user_id = company_responding_to_offer.armor_user_id
    auth_data = { 'uri' => "/accounts/#{company_receiving_response.armor_account_id}/orders/#{transaction.order_id}/disputes/#{transaction.dispute_id}", 'action' => 'view' }
    result = CLIENT.accounts.users(account_id).authentications(user_id).create(auth_data)
    result[:body]["url"]
  end

  def self.send_message(company_sending_message, transaction, company_receiving_message)
    account_id = company_sending_message.armor_account_id
    user_id = company_sending_message.armor_user_id

    auth_data = { 'uri' => "/accounts/#{company_receiving_message.account_id}/orders/#{transaction.order_id}/disputes/#{transaction.dispute_id}", 'action' => 'view' }
    result = CLIENT.accounts.users(account_id).authentications(user_id).create(auth_data)
    result[:body]["url"]
  end

  def self.create_shipment_record(transaction)
    #testing purposes carrier name not being passed through form.. because of _shipment partial 'options_for_select'
    transaction.update_attribute('carrier', CLIENT.shipmentcarriers.all[:body][transaction.carrier_code.to_i - 1]["name"])
    user_id = transaction.seller.armor_user_id
    account_id = transaction.seller.armor_account_id
    order_id = transaction.order_id
    action_data = { "user_id" => user_id, "carrier_id" => transaction.carrier_code, "tracking_id" => transaction.tracking_num, "description" => transaction.shipment_desc }
    result = CLIENT.orders(account_id).shipments(order_id).create(action_data)
  end

end
