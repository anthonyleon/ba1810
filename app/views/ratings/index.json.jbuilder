json.array!(@ratings) do |rating|
  json.extract! rating, :id, :packaging, :timeliness, :documentation, :bid_aero, :dependability
  json.url rating_url(rating, format: :json)
end
