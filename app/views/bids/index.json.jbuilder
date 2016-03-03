json.array!(@bids) do |bid|
  json.extract! bid, :id, :amount, :company_id, :auction_id, :inventory_part_id
  json.url bid_url(bid, format: :json)
end
