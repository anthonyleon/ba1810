class ArmorPaymentsApi
  CLIENT = ArmorPayments::API.new( ENV['ARMOR_PKEY'], ENV['ARMOR_SKEY'], true)


  def self.get_account(account_id)
    p CLIENT.accounts.get(account_id)
  end
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
    return { armor_user_number: user_id, armor_account_number: armor_account_num }
  end

  def self.create_order(transaction)
    p data = {
     "type" => 1,
     "seller_id" => transaction.seller.armor_user_id,
     "buyer_id" => transaction.buyer.armor_user_id,
     "amount" => transaction.total_amount,
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
    "amount" => transaction.total_amount,
    "invoice_num" => "123456",
    "purchase_order_num" => "675890",
    "message" => opts["message"]
  }
  order_id = transaction.order_id
  p result = CLIENT.orders(transaction.seller.armor_account_id).update(order_id, data)

end

def self.release_payment(transaction, company)
  account_id = company.armor_account_id
  user_id = company.armor_user_id
  auth_data = { 'uri' => "/accounts/#{account_id}/orders/#{transaction.order_id}", 'action' => 'release' }
  url_result = CLIENT.accounts.users(account_id).authentications(user_id).create(auth_data)
  url_result.data[:body]["url"]
end

def self.get_payment_url(company, transaction)
  auth_data = { 'uri' => "/accounts/#{company.armor_account_id}/orders/#{transaction.order_id}/paymentinstructions", 'action' => 'view' }
  p result = CLIENT.accounts.users(company.armor_account_id).authentications(company.armor_user_id).create(auth_data)
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

def self.create_shipment_record(transaction)
    #testing purposes carrier name not being passed through form.. because of _shipment partial 'options_for_select'
    transaction.update_attribute('carrier', CLIENT.shipmentcarriers.all[:body][transaction.carrier_code.to_i - 1]["name"])
    user_id = transaction.seller.armor_user_id
    account_id = transaction.seller.armor_account_id
    order_id = transaction.order_id
    action_data = { "user_id" => user_id, "carrier_id" => transaction.carrier_code, "tracking_id" => transaction.tracking_num,
    "description" => transaction.shipment_desc }
    result = CLIENT.orders(account_id).shipments(order_id).create(action_data)
   end

 end