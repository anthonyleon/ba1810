json.array!(@companies) do |company|
  json.extract! company, :id, :name, :email, :password_digest
  json.url company_url(company, format: :json)
end
