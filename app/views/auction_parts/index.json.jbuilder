json.array!(@auction_parts) do |auction_part|
  json.extract! auction_part, :id, :part_num, :init_price, :part_id, :auction_id
  json.url auction_part_url(auction_part, format: :json)
end
